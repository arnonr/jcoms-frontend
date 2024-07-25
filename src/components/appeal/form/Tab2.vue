<template>
  <tab-content
    :title="`รายละเอียดเรื่อง${complaint_type?.name_th}`"
    :before-change="onTab2Validate"
  >
    <div class="row">
      <div class="mb-5 mt-5">
        <h4>2. รายละเอียดเรื่อง{{ complaint_type?.name_th }}</h4>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="complaint_title" class="required form-label"
          >หัวข้อเรื่อง</label
        >
        <input
          type="text"
          class="form-control"
          :placeholder="`หัวข้อเรื่อง`"
          :aria-label="`หัวข้อเรื่อง`"
          v-model="complaint_item.complaint_title"
        />
        <div class="d-block mt-1" v-if="errors.complaint_title.error == 1">
          <span role="alert" class="text-danger">{{
            errors.complaint_title.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="complaint_topic" class="required form-label"
          >ประเภท/ลักษณะเรื่อง</label
        >
        <v-select
          name="id"
          placeholder="หมวดหมู่/ประเภท/ลักษณะเรื่อง Type of Topic"
          :options="selectOptions.complaint_topic_all"
          class="form-control"
          :clearable="false"
          v-model="complaint_item.complaint_topic"
        >
        </v-select>
        <div class="d-block mt-1" v-if="errors.complaint_topic.error == 1">
          <span role="alert" class="text-danger">{{
            errors.complaint_topic.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="address_all" class="required form-label"
          >สถานที่เกิดเหตุ</label
        >
        <v-select
          :label="'label'"
          id="slt-province-amphur-tumbol"
          placeholder="จังหวัด/อำเภอ/ตำบล Place of the incident"
          :options="selectOptions.address_all"
          class="form-control v-select-no-border"
          :clearable="true"
          item-value="id"
          v-model="complaint_item.address_all"
        ></v-select>
        <div class="d-block mt-1" v-if="errors.address_all.error == 1">
          <span role="alert" class="text-danger">{{
            errors.address_all.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="incident_location" class="required form-label"
          >บันทึกข้อมูลสถานที่เกิดเหตุ (โดยละเอียด
          บ้านเลขที่/หมู่บ้าน/หมู่ที่/ตรอก/ซอย/ถนน)</label
        >
        <input
          type="text"
          class="form-control"
          placeholder="บันทึกข้อมูลสถานที่เกิดเหตุ/Describe the location incident in detail"
          aria-label="บันทึกข้อมูลสถานที่เกิดเหตุ/Describe the location incident in detail"
          v-model="complaint_item.incident_location"
        />
        <div class="d-block mt-1" v-if="errors.incident_location.error == 1">
          <span role="alert" class="text-danger">{{
            errors.incident_location.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-4">
        <label for="incident_date" class="required form-label"
          >วันที่เกิดเหตุ</label
        >
        <VueDatePicker
          v-model="complaint_item.incident_date"
          :enable-time-picker="false"
          :locale="'th'"
          :max-date="new Date()"
          auto-apply
          class="form-control"
          :format="format"
          placeholder="วันที่เกิดเหตุ/Date of Incident"
        >
          <template #year-overlay-value="{ text }">
            {{ parseInt(text) + 543 }}
          </template>

          <template #year="{ value }">
            {{ value + 543 }}
          </template>
        </VueDatePicker>
        <div class="d-block mt-1" v-if="errors.incident_date.error == 1">
          <span role="alert" class="text-danger">{{
            errors.incident_date.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-4">
        <label for="incident_time" class="form-label">เวลาเกิดเหตุ</label>
        <VueDatePicker
          v-model="complaint_item.incident_time"
          time-picker
          :locale="'th'"
          auto-apply
          class="form-control"
          placeholder="เวลาเกิดเหตุ/Time of Incident"
        >
        </VueDatePicker>

        <div class="d-block mt-1" v-if="errors.incident_time.error == 1">
          <span role="alert" class="text-danger">{{
            errors.incident_time.text
          }}</span>
        </div>
      </div>

      <div class="col-12 col-lg-4 mb-7">
        <label for="day_time" class="form-label">ห้วงเวลาเกิดเหตุ</label>
        <v-select
          label="name"
          name="day_time"
          placeholder="ห้วงเวลา"
          :options="selectOptions.day_times"
          class="form-control"
          :clearable="false"
          v-model="complaint_item.day_time"
        >
        </v-select>

        <div class="d-block mt-1" v-if="errors.day_time.error == 1">
          <span role="alert" class="text-danger">{{
            errors.day_time.text
          }}</span>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="complaint_map" class="form-label"
          >ปักหมุดสถานที่เกิดเหตุ</label
        >
        <div>
          <GMapAutocomplete
            placeholder="ค้นหาสถานที่เกิดเหตุ"
            @place_changed="setPlace"
            style="font-size: medium"
            class="form-control mb-5"
          >
          </GMapAutocomplete>

          <GMapMap
            :center="markerDetails.position"
            :click="true"
            @click="handleClickGMap"
            :zoom="14"
            map-type-id="terrain"
            style="width: 100%; height: 400px"
          >
            <GMapMarker
              :key="markerDetails.id"
              :position="markerDetails.position"
              :clickable="true"
              :draggable="true"
            >
            </GMapMarker>
            <!-- <GMapCircle
            :key="1"
            :radius="100"
            :center="markerDetails.position"
          /> -->
          </GMapMap>
        </div>
      </div>

      <div class="col-12 mb-7">
        <div
          class="row p-3 border border-dark-subtle rounded"
          :class="[idx == 0 ? '' : ' mt-7']"
          v-if="accused"
          style="margin: 0.03rem"
          v-for="(ac, idx) in accused"
          :key="'accused' + idx"
        >
          <div class="mb-3">
            <h4>ผู้ถูกร้องคนที่ {{ idx + 1 }}</h4>
          </div>
          <div class="mb-3 col-12 col-lg-2">
            <label for="accused_prefix_name_id" class="form-label"
              >คำนำหน้า</label
            >
            <v-select
              label="name_th_abbr"
              name="id"
              placeholder="คำนำหน้า (ยศ)/prefix"
              :options="selectOptions.prefix_names"
              class="form-control"
              :clearable="false"
              v-model="ac.prefix_name_id"
            >
            </v-select>
            <div
              class="d-block mt-1"
              v-if="accused_errors.prefix_name_id.error == 1"
            >
              <span role="alert" class="text-danger">{{
                accused_errors.prefix_name_id.text
              }}</span>
            </div>
          </div>
          <div class="mb-3 col-12 col-lg-5">
            <label for="accused_firstname" class="form-label">ชื่อ</label>
            <input
              type="text"
              class="form-control"
              placeholder="ชื่อ/Firstname"
              aria-label="ชื่อ/Firstname"
              v-model="ac.firstname"
            />
            <div
              class="d-block mt-1"
              v-if="accused_errors.firstname.error == 1"
            >
              <span role="alert" class="text-danger">{{
                accused_errors.firstname.text
              }}</span>
            </div>
          </div>
          <div class="mb-3 col-12 col-lg-5">
            <label for="accused_lastname" class="form-label">นามสกุล</label>
            <input
              type="text"
              class="form-control"
              placeholder="นามสกุล/Surname"
              aria-label="นามสกุล/Surname"
              v-model="ac.lastname"
            />
            <div class="d-block mt-1" v-if="accused_errors.lastname.error == 1">
              <span role="alert" class="text-danger">{{
                accused_errors.lastname.text
              }}</span>
            </div>
          </div>
          <div class="mb-3 col-12 col-lg-6">
            <label for="accused_position_id" class="form-label">ตำแหน่ง</label>
            <v-select
              label="name_th"
              name="accused_position_id"
              placeholder="ตำแหน่งงาน/Position"
              :options="selectOptions.positions"
              class="form-control"
              :clearable="false"
              v-model="ac.position_id"
            >
            </v-select>
            <div
              class="d-block mt-1"
              v-if="accused_errors.position_id.error == 1"
            >
              <span role="alert" class="text-danger">{{
                accused_errors.position_id.text
              }}</span>
            </div>
          </div>
          <div class="mb-3 col-12 col-lg-6">
            <label for="accused_section_id" class="form-label">สายงาน</label>
            <v-select
              label="name_th"
              name="accused_section_id"
              placeholder="สายงาน/section"
              :options="selectOptions.sections"
              class="form-control"
              :clearable="false"
              v-model="ac.section_id"
            >
            </v-select>
            <div
              class="d-block mt-1"
              v-if="accused_errors.section_id.error == 1"
            >
              <span role="alert" class="text-danger">{{
                accused_errors.section_id.text
              }}</span>
            </div>
          </div>
          <div class="mb-1 col-12 col-md-10">
            <label for="organization_all" class="form-label">หน่วยงาน</label>
            <v-select
              name="accused_organization_all"
              placeholder="หน่วยงาน/Organization"
              :options="selectOptions.organizations"
              class="form-control"
              :clearable="false"
              v-model="ac.organization_all"
            >
            </v-select>
            <div
              class="d-block mt-1"
              v-if="accused_errors.organization_all.error == 1"
            >
              <span role="alert" class="text-danger">{{
                accused_errors.organization_all.text
              }}</span>
            </div>
          </div>
          <div class="mb-1 col-12 col-md-2 d-flex" v-if="idx != 0">
            <button class="btn btn-danger mt-7" @click="onDecreaseAccused(idx)">
              <i class="fa fa-close"></i>
              <span>ลบผู้ถูกร้องคนที่ {{ idx + 1 }}</span>
            </button>
          </div>
        </div>
        <div class="mt-3">
          <a @click="onIncreaseAccused" class="cursor-pointer"
            ><span>+ เพิ่มผู้ถูก{{ complaint_type.name_th }}</span></a
          >
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="complaint_detail" class="required form-label"
          >บรรยายพฤติกรรมการกระทำความผิด (โปรดระบุข้อมูลให้ละเอียดครบถ้วน เช่น
          ใคร ทำอะไร ที่ไหน อย่างไร และเมื่อไหร่
          ได้รับความเสียหายอย่างไร)</label
        >
        <textarea
          style="height: 150px"
          type="text"
          class="form-control"
          placeholder="บรรยายพฤติกรรมการกระทำความผิด/Describe the behavior constituting the offense."
          aria-label="บรรยายพฤติกรรมการกระทำความผิด/Describe the behavior constituting the offense."
          v-model="complaint_item.complaint_detail"
        />
        <div class="d-block mt-1" v-if="errors.complaint_detail.error == 1">
          <span role="alert" class="text-danger">{{
            errors.complaint_detail.text
          }}</span>
        </div>
      </div>

      <div class="col-12">
        <div class="mb-7 row">
          <div class="col-12 col-lg-12">
            <label for="formFile" class="form-label"
              >แนบไฟล์หลักฐานเพิ่มเติม (แนบได้หลายไฟล์ ภาพถ่าย วิดีโอ เสียง
              เอกสาร) เช่น ข้อมูลผู้ถูกร้องเรียน, ข้อมูลเรื่องร้องเรียน /Attach
              evidence files</label
            >
            <dashboard
              :uppy="uppy"
              :plugins="['Webcam']"
              aria-placeholder=""
              ref="dash"
              :props="{
                width: '100%',
                doneButtonHandler: null,
                hideCancelButton: true,
                showRemoveButtonAfterComplete: true,
              }"
            />
          </div>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="complaint_detail" class="form-label">แนบลิ้งค์ URL</label>
        <vue3-tags-input
          :tags="tags"
          placeholder=""
          @on-tags-changed="handleChangeTag"
        />
        <!-- @on-tags-changed="handleChangeTag" -->
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="channel" class="form-label"
          >เคยร้องเรียน/ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแสเรื่องนี้ผ่านช่องทางใด</label
        >
        <div class="row">
          <div
            class="form-check col-md-3 mt-3 ms-2"
            v-for="(cc, idx) in selectOptions.complaint_channels"
            :key="idx"
          >
            <input
              class="form-check-input"
              type="checkbox"
              name="flexCheckDefault"
              :value="cc.id"
              v-model="complaint_item.complaint_channel_all"
            />
            <label class="form-check-label" for="flexCheckDefault">
              {{ cc.name_th }}
            </label>
          </div>
          <div class="mb-7 col-6 col-lg-6 mt-7">
            <label for="channel_history_text" class="form-label"
              >ช่องทางร้องเรียนอื่น ๆ โปรดระบุ</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="ช่องทางร้องเรียนอื่น ๆ โปรดระบุ"
              aria-label="ช่องทางร้องเรียนอื่น ๆ โปรดระบุ"
              v-model="complaint_item.channel_history_text"
            />
          </div>
        </div>
      </div>
    </div>
  </tab-content>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, watch, reactive, toRefs } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";
dayjs.extend(buddhistEra);
dayjs.extend(utc);
dayjs.extend(timezone);
// Import FormWizard
import { TabContent } from "vue3-form-wizard";
// Import Yup Validate
import * as Yup from "yup";
// Use Toast Composables
import useToast from "@/composables/useToast";
// Uppy
import { Dashboard } from "@uppy/vue";
import Uppy from "@uppy/core";
import Webcam from "@uppy/webcam";
// import Preview from "@uppy/preview";
import XHRUpload from "@uppy/xhr-upload";
import "@uppy/core/dist/style.css";
import "@uppy/dashboard/dist/style.css";
import "@uppy/webcam/dist/style.css";
// Vue3 Tags
import Vue3TagsInput from "vue3-tags-input";

// Use Address Composables
import useBasicData from "@/composables/useBasicData";
import useAddressData from "@/composables/useAddressData";
import useComplaintTopicData from "@/composables/useComplaintTopicData";
import useOrganizationData from "@/composables/useOrganizationData";
import useMasterData from "@/composables/useMasterData";

export default defineComponent({
  name: "appeal-form-tab2",
  props: {
    complaint_item: {
      type: Object,
      required: true,
    },
    complaint_type: {
      type: Object,
      required: true,
    },
    accused: {
      type: Array as () => any[],
      required: true,
    },
    r: {
      type: String,
      required: true,
    },
  },
  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    Dashboard,
    TabContent,
    Vue3TagsInput,
  },
  setup(props, { emit }) {
    // Variable
    const { complaint_item, accused } = toRefs(props);

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const tags = ref<string[]>([]);

    // Uppy
    const uppy = new Uppy({
      meta: {
        complaint_id: null,
        secret_key: props.r,
        id: null,
        table_name: "complaint",
      },
      debug: true,
      restrictions: {
        allowedFileTypes: [
          "image/*",
          "video/*",
          "application/*",
          "audio/*",
          ".mp3",
          ".ogg",
          ".wav",
        ],
      },
    })
      .use(XHRUpload, {
        headers: {
          // Authorization: `Bearer ${}`,
        },
        endpoint: `${import.meta.env.VITE_APP_API_URL}/froala/uppy`,
        fieldName: "file",
      })
      .use(Webcam, {
        modes: ["picture"],
      });

    uppy.on("file-added", (file) => {
      if (file.meta.id == null) {
        uppy.upload();
      }
    });

    uppy.on("upload-success", (file: any, response) => {
      uppy.setFileMeta(file.id, {
        url: response.body.link,
        complaint_id: response.body.complaint_id,
        id: response.body.id,
      });
    });

    uppy.on("file-removed", (file, reason) => {
      if (file.meta.id != null) {
        ApiService.delete(
          `${import.meta.env.VITE_APP_API_URL}/complaint-file-attach/${
            file.meta.id
          }`
        )
          .then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response.data.errors);
          });
      }
    });
    // End Uppy

    const selectOptions = ref({
      address_all: useAddressData().addresses_mapping(),
      day_times: useBasicData().day_times,
      organizations: useOrganizationData().organization_mapping(),
      complaint_topic_all: useComplaintTopicData().complaint_topic_mapping(
        props.complaint_type.id
      ),
      prefix_names: <any>[],
      complaint_channels: <any>[],
      positions: useBasicData().positions,
      sections: useBasicData().sections,
    });
    selectOptions.value.organizations.unshift({
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      label: "ไม่ทราบหน่วยงาน",
    });

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      is_anonymous: Yup.number()
        .required("${path} จำเป็นต้องระบุ")
        .label("ประเภทระบุตัวตน"),
      complaint_title: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("หัวข้อเรื่อง"),
      house_number: Yup.string().nullable().label("บ้านเลขที่"),
      building: Yup.string().nullable().label("หมู่บ้าน"),
      moo: Yup.string().nullable().label("หมู่ที่"),
      soi: Yup.string().nullable().label("ซอย"),
      road: Yup.string().nullable().label("ถนน"),
      address_all: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("จังหวัด/อำเภอ/ตำบล"),
      incident_location: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("สถานที่เกิดเหตุ"),
      incident_date: Yup.date()
        .required("${path} จำเป็นต้องระบุ")
        .label("วันที่เกิดเหตุ"),
      incident_time: Yup.object().nullable().label("เวลาเกิดเหตุ"),
      day_time: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("ห้วงเวลาเกิดเหตุ"),
      location_coordinates: Yup.string().nullable().label("coordinates"),
      complaint_detail: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("บรรยายพฤติกรรมการกระทำความผิด"),
      //   complaint_channel_id: Yup.object().nullable(),
      complaint_topic: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("ประเภทเรื่อง"),
      complaint_channel_all: Yup.array()
        .nullable()
        .label("เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด"),
    });
    const validationAccusedSchema = Yup.object().shape({
      prefix_name_id: Yup.object().nullable().label("คำนำหน้า"),
      firstname: Yup.string().nullable().label("ชื่อ"),
      lastname: Yup.string().nullable().label("นามสกุล"),
      organization_all: Yup.object().nullable().label("หน่วยงาน"),
    });

    // errors
    const errors_default = {
      complaint_type_id: { error: 0, text: "" },
      is_anonymous: { error: 0, text: "" },
      complaint_title: { error: 0, text: "" },
      house_number: { error: 0, text: "" },
      building: { error: 0, text: "" },
      moo: { error: 0, text: "" },
      soi: { error: 0, text: "" },
      road: { error: 0, text: "" },
      address_all: { error: 0, text: "" },
      incident_location: { error: 0, text: "" },
      incident_date: { error: 0, text: "" },
      incident_time: { error: 0, text: "" },
      day_time: { error: 0, text: "" },
      location_coordinates: { error: 0, text: "" },
      complaint_detail: { error: 0, text: "" },
      complaint_channel_id: { error: 0, text: "" },
      inspector_id: { error: 0, text: "" },
      bureau_id: { error: 0, text: "" },
      division_id: { error: 0, text: "" },
      agency_id: { error: 0, text: "" },
      topic_type_id: { error: 0, text: "" },
      notice_type: { error: 0, text: "" },
      complaint_topic: { error: 0, text: "" },
      complaint_channel_all: { error: 0, text: "" },
    };
    const errors = reactive<any>({
      ...errors_default,
    });

    // accused_errors
    const accused_errors_default = {
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
      section_id: { error: 0, text: "" },
      position_id: { error: 0, text: "" },
    };
    const accused_errors = reactive<any>({
      ...accused_errors_default,
    });

    //Fetch
    const fetchAccused = async () => {
      const { data } = await ApiService.query("accused", {
        params: { complaint_id: props.complaint_item.id, perPage: 100 },
      });

      // accused คำนำหน้ากับหน่วยงาน
      let ac = data.data.map((el: any, idx: number) => {
        if (el.prefix_name_id != null) {
          let prefix_name_id = {
            id: el.prefix_name_id,
            name_th: el.prefix_name.name_th,
          };
          el.prefix_name_id = prefix_name_id;
        }

        el.organzation = "";
        if (el.agency) {
          el.organzation = el.organzation + el.agency.name_th + " > ";
        }
        if (el.division) {
          el.organzation = el.organzation + el.division.name_th + " > ";
        }
        if (el.bureau) {
          el.organzation = el.organzation + el.bureau.name_th;
        }
        el.organization_all = {
          label: el.organzation,
          agency_id: el.agency_id,
          division_id: el.division_id,
          bureau_id: el.bureau_id,
          inspector_id: el.inspector_id,
        };

        if (el.position_id != null) {
          let position_id = {
            id: el.position_id,
            name_th: el.position.name_th,
          };
          el.position_id = position_id;
        }

        if (el.section_id != null) {
          let section_id = {
            id: el.section_id,
            name_th: el.section.name_th,
          };
          el.section_id = section_id;
        }

        return el;
      });
      Object.assign(props.accused, ac);
    };

    // Event
    const onTab2Validate = async () => {
      Object.assign(errors, {
        ...errors_default,
      });

      Object.assign(accused_errors, {
        ...accused_errors_default,
      });

      try {
        await validationItemSchema.validate(complaint_item.value, {
          abortEarly: false,
        });
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          errors[fieldName].error = 1;
          errors[fieldName].text = errorMessage;
        });
        console.log(errors);
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      try {
        if (accused.value.length > 0) {
          await validationAccusedSchema.validate(accused[0], {
            abortEarly: false,
          });
        }
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          accused_errors[fieldName].error = 1;
          accused_errors[fieldName].text = errorMessage;
        });
        useToast("ข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      return true;
    };

    // Gmap
    const coords = ref({ lat: 13.7563, lng: 200.5018 });
    const markerDetails = ref({
      id: 1,
      position: coords.value,
    });

    const getUserLocation = () => {
      const isSupported = "navigator" in window && "geolocation" in navigator;
      if (isSupported) {
        if (
          complaint_item.value.location_coordinates != null &&
          complaint_item.value.location_coordinates != ""
        ) {
          coords.value.lat = parseFloat(
            complaint_item.value.location_coordinates.split(",")[0]
          );
          coords.value.lng = parseFloat(
            complaint_item.value.location_coordinates.split(",")[1]
          );
        } else {
          navigator.geolocation.getCurrentPosition(
            (position) => {
              coords.value.lat = position.coords.latitude;
              coords.value.lng = position.coords.longitude;
            },
            (error) => {
              console.error(error);
            }
          );
        }
      }
    };
    const setPlace = (place: any) => {
      coords.value.lat = place.geometry.location.lat();
      coords.value.lng = place.geometry.location.lng();
      props.complaint_item.location_coordinates =
        coords.value.lat + "," + coords.value.lng;
    };
    const handleClickGMap = (event: any) => {
      coords.value.lat = event.latLng.lat();
      coords.value.lng = event.latLng.lng();
      props.complaint_item.location_coordinates =
        coords.value.lat + "," + coords.value.lng;
    };
    // End GMap

    const handleChangeTag = (tags: any) => {
      tags.value = tags;
      complaint_item.value.evidence_url = tags.value.join(",");
    };

    const isDay = (time: any) => {
      return time.hours >= 6 && time.hours < 18;
    };

    // Mounted

    onMounted(async () => {
      selectOptions.value.prefix_names = await useMasterData().fetchPrefixName({
        is_active: 1,
        perPage: 500,
      });

      selectOptions.value.complaint_channels = await useMasterData()
        .fetchComplaintChannel({
          is_active: 1,
          perPage: 500,
        })
        .then((res: any) => {
          return res.filter((x: any) => {
            return x.name_th != "RPA";
          });
        });

      //   getUserLocation();

      if (complaint_item.value.location_coordinates) {
        coords.value.lat = parseFloat(
          complaint_item.value.location_coordinates.split(",")[0]
        );
        coords.value.lng = parseFloat(
          complaint_item.value.location_coordinates.split(",")[1]
        );
      }
      //   Location

      // Get Topic
      let find_complaint_topic = selectOptions.value.complaint_topic_all.find(
        (x: any) => {
          return x.topic_type_id == complaint_item.value.topic_type_id;
        }
      );
      props.complaint_item.complaint_topic = find_complaint_topic;

      //   Get Address All
      let find_address = selectOptions.value.address_all.find((x: any) => {
        return x.sub_district_id == complaint_item.value.sub_district_id;
      });
      complaint_item.value.address_all = find_address;
      complaint_item.value.province_id = find_address?.province_id;
      complaint_item.value.district_id = find_address?.district_id;
      complaint_item.value.sub_district_id = find_address?.sub_district_id;
      complaint_item.value.postal_code = find_address?.post_code;

      // Get Day Night
      let day_time = selectOptions.value.day_times.find((x: any) => {
        return x.value == complaint_item.value.day_time;
      });

      complaint_item.value.day_time = day_time;

      // Get Incident Date
      complaint_item.value.incident_date = dayjs(
        complaint_item.value.incident_datetime
      ).format("YYYY-MM-DD");

      // Get Incident Time
      if (complaint_item.value.incident_datetime) {
        let date_time = dayjs(complaint_item.value.incident_datetime)
          .utc()
          .format("HH:mm");

        complaint_item.value.incident_time = {
          hours: date_time.split(":")[0],
          minutes: date_time.split(":")[1],
          seconds: 0,
        };
      }

      if (complaint_item.value.channel_history?.length > 0) {
        complaint_item.value.complaint_channel_all = [];
        complaint_item.value.channel_history.forEach((el: any) => {
          complaint_item.value.complaint_channel_all.push(
            el.complaint_channel_id
          );
        });
      }

      tags.value =
        complaint_item.value.evidence_url != "" &&
        complaint_item.value.evidence_url != null
          ? complaint_item.value.evidence_url
              .split(",")
              .map((it: any) => it.replace(/(^'|'$)/g, ""))
          : [];
    });

    watch(
      () => complaint_item.value.address_all,
      (value: any) => {
        complaint_item.value.province_id = null;
        complaint_item.value.district_id = null;
        complaint_item.value.sub_district_id = null;
        complaint_item.value.postal_code = null;

        if (value !== null) {
          complaint_item.value.province_id = value?.province_id;
          complaint_item.value.district_id = value?.district_id;
          complaint_item.value.sub_district_id = value?.sub_district_id;
          complaint_item.value.postal_code = value?.post_code;
        }
      }
    );

    watch(
      () => complaint_item.value.complaint_topic,
      (value: any) => {
        complaint_item.value.complaint_type_id = null;
        complaint_item.value.topic_category_id = null;
        complaint_item.value.topic_type_id = null;
        if (value !== null) {
          complaint_item.value.complaint_type_id = value?.complaint_type_id;
          complaint_item.value.topic_category_id = value?.topic_category_id;
          complaint_item.value.topic_type_id = value?.topic_type_id;
        }
      }
    );

    watch(
      () => complaint_item.value.incident_time,
      (value: any) => {
        let day = isDay(value);
        if (day) {
          complaint_item.value.day_time = {
            name: "กลางวัน",
            value: 1,
          };
        } else {
          complaint_item.value.day_time = { name: "กลางคืน", value: 2 };
        }
      }
    );

    watch(
      () => accused.value,
      (value: any[]) => {
        if (value.length > 0) {
          value.forEach((person, idx) => {
            if (person.organization_all) {
              if (idx == 0) {
                props.complaint_item.inspector_id =
                  person.organization_all.inspector_id || null;
                props.complaint_item.bureau_id =
                  person.organization_all.bureau_id || null;
                props.complaint_item.division_id =
                  person.organization_all.division_id || null;
                props.complaint_item.agency_id =
                  person.organization_all.agency_id || null;
              }

              person.inspector_id =
                person.organization_all.inspector_id || null;
              person.bureau_id = person.organization_all.bureau_id || null;
              person.division_id = person.organization_all.division_id || null;
              person.agency_id = person.organization_all.agency_id || null;
            } else {
              if (idx == 0) {
                props.complaint_item.inspector_id = null;
                props.complaint_item.bureau_id = null;
                props.complaint_item.division_id = null;
                props.complaint_item.agency_id = null;
              }

              person.inspector_id = null;
              person.bureau_id = null;
              person.division_id = null;
              person.agency_id = null;
            }
          });
        } else {
          props.complaint_item.inspector_id = null;
          props.complaint_item.bureau_id = null;
          props.complaint_item.division_id = null;
          props.complaint_item.agency_id = null;
        }
      },
      { deep: true }
    );

    const onIncreaseAccused = () => {
      accused.value.push({
        id: null,
        prefix_name_id: null,
        firstname: "",
        lastname: "",
        position_id: null,
        section_id: null,
        agency_id: null,
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        complaint_id: null,
        type: null,
        detail: null,
        organization_all: null,
      });
    };
    const onDecreaseAccused = (index: number) => {
      accused.value.splice(index, 1);
    };

    // Return
    return {
      format,
      selectOptions,
      tags,
      uppy,
      setPlace,
      coords,
      markerDetails,
      handleClickGMap,
      handleChangeTag,
      onIncreaseAccused,
      onDecreaseAccused,
      onTab2Validate,
      errors,
      accused_errors,
    };
  },
});
</script>

<style scoped>
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
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

.form-control {
  border-color: #800001;
  border-width: 0.1em;
}

.form-check-input:not(:checked) {
  background-color: #fff;
}

.form-check-input:checked {
  background-color: #1b84ff !important;
  border-color: #1b84ff !important;
}
</style>
