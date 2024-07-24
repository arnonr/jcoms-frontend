<template>
  <div>
    <!-- Modal OTP -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="detailModalRef"
      id="detail-modal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
    >
      <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">รายละเอียด</h3>
          </div>

          <div class="modal-body">
            <div class="col-md-12">
              <div class="row">
                <div class="col-md-12 mb-5">
                  <h4>
                    ข้อมูลผู้{{
                      item.complaint_type != null
                        ? item.complaint_type.name_th
                        : ""
                    }}
                  </h4>
                </div>
                <div class="col-md-12">
                  <span>หมายเลขโทรศัพท์ : </span>
                  <span class="fst-italic">{{ complainant.phone_number }}</span>
                  <div class="separator separator-dotted my-2"></div>
                </div>
                <div class="col-md-12" v-if="item.is_anonymous == 1">
                  <div class="row">
                    <div class="col-md-12">
                      <span>ประเภทบัตร : </span>
                      <span class="fst-italic">{{
                        showCardType(complainant.card_type)
                      }}</span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>หมายเลขบัตรประชาชน/Passport : </span>
                      <span class="fst-italic">{{ complainant.id_card }}</span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>ชื่อ-นามสกุล : </span>
                      <span class="fst-italic"
                        >{{ complainant.prefix_name_id?.name_th
                        }}{{ complainant.firstname }}
                        {{ complainant.lastname }}</span
                      >
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>วัน/เดือน/ปีเกิด : </span>
                      <span class="fst-italic">
                        {{ showDate(complainant.birthday) }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>อาชีพ : </span>
                      <span class="fst-italic">
                        {{ complainant.occupation_text }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>ที่อยู่ : </span>
                      <span class="fst-italic">
                        {{
                          complainant.house_number
                            ? "บ้านเลขที่ " + complainant.house_number
                            : ""
                        }}{{
                          complainant.building
                            ? " หมู่บ้าน " + complainant.building
                            : ""
                        }}{{
                          complainant.moo ? " หมู่ที่ " + complainant.moo : ""
                        }}{{
                          complainant.soi ? " ตรอก/ซอย " + complainant.soi : ""
                        }}{{
                          complainant.road ? " ถนน " + complainant.road : ""
                        }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>ตำบล/อำเภอ/จังหวัด : </span>
                      <span class="fst-italic">
                        {{
                          complainant.sub_district?.name_th +
                          " > " +
                          complainant.district?.name_th +
                          " > " +
                          complainant.province?.name_th +
                          " > " +
                          complainant.postal_code
                        }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>อีเมล : </span>
                      <span class="fst-italic">
                        {{ complainant.email }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>Line ID : </span>
                      <span class="fst-italic">
                        {{ complainant.line_id }}
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                    <div class="col-md-12">
                      <span>รูปถ่ายตนเองพร้อมบัตร : </span>
                      <br />
                      <span class="fst-italic">
                        <img :src="complainant.card_photo" class="mt-5 w-40" />
                      </span>
                      <div class="separator separator-dotted my-2"></div>
                    </div>
                  </div>
                </div>

                <div class="col-md-12 mb-5 mt-5">
                  <h4>ข้อมูลเรื่อง{{ item.complaint_type.name_th }}</h4>
                </div>

                <div class="col-md-12">
                  <span>หัวข้อเรื่อง{{ item.complaint_type.name_th }} : </span>
                  <span class="fst-italic">{{ item.complaint_title }}</span>
                  <div class="separator separator-dotted my-2"></div>
                </div>
                <div class="col-md-12">
                  <span>ประเภท/ลักษณะเรื่อง : </span>
                  <span class="fst-italic">{{
                    showTopic(item.topic_type_id)
                  }}</span>
                  <div class="separator separator-dotted my-2"></div>
                </div>
                <div class="col-md-12">
                  <span>สถานที่เกิดเหตุ : </span>
                  <span class="fst-italic">
                    {{
                      item.sub_district?.name_th +
                      " > " +
                      item.district?.name_th +
                      " > " +
                      item.province?.name_th +
                      " > " +
                      item.postal_code
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
                    {{ showDate(item.incident_datetime, true) }}
                    {{ "(" + showDayTime(item.day_time) + ")" }}</span
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
                  <div class="separator separator-dotted my-2"></div>
                </div>

                <div v-for="(ac, idx) in accused" :key="idx">
                  <div class="col-md-12">
                    <span>ผู้ถูกร้อง คนที่ {{ idx + 1 }} : </span>
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
                    <span class="fst-italic">{{
                      showAccusedOrganization(ac)
                    }}</span>
                    <div class="separator separator-dotted my-2"></div>
                  </div>
                </div>

                <div class="col-md-12">
                  <span>พฤติกรรมการกระทำความผิด : </span>
                  <span class="fst-italic">{{ item.complaint_detail }}</span>
                  <div class="separator separator-dotted my-2"></div>
                </div>

                <div class="col-md-12">
                  <span>เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด : </span>
                  <span
                    class="fst-italic"
                    v-for="(it, idx) in item.channel_history"
                    :key="idx"
                    >{{ it.channel.name_th + ", " }}</span
                  >
                  <div class="separator separator-dotted my-2"></div>
                </div>

                <div class="text-center mt-5">
                  <button class="btn btn-primary" @click="onClose">
                    Close
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, onUnmounted, watch } from "vue";
import ApiService from "@/core/services/ApiService";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);
// Import Modal Bootstrap
import { Modal } from "bootstrap";
import useComplaintTopicData from "@/composables/useComplaintTopicData";

export default defineComponent({
  name: "tracking-detail",
  props: {
    item: {
      type: Object,
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
    const complainant = ref<any>({});
    const accused = ref<any>([]);

    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: [
        {
          name: "หมายเลขบัตรประชาชน",
          value: 1,
        },
        {
          name: "หนังสือเดินทาง",
          value: 2,
        },
      ],
      day_times: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      complaint_topics: useComplaintTopicData().complaint_topics,
    });

    const detailModalRef = ref<any>(null);
    const detailModalObj = ref<any>(null);

    const new_item = ref<any>({
      birthday: null,
      organization_all: [],
      preview_card_photo: null,
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
    });

    // Fetch
    const fetchComplainant = async () => {
      let api = {
        type: "query",
        url: "complainant/",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url + props.item.complainant_id)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          complainant.value = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchAccused = async () => {
      let api = {
        type: "query",
        url: "accused",
      };

      await ApiService[api.type](api.url, {
        params: { complaint_id: props.item.id },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          accused.value = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Event
    const onDetailModal = () => {
      detailModalObj.value.show();
    };

    const showCardType = (card_type: any) => {
      let find_card_type = selectOptions.value.card_types.find((x) => {
        return x.value == card_type;
      });

      return find_card_type?.name;
    };

    const showTopic = (topic_type_id: any) => {
      let find_complaint_topic = selectOptions.value.complaint_topics.find(
        (x: any) => {
          return x.topic_type_id == topic_type_id;
        }
      );

      return (
        find_complaint_topic?.complaint_type_th +
        " > " +
        find_complaint_topic?.topic_category_th +
        " > " +
        find_complaint_topic?.topic_type_th
      );
    };

    const showDayTime = (day_time: any) => {
      let find_day_time = selectOptions.value.day_times.find((x) => {
        return x.value == day_time;
      });

      return find_day_time?.name;
    };

    const showDate = (date: any, time: any = false) => {
      if (time == true) {
        return dayjs(date).utc().locale("th").format("DD MMM BBBB HH:mm");
      }
      return dayjs(date).utc().locale("th").format("DD MMM BBBB");
    };

    const showPhoto = (image: any) => {
      return import.meta.env.VITE_APP_API_UPLOAD_URL + image;
    };

    const showAccusedOrganization = (ac: any) => {
      let item = "";

      if (ac.agency != null) {
        item = item + ac.agency.name_th;
      }
      if (ac.division != null) {
        item = item + " > " + ac.division.name_th;
      }

      if (ac.bureau != null) {
        item = item + " > " + ac.bureau.name_th;
      }

      return item;
    };

    const onClose = () => {
      detailModalObj.value.hide();
      emit("close-detail-modal");
    };

    // Mounted
    onMounted(() => {
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

      fetchComplainant();
      fetchAccused();
      detailModalObj.value = new Modal(detailModalRef.value, {});
      onDetailModal();
    });

    onUnmounted(() => {
      detailModalObj.value.hide();
    });

    // Watch

    // Return
    return {
      getAssetPath,
      item,
      new_item,
      selectOptions,
      detailModalRef,
      detailModalObj,
      showCardType,
      showDate,
      showPhoto,
      showTopic,
      showDayTime,
      showAccusedOrganization,
      complainant,
      onClose,
      accused,
    };
  },
});
</script>
