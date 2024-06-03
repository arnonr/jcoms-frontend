<template>
  <tab-content :title="'สรุปข้อมูล'">
    <div class="row" v-if="tab_index == 2">
      <div class="col-md-12">
        <div class="row">
          <div class="col-md-12 mb-5">
            <h4>3.1 ข้อมูลผู้{{ complaint_type.name_th }}</h4>
          </div>
          <div class="col-md-6">
            <span class="fw-bold">ประเภทการระบุตัวตน : </span>
            <span class="fst-italic">{{ new_item.is_anonymous?.name }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span class="fw-bold">หมายเลขโทรศัพท์ : </span>
            <span class="fst-italic">{{ complainant_item.phone_number }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12" v-if="complaint_item.is_anonymous == 1">
            <div class="row">
              <div class="col-md-6">
                <span class="fw-bold">ประเภทบัตร : </span>
                <span class="fst-italic">{{
                  selectOptions.card_types[complainant_item.card_type.value - 1]
                    .name
                }}</span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-6">
                <span class="fw-bold">หมายเลขบัตรประชาชน/Passport : </span>
                <span class="fst-italic">{{ complainant_item.id_card }}</span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-6">
                <span class="fw-bold">ชื่อ-นามสกุล : </span>
                <span class="fst-italic"
                  >{{ complainant_item.prefix_name_id?.name_th
                  }}{{ complainant_item.firstname }}
                  {{ complainant_item.lastname }}</span
                >
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-6">
                <span class="fw-bold">วัน/เดือน/ปีเกิด : </span>
                <span class="fst-italic">
                  {{ new_item.birthday }}
                </span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-12">
                <span class="fw-bold">อาชีพ : </span>
                <span class="fst-italic">
                  {{ complainant_item.occupation_text }}
                </span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-12">
                <span class="fw-bold">ที่อยู่ : </span>
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
                <span class="fw-bold">ตำบล/อำเภอ/จังหวัด : </span>
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
              <div class="col-md-6">
                <span class="fw-bold">อีเมล : </span>
                <span class="fst-italic">
                  {{ complainant_item.email }}
                </span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-6">
                <span class="fw-bold">Line ID : </span>
                <span class="fst-italic">
                  {{ complainant_item.line_id }}
                </span>
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-12">
                <span class="fw-bold">รูปถ่ายตนเองพร้อมบัตร : </span>
                <br />
                <span class="fst-italic">
                  <img
                    :src="previewCardPhoto"
                    class="mt-5 w-100 w-md-50"
                    v-if="previewCardPhoto"
                  />
                  <img
                    :src="
                      previewCardPhoto == null &&
                      complainant_item.card_photo_old != null
                        ? complainant_item.card_photo_old
                        : null
                    "
                    alt=""
                    class="mt-5 w-100 w-md-50"
                  />
                </span>
                <div class="separator separator-dotted my-2"></div>
              </div>
            </div>
          </div>

          <div class="col-md-12 mb-5 mt-5">
            <h4>3.2 ข้อมูลเรื่อง{{ complaint_type.name_th }}</h4>
          </div>

          <div class="col-md-12">
            <span class="fw-bold">หมายเลขรหัส Jcoms : </span>
            <span class="fst-italic">{{ complaint_item.jcoms_no }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div class="col-md-12">
            <span class="fw-bold"
              >หัวข้อเรื่อง{{ complaint_type.name_th }} :
            </span>
            <span class="fst-italic">{{ complaint_item.complaint_title }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">ประเภท/ลักษณะเรื่อง : </span>
            <span class="fst-italic">{{
              complaint_item.complaint_topic?.topic_category_th +
              " > " +
              complaint_item.complaint_topic?.topic_type_th
            }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">สถานที่เกิดเหตุ : </span>
            <span class="fst-italic">
              {{
                complaint_item.address_all?.sub_district_th +
                " > " +
                complaint_item.address_all?.district_th +
                " > " +
                complaint_item.address_all?.province_th +
                " > " +
                complaint_item.address_all?.post_code
              }}</span
            >
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">ข้อมูลสถานที่เกิดเหตุ : </span>
            <span class="fst-italic">{{
              complaint_item.incident_location
            }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">วันที่เกิดเหตุ : </span>
            <span class="fst-italic">
              {{ new_item.incident_date }}
              {{ new_item.incident_time }}
              {{ new_item.day_time }}</span
            >
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">Google Map : </span>
            <br />
            <GMapMap
              v-if="
                complaint_item.location_coordinates != null &&
                complaint_item.location_coordinates != ''
              "
              :center="new_item.markerDetails.position"
              :click="false"
              :zoom="14"
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

          <div v-for="(ac, idx) in accused" :key="idx" class="row">
            <div class="col-md-12">
              <span class="fw-bold">ผู้ถูกร้องคนที่ {{ idx + 1 }} : </span>
              <span class="fst-italic">
                {{
                  ac.prefix_name_id
                    ? ac.prefix_name_id?.name_th +
                      "" +
                      ac.firstname +
                      " " +
                      ac.lastname
                    : ""
                }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span class="fw-bold">หน่วยงานผู้ถูกร้อง : </span>
              <span class="fst-italic">{{ ac.organization_all?.label }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">สายงาน : </span>
              <span class="fst-italic">{{ ac.section_id?.name_th }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">ตำแหน่งงาน : </span>
              <span class="fst-italic">{{ ac.position_id?.name_th }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
          </div>

          <div class="col-md-12">
            <span class="fw-bold">พฤติกรรมการกระทำความผิด : </span>
            <span class="fst-italic">{{
              complaint_item.complaint_detail
            }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div v-for="(cf, idx) in complaint_file_attach" :key="idx">
            <span class="fw-bold">ไฟล์หลักฐานเพิ่มเติม {{ idx + 1 }} : </span>
            <a :href="cf.filename" target="_blank"
              ><span class="fst-italic">คลิก</span></a
            >
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div class="col-md-12">
            <span class="fw-bold">ลิ้งค์เพิ่มเติม : </span>
            <span
              class="fst-italic"
              v-for="(eu, idx) in new_item.evidence_url"
              :key="idx"
              >{{ idx != 0 ? " , " : "" }}
              <a :href="eu" target="_blank">{{ eu }}</a>
            </span>
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div class="col-md-12">
            <span class="fw-bold">เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด : </span>
            <span class="fst-italic">{{ new_item.complaint_channel_all }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span class="fw-bold">เคยร้องเรียนผ่านช่องทางร้องเรียนอื่น : </span>
            <span class="fst-italic">{{
              complaint_item.channel_history_text
            }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>
      </div>
    </div>
  </tab-content>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, toRefs, watch } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// Import FormWizard
import { TabContent } from "vue3-form-wizard";

import useBasicData from "@/composables/useBasicData";
import useMasterData from "@/composables/useMasterData";

export default defineComponent({
  name: "complaint-form-tab3",
  props: {
    complaint_type: {
      type: Object,
      required: true,
    },
    complaint_item: {
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
    tab_index: {
      type: Number,
      required: true,
    },
  },
  components: {
    dayjs,
    TabContent,
  },
  setup(props) {
    // Variable
    const { tab_index, complaint_item, complainant_item } = toRefs(props);

    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: useBasicData().card_types,
      is_anonymouses: useBasicData().is_anonymouses,
    });

    const complaint_file_attach = reactive<any>([]);

    // Fetch
    const fetchComplaintFileAttach = async () => {
      try {
        const { data } = await ApiService.query("complaint-file-attach/", {
          params: { complaint_id: complaint_item.value.id },
        });
        Object.assign(complaint_file_attach, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    // Mounted
    const previewCardPhoto = ref<any>(null);
    const new_item = reactive<any>({
      is_anonymous: null,
      birthday: null,
      organization_all: [],
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
      card_type: null,
      evidence_url: [],
    });

    const beforeShowTab = () => {
      fetchComplaintFileAttach();

      new_item.complaint_channel_all = "";
      if (complaint_item.value.complaint_channel_all.length > 0) {
        props.complaint_item.complaint_channel_all.forEach((el: any) => {
          let comma_text = " , ";
          if (new_item.complaint_channel_all.length == 0) {
            comma_text = "";
          }
          new_item.complaint_channel_all =
            new_item.complaint_channel_all +
            comma_text +
            selectOptions.value.complaint_channels[el - 1].name_th;
        });
      }

      new_item.is_anonymous = selectOptions.value.is_anonymouses.find(
        (x: any) => {
          return x.value == complaint_item.value.is_anonymous;
        }
      );

      if (complainant_item.value.card_photo.length != 0) {
        previewCardPhoto.value = URL.createObjectURL(
          complainant_item.value.card_photo
        );
      } else {
        previewCardPhoto.value = null;
      }

      new_item.birthday = complainant_item.value.birthday
        ? dayjs(complainant_item.value.birthday)
            .locale("th")
            .format("DD MMMM BBBB")
        : "";

      // Get Incident Date
      new_item.incident_date = complaint_item.value.incident_datetime
        ? dayjs(complaint_item.value.incident_datetime)
            .locale("th")
            .format("DD MMMM BBBB")
        : "";

      // Get Incident Time
      if (complaint_item.value.incident_time) {
        let prefix_hours = "";
        let prefix_minutes = "";
        if (complaint_item.value.incident_time.hours.length == 1) {
          prefix_hours = "0";
        }
        if (complaint_item.value.incident_time.minutes.length == 1) {
          prefix_minutes = "0";
        }

        new_item.incident_time =
          "เวลา " +
          prefix_hours +
          complaint_item.value.incident_time.hours +
          ":" +
          prefix_minutes +
          complaint_item.value.incident_time.minutes +
          " น.";
      }

      new_item.day_time = complaint_item.value.day_time
        ? "(" + complaint_item.value.day_time.name + ")"
        : "";

      if (
        complaint_item.value.location_coordinates != "" &&
        complaint_item.value.location_coordinates != null
      ) {
        const [lat, lng] = complaint_item.value.location_coordinates.split(",");
        new_item.markerDetails = {
          id: 1,
          position: { lat: Number(lat), lng: Number(lng) },
        };
      }

      new_item.evidence_url =
        complaint_item.value.evidence_url != "" &&
        complaint_item.value.evidence_url != null
          ? complaint_item.value.evidence_url
              .split(",")
              .map((it: any) => it.replace(/(^'|'$)/g, ""))
          : [];
    };

    onMounted(async () => {
      selectOptions.value.complaint_channels =
        await useMasterData().fetchComplaintChannel({
          is_active: 1,
          perPage: 500,
        });

      beforeShowTab();
    });

    // Watch
    watch(
      () => tab_index.value,
      () => {
        beforeShowTab();
      }
    );
    // onCalulate

    // Return
    return {
      selectOptions,
      new_item,
      previewCardPhoto,
      complaint_file_attach,
    };
  },
});
</script>

<style scoped>
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

.color-primary {
  color: #800001;
}
</style>
