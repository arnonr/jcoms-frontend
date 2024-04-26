<template>
  <div class="row">
    <div class="col-md-12">
      <div class="row">
        <div class="col-md-12 mb-5">
          <h4 class="color-primary">ข้อมูลการดำเนินการ</h4>
        </div>

        <div class="col-md-12">
          <span> สถานะปัจจุบัน : </span>
          <span
            class="badge p-2 text-white fw-bold"
            :style="`background-color: ${complaint_item.state?.bg_color};`"
            >{{ complaint_item.state?.name_th }}</span
          >
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12" v-if="complaint_item.receive_doc_date">
          <span> {{ showDate(complaint_item.receive_doc_date) }} : </span>
          <span class="fw-bold me-10"
            >ฝรท
            {{
              complaint_item.receive_status == 1 ? "รับเรื่อง" : "ไม่รับเรื่อง"
            }}
          </span>
          <span> เลขที่เอกสาร : {{ complaint_item.receive_doc_no }}, </span
          ><span>หมายเหตุ : {{ complaint_item.receive_comment }}, </span
          ><span v-if="complaint_item.receive_doc_filename"
            >ไฟล์แนบ :
            <a :href="complaint_item.receive_doc_filename" target="_blank"
              >คลิก</a
            >
          </span>

          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12" v-if="complaint_item.receive_doc_date">
          <span> {{ showDate(complaint_item.receive_doc_date) }} : </span>
          <span class="fw-bold me-10">ฝรท. ส่งเรื่องต่อ </span>
          <span> เลขที่เอกสาร : {{ complaint_item.receive_doc_no }}, </span
          ><span>หมายเหตุ : {{ complaint_item.receive_comment }}, </span
          ><span v-if="complaint_item.receive_doc_filename"
            >ไฟล์แนบ :
            <a :href="complaint_item.receive_doc_filename" target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12 mb-5 mt-5">
          <h4 class="color-primary">ข้อมูลผู้{{ complaint_type.name_th }}</h4>
        </div>
        <div class="col-md-6">
          <span>ประเภทการระบุตัวตน : </span>
          <span class="fst-italic">{{ new_item.is_anonymous?.name }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-6">
          <span>หมายเลขโทรศัพท์ : </span>
          <span class="fst-italic">{{ complainant_item.phone_number }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12" v-if="complaint_item.is_anonymous == 1">
          <div class="row">
            <div class="col-md-6">
              <span>ประเภทบัตร : </span>
              <span class="fst-italic">
                {{ new_item.card_type?.name }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>หมายเลขบัตรประชาชน/Passport : </span>
              <span class="fst-italic">{{ complainant_item.id_card }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>ชื่อ-นามสกุล : </span>
              <span class="fst-italic"
                >{{ complainant_item.prefix_name_id?.name_th
                }}{{ complainant_item.firstname }}
                {{ complainant_item.lastname }}</span
              >
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
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
                {{ complainant_item.address_all }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>อีเมล : </span>
              <span class="fst-italic">
                {{ complainant_item.email }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
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
                  :src="complainant_item.card_photo"
                  class="mt-5 w-100 w-md-50"
                />
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
          </div>
        </div>

        <div class="col-md-12 mb-5 mt-5">
          <h4 class="color-primary">
            ข้อมูลเรื่อง{{ complaint_type.name_th }}
          </h4>
        </div>

        <div class="col-md-12">
          <span>เลข Jcom : </span>
          <span class="fst-italic">{{ complaint_item.jcoms_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>เลขรับ ฝรท. : </span>
          <span class="fst-italic">{{ complaint_item.receive_doc_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>หัวข้อเรื่อง{{ complaint_type.name_th }} : </span>
          <span class="fst-italic">{{ complaint_item.complaint_title }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ประเภท/ลักษณะเรื่อง : </span>
          <span class="fst-italic">{{
            complaint_item.topic_type?.topic_category.name_th +
            " > " +
            complaint_item.topic_type?.name_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>สถานที่เกิดเหตุ : </span>
          <span class="fst-italic"> {{ complaint_item.address_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ข้อมูลสถานที่เกิดเหตุ : </span>
          <span class="fst-italic">{{ complaint_item.incident_location }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>วันที่เกิดเหตุ : </span>
          <span class="fst-italic">
            {{ new_item.incident_date }}
            {{ new_item.incident_time }}
            {{ "(" + new_item.day_time?.name + ")" }}
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>Google Map : </span>
          <br />
          <GMapMap
            v-if="
              complaint_item.location_coordinates != null &&
              complaint_item.location_coordinates != ''
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

        <div v-for="(ac, idx) in accused_item" :key="idx">
          <div class="col-md-12">
            <span>ผู้ถูกร้องคนที่ {{ Number(idx) + 1 }} : </span>
            <span class="fst-italic">
              {{
                ac.prefix_name_id
                  ? ac.prefix_name?.name_th +
                    "" +
                    ac.firstname +
                    " " +
                    ac.lastname
                  : ""
              }}
            </span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span>ตำแหน่งงาน : </span>
            <span class="fst-italic">{{ ac.position?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span>สายงาน : </span>
            <span class="fst-italic">{{ ac.section?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span>หน่วยงานผู้ถูกร้อง : </span>
            <span class="fst-italic">{{ showAccusedOrganization(ac) }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>

        <div class="col-md-12">
          <span>พฤติกรรมการกระทำความผิด : </span>
          <span class="fst-italic">{{ complaint_item.complaint_detail }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div v-for="(cf, idx) in complaint_file_attach" :key="idx">
          <span>ไฟล์หลักฐานเพิ่มเติม {{ idx + 1 }} : </span>
          <a :href="cf.filename" target="_blank"
            ><span class="fst-italic">คลิก</span></a
          >
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>ช่องทางการร้องเรียน : </span>
          <span class="fst-italic">{{
            complaint_item.complaint_channel?.name_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด : </span>
          <span class="fst-italic">{{ new_item.complaint_channel_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from "vue";
import ApiService from "@/core/services/ApiService";

// Import route
import { useRoute } from "vue-router";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

// Use Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useComplaintChannelData from "@/composables/useComplaintChannelData";
import useBasicData from "@/composables/useBasicData";
import useStateData from "@/composables/useStateData";

export default defineComponent({
  name: "complaint-receive-tab3",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    dayjs,
  },
  setup(props) {
    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: useBasicData().card_types,
      is_anonymouses: useBasicData().is_anonymouses,
      day_times: useBasicData().day_times,
      states: useStateData().states,
    });

    const complaint_item = reactive<any>({});
    const complainant_item = reactive<any>({});
    const accused_item = reactive<any>({});
    const complaint_file_attach = reactive<any>([]);
    const complaint_type = reactive<any>({
      name_th: "",
    });
    const complaint_forward = reactive<any>({});
    const complaint_report = reactive<any>({});
    // Fetch
    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        Object.assign(complaint_item, data.data);

        Object.assign(
          complaint_type,
          useComplaintTypeData().complaint_types.find(
            (x: any) => x.id == complaint_item.complaint_type_id
          )
        );
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplainant = async () => {
      try {
        const { data } = await ApiService.query(
          "complainant/" + complaint_item.complainant_id,
          {}
        );

        Object.assign(complainant_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchAccused = async () => {
      try {
        const { data } = await ApiService.query("accused/", {
          params: {
            complaint_id: complaint_item.id,
          },
        });

        Object.assign(accused_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplaintFileAttach = async () => {
      try {
        const { data } = await ApiService.query("complaint-file-attach/", {
          params: { complaint_id: complaint_item.id },
        });
        Object.assign(complaint_file_attach, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchForward = async () => {
      try {
        const { data } = await ApiService.query("complaint-forward/", {
          params: { complaint_id: complaint_item.id },
        });
        Object.assign(complaint_forward, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchReport = async () => {
      try {
        const { data } = await ApiService.query("complaint-report/", {
          params: { complaint_id: complaint_item.id },
        });
        Object.assign(complaint_report, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    // สถานะ ตั้งแต่ receive ใน complaint เมื่อไหร่ เอกสาร เลขที่เอกสาร หมายเหตุ

    // Forward
    // สถานะ ตั้งแต่ send ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขที่เอกสาร หมายเหตุ
    // สถานะ receive ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขที่เอกสาร หมายเหตุ

    // Report
    // สถานะ ตั้งแต่ send ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขที่เอกสาร หมายเหตุ
    // สถานะ receive ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขที่เอกสาร หมายเหตุ

    const previewImage = ref<any>(null);
    const new_item = reactive<any>({
      is_anonymous: null,
      card_type: null,
      birthday: null,
      organization_all: [],
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
      incident_date: "",
    });

    // Mounted
    onMounted(async () => {
      await fetchComplaint();
      await fetchComplainant();
      await fetchAccused();
      await fetchComplaintFileAttach();
      console.log(complaint_item);
      //   console.log(complainant_item);
      //   console.log(accused_item);
      // console.log(complaint_file_attach);

      // complaint_item.complaint_channel.name_th

      new_item.is_anonymous = selectOptions.value.is_anonymouses.find(
        (x: any) => {
          return x.value == complaint_item.is_anonymous;
        }
      );

      if (complaint_item.is_anonymous == 1) {
        new_item.card_type = selectOptions.value.card_types.find((x: any) => {
          return x.value == complainant_item.card_type;
        });

        new_item.birthday = complainant_item.birthday
          ? dayjs(complainant_item.birthday).locale("th").format("DD MMMM BBBB")
          : "";

        complainant_item.address_all = `${complainant_item.sub_district.name_th} > ${complainant_item.district.name_th} > ${complainant_item.province.name_th} > ${complainant_item.postal_code}`;
      }

      complaint_item.address_all = "";
      if (Object.keys(complaint_item.sub_district).length != 0) {
        complaint_item.address_all = `${complaint_item.sub_district?.name_th} > ${complaint_item.district?.name_th} > ${complaint_item.province?.name_th} > ${complaint_item.postal_code}`;
      }

      if (complaint_item.incident_datetime) {
        new_item.incident_date = dayjs(complaint_item.incident_datetime)
          .utc()
          .locale("th")
          .format("DD MMM BBBB HH:mm");

        new_item.day_time = selectOptions.value.day_times.find((x: any) => {
          return x.value == complaint_item.day_time;
        });
      }

      if (
        complaint_item.location_coordinates != "" &&
        complaint_item.location_coordinates != null
      ) {
        const [lat, lng] = complaint_item.location_coordinates.split(",");
        new_item.markerDetails = {
          id: 1,
          position: { lat: Number(lat), lng: Number(lng) },
        };
      }

      complaint_item.state = selectOptions.value.states.find(
        (x: any) => x.id === complaint_item.state_id
      );
    });

    // Watch

    const showAccusedOrganization = (ac: any) => {
      let item = "";

      if (ac.agency != null) {
        item = item + ac.agency.name_th + " > ";
      }

      if (ac.division != null) {
        item = item + ac.division.name_th + " > ";
      }

      if (ac.bureau != null) {
        item = item + ac.bureau.name_th;
      }

      return item;
    };

    const showDate = (date: any) => {
      if (date == null) {
        return "";
      }
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    // Return
    return {
      complaint_item,
      complainant_item,
      accused_item,
      complaint_file_attach,
      complaint_type,
      new_item,
      previewImage,
      selectOptions,
      showAccusedOrganization,
      showDate,
    };
  },
});
</script>

<style>
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}

.color-primary {
  color: #800001;
}
</style>
