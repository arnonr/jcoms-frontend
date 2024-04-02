<template>
  <div class="row">
    <div class="mb-5 mt-5">
      <h4>2. รายละเอียดเรื่อง{{ complant_type.name_th }}</h4>
    </div>

    <div class="mb-7 col-12 col-lg-12">
      <label for="complaint_title" class="required form-label"
        >หัวข้อเรื่อง{{ complant_type.name_th }}</label
      >
      <input
        type="text"
        class="form-control"
        :placeholder="`หัวข้อเรื่อง${complant_type.name_th}`"
        :aria-label="`หัวข้อเรื่อง${complant_type.name_th}`"
        v-model="item.complaint_title"
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
        v-model="item.complaint_topic"
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
        v-model="item.address_all"
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
        v-model="item.incident_location"
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
        v-model="item.incident_date"
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
        v-model="item.incident_time"
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
        v-model="item.day_time"
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
          @click="handleClick"
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
          ><span>+ เพิ่มผู้ถูก{{ complant_type.name_th }}</span></a
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
        v-model="item.complaint_detail"
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
        >เคย{{ complant_type.name_th }}เรื่องนี้ผ่านช่องทางใด/Have you
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
            v-model="item.complaint_channel_all"
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
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch } from "vue";
import type { Ref } from "vue";
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
dayjs.extend(buddhistEra);
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
import useAddressData from "@/composables/useAddressData";
import useComplaintTopicData from "@/composables/useComplaintTopicData";
import useOrganizationData from "@/composables/useOrganizationData";

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
  name: "tab2",
  props: {
    item: {
      type: Object,
      required: true,
    },
    complant_type: {
      type: Object,
      required: true,
    },
    errors: {
      type: Object,
      required: true,
    },
    accused: {
      type: Array as PropType<accused_itf[]>,
      required: true,
    },
    accused_errors: {
      type: Object,
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
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;

    const address_all = ref([]);
    address_all.value = useAddressData().addresses.map((el: any) => {
      el.label =
        el.sub_district_th +
        " > " +
        el.district_th +
        " > " +
        el.province_th +
        " > " +
        el.post_code;
      return el;
    });

    // const r = (Math.random() + 1).toString(36).substring(7);

    const uppy = new Uppy({
      meta: {
        complaint_id: null,
        secret_key: props.r,
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

    uppy.on("file-added", () => {
      uppy.upload();
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

    const complaint_topic_all = ref([]);

    complaint_topic_all.value = useComplaintTopicData()
      .complaint_topics.filter((x: any) => {
        return x.complaint_type_id == props.complant_type.id;
      })
      .map((el: any) => {
        el.label = el.topic_category_th + " > " + el.topic_type_th;
        return el;
      });

    const agency_organization_all = ref<any>([]);
    agency_organization_all.value =
      useOrganizationData().agency_organizations.map((el: any) => {
        el.label = el.agency_th + " > " + el.division_th + " > " + el.bureau_th;
        return el;
      });

    const division_organization_all = ref<any>([]);
    division_organization_all.value =
      useOrganizationData().division_organizations.map((el: any) => {
        el.label = el.division_th + " > " + el.bureau_th;
        return el;
      });

    const bureau_organization_all = ref<any>([]);
    bureau_organization_all.value =
      useOrganizationData().bureau_organizations.map((el: any) => {
        el.label = el.bureau_th;
        return el;
      });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const selectOptions = ref({
      day_times: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      organizations: [
        ...bureau_organization_all.value,
        ...division_organization_all.value,
        ...agency_organization_all.value,
      ].sort((a, b) => {
        const bureauIDComparison = a.bureau_id - b.bureau_id;

        if (bureauIDComparison === 0) {
          const divisionIDComparison = a.division_id - b.division_id;

          if (divisionIDComparison === 0) {
            return a.agency_id - b.agency_id;
          }
          return divisionIDComparison;
        }

        // มิฉะนั้น เรียงลำดับตามอายุ
        return bureauIDComparison;
      }),
      prefix_names: [],
      complaint_channels: <any>[],
      address_all: address_all.value,
      complaint_topic_all: complaint_topic_all.value,
    });

    const item = ref<any>(props.item);

    //Fetch
    const fetchPrefixName = () => {
      const params = {
        perPage: 100,
      };
      ApiService.query("prefix-name", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.prefix_names = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
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
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    // Event
    const onIncreaseAccused = () => {
      emit("increase-accused");
    };
    const onDecreaseAccused = (index: number) => {
      emit("decrease-accused", index);
    };

    const coords = ref({ lat: 51.5072, lng: 0.1276 });
    const markerDetails = ref({
      id: 1,
      position: coords.value,
    });
    const getUserLocation = () => {
      // Check if geolocation is supported by the browser
      navigator.geolocation.getCurrentPosition((position) => {
        coords.value.lat = position.coords.latitude;
        coords.value.lng = position.coords.longitude;
      });

      const isSupported = "navigator" in window && "geolocation" in navigator;
      if (isSupported) {
        console.log("FREEDOM")
        // Retrieve the user's current position
        navigator.geolocation.getCurrentPosition((position) => {
          coords.value.lat = position.coords.latitude;
          coords.value.lng = position.coords.longitude;
        });
      }else{
        console.log("FREEDOM1")
      }
    };

    const setPlace = (place: any) => {
      coords.value.lat = place.geometry.location.lat();
      coords.value.lng = place.geometry.location.lng();
      // Update the location details
      // locationDetails.value.address = place.formatted_address;
      props.item.location_coordinates =
        coords.value.lat + "," + coords.value.lng;
      // locationDetails.value.url = place.url;
    };

    const handleClick = (event: any) => {
      coords.value.lat = event.latLng.lat();
      coords.value.lng = event.latLng.lng();
      props.item.location_coordinates =
        coords.value.lat + "," + coords.value.lng;
    };

    // Mounted
    onMounted(() => {
      fetchPrefixName();
      fetchComplaintChannel();
      getUserLocation();
    });

    // Watch
    watch(
      () => props.item.address_all,
      (value: any) => {
        props.item.province_id = value.province_id;
        props.item.district_id = value.district_id;
        props.item.sub_district_id = value.sub_district_id;
        props.item.postal_code = value.post_code;
      }
    );

    watch(
      () => props.item.complaint_topic,
      (value: any) => {
        props.item.complaint_type_id = value.complaint_type_id;
        props.item.topic_category_id = value.topic_category_id;
        props.item.topic_type_id = value.topic_type_id;
      }
    );

    watch(
      () => props.accused,
      (value: any) => {
        if (value.length > 0) {
          if (value[0].organization_all != null) {
            props.item.inspector_id = value[0].organization_all.hasOwnProperty(
              "inspector_id"
            )
              ? value[0].organization_all.inspector_id
              : null;
            props.item.bureau_id = value[0].organization_all.hasOwnProperty(
              "bureau_id"
            )
              ? value[0].organization_all.bureau_id
              : null;
            props.item.division_id = value[0].organization_all.hasOwnProperty(
              "division_id"
            )
              ? value[0].organization_all.division_id
              : null;
            props.item.agency_id = value[0].organization_all.hasOwnProperty(
              "agency_id"
            )
              ? value[0].organization_all.agency_id
              : null;
          } else {
            props.item.inspector_id = null;
            props.item.bureau_id = null;
            props.item.division_id = null;
            props.item.agency_id = null;
          }
          //   FOR
          for (let index = 0; index < value.length; index++) {
            if (value[index].organization_all != null) {
              value[index].inspector_id = value[
                index
              ].organization_all.hasOwnProperty("inspector_id")
                ? value[index].organization_all.inspector_id
                : null;

              value[index].bureau_id = value[
                index
              ].organization_all.hasOwnProperty("bureau_id")
                ? value[index].organization_all.bureau_id
                : null;

              value[index].division_id = value[
                index
              ].organization_all.hasOwnProperty("division_id")
                ? value[index].organization_all.division_id
                : null;
              value[index].agency_id = value[
                index
              ].organization_all.hasOwnProperty("agency_id")
                ? value[index].organization_all.agency_id
                : null;
            } else {
              value[index].inspector_id = null;
              value[index].bureau_id = null;
              value[index].division_id = null;
              value[index].agency_id = null;
            }
          }
        }
      },
      { deep: true }
    );

    // Return
    return {
      getAssetPath,
      selectOptions,
      item,
      format,
      uppy,
      setPlace,
      coords,
      markerDetails,
      handleClick,

      onIncreaseAccused,
      onDecreaseAccused,
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
