<template>
  <div class="row">
    <div class="mb-5 mt-5">
      <h4>2. รายละเอียดเรื่องเรื่องร้องเรียน/แจ้งเบาะแส</h4>
    </div>

    <div class="mb-7 col-12 col-lg-12">
      <label for="complaint_title" class="required form-label"
        >หัวข้อเรื่องร้องเรียน/แจ้งเบาะแส</label
      >
      <input
        type="text"
        class="form-control"
        :placeholder="`หัวข้อเรื่องเรื่องร้องเรียน/แจ้งเบาะแส`"
        :aria-label="`หัวข้อเรื่องเรื่องร้องเรียน/แจ้งเบาะแส`"
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
      <label for="day_time" class="required form-label">ห้วงเวลาเกิดเหตุ</label>
      <v-select
        label="name"
        name="id"
        placeholder="ห้วงเวลาเกิดเหตุ/Day or Night of Incident"
        :options="selectOptions.day_times"
        class="form-control"
        :clearable="false"
        v-model="complaint_item.day_time"
      >
      </v-select>
      <div class="d-block mt-1" v-if="errors.day_time.error == 1">
        <span role="alert" class="text-danger">{{ errors.day_time.text }}</span>
      </div>
    </div>

    <div class="mb-7 col-12 col-lg-12">
      <label for="complaint_title" class="required form-label"
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
          :zoom="16"
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
          <h4>ผู้ถูกร้องคนที่ {{ idx + 1 }}/The {{ idx + 1 }} Accused</h4>
        </div>
        <div class="mb-3 col-12 col-lg-2">
          <label for="accused_prefix_name_id" class="form-label"
            >คำนำหน้า</label
          >
          <v-select
            label="name_th"
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
          <div class="d-block mt-1" v-if="accused_errors.firstname.error == 1">
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
          <div class="d-block mt-1" v-if="accused_errors.section_id.error == 1">
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
          <button
            class="btn btn-danger mt-7"
            @click="$emit('decrease-accused', idx)"
          >
            <i class="fa fa-close"></i>
            <span>ลบผู้ถูกร้องคนที่ {{ idx + 1 }}</span>
          </button>
        </div>
      </div>
      <div class="mt-3">
        <a @click="$emit('increase-accused')" class="cursor-pointer"
          ><span>+ เพิ่มผู้ถูก{{ complaint_type.name_th }}</span></a
        >
      </div>
    </div>

    <div class="mb-7 col-12 col-lg-12">
      <label for="complaint_detail" class="required form-label"
        >บรรยายพฤติกรรมการกระทำความผิด</label
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
            >แนบไฟล์หลักฐานเพิ่มเติม (แนบได้หลายไฟล์) /Attach evidence
            files</label
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
      <label for="surname" class="form-label"
        >เคย{{ complaint_type.name_th }}เรื่องนี้ผ่านช่องทางใด/Have you
        previously reported this issue through any channel?</label
      >
      <div class="row ms-2">
        <div
          class="form-check col-md-3 mt-3"
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
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  ref,
  onMounted,
  onUnmounted,
  watch,
  toRefs,
  watchEffect,
} from "vue";
import type { PropType } from "vue";
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
// Uppy
import { Dashboard } from "@uppy/vue";
import Uppy from "@uppy/core";
import Webcam from "@uppy/webcam";
// import Preview from "@uppy/preview";
import XHRUpload from "@uppy/xhr-upload";
import "@uppy/core/dist/style.css";
import "@uppy/dashboard/dist/style.css";
import "@uppy/webcam/dist/style.css";
// Use Address Composables
import useBasicData from "@/composables/useBasicData";
import useAddressData from "@/composables/useAddressData";
import useComplaintTopicData from "@/composables/useComplaintTopicData";
import useOrganizationData from "@/composables/useOrganizationData";
import usePrefixNameData from "@/composables/usePrefixNameData";
import useComplaintChannelData from "@/composables/useComplaintChannelData";

interface accused_itf {
  id: any;
  prefix_name_id: any;
  firstname: any;
  lastname: any;
  position_id: any;
  section_id: any;
  agency_id: any;
  inspector_id: any;
  bureau_id: any;
  division_id: any;
  complaint_id: any;
  type: any;
  detail: any;
  organization_all: any;
  // other properties
}

