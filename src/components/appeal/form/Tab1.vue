<template>
  <tab-content
    :title="`ข้อมูลผู้${complaint_type?.name_th}`"
    :before-change="onTab1Validate"
    color="#800001"
  >
    <div id="google_translate_element"></div>
    <div class="row">
      <!--begin::Input group-->
      <div class="mb-5 mt-5">
        <h4>
          1.
          {{
            getLang() == "en"
              ? "Complainant Information"
              : "ข้อมูลผู้" + complaint_type?.name_th
          }}
        </h4>
      </div>

      <div class="input-group">
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

      <div
        class="mb-0 mt-0 col-12 col-lg-12"
        v-if="
          parseInt(complaint_item.is_anonymous) == 1
        "
      >
        <button @click="loginWithThaiD" class="btn" style="padding-left: 0px">
          <!-- Data with ThaiD -->
          <img
            src="/media/logos/thaid.png"
            alt=""
            style="width: 100px; border-radius: 0.5em"
          />
          ระบุตัวตนด้วย ThaiD
        </button>
      </div>

      <div class="col-12 mt-7">
        <div class="row">
          <div class="mb-7 col-12 col-lg-4 col-lg-12">
            <label for="phone_number" class="required form-label">{{
              $t("phone_number")
            }}</label>
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
            <label for="prefix_name" class="required form-label"
              >คำนำหน้า</label
            >
            <v-select
              label="name_th_abbr"
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
              <span role="alert" class="text-danger">{{
                errors.moo.text
              }}</span>
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
              <span role="alert" class="text-danger">{{
                errors.soi.text
              }}</span>
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
              <span role="alert" class="text-danger">{{
                errors.road.text
              }}</span>
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
            <br />
            <input
              class="form-control"
              type="file"
              id="formFile"
              accept="image/*"
              @change="onCardPhotoFileChange"
              ref="cardPhotoFile"
              style="display: none"
            />
            <div class="d-block mt-1" v-if="errors.card_photo.error == 1">
              <span role="alert" class="text-danger">{{
                errors.card_photo.text
              }}</span>
            </div>

            <!--  -->
            <div style="cursor: pointer">
              <img
                v-if="previewCardPhoto"
                :src="previewCardPhoto"
                class="mt-5 w-100 w-md-50"
                @click="openFileInput"
              />
              <img
                v-if="
                  previewCardPhoto == null &&
                  complainant_item.card_photo_old != null
                "
                :src="complainant_item.card_photo_old"
                alt=""
                class="mt-5 w-100 w-md-50"
                @click="openFileInput"
              />

              <img
                v-if="
                  previewCardPhoto == null &&
                  complainant_item.card_photo_old == null
                "
                src="/media/jcoms_exam_card.jpg"
                alt=""
                class="mt-5 w-100 w-md-50"
                @click="openFileInput"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </tab-content>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  watch,
  toRefs,
  computed,
} from "vue";
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
// Import FormWizard
import { TabContent } from "vue3-form-wizard";
// Import Yup Validate
import * as Yup from "yup";
// Use Toast Composables
import useToast from "@/composables/useToast";
import { useRoute } from "vue-router";

// Use Address Composables
import useBasicData from "@/composables/useBasicData";
import useAddressData from "@/composables/useAddressData";
import useMasterData from "@/composables/useMasterData";

import TranslateWidget from "@/components/translate/TranslateWidget.vue";

