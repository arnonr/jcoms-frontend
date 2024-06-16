<template>
  <div>
    <h2 class="accordion-header">
      <h4 class="color-primary">ข้อมูลเรื่อง{{ complaint_type.name_th }}</h4>
    </h2>
    <div id="item4">
      <div class="accordion-body">
        <div class="col-md-12">
          <span class="fw-bold">หมายเลขรหัส Jcoms : </span>
          <span class="fst-italic">{{ complaint_item.jcoms_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">เลขรับ ฝรท. : </span>
          <span class="fst-italic">{{ complaint_item.receive_doc_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span class="fw-bold">หัวข้อเรื่อง : </span>
          <span class="fst-italic">{{ complaint_item.complaint_title }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">ประเภท/ลักษณะเรื่อง : </span>
          <span class="fst-italic">{{
            complaint_item.topic_type?.topic_category.name_th +
            " > " +
            complaint_item.topic_type?.name_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">สถานที่เกิดเหตุ : </span>
          <span class="fst-italic"> {{ complaint_item.address_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">ข้อมูลสถานที่เกิดเหตุ : </span>
          <span class="fst-italic">{{ complaint_item.incident_location }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">วันที่เกิดเหตุ : </span>
          <span class="fst-italic">
            {{ new_item.incident_date }}
            {{ new_item.incident_time }}
            {{ "(" + new_item.day_time?.name + ")" }}
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span class="fw-bold">Google Map : </span>
          <br />
          <GMapMap
            v-if="
              complaint_item.location_coordinates != null &&
              complaint_item.location_coordinates != '' &&
              new_item.markerDetails.position.lat != null
            "
            :center="new_item.markerDetails.position"
            :click="false"
            :zoom="14"
            map-type-id="terrain"
            style="width: 100%; height: 300px"
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

        <div v-for="(ac, idx) in accused_item" :key="idx" class="row">
          <div class="col-md-12">
            <span class="fw-bold"
              >ผู้ถูกร้องคนที่ {{ Number(idx) + 1 }} :
            </span>
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
          <div class="col-md-12">
            <span class="fw-bold">หน่วยงานผู้ถูกร้อง : </span>
            <span class="fst-italic">{{ showAccusedOrganization(ac) }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span class="fw-bold">ตำแหน่งงาน : </span>
            <span class="fst-italic">{{ ac.position?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span class="fw-bold">สายงาน : </span>
            <span class="fst-italic">{{ ac.section?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>

        <div class="col-md-12">
          <span class="fw-bold">พฤติกรรมการกระทำความผิด : </span>
          <span class="fst-italic">{{ complaint_item.complaint_detail }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div>
          <span class="fw-bold"
            >ไฟล์หลักฐานเพิ่มเติม : {{ complaint_file_attach.length }} รายการ</span
          >

          <div class="separator separator-dotted my-2"></div>
        </div>

        <!-- <div v-for="(cf, idx) in complaint_file_attach" :key="idx">
          <span class="fw-bold">ไฟล์หลักฐานเพิ่มเติม {{ idx + 1 }} : </span>
          <a :href="cf.filename" target="_blank"
            ><span class="fst-italic">คลิก</span></a
          >
          <div class="separator separator-dotted my-2"></div>
        </div> -->

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
          <span class="fw-bold">ช่องทางการร้องเรียน : </span>
          <span class="fst-italic">{{
            complaint_item.complaint_channel?.name_th
          }}</span>
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

        <div class="col-md-12">
            <span class="fw-bold">วันที่พิมพ์ข้อมูล :  </span>
            <span class="fst-italic"> {{ new Date() }}</span>
            <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
            <span class="fw-bold">ผู้พิมพ์ข้อมูล :  </span>
            <span class="fst-italic"> {{ userData.fullname }}</span>
            <div class="separator separator-dotted my-2"></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, onMounted } from "vue";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

export default defineComponent({
  name: "complaint-detail-section3",
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
    new_item: {
      type: Object,
      required: true,
    },
    complaint_file_attach: {
      type: Object,
      required: true,
    },
    accused_item: {
      type: Object,
      required: true,
    },
  },

  components: {
    dayjs,
  },
  setup(props) {
    // Variable
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
 

    // Event
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

    // Mounted
    onMounted(() => {});

    // Watch
    // Return
    return {
      getAssetPath,
      showAccusedOrganization,
      userData
    };
  },
});
</script>

<style scoped>
/* .bg-sky {
  background-color: #d9f4fe;
} */

/* .bg-header-grey {
  background-color: #ddd;
} */

.separator.separator-dotted {
  border-bottom-color: #aaa;
}

.accordion-item {
  border-color: #d9f4fe;
}
.color-primary {
  color: #800001;
}
</style>
