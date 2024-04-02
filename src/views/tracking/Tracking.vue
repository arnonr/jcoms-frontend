<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container p-lg-10 mt-5">
      <h2 class="mt-10 mb-5 text-black">ติดตามเรื่องร้องเรียน</h2>

      <div class="card">
        <div class="card-body px-5 py-5 pt-10">
          <div class="mb-10">
            <h4 class="text-center">
              ระบุรหัสคำร้องเรียน/หมายเลขบัตรประชาชน/หนังสือเดินทาง
            </h4>
          </div>
          <div class="d-flex justify-content-center mb-7">
            <div
              class="form-check form-check-custom form-check-solid me-5 mb-2"
            >
              <input
                class="form-check-input"
                name="type_of_track"
                type="radio"
                value="1"
                checked
                v-model="item.type_of_track"
                id="flexCheckboxLg"
              />
              <label class="form-check-label fs-5" for="flexCheckboxLg">
                เลขที่ร้องเรียน
              </label>
            </div>
            <div class="form-check form-check-custom form-check-solid mb-2">
              <input
                class="form-check-input"
                name="type_of_track"
                type="radio"
                value="2"
                v-model="item.type_of_track"
                id="flexCheckboxLg"
              />
              <label class="form-check-label fs-5" for="flexCheckboxLg">
                หมายเลขบัตรประชาชน/หนังสือเดินทาง
              </label>
            </div>
          </div>
          <div class="mb-7 d-flex justify-content-center">
            <input
              style="max-width: 600px"
              type="text"
              class="form-control"
              placeholder="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
              aria-label="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
              aria-describedby="basic-addon2"
              v-model="item.id_card_or_jcoms_no"
            />
          </div>
          <div class="d-flex justify-content-center">
            <button class="btn btn-bg-primary text-white" @click="onSearch">
              ค้นหา
            </button>
          </div>
          <div class="separator my-10 mt-15"></div>

          <div class="row">
            <div class="col-md-12 mb-5">
              <h4>รายการเรื่องร้องเรียน</h4>
            </div>
            <div class="col-md-12 table-responsive">
              <table
                class="table table-bordered table-striped"
                style="width: 100%"
              >
                <thead class="bg-color-police">
                  <tr>
                    <th class="text-center text-white">วันที่ร้องเรียน</th>
                    <th class="text-center text-white">รหัสคำร้อง</th>
                    <th class="text-center text-white">ลักษณะความผิด</th>
                    <th class="text-center text-white">เรื่องร้องเรียน</th>
                    <th class="text-center text-white">ผู้ถูกร้อง</th>
                    <th class="text-center text-white">หน่วยงานถูกร้อง</th>
                    <th class="text-center text-white">สถานะ</th>
                    <th class="text-center text-white">รายละอียด</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(it, idx) in items" :key="idx">
                    <td class="text-center">
                      {{ convert_date(it.created_at) }}
                    </td>
                    <td class="text-center">{{ it.jcoms_no }}</td>
                    <td>{{ it.topic_type.name_th }}</td>
                    <td>{{ it.complaint_title }}</td>
                    <td>{{ showAccused(it.accused) }}</td>
                    <td>
                      <span v-if="it.agency_id">{{ it.agency.name_th }}</span>
                      <span v-else-if="it.division_id">{{
                        it.division.name_th
                      }}</span>
                      <span v-else-if="it.bureau_id">{{
                        it.bureau.name_th
                      }}</span>
                      <span v-else-if="it.inspector_id">{{
                        it.inspector.name_th
                      }}</span>
                      <span v-else></span>
                    </td>
                    <td class="text-center">
                      {{
                        it.state.name_th ==
                        "เรื่องร้องเรียนใหม่ (ยังไม่รับเรื่อง)"
                          ? "รอรับเรื่อง"
                          : it.state.name_th
                      }}
                    </td>
                    <td class="text-center">
                      <button
                        class="btn btn-success"
                        @click="
                          () => {
                            data_item = it;
                            detail_modal = true;
                          }
                        "
                      >
                        รายละเอียด
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div id="detail">
      <Detail
        v-if="detail_modal"
        :item="data_item"
        @close-detail-modal="
          () => {
            detail_modal = false;
          }
        "
      />
    </div>

    <div id="otp-before-confirm">
      <Otp
        v-if="otp_modal"
        :otp_send="otp_send"
        @close-otp-modal="
          () => {
            otp_modal = false;
          }
        "
        @fetch-complaint="fetchComplaint"
      />
    </div>
    <!--end::Wrapper-->
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch } from "vue";
import { useRouter } from "vue-router";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
import useAddressData from "@/composables/useAddressData";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// import * as bootstrap from "bootstrap";
import { Modal } from "bootstrap";
// Use Toast Composables
import useToast from "@/composables/useToast";
// import Api Service
import ApiService from "@/core/services/ApiService";
// OTP
import Otp from "@/components/tracking/Otp.vue";
import Detail from "@/components/tracking/Detail.vue";
// import Detail from "@/components/tracking/Detail.vue";

interface PrefixName {
  id: number;
  name_th: string;
  // เพิ่ม property อื่น ๆ ตามโครงสร้างข้อมูลของ prefix_name
}

