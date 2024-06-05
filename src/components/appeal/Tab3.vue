<template>
  <div class="row">
    <div class="col-md-12 mb-5 mt-5">
      <h4>3. ยืนยันข้อมูล</h4>
    </div>
    <!-- <div class="separator my-10"></div> -->
    <div class="col-md-12">
      <div class="row">
        <div class="col-md-12 mb-5">
          <h4>3.1 ข้อมูลผู้{{ complant_type.name_th }}</h4>
        </div>
        <div class="col-md-6">
          <span>ประเภทการระบุตัวตน : </span>
          <span class="fst-italic">{{ new_item.is_anonymous?.name }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>หมายเลขโทรศัพท์ : </span>
          <span class="fst-italic">{{ complainant_item.phone_number }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12" v-if="item.is_anonymous == 1">
          <div class="row">
            <div class="col-md-12">
              <span>ประเภทบัตร : </span>
              <span class="fst-italic">{{
                selectOptions.card_types[complainant_item.card_type.value - 1]
                  .name
              }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>หมายเลขบัตรประชาชน/Passport : </span>
              <span class="fst-italic">{{ complainant_item.id_card }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>ชื่อ-นามสกุล : </span>
              <span class="fst-italic"
                >{{ complainant_item.prefix_name_id?.name_th
                }}{{ complainant_item.firstname }}
                {{ complainant_item.lastname }}</span
              >
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>วัน/เดือน/ปีเกิด : </span>
              <span class="fst-italic">
                {{ new_item.birthday }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>อาชีพ : </span>
              <span class="fst-italic">
                {{ complainant_item.occupation_text }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>ที่อยู่ : </span>
              <span class="fst-italic">
                {{
                  complainant_item.house_number
                    ? "บ้านเลขที่ " + complainant_item.house_number
                    : ""
                }}{{
                  complainant_item.building
                    ? " หมู่บ้าน " + complainant_item.building
                    : ""
                }}{{
                  complainant_item.moo
                    ? " หมู่ที่ " + complainant_item.moo
                    : ""
                }}{{
                  complainant_item.soi
                    ? " ตรอก/ซอย " + complainant_item.soi
                    : ""
                }}{{
                  complainant_item.road ? " ถนน " + complainant_item.road : ""
                }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>ตำบล/อำเภอ/จังหวัด : </span>
              <span class="fst-italic">
                {{
                  complainant_item.address_all?.sub_district_th +
                  " > " +
                  complainant_item.address_all?.district_th +
                  " > " +
                  complainant_item.address_all?.province_th +
                  " > " +
                  complainant_item.address_all?.post_code
                }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>อีเมล : </span>
              <span class="fst-italic">
                {{ complainant_item.email }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>Line ID : </span>
              <span class="fst-italic">
                {{ complainant_item.line_id }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>รูปถ่ายตนเองพร้อมบัตร : </span>
              <br />
              <span class="fst-italic">
                <img
                  :src="
                    new_item.preview_card_photo !== null
                      ? new_item.preview_card_photo
                      : complainant_item.card_photo_old
                  "
                  class="mt-5 w-100 w-md-50"
                />
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
          </div>
        </div>

        <div class="col-md-12 mb-5 mt-5">
          <h4>3.2 ข้อมูลเรื่อง{{ complant_type.name_th }}</h4>
        </div>

        <div class="col-md-12">
          <span>หัวข้อเรื่อง{{ complant_type.name_th }} : </span>
          <span class="fst-italic">{{ item.complaint_title }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ประเภท/ลักษณะเรื่อง : </span>
          <span class="fst-italic">{{
            item.complaint_topic?.topic_category_th +
            " > " +
            item.complaint_topic?.topic_type_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>สถานที่เกิดเหตุ : </span>
          <span class="fst-italic">
            {{
              item.address_all?.sub_district_th +
              " > " +
              item.address_all?.district_th +
              " > " +
              item.address_all?.province_th +
              " > " +
              item.address_all?.post_code
            }}</span
          >
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ข้อมูลสถานที่เกิดเหตุ : </span>
          <span class="fst-italic">{{ item.incident_location }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>วันที่เกิดเหตุ : </span>
          <span class="fst-italic">
            {{ new_item.incident_date }}
            {{ new_item.incident_time }}
            {{ new_item.day_time }}</span
          >
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>Google Map : </span>
          <br />
          <GMapMap
            v-if="
              item.location_coordinates != null &&
              item.location_coordinates != ''
            "
            :center="new_item.markerDetails.position"
            :click="false"
            :zoom="16"
            map-type-id="terrain"
            style="width: 100%; height: 400px"
          >
            <GMapMarker
              :key="1"
              :position="new_item.markerDetails.position"
              :clickable="false"
              :draggable="false"
            >
            </GMapMarker>
          </GMapMap>
          <!-- <span class="fst-italic"> </span> -->
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div v-for="(ac, idx) in accused" :key="idx">
          <div class="col-md-12">
            <span>ผู้ถูกร้องคนที่ {{ Number(idx) + 1 }} : </span>
            <span class="fst-italic">
              {{
                ac.prefix_name_id
                  ? ac.prefix_name_id?.name_th
                  : "" + ac.firstname + " " + ac.lastname
              }}
            </span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span>หน่วยงานผู้ถูกร้อง : </span>
            <span class="fst-italic">{{ new_item.organization_all[idx] }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>

        <div class="col-md-12">
          <span>พฤติกรรมการกระทำความผิด : </span>
          <span class="fst-italic">{{ item.complaint_detail }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <!-- <div>
          <span>ไฟล์หลักฐานเพิ่มเติม : </span>
          <span class="fst-italic">PDF</span>
          <div class="separator separator-dotted my-2"></div>
        </div> -->

        <div v-for="(cf, idx) in complaint_file_attach" :key="idx">
          <span>ไฟล์หลักฐานเพิ่มเติม {{ idx + 1 }} : </span>
          <a :href="cf.filename" target="_blank"
            ><span class="fst-italic">คลิก</span></a
          >
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด : </span>
          <span class="fst-italic">{{ new_item.complaint_channel_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12 mt-5 mb-5">
          <div
            class="d-flex justify-content-center align-items-center"
            @click="onPolicyModal"
          >
            <input
              class="form-check-input form-control form-check-input-custom"
              type="checkbox"
              :checked="policy_checkbox_tab"
              name="flexCheckDefault"
              disabled
            />
            <label
              class="form-check-label ms-3 text-primary fw-bold fs-3"
              for="checkboxCentered"
              >ยอมรับ นโนบายข้อมูลส่วนบุคคลและ พรบ. คุ้มครองข้อมูล</label
            >
          </div>
        </div>
      </div>
    </div>

    <div class="modal fade" tabindex="1" ref="policyModalRef" id="policy-modal">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3>ยอมรับนโยบาย</h3>
          </div>

          <div class="modal-body mx-auto pb-10 pt-10 text-center">
            <h3 class="modal-title mb-4">
              ความยินยอมเพื่อเก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลส่วนบุคคลของ
              ตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ.2562
            </h3>
            <div>
              เพื่อเป็นการปฏิบัติให้เป็นไปตามข้อกำหนดของพระราชบัญญัติคุุ้มครองข้อมูลส่วนบุคคล
              พ.ศ. 2562 สำนักงานจเรตำรวจได้ดำเนินการควบคุม
              และจัดให้มีระบบงานที่เหมาะสมเพื่อให้มั่นใจได้ว่าข้อมูลส่วนบุคคลของท่านได้รับการรวบรวมจัดเก็บ
              ประมวลผล และเผยแพร่ โดยเป็นไปตามข้อกำหนดและได้รับความปลอดภัย
              ท่านสามารถศึกษารายละเอียดได้ที่ https://jaray.police.go.th
            </div>
            <div class="mt-5">
              <button class="btn btn-primary" @click="onAcceptPolicy(1)">
                ยอมรับ
              </button>
              <button class="btn btn-secondary ms-4" @click="onAcceptPolicy(0)">
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch, reactive } from "vue";
import ApiService from "@/core/services/ApiService";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// Import Modal Bootstrap
import { Modal } from "bootstrap";

import useBasicData from "@/composables/useBasicData";

export default defineComponent({
  name: "tab3",
  props: {
    item: {
      type: Object,
      required: true,
    },
    complainant_item: {
      type: Object,
      required: true,
    },
    accused: {
      type: Object,
      required: true,
    },
    complant_type: {
      type: Object,
      required: true,
    },
    r: {
      type: String,
      required: true,
    },
  },
  components: {
    dayjs,
  },
  setup(props, context) {
    const emit = context.emit;
    // Variable
    const item = ref<any>(props.item);
    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: useBasicData().card_types,
      is_anonymouses: useBasicData().is_anonymouses,
      day_times: useBasicData().day_times,
    //   states: useStateData().states,
     
    });
    const policy_checkbox_tab = ref<boolean>(false);

    const policyModalRef = ref<any>(null);
    const policyModalObj = ref<any>(null);
    const complaint_file_attach = reactive<any>([]);

    // Fetch

    const fetchComplaintFileAttach = async () => {
      try {
        const { data } = await ApiService.query("complaint-file-attach/", {
          params: { secret_key: props.r },
        });
        complaint_file_attach.length = 0;
        Object.assign(complaint_file_attach, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplaintChannel = () => {
      const params = {
        perPage: 100,
      };
      ApiService.query("complaint-channel", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.complaint_channels = data.data;

          if (props.item.complaint_channel_all.length > 0) {
            props.item.complaint_channel_all.forEach((el: any) => {
              let comma_text = " , ";
              if (new_item.value.complaint_channel_all.length == 0) {
                comma_text = "";
              }
              new_item.value.complaint_channel_all =
                new_item.value.complaint_channel_all +
                comma_text +
                selectOptions.value.complaint_channels[el - 1].name_th;
            });
          }
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    // Event
    const onPolicyModal = () => {
      policyModalObj.value.show();
    };

    const onAcceptPolicy = (value: number) => {
      // checkbox
      if (value == 1) {
        policy_checkbox_tab.value = true;
        emit("change-policy", true);
        policyModalObj.value.hide();
      } else {
        policy_checkbox_tab.value = false;
        emit("change-policy", false);
        policyModalObj.value.hide();
      }
    };

    // Mounted
    const new_item = ref<any>({
      birthday: null,
      organization_all: [],
      preview_card_photo: null,
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
    });

    onMounted(() => {
      policyModalObj.value = new Modal(policyModalRef.value, {});
      fetchComplaintChannel();

      fetchComplaintFileAttach();

      new_item.value.is_anonymous = selectOptions.value.is_anonymouses.find(
        (x: any) => {
          return x.value == props.item.is_anonymous;
        }
      );

      new_item.value.birthday = props.complainant_item.birthday
        ? dayjs(props.complainant_item.birthday)
            .locale("th")
            .format("DD MMMM BBBB")
        : "";
      new_item.value.incident_date = props.item.incident_date
        ? dayjs(props.item.incident_date).locale("th").format("DD MMMM BBBB")
        : "";
      new_item.value.incident_time = props.item.incident_time
        ? "เวลา " +
          props.item.incident_time.hours +
          ":" +
          props.item.incident_time.minutes +
          " น."
        : "";
      new_item.value.day_time = props.item.day_time
        ? "(" + props.item.day_time.name + ")"
        : "";

      if (
        props.complainant_item.card_photo != null &&
        props.complainant_item.card_photo != ""
      ) {
        new_item.value.preview_card_photo = URL.createObjectURL(
          props.complainant_item.card_photo
        );
      }

      if (
        props.item.location_coordinates != "" &&
        props.item.location_coordinates != null
      ) {
        const [lat, lng] = props.item.location_coordinates.split(",");
        new_item.value.markerDetails = {
          id: 1,
          position: { lat: Number(lat), lng: Number(lng) },
        };
      }

      if (props.accused.length > 0) {
        props.accused.forEach((el: any, i: number) => {
          if (el.organization_all != null) {
            if (el.organization_all.hasOwnProperty("agency_id")) {
              new_item.value.organization_all[i] =
                el.organization_all.agency_th + " > ";
            }

            if (el.organization_all.hasOwnProperty("division_id")) {
              new_item.value.organization_all[i] =
                new_item.value.organization_all[i] +
                el.organization_all.division_th +
                " > ";
            }

            if (el.organization_all.hasOwnProperty("bureau_id")) {
              new_item.value.organization_all[i] =
                new_item.value.organization_all[i] +
                el.organization_all.bureau_th;
            }

            //   if (el.organization_all.hasOwnProperty("inspector_id")) {
            //     new_item.value.organization_all =
            //      el.organization_all.inspector_th;
            //   }
          }
        });
      }

      // previewImage.value = URL.createObjectURL(item.value.card_photo);
    });

    // onUnMounted(() => {

    // })

    // Watch

    // Return
    return {
      getAssetPath,
      item,
      new_item,
      policy_checkbox_tab,
      selectOptions,
      complaint_file_attach,

      policyModalObj,
      policyModalRef,
      onPolicyModal,
      onAcceptPolicy,
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

.form-check-input-custom {
  border-radius: 0.45em;
  border-color: #1b84ff;
  border-width: 2px;
}

.form-check-input-custom:disabled {
  pointer-events: none;
  filter: none;
  opacity: 1;
}

.form-check-input-custom:disabled {
  color: var(--bs-gray-500);
  background-color: none !important;
  border-color: #1b84ff;
  opacity: 1;
}

.form-check-input[disabled] ~ .form-check-label,
.form-check-input:disabled ~ .form-check-label {
  opacity: 1;
}
</style>
