<template>
  <!--begin::Wrapper-->
  <div class="p-10 card">
    <!--begin::Form-->
    <!--begin::Heading-->
    <div class="mb-10 text-center">
      <!--begin::Title-->
      <h1 class="text-gray-900 mb-3">เจ้าหน้าที่สมัครเข้าใช้งาน</h1>
      <!--end::Title-->

      <!--begin::Link-->
      <div class="text-gray-500 fw-semibold fs-4">
        มีบัญชีอยู่แล้ว

        <router-link to="/sign-in" class="link-primary fw-bold">
          Sign in here
        </router-link>
      </div>
      <!--end::Link-->
    </div>
    <!--end::Heading-->

    <!--begin::Input group-->
    <div class="row fv-row">
      <!--begin::Col-->
      <div class="col-xl-4 mb-7">
        <label class="form-label fw-bold text-gray-900 fs-6">คำนำหน้า</label>
        <v-select
          label="name_th"
          name="prefix_name"
          placeholder="คำนำหน้า (ยศ)"
          :options="selectOptions.prefix_names"
          class="form-control form-control-lg"
          :clearable="false"
          v-model="item.prefix_name_id"
        >
        </v-select>
        <div class="fv-plugins-message-container">
          <div class="fv-help-block">
            <ErrorMessage name="prefix_name" />
          </div>
        </div>
      </div>
      <!--end::Col-->

      <!--begin::Col-->
      <div class="col-xl-4 mb-7">
        <label for="firstname" class="required form-label">ชื่อ</label>
        <input
          type="text"
          class="form-control"
          placeholder="ชื่อ"
          aria-label="ชื่อ/Firstname"
          v-model="item.firstname"
        />
        <div class="d-block mt-1" v-if="errors.firstname.error == 1">
          <span role="alert" class="text-danger">{{
            errors.firstname.text
          }}</span>
        </div>
      </div>
      <!--end::Col-->

      <!--begin::Col-->
      <div class="col-xl-4 mb-7">
        <label for="lastname" class="required form-label">นามสกุล</label>
        <input
          type="text"
          class="form-control"
          placeholder="นามสกุล"
          aria-label="นามสกุล/Surname"
          v-model="item.lastname"
        />
        <div class="d-block mt-1" v-if="errors.lastname.error == 1">
          <span role="alert" class="text-danger">{{
            errors.lastname.text
          }}</span>
        </div>
      </div>
      <!--end::Col-->

      <div class="col-xl-6 mb-7">
        <label for="line_id" class="form-label">วันเดือนปีเกิด</label>
        <VueDatePicker
          v-model="item.birthday"
          :max-date="new Date()"
          :enable-time-picker="false"
          placeholder="วันเดือนปีเกิด(พ.ศ.)"
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
      <div class="col-xl-6 mb-7">
        <label for="phone_number" class="form-label">เบอร์โทรศัพท์</label>
        <input
          type="text"
          class="form-control"
          placeholder="โทรศัพท์"
          aria-label="โทรศัพท์"
          v-model="item.phone_number"
        />
        <div class="d-block mt-1" v-if="errors.phone_number.error == 1">
          <span role="alert" class="text-danger">{{
            errors.phone_number.text
          }}</span>
        </div>
      </div>
      <div class="col-xl-6 mb-7">
        <label for="email" class="form-label">อีเมล</label>
        <input
          type="text"
          class="form-control"
          placeholder="อีเมล"
          aria-label="อีเมล/Email"
          v-model="item.email"
        />
        <div class="d-block mt-1" v-if="errors.email.error == 1">
          <span role="alert" class="text-danger">{{ errors.email.text }}</span>
        </div>
      </div>
      <div class="col-xl-6 mb-7">
        <label for="line_id" class="form-label">Line ID</label>
        <input
          type="text"
          class="form-control"
          placeholder="Line ID"
          aria-label="Line ID"
          v-model="item.line_id"
        />
        <div class="d-block mt-1" v-if="errors.line_id.error == 1">
          <span role="alert" class="text-danger">{{
            errors.line_id.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-6 mb-7">
        <label for="line_id" class="form-label">เลขบัตรข้าราชการ</label>
        <input
          type="text"
          class="form-control"
          placeholder="เลขบัตรข้าราชการ"
          aria-label="เลขบัตรข้าราชการ"
          v-model="item.officer_code"
        />
        <div class="d-block mt-1" v-if="errors.officer_code.error == 1">
          <span role="alert" class="text-danger">{{
            errors.officer_code.text
          }}</span>
        </div>
      </div>
      <div class="col-xl-6 mb-7">
        <label for="line_id" class="form-label">เลขบัตรประจำตัวประชาชน</label>
        <input
          type="text"
          class="form-control"
          placeholder="เลขบัตรประจำตัวประชาชน"
          aria-label="เลขบัตรประจำตัวประชาชน"
          v-model="item.id_card"
        />
        <div class="d-block mt-1" v-if="errors.id_card.error == 1">
          <span role="alert" class="text-danger">{{
            errors.id_card.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-12 mb-7">
        <label for="organization_all" class="form-label">หน่วยงาน</label>
        <v-select
          name="organization_all"
          placeholder="หน่วยงาน/Organization"
          :options="selectOptions.organizations"
          class="form-control"
          :clearable="false"
          v-model="item.organization_all"
        >
        </v-select>
        <div class="d-block mt-1" v-if="errors.position_id.error == 1">
          <span role="alert" class="text-danger">{{
            errors.position_id.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-6 mb-7">
        <label for="position_id" class="form-label">ตำแหน่ง</label>
        <v-select
          label="name_th"
          name="position_id"
          placeholder="ตำแหน่ง"
          :options="selectOptions.positions"
          class="form-control form-control-lg"
          :clearable="false"
          v-model="item.position_id"
        >
        </v-select>
        <div class="d-block mt-1" v-if="errors.position_id.error == 1">
          <span role="alert" class="text-danger">{{
            errors.position_id.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-6 mb-7">
        <label for="section_id" class="form-label">สายงาน</label>
        <v-select
          label="name_th"
          name="section_id"
          placeholder="สายงาน"
          :options="selectOptions.sections"
          class="form-control form-control-lg"
          :clearable="false"
          v-model="item.section_id"
        >
        </v-select>
        <div class="d-block mt-1" v-if="errors.position_id.error == 1">
          <span role="alert" class="text-danger">{{
            errors.section_id.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-12 mb-7">
        <label for="line_id" class="form-label">สิทธิผู้ใช้งาน</label>
        <v-select
          label="name_th"
          name="role_id"
          placeholder="สิทธิผู้ใช้งาน"
          :options="selectOptions.roles"
          class="form-control form-control-lg"
          :clearable="false"
          v-model="item.role_id"
        >
        </v-select>
        <div class="d-block mt-1" v-if="errors.role_id.error == 1">
          <span role="alert" class="text-danger">{{
            errors.role_id.text
          }}</span>
        </div>
      </div>

      <div class="col-xl-12 mb-7">
        <label for="formFile" class="form-label required"
          >แนบบัตรข้าราชการ</label
        >
        <input
          class="form-control"
          type="file"
          id="formFile"
          ref="FileAttach"
          @change="onFileChange"
        />
        <div class="d-block mt-1" v-if="errors.file_attach.error == 1">
          <span role="alert" class="text-danger">{{
            errors.file_attach.text
          }}</span>
        </div>
      </div>

      <!--begin::Input group-->
      <div class="col-xl-6 mb-7" data-kt-password-meter="true">
        <!--begin::Wrapper-->
        <div class="mb-1">
          <!--begin::Label-->
          <label class="form-label fw-bold text-gray-900 fs-6">
            รหัสผ่าน
          </label>
          <!--end::Label-->

          <!--begin::Input wrapper-->
          <div class="position-relative mb-3">
            <input
              type="password"
              class="form-control"
              placeholder="รหัสผ่าน"
              aria-label="รหัสผ่าน"
              v-model="item.password"
            />
            <div class="d-block mt-1" v-if="errors.password.error == 1">
              <span role="alert" class="text-danger">{{
                errors.password.text
              }}</span>
            </div>
          </div>
          <!--end::Input wrapper-->
          <!--begin::Meter-->
          <div
            class="d-flex align-items-center mb-3"
            data-kt-password-meter-control="highlight"
          >
            <div
              class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"
            ></div>
            <div
              class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"
            ></div>
            <div
              class="flex-grow-1 bg-secondary bg-active-success rounded h-5px me-2"
            ></div>
            <div
              class="flex-grow-1 bg-secondary bg-active-success rounded h-5px"
            ></div>
          </div>
          <!--end::Meter-->
        </div>
        <!--end::Wrapper-->
        <!--begin::Hint-->
        <div class="text-muted">
          Use 8 or more characters with a mix of letters, numbers & symbols.
        </div>
        <!--end::Hint-->
      </div>
      <!--end::Input group--->

      <!--begin::Input group-->
      <div class="col-xl-6 mb-7">
        <label class="form-label fw-bold text-gray-900 fs-6"
          >ยืนยันรหัสผ่าน</label
        >
        <input
          type="password"
          class="form-control"
          placeholder="ยืนยันรหัสผ่าน"
          aria-label="ยืนยันรหัสผ่าน"
          v-model="item.confirm_password"
        />
        <div class="d-block mt-1" v-if="errors.confirm_password.error == 1">
          <span role="alert" class="text-danger">{{
            errors.confirm_password.text
          }}</span>
        </div>
      </div>
      <!--end::Input group-->
    </div>
    <!--end::Input group-->

    <!--begin::Actions-->
    <div class="text-center">
      <button
        id="kt_sign_up_submit"
        class="btn btn-lg btn-primary"
        @click="onValidate"
      >
        <span class="indicator-label"> ส่งข้อมูล </span>
        <span class="indicator-progress">
          Please wait...
          <span
            class="spinner-border spinner-border-sm align-middle ms-2"
          ></span>
        </span>
      </button>

      <button
        id="kt_sign_up_submit"
        class="btn btn-lg btn-secondary ms-5"
        @click="
          () => {
            $router.push('home');
          }
        "
      >
        <span class="indicator-label"> กลับหน้าหลัก </span>
      </button>
    </div>
    <!--end::Actions-->
    <!--end::Form-->
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, nextTick, onMounted, ref, watch } from "vue";
import { ErrorMessage, Field, Form as VForm } from "vee-validate";
import * as Yup from "yup";
import { useAuthStore, type User } from "@/stores/auth";
import { useRouter } from "vue-router";
import { PasswordMeterComponent } from "@/assets/ts/components";
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Use Toast Composables
import useToast from "@/composables/useToast";
// import Api Service
import ApiService from "@/core/services/ApiService";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// Use Address Composables
import useOrganizationData from "@/composables/useOrganizationData";

export default defineComponent({
  name: "sign-up",
  components: {
    Field,
    VForm,
    ErrorMessage,
    vSelect,
    VueDatePicker,
  },
  setup() {
    const store = useAuthStore();
    const router = useRouter();

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

    const FileAttach = ref<any>(null);

    const selectOptions = ref({
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
      roles: [],
      positions: [],
      sections: [],
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const item = ref<any>({
      prefix_name_id: null,
      firstname: "",
      lastname: "",
      phone_number: "",
      email: "",
      line_id: "",
      role_id: null,
      officer_code: "",
      id_card: "",
      position_id: null,
      section_id: null,
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      birthday: null,
      file_attach: null,
      password: null,
      confirm_password: null,
      status: 2,
      organization_all: null,
    });
    const errors = ref<any>({
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
      phone_number: { error: 0, text: "" },
      email: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
      line_id: { error: 0, text: "" },
      role_id: { error: 0, text: "" },
      officer_code: { error: 0, text: "" },
      id_card: { error: 0, text: "" },
      position_id: { error: 0, text: "" },
      section_id: { error: 0, text: "" },
      inspector_id: { error: 0, text: "" },
      bureau_id: { error: 0, text: "" },
      division_id: { error: 0, text: "" },
      agency_id: { error: 0, text: "" },
      birthday: { error: 0, text: "" },
      file_attach: { error: 0, text: "" },
      password: { error: 0, text: "" },
      confirm_password: { error: 0, text: "" },
      status: { error: 0, text: "" },
    });

    const thaiPhoneNumberRegex = /^0\d{9}$/;
    const validationItemSchema = Yup.object().shape({
      prefix_name_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("คำนำหน้า"),
      firstname: Yup.string().required("${path} จำเป็นต้องระบุ").label("ชื่อ"),
      lastname: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("นามสกุล"),
      phone_number: Yup.string()
        .matches(thaiPhoneNumberRegex, "หมายเลขโทรศัพท์ไม่ถูกต้อง")
        .required("${path} จำเป็นต้องระบุ")
        .label("หมายเลขโทรศัพท์"),
      email: Yup.string()
        .email()
        .required("${path} จำเป็นต้องระบุ")
        .label("อีเมล"),
      organization_all: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("หน่วยงาน"),
      line_id: Yup.string().nullable().label("Line ID"),
      role_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("สิทธิผู้ใช้งาน"),
      officer_code: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("เลขบัตรข้าราชการ"),
      id_card: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .min(13, "หมายเลขบัตรประชาชนไม่ถูกต้อง")
        .max(13, "หมายเลขบัตรประชาชนไม่ถูกต้อง")
        .label("หมายเลขบัตรประชาชน/หนังสือเดินทาง"),
      position_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("ตำแหน่งงาน"),
      section_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("สายงาน"),
      inspector_id: Yup.number().nullable().label("กองตรวจ"),
      bureau_id: Yup.number().nullable().label("บช"),
      division_id: Yup.number().nullable().label("ภาค"),
      agency_id: Yup.number().nullable().label("สน"),
      birthday: Yup.date()
        .required("${path} จำเป็นต้องระบุ")
        .label("วัน/เดือน/ปีเกิด"),
      password: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("รหัสผ่าน"),
      confirm_password: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .oneOf([Yup.ref("password")], "Passwords must match")
        .label("รหัสผ่าน"),
      status: Yup.number().required("${path} จำเป็นต้องระบุ").label("สถานะ"),
      //   file_attach: Yup.string()
      //     .nullable()
      // .required("${path} จำเป็นต้องระบุ")
      // .label("หลักฐาน"),
    });

    const submitButton = ref<HTMLButtonElement | null>(null);

    const registration = Yup.object().shape({
      prefix_name: Yup.string().required().label("คำนำหน้า"),
      first_name: Yup.string().required().label("ชื่อ"),
      last_name: Yup.string().required().label("Surname"),
      email: Yup.string().min(4).required().email().label("Email"),
      password: Yup.string().required().label("Password"),
      password_confirmation: Yup.string()
        .required()
        .oneOf([Yup.ref("password")], "Passwords must match")
        .label("Password Confirmation"),
    });

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

    // Fetch
    const fetchPrefixName = async () => {
      let api = {
        type: "query",
        url: "prefix-name",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.prefix_names = data.data.filter((x: any) => {
            return (
              x.id != 29 &&
              x.id != 30 &&
              x.id != 31 &&
              x.id != 33 &&
              x.id != 34 &&
              x.id != 35 &&
              x.id != 36 &&
              x.id != 37 &&
              x.id != 38 &&
              x.id != 39
            );
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchPosition = async () => {
      let api = {
        type: "query",
        url: "position",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.positions = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchSection = async () => {
      let api = {
        type: "query",
        url: "section",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.sections = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchRole = async () => {
      let api = {
        type: "query",
        url: "role",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.roles = data.data.filter((x: any) => {
            return x.id != 7;
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Event
    const onValidate = async () => {
      errors.value = {
        prefix_name_id: { error: 0, text: "" },
        firstname: { error: 0, text: "" },
        lastname: { error: 0, text: "" },
        phone_number: { error: 0, text: "" },
        email: { error: 0, text: "" },
        organization_all: { error: 0, text: "" },
        line_id: { error: 0, text: "" },
        role_id: { error: 0, text: "" },
        officer_code: { error: 0, text: "" },
        id_card: { error: 0, text: "" },
        position_id: { error: 0, text: "" },
        section_id: { error: 0, text: "" },
        inspector_id: { error: 0, text: "" },
        bureau_id: { error: 0, text: "" },
        division_id: { error: 0, text: "" },
        agency_id: { error: 0, text: "" },
        birthday: { error: 0, text: "" },
        file_attach: { error: 0, text: "" },
        password: { error: 0, text: "" },
        confirm_password: { error: 0, text: "" },
        status: { error: 0, text: "" },
      };

      try {
        await validationItemSchema.validate(item.value, {
          abortEarly: false,
        });
      } catch (err: any) {
        console.log(err);
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          errors.value[fieldName].error = 1;
          errors.value[fieldName].text = errorMessage;
        });

        if (item.value.file_attach == null) {
          errors.value["file_attach"].error = 1;
          errors.value["file_attach"].text = "หลักฐาน จำเป็นต้องระบุ";
        }

        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      let check = validateThaiCitizenId(item.value.id_card);

      if (check == false) {
        errors.value["id_card"].error = 1;
        errors.value["id_card"].text = "หมายเลขบัตรประชาชนไม่ถูกต้อง";
        useToast("หมายเลขบัตรประชาชนไม่ถูกต้อง", "error");
        return false;
      }

      //   Save and swal success
      await onSaveUser();
    };

    const onFileChange = (event: any) => {
      item.value.file_attach = event.target.files[0];
    };

    onMounted(() => {
      fetchPrefixName();
      fetchPosition();
      fetchSection();
      fetchRole();
      nextTick(() => {
        PasswordMeterComponent.bootstrap();
      });
    });

    const onSubmitRegister = async (values: any) => {
      values = values as User;

      // Clear existing errors
      store.logout();

      // eslint-disable-next-line
      submitButton.value!.disabled = true;

      // Activate indicator
      submitButton.value?.setAttribute("data-kt-indicator", "on");

      // Send login request
      await store.register(values);

      const error = Object.values(store.errors);

      if (!error) {
        Swal.fire({
          text: "You have successfully logged in!",
          icon: "success",
          buttonsStyling: false,
          confirmButtonText: "Ok, got it!",
          heightAuto: false,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-primary",
          },
        }).then(function () {
          // Go to page after successfully login
          router.push({ name: "dashboard" });
        });
      } else {
        Swal.fire({
          text: error[0] as string,
          icon: "error",
          buttonsStyling: false,
          confirmButtonText: "Try again!",
          heightAuto: false,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-danger",
          },
        });
      }

      submitButton.value?.removeAttribute("data-kt-indicator");
      // eslint-disable-next-line
      submitButton.value!.disabled = false;
    };

    const onSaveUser = async () => {
      //
      let data_item = {
        file_attach:
          item.value.file_attach != null ? item.value.file_attach : null,
        id_card: item.value.id_card,
        prefix_name_id: item.value.prefix_name_id
          ? item.value.prefix_name_id.id
          : null,
        firstname: item.value.firstname,
        lastname: item.value.lastname,
        birthday: item.value.birthday
          ? dayjs(item.value.birthday).format("YYYY-MM-DD")
          : "",
        phone_number: item.value.phone_number,
        email: item.value.email,
        line_id: item.value.line_id,
        position_id: item.value.position_id.id,
        section_id: item.value.section_id.id,

        officer_code: item.value.officer_code,
        role_id: item.value.role_id.id,

        status: item.value.status,
        password: item.value.password,
        //
        inspector_id: item.value.inspector_id,
        bureau_id: item.value.bureau_id,
        division_id: item.value.division_id,
        agency_id: item.value.agency_id,
        created_by: item.value.firstname + " " + item.value.firstname,
        updated_by: item.value.firstname + " " + item.value.lastname,
        // รุป
      };

      let api = {
        type: "postFormData",
        url: "user/",
        textToast: "เพิ่มข้อมูลเสร็จสิ้น",
      };

      await ApiService[api.type](api.url, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          // Swal
          Swal.fire({
            text: "เราได้รับข้อมูลของท่านเรียบร้อยแล้ว กรุณารอการตรวจสอบและอนุมัติผู้ใช้งาน",
            icon: "success",
            buttonsStyling: false,
            confirmButtonText: "ตกลง",
            heightAuto: false,
            customClass: {
              confirmButton: "btn fw-semibold btn-light-primary",
            },
          }).then(() => {
            router.push({ name: "home" });
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // watch
    watch(
      () => item.value.organization_all,
      (organization_all: any) => {
        if (organization_all != null) {
          item.value.inspector_id = organization_all.hasOwnProperty(
            "inspector_id"
          )
            ? organization_all.inspector_id
            : null;
          item.value.bureau_id = organization_all.hasOwnProperty("bureau_id")
            ? organization_all.bureau_id
            : null;
          item.value.division_id = organization_all.hasOwnProperty(
            "division_id"
          )
            ? organization_all.division_id
            : null;
          item.value.agency_id = organization_all.hasOwnProperty("agency_id")
            ? organization_all.agency_id
            : null;
        } else {
          item.value.inspector_id = null;
          item.value.bureau_id = null;
          item.value.division_id = null;
          item.value.agency_id = null;
        }
      },
      { deep: true }
    );

    return {
      item,
      errors,
      registration,
      onSubmitRegister,
      submitButton,
      getAssetPath,
      selectOptions,
      onValidate,
      format,
      FileAttach,
      onFileChange,
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