export default defineComponent({
  name: "tracking",
  components: {
    dayjs,
    Otp,
    Detail,
  },
  setup() {
    // Variable
    const router = useRouter();
    const otp_modal = ref(false);
    const detail_modal = ref(false);
    const otp_send = ref<any>({
      jcoms_no: undefined,
      id_card: undefined,
      phone_number: undefined,
      opt_code: undefined,
      otp_secret: undefined,
    });

    const address_all = ref([]);
    address_all.value = useAddressData().addresses.map((el: any) => {
      el.label =
        el.district +
        " > " +
        el.amphoe +
        " > " +
        el.province +
        " > " +
        el.zipcode;
      return el;
    });

    const selectOptions = ref({
      type_of_track: [
        {
          name: "หมายเลขบัตรประชาชน",
          value: 1,
        },
        {
          name: "หนังสือเดินทาง",
          value: 2,
        },
      ],
      address_all: address_all.value,
      dayornight: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      organizations: [
        {
          name: "สถานีตำรวจภูธรเจาะไอ้ร้อง > บก... > บช.. > สังกัด ...",
          value: 1,
        },
        {
          name: "สถานีตำรวจภูธรจักราช > บก... > บช.. > สังกัด ...",
          value: 2,
        },
      ],
      prefix_names: [],
    });

    const item = ref({
      type_of_track: 1,
      id_card_or_jcoms_no: "",
    });
    const items = ref<any>([]);
    const data_item = ref({});

    const convert_date = (date: any) => {
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    // Fetch
    const fetchComplaint = async (complainant_uuid: any) => {
      let api = {
        type: "query",
        url: "complaint/get-complaint-by-otp",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { complainant_uuid: complainant_uuid, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          items.value = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchPrefixName = async () => {
      let api = {
        type: "query",
        url: "prefix-name",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.prefix_names = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Event
    const onSearch = async () => {
      if (
        item.value.type_of_track == null ||
        item.value.id_card_or_jcoms_no == null ||
        item.value.id_card_or_jcoms_no == ""
      ) {
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return;
      }

      items.value = [];

      if (item.value.type_of_track == 1) {
        otp_send.value.jcoms_no = item.value.id_card_or_jcoms_no;
        otp_send.value.id_card = undefined;
        otp_send.value.phone_number = undefined;
      } else if (item.value.type_of_track == 2) {
        otp_send.value.id_card = item.value.id_card_or_jcoms_no;
        otp_send.value.jcoms_no = undefined;
        otp_send.value.phone_number = undefined;
      } else if (item.value.type_of_track == 3) {
        // data_send.phone_number = item.value.phone_number;
        otp_send.value.jcoms_no = undefined;
        otp_send.value.id_card = undefined;
      } else {
        useToast("พบข้อผิดพลาด", "error");
        return;
      }

      const getRandomEnglishCharacter = () => {
        const characters =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        const randomIndex = Math.floor(Math.random() * characters.length);
        return characters.charAt(randomIndex);
      };

      const generateRandomEnglishString = (length: any) => {
        let result = "";

        for (let i = 0; i < length; i++) {
          const randomChar = getRandomEnglishCharacter();
          result += randomChar;
        }

        return result;
      };

      // Generate a random string of 4 English characters
      otp_send.value.otp_secret = generateRandomEnglishString(4);

      let api = {
        type: "post",
        url: "complaint/get-otp-tracking",
      };

      await ApiService[api.type](api.url, {
        ...otp_send.value,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          otp_send.value.phone_number_res = data.data.phone_number;
          otp_modal.value = true;
        })
        .catch(({ response }) => {
          useToast("ไม่พบข้อมูล", "error");
          console.log(response);
        });
    };

    const showAccused = (accused: any) => {
      let text = "";

      if (accused != null && accused.length != 0) {
        accused.forEach((x: any, idx: number) => {
          if (x.firstname == null) {
            return;
          }
          if (idx != 0) {
            text = text + ", ";
          }

          let fn = x.firstname;
          let ln = x.lastname != null ? x.lastname : "";
          text = text + showPrefix(x.prefix_name_id) + fn + " " + ln;
        });
      }
      return text;
    };

    const showPrefix = (prefix_name_id: any) => {
      let text = "";

      if (prefix_name_id != null) {
        let prefix_name: any;
        prefix_name = selectOptions.value.prefix_names.find((x: any) => {
          return prefix_name_id == x.id;
        });
        if (prefix_name) {
          return prefix_name.name_th;
        }
      }
      return text;
    };

    // Mounted
    onMounted(() => {
      fetchPrefixName();
      // if(state){
      //     fetchComplaint();
      // }
    });

    return {
      getAssetPath,
      selectOptions,
      item,
      items,
      otp_modal,
      otp_send,
      detail_modal,
      convert_date,
      data_item,

      onSearch,
      showAccused,
      showPrefix,
      fetchComplaint,
    };
  },
});
</script>

<style>
.vs__dropdown-toggle {
  border: none;
}

.v-select {
  padding: 0.4em 0.5em;
}

.dp__main {
  padding: 0.35em 0em;
}

.dp__input {
  border: none !important;
}
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}
.bg-color-police {
  background-color: #800001;
}
</style>
