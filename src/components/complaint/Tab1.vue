<template>
  <div class="row">
    <!--begin::Input group-->
    <div class="mb-5 mt-5">
      <h4>1. ข้อมูลผู้เรื่องร้องเรียน/แจ้งเบาะแส</h4>
    </div>

    <div class="input-group mb-7">
      <div class="me-5 fs-5 mb-2">ประเภทการระบุตัวตน</div>
      <div class="form-check form-check-custom form-check-solid me-5 mb-2">
        <input
          class="form-check-input"
          name="is_anonymous"
          type="radio"
          value="1"
          v-model="complaint_item.is_anonymous"
          :checked="parseInt(complaint_item.is_anonymous) == 2 ? false : true"
          id="flexCheckboxLg"
        />
        <label class="form-check-label fs-5" for="flexCheckboxLg">
          แบบระบุตัวตน
        </label>
      </div>
      <div class="form-check form-check-custom form-check-solid">
        <input
          class="form-check-input"
          name="is_anonymous"
          type="radio"
          value="2"
          v-model="complaint_item.is_anonymous"
          :checked="parseInt(complaint_item.is_anonymous) == 2 ? true : false"
          id="flexCheckboxLg"
        />
        <label class="form-check-label fs-5" for="flexCheckboxLg">
          แบบไม่ระบุตัวตน
        </label>
      </div>
    </div>

    <div class="col-12">
      <div class="row">
        <div class="mb-7 col-12 col-lg-4 col-lg-12">
          <label for="phone_number" class="required form-label"
            >หมายเลขโทรศัพท์</label
          >
          <div class="d-flex">
            <input
              type="text"
              class="form-control"
              placeholder="หมายเลขโทรศัพท์"
              aria-label="หมายเลขโทรศัพท์"
              v-model="complainant_item.phone_number"
            />
          </div>

          <div class="d-block mt-1" v-if="errors.phone_number.error == 1">
            <span role="alert" class="text-danger">{{
              errors.phone_number.text
            }}</span>
          </div>
        </div>
      </div>

      <div v-if="parseInt(complaint_item.is_anonymous) == 1" class="row">
        <div class="mb-7 col-12 col-lg-4">
          <label for="card_type" class="required form-label"
            >ประเภทเลขบัตร</label
          >
          <v-select
            label="name"
            name="id"
            placeholder="ประเภทเลขบัตร/Card Type"
            :options="selectOptions.card_types"
            class="form-control"
            :clearable="false"
            v-model="complainant_item.card_type"
          >
          </v-select>
          <div class="d-block mt-1" v-if="errors.card_type.error == 1">
            <span role="alert" class="text-danger">{{
              errors.card_type.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-8">
          <label for="id_card" class="required form-label"
            >หมายเลขบัตรประชาชน/Passport</label
          >
          <input
            type="text"
            class="form-control"
            placeholder="หมายเลขบัตรประชาชน/Passport"
            aria-label="หมายเลขบัตรประชาชน/Passport"
            v-model="complainant_item.id_card"
          />
          <div class="d-block mt-1" v-if="errors.id_card.error == 1">
            <span role="alert" class="text-danger">{{
              errors.id_card.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-2">
          <label for="prefix_name" class="required form-label">คำนำหน้า</label>
          <v-select
            label="name_th"
            name="id"
            placeholder="คำนำหน้า/Prefix"
            :options="selectOptions.prefix_names"
            class="form-control"
            :clearable="false"
            v-model="complainant_item.prefix_name_id"
          >
          </v-select>
          <div class="d-block mt-1" v-if="errors.prefix_name_id.error == 1">
            <span role="alert" class="text-danger">{{
              errors.prefix_name_id.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-5">
          <label for="firstname" class="required form-label">ชื่อ</label>
          <input
            type="text"
            class="form-control"
            placeholder="ชื่อ/Firstname"
            aria-label="ชื่อ/Firstname"
            v-model="complainant_item.firstname"
          />
          <div class="d-block mt-1" v-if="errors.firstname.error == 1">
            <span role="alert" class="text-danger">{{
              errors.firstname.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-5">
          <label for="lastname" class="required form-label">นามสกุล</label>
          <input
            type="text"
            class="form-control"
            placeholder="นามสกุล/Surname"
            aria-label="นามสกุล/Surname"
            v-model="complainant_item.lastname"
          />
          <div class="d-block mt-1" v-if="errors.lastname.error == 1">
            <span role="alert" class="text-danger">{{
              errors.lastname.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-6">
          <label for="birthday" class="required form-label"
            >วัน/เดือน/ปีเกิด</label
          >
          <VueDatePicker
            v-model="complainant_item.birthday"
            :enable-time-picker="false"
            placeholder="วันเดือนปีเกิด(พ.ศ.)/Birthdate"
            :max-date="new Date()"
            :locale="'th'"
            auto-apply
            class="form-control"
            :format="format"
          >
            <template #year-overlay-value="{ text }">
              {{ parseInt(text) + 543 }}
            </template>

            <template #year="{ value }">
              {{ value + 543 }}
            </template>
          </VueDatePicker>
          <div class="d-block mt-1" v-if="errors.birthday.error == 1">
            <span role="alert" class="text-danger">{{
              errors.birthday.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-6">
          <label for="occupation_text" class="form-label">อาชีพ</label>
          <input
            type="text"
            class="form-control"
            placeholder="อาชีพ/occupation"
            aria-label="อาชีพ/occupation"
            v-model="complainant_item.occupation_text"
          />
          <div class="d-block mt-1" v-if="errors.occupation_text.error == 1">
            <span role="alert" class="text-danger">{{
              errors.occupation_text.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-3">
          <label for="house_number" class="required form-label"
            >บ้านเลขที่</label
          >
          <input
            type="text"
            class="form-control"
            placeholder="บ้านเลขที่/House Number"
            aria-label="บ้านเลขที่/House Number"
            v-model="complainant_item.house_number"
          />
          <div class="d-block mt-1" v-if="errors.house_number.error == 1">
            <span role="alert" class="text-danger">{{
              errors.house_number.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-4">
          <label for="building" class="form-label">หมู่บ้าน</label>
          <input
            type="text"
            class="form-control"
            placeholder="หมู่บ้าน/Village"
            aria-label="หมู่บ้าน/Village"
            v-model="complainant_item.building"
          />
          <div class="d-block mt-1" v-if="errors.building.error == 1">
            <span role="alert" class="text-danger">{{
              errors.building.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-2">
          <label for="moo" class="form-label">หมู่ที่</label>
          <input
            type="text"
            class="form-control"
            placeholder="หมู่ที่/Moo"
            aria-label="หมู่ที่/Moo"
            v-model="complainant_item.moo"
          />
          <div class="d-block mt-1" v-if="errors.moo.error == 1">
            <span role="alert" class="text-danger">{{ errors.moo.text }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-3">
          <label for="moo" class="form-label">ตรอก/ซอย</label>
          <input
            type="text"
            class="form-control"
            placeholder="ตรอก/ซอย/lane"
            aria-label="ตรอก/ซอย/lane"
            v-model="complainant_item.soi"
          />
          <div class="d-block mt-1" v-if="errors.soi.error == 1">
            <span role="alert" class="text-danger">{{ errors.soi.text }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-4">
          <label for="road" class="form-label">ถนน</label>
          <input
            type="text"
            class="form-control"
            placeholder="ถนน/Road"
            aria-label="ถนน/Road"
            v-model="complainant_item.road"
          />
          <div class="d-block mt-1" v-if="errors.road.error == 1">
            <span role="alert" class="text-danger">{{ errors.road.text }}</span>
          </div>
        </div>

        <div class="mb-5 col-12 col-lg-8">
          <label for="tumbol/amphur/province" class="required form-label"
            >ตำบล/อำเภอ/จังหวัด :</label
          >
          <v-select
            :label="'label'"
            placeholder="จังหวัด/อำเภอ/ตำบล tumbol/amphur/province"
            :options="selectOptions.address_all"
            item-value="id"
            id="slt-province-amphur-tumbol"
            v-model="complainant_item.address_all"
            class="form-control v-select-no-border"
            :clearable="true"
          ></v-select>
          <div class="d-block mt-1" v-if="errors.address_all.error == 1">
            <span role="alert" class="text-danger">{{
              errors.address_all.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-6">
          <label for="email" class="form-label">อีเมล</label>
          <input
            type="text"
            class="form-control"
            placeholder="อีเมล/Email"
            aria-label="อีเมล/Email"
            v-model="complainant_item.email"
          />
          <div class="d-block mt-1" v-if="errors.email.error == 1">
            <span role="alert" class="text-danger">{{
              errors.email.text
            }}</span>
          </div>
        </div>

        <div class="mb-7 col-12 col-lg-6">
          <label for="line_id" class="form-label">Line ID</label>
          <input
            type="text"
            class="form-control"
            placeholder="Line ID"
            aria-label="Line ID"
            v-model="complainant_item.line_id"
          />
          <div class="d-block mt-1" v-if="errors.road.error == 1">
            <span role="alert" class="text-danger">{{
              errors.line_id.text
            }}</span>
          </div>
        </div>
        <div class="mb-7 col-12 col-lg-12">
          <label for="formFile" class="form-label required"
            >ถ่ายรูปตนเองพร้อมบัตร /Take a selfie with an ID card.</label
          >
          <input
            class="form-control"
            type="file"
            id="formFile"
            accept="image/*"
            @change="onCardPhotoFileChange"
            ref="cardPhotoFile"
          />
          <div class="d-block mt-1" v-if="errors.card_photo.error == 1">
            <span role="alert" class="text-danger">{{
              errors.card_photo.text
            }}</span>
          </div>
          <img
            :src="previewImage"
            class="mt-5 w-100 w-md-50"
            v-if="previewImage"
          />
          <img
            :src="
              previewImage == null && complainant_item.card_photo_old != null
                ? complainant_item.card_photo_old
                : null
            "
            alt=""
            class="mt-5 w-100 w-md-50"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch, watchEffect } from "vue";
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
// Use Address Composables
import useAddressData from "@/composables/useAddressData";

export default defineComponent({
  name: "complaint-receive-tab1",
  props: {
    complaint_item: {
      type: Object,
      required: true,
    },
    complainant_item: {
      type: Object,
      required: true,
    },
    complaint_type: {
      type: Object,
      required: true,
    },
    errors: {
      type: Object,
      required: true,
    },
  },

  components: {
    vSelect,
    VueDatePicker,
    dayjs,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;

    const cardPhotoFile = ref<any>(null);

    const onChangePhoneNumber = () => {
      emit("update-phone-number-data");
    };

    const previewImage = ref<any>(null);

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

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const selectOptions = ref({
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
      prefix_names: [],
      address_all: address_all.value,
    });

    // const item = ref<any>(props.complainant_item);

    // Fetch
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

    // Event
    const onCardPhotoFileChange = (event: any) => {
      props.complainant_item.card_photo = event.target.files[0];
      if (props.complainant_item.card_photo) {
        previewImage.value = URL.createObjectURL(
          props.complainant_item.card_photo
        );
      } else {
        previewImage.value = null;
      }
    };

    // Mounted
    onMounted(() => {
      fetchPrefixName();
    });

    // Watch
    watch(
      () => props.complainant_item.address_all,
      (value: any) => {
        if (value == null) {
          props.complainant_item.province_id = null;
          props.complainant_item.district_id = null;
          props.complainant_item.sub_district_id = null;
          props.complainant_item.postal_code = null;
        } else {
          props.complainant_item.province_id = value.province_id;
          props.complainant_item.district_id = value.district_id;
          props.complainant_item.sub_district_id = value.sub_district_id;
          props.complainant_item.postal_code = value.post_code;
        }
      }
    );

    // watchEffect(() => {
    //   // เพิ่มการตอบสนองต่อการเปลี่ยนแปลงของ count ที่นี่
    //   item.value = props.item;
    // });

    // Return
    return {
      getAssetPath,
      selectOptions,
      format,
      previewImage,
      onCardPhotoFileChange,
      onChangePhoneNumber,
      cardPhotoFile,
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