export default defineComponent({
  name: "complaint-receive-tab2",
  props: {
    complaint_type: {
      type: Object,
      required: true,
    },
    complaint_item: {
      type: Object,
      required: true,
    },
    accused: {
      type: Array as PropType<accused_itf[]>,
      required: true,
    },
    errors: {
      type: Object,
      required: true,
    },
    accused_errors: {
      type: Object,
      required: true,
    },
  },
  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    Dashboard,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;

    const uppy = new Uppy({
      meta: {
        complaint_id: props.complaint_item.id,
        id: null,
        table_name: "complaint",
      },
      debug: true,
      restrictions: {
        allowedFileTypes: ["image/*", "video/*", "application/*"],
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

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const selectOptions = ref({
      day_times: useBasicData().day_times,
      organizations: useOrganizationData().organization_mapping(),
      address_all: useAddressData().addresses_mapping(),
      complaint_topic_all: useComplaintTopicData().complaint_topic_mapping(
        props.complaint_type.id
      ),
      prefix_names: [],
      complaint_channels: <any>[],
      positions: useBasicData().positions,
      sections: useBasicData().sections,
    });

    // const item = ref<any>(props.item);
    // const accused = ref<any>(props.accused);

    //Fetch
    usePrefixNameData()
      .fetchPrefixName()
      .then((data: any) => {
        selectOptions.value.prefix_names = data;
      });

    useComplaintChannelData()
      .fetchComplaintChannel()
      .then((data: any) => {
        selectOptions.value.complaint_channels = data;
      });

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

    const fetchComplaintFileAttach = async () => {
      const { data } = await ApiService.query("complaint-file-attach", {
        params: { complaint_id: props.complaint_item.id, perPage: 100 },
      });

      //
      for (let i = 0; i < data.data.length; i++) {
        await fetch(data.data[i].filename)
          .then((response) => response.blob())
          .then((blob) => {
            if (blob.type != "text/html") {
              uppy.addFile({
                name: undefined,
                type: blob.type,
                data: blob,
                meta: {
                  relativePath: data.data[i].filename,
                  complaint_id: data.data[i].complaint_id,
                  id: data.data[i].id,
                  secret_key: data.data[i].secret_key,
                  isRemote: true,
                },
                source: "Local",
                isRemote: false,
              });
            }
          });
      }
      //

      //
      uppy.getFiles().forEach((file) => {
        uppy.setFileState(file.id, {
          progress: { uploadComplete: true, uploadStarted: true },
        });
      });
    };

    // Event

    // Gmap
    const coords = ref({ lat: 13.7563, lng: 100.5018 });
    const markerDetails = ref({
      id: 1,
      position: coords.value,
    });
    const getUserLocation = () => {
      const isSupported = "navigator" in window && "geolocation" in navigator;
      if (isSupported) {
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

    // Mounted
    onMounted(() => {
      getUserLocation();
      // Get Topic
      let find_complaint_topic = selectOptions.value.complaint_topic_all.find(
        (x: any) => {
          return x.topic_type_id == props.complaint_item.topic_type_id;
        }
      );
      props.complaint_item.complaint_topic = find_complaint_topic;
      //   Get Address All
      let find_address = selectOptions.value.address_all.find((x: any) => {
        return x.sub_district_id == props.complaint_item.sub_district_id;
      });
      props.complaint_item.address_all = find_address;
      props.complaint_item.province_id = find_address.province_id;
      props.complaint_item.district_id = find_address.district_id;
      props.complaint_item.sub_district_id = find_address.sub_district_id;
      props.complaint_item.postal_code = find_address.post_code;

      // Get Day Night
      let day_time = selectOptions.value.day_times.find((x: any) => {
        return x.value == props.complaint_item.day_time;
      });
      props.complaint_item.day_time = day_time;
      // Get Incident Date
      props.complaint_item.incident_date = dayjs(
        props.complaint_item.incident_datetime
      ).format("YYYY-MM-DD");

      // Get Incident Time
      if (props.complaint_item.incident_datetime) {
        let date_time = dayjs(props.complaint_item.incident_datetime)
          .utc()
          .format("HH:mm");

        props.complaint_item.incident_time = {
          hours: date_time.split(":")[0],
          minutes: date_time.split(":")[1],
          seconds: 0,
        };
      }

      //   Location
      if (props.complaint_item.location_coordinates) {
        coords.value.lat = parseFloat(
          props.complaint_item.location_coordinates.split(",")[0]
        );
        coords.value.lng = parseFloat(
          props.complaint_item.location_coordinates.split(",")[1]
        );
      }

      if (props.complaint_item.channel_history.length > 0) {
        props.complaint_item["complaint_channel_all"] = [];
        props.complaint_item.channel_history.forEach((element: any) => {
          props.complaint_item["complaint_channel_all"].push(
            element.complaint_channel_id
          );
        });
      }

      fetchAccused();
      fetchComplaintFileAttach();
    });

    // onUnmounted(() => {
    //   uppy.getFiles().forEach((file) => {
    //    console.log(file)
    //   });
    // });

    // Watch
    watch(
      () => props.complaint_item.address_all,
      (value: any) => {
        props.complaint_item.province_id = value.province_id;
        props.complaint_item.district_id = value.district_id;
        props.complaint_item.sub_district_id = value.sub_district_id;
        props.complaint_item.postal_code = value.post_code;
      }
    );

    watch(
      () => props.complaint_item.complaint_topic,
      (value: any) => {
        props.complaint_item.complaint_type_id = value.complaint_type_id;
        props.complaint_item.topic_category_id = value.topic_category_id;
        props.complaint_item.topic_type_id = value.topic_type_id;
      }
    );

    watch(
      () => props.accused,
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

    // watch(
    //   () => complaint_item.value.incident_time,
    //   (value: any) => {
    //     console.log(value)
    //   }
    // );

    // Return
    return {
      selectOptions,
      format,
      uppy,
      setPlace,
      coords,
      markerDetails,
      handleClickGMap,
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
</style>