export default defineComponent({
  name: "appeal-form-tab1",
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
  },

  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    TabContent,
    TranslateWidget,
  },
  setup(props, { emit }) {
    // Variable
    const cardPhotoFile = ref<any>(null);
    const previewCardPhoto = ref<any>(null);

    const { complainant_item, complaint_item } = toRefs(props);

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    // const address_all = reactive(
    //   useAddressData().addresses.map((el: any) => {
    //     el.label =
    //       el.sub_district_th +
    //       " > " +
    //       el.district_th +
    //       " > " +
    //       el.province_th +
    //       " > " +
    //       el.post_code;
    //     return el;
    //   })
    // );

    const selectOptions = ref({
      address_all: useAddressData().addresses_mapping(),
      card_types: useBasicData().card_types,
      prefix_names: <any>[],
    });

    const validationComplainantSchema = Yup.object().shape({
      phone_number: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("หมายเลขโทรศัพท์"),
      card_type: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("ประเภทบัตร"),
      id_card: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .min(13, "Must be exactly 13 digits")
        .max(13, "Must be exactly 13 digits")
        .label("หมายเลขบัตรประชาชน/หนังสือเดินทาง"),
      prefix_name_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("คำนำหน้า"),
      firstname: Yup.string().required("${path} จำเป็นต้องระบุ").label("ชื่อ"),
      lastname: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("นามสกุล"),
      birthday: Yup.date()
        .required("${path} จำเป็นต้องระบุ")
        .label("วัน/เดือน/ปีเกิด"),
      occupation_text: Yup.string().nullable().label("อาชีพ"),
      house_number: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("บ้านเลขที่"),
      building: Yup.string().nullable().label("หมู่บ้าน"),
      moo: Yup.string().nullable().label("หมู่ที่"),
      soi: Yup.string().nullable().label("ซอย"),
      road: Yup.string().nullable().label("ถนน"),
      address_all: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("จังหวัด/อำเภอ/ตำบล"),
      //   card_photo: Yup.string()
      //     .required("${path} จำเป็นต้องระบุ")
      //     .label("รูปถ่ายตนเองพร้อมบัตร"),
      email: Yup.string().nullable().label("อีเมล"),
      line_id: Yup.string().nullable().label("Line ID"),
    });

    const errors_default = {
      phone_number: { error: 0, text: "" },
      card_type: { error: 0, text: "" },
      id_card: { error: 0, text: "" },
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
      birthday: { error: 0, text: "" },
      occupation_text: { error: 0, text: "" },
      house_number: { error: 0, text: "" },
      building: { error: 0, text: "" },
      moo: { error: 0, text: "" },
      soi: { error: 0, text: "" },
      road: { error: 0, text: "" },
      address_all: { error: 0, text: "" },
      card_photo: { error: 0, text: "" },
      email: { error: 0, text: "" },
      line_id: { error: 0, text: "" },
    };

    const errors = reactive<any>({
      ...errors_default,
    });

    const isValidPhoneNumber = (phoneNumber: any) => {
      // Thai phone number regex pattern
      const phonePattern = /^(0[689]{1}[0-9]{8}|0[12]{1}[0-9]{8})$/;

      return phonePattern.test(phoneNumber);
    };

    const validateThaiCitizenId = (id: any) => {
      // ตรวจสอบความยาวของเลขบัตรประชาชน
      if (id.length !== 13) {
        return false;
      }

      // ตรวจสอบรูปแบบตัวเลข
      const pattern = /^[0-9]+$/;
      if (!pattern.test(id)) {
        return false;
      }

      // คำนวณผลรวมของเลขแต่ละตำแหน่ง
      let sum = 0;
      for (let i = 0; i < 12; i++) {
        sum += parseInt(id.charAt(i)) * (13 - i);
      }

      // ตรวจสอบเลขควบคุม
      const lastDigit = parseInt(id.charAt(12));
      const remainder = sum % 11;
      const checkDigit = remainder < 2 ? remainder : 11 - remainder;

      return checkDigit === lastDigit;
    };

    const validatePhoneNumber = (phoneNumber: any) => {
      // รูปแบบเบอร์โทรศัพท์: 0xxxxxxxxx (เบอร์ 10 หลัก)
      const phoneRegex = /^0\d{9}$/;
      return phoneRegex.test(phoneNumber);
    };

    // ฟังก์ชันตรวจสอบอีเมล
    const validateEmail = (email: any) => {
      // รูปแบบอีเมลทั่วไป
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailRegex.test(email);
    };

    // Fetch

    // Event
    const openFileInput = () => {
      cardPhotoFile.value.click();
    };

    const onCardPhotoFileChange = (event: any) => {
      props.complainant_item.card_photo = event.target.files[0];
      if (props.complainant_item.card_photo) {
        previewCardPhoto.value = URL.createObjectURL(
          props.complainant_item.card_photo
        );
      } else {
        previewCardPhoto.value = null;
      }
    };

    const onTab1Validate = async () => {
      Object.assign(errors, {
        ...errors_default,
      });

      //   ต้องเป็น 1
      if (complaint_item.value.is_anonymous == 1) {
        try {
          await validationComplainantSchema.validate(complainant_item.value, {
            abortEarly: false,
          });
        } catch (err: any) {
          err.inner.forEach((error: any) => {
            const fieldName = error.path;
            const errorMessage = error.message;
            errors[fieldName].error = 1;
            errors[fieldName].text = errorMessage;
          });

          if (
            complainant_item.value.card_photo == null &&
            complainant_item.value.card_photo_old == null
          ) {
            errors["card_photo"].error = 1;
            errors["card_photo"].text = "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          }

          useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
          return false;
        }

        if (
          complainant_item.value.card_photo == null &&
          complainant_item.value.card_photo_old == null
        ) {
          errors["card_photo"].error = 1;
          errors["card_photo"].text = "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          return false;
        }

        let checkPhone = validatePhoneNumber(
          complainant_item.value.phone_number
        );

        if (checkPhone == false) {
          errors["phone_number"].error = 1;
          errors["phone_number"].text = "รูปแบบหมายเลขโทรศัพท์ไม่ถูกต้อง";
          useToast(errors["phone_number"].text, "error");
          return false;
        }

        let checkEmail = validateEmail(complainant_item.value.email);
        if (
          checkEmail == false &&
          complainant_item.value.email != "" &&
          complainant_item.value.email != null
        ) {
          errors["email"].error = 1;
          errors["email"].text = "รูปแบบอีเมลไม่ถูกต้อง";
          useToast(errors["email"].text, "error");
          return false;
        }

        if (complainant_item.value.card_type.value == 1) {
          let check = validateThaiCitizenId(complainant_item.value.id_card);

          if (check == false) {
            errors["id_card"].error = 1;
            errors["id_card"].text = "หมายเลขบัตรประชาชนไม่ถูกต้อง";
            useToast(errors["id_card"].text, "error");
            return false;
          }
        }
      } else {
        let checkPhone = validatePhoneNumber(
          complainant_item.value.phone_number
        );

        if (
          complainant_item.value.phone_number == "" ||
          complainant_item.value.phone_number == null ||
          checkPhone == false
        ) {
          errors["phone_number"].error = 1;
          errors["phone_number"].text = "รูปแบบหมายเลขโทรศัพท์ไม่ถูกต้อง";
          useToast("รูปแบบหมายเลขโทรศัพท์ไม่ถูกต้อง", "error");
          return false;
        }
      }

      let checkPhone = isValidPhoneNumber(complainant_item.value.phone_number);
      if (!checkPhone) {
        errors["phone_number"].error = 1;
        errors["phone_number"].text = "รูปแบบหมายเลขโทรศัพท์ไม่ถูกต้อง";
        useToast("รูปแบบหมายเลขโทรศัพท์ไม่ถูกต้อง", "error");
        return false;
      }

      return true;
    };

    const sortPrefixNames = (prefixNames) => {
      const priority = ["นาย", "นาง", "นางสาว"];
      return prefixNames.sort((a, b) => {
        const aIndex = priority.indexOf(a.name_th_abbr);
        const bIndex = priority.indexOf(b.name_th_abbr);

        if (aIndex === -1 && bIndex === -1) {
          return 0; // Neither a nor b is in the priority list
        } else if (aIndex === -1) {
          return 1; // a is not in the priority list, b is
        } else if (bIndex === -1) {
          return -1; // b is not in the priority list, a is
        } else {
          return aIndex - bIndex; // Both a and b are in the priority list
        }
      });
    };

    // Mounted
    onMounted(async () => {
      selectOptions.value.prefix_names = await useMasterData().fetchPrefixName({
        is_active: 1,
        perPage: 500,
      });

      // Sort the prefix names
      selectOptions.value.prefix_names = sortPrefixNames(
        selectOptions.value.prefix_names
      );
    });

    // Watch
    watch(
      () => complainant_item.value.address_all,
      (value: any) => {
        complainant_item.value.province_id = null;
        complainant_item.value.district_id = null;
        complainant_item.value.sub_district_id = null;
        complainant_item.value.postal_code = null;

        if (value !== null) {
          complainant_item.value.province_id = value.province_id;
          complainant_item.value.district_id = value.district_id;
          complainant_item.value.sub_district_id = value.sub_district_id;
          complainant_item.value.postal_code = value.post_code;
        }
      }
    );

    const getLang = () => {
      return localStorage.getItem("lang");
    };

    const route = useRoute();
    const fullUrl = computed(() => window.location.href);

    const loginWithThaiD = () => {
      const clientId = import.meta.env.VITE_APP_THAID_CLIENTID;
      const redirectUri = import.meta.env.VITE_APP_THAID_REDIRECT_URI;
      const responseType = "code";
      const scope = import.meta.env.VITE_APP_THAID_SCOPE;
      const state = btoa(fullUrl.value);
      //import.meta.env.VITE_APP_THAID_STATE;
      //   http://localhost:5173/jcoms/appeal?type_id=1

      const authUrl = `https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/?response_type=${responseType}&client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scope}&state=${state}`;
      window.location.href = authUrl;
    };

    //jcoms2.police.go.th/thaid-callback?code=Y2QzNjk4MTMtNmJiMi00ZjlhLTgzMzgtYzg1NDQ4YzRkODk5I2IxNmZlNmRmLTBlMTYtNDU0ZC05NTY5LTE2Mzc4NjI4NDFhNQ&state=%22HC1UAbHvRc%22

    // Return
    https: return {
      getAssetPath,
      format,
      selectOptions,
      cardPhotoFile,
      previewCardPhoto,
      onCardPhotoFileChange,
      onTab1Validate,
      errors,
      openFileInput,
      getLang,
      loginWithThaiD,
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
.form-control {
  border-color: #800001;
  border-width: 0.1em;
}
</style>
