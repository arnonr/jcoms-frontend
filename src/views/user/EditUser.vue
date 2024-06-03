<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">แก้ไขข้อมูล/เปลี่ยนสถานะ</h3>
          <button
            @click="onClose"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <div class="container" v-if="item">
            <div class="row">
              <div class="col-md-12">
                <div class="row">
                  <div class="col-md-12 mb-5">
                    <h4 class="color-primary">สถานะผู้ใช้งาน</h4>
                  </div>
                  <div class="col-md-12 mb-7">
                    <label class="form-label required">สถานะ</label>
                    <v-select
                      label="name"
                      name="status"
                      placeholder="สถานะ"
                      :options="selectOptions.user_statuses"
                      class="form-control form-control-lg"
                      :clearable="false"
                      v-model="item.status"
                    >
                    </v-select>
                    <div class="fv-plugins-message-container">
                      <div class="fv-help-block">
                        <ErrorMessage name="status" />
                      </div>
                    </div>
                  </div>

                  <div class="col-md-12 mb-5 mt-5">
                    <h4 class="color-primary">ข้อมูลผู้ใช้งาน</h4>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label class="form-label required">คำนำหน้า</label>
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

                  <div class="col-md-4 mb-7">
                    <label for="firstname" class="required form-label"
                      >ชื่อ</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="ชื่อ"
                      aria-label="ชื่อ/Firstname"
                      v-model="item.firstname"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.firstname.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.firstname.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label for="lastname" class="required form-label"
                      >นามสกุล</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="นามสกุล"
                      aria-label="นามสกุล/Lastname"
                      v-model="item.lastname"
                    />
                    <div class="d-block mt-1" v-if="errors.lastname.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.lastname.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="line_id" class="form-label"
                      >รหัสเจ้าหน้าที่</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="รหัสเจ้าหน้าที่"
                      aria-label="รหัสเจ้าหน้าที่"
                      v-model="item.officer_code"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.officer_code.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.officer_code.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="line_id" class="form-label required"
                      >เลขบัตรประจำตัวประชาชน</label
                    >
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

                  <div class="col-md-6 mb-7">
                    <label for="birthday" class="form-label"
                      >วันเดือนปีเกิด</label
                    >
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

                  <div class="col-md-6 mb-7">
                    <label for="phone_number" class="form-label required"
                      >เบอร์โทรศัพท์</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="โทรศัพท์"
                      aria-label="โทรศัพท์"
                      v-model="item.phone_number"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.phone_number.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.phone_number.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="email" class="form-label required">อีเมล</label>
                    <input
                      type="text"
                      class="form-control"
                      placeholder="อีเมล"
                      aria-label="อีเมล/Email"
                      v-model="item.email"
                    />
                    <div class="d-block mt-1" v-if="errors.email.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.email.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
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

                  <div class="col-md-12 mb-7">
                    <label for="organization_all" class="form-label required"
                      >หน่วยงาน</label
                    >
                    <v-select
                      name="organization_all"
                      placeholder="หน่วยงาน/Organization"
                      :options="selectOptions.organizations"
                      class="form-control"
                      :clearable="false"
                      v-model="item.organization_all"
                    >
                    </v-select>
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.position_id.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="position_id" class="form-label required"
                      >ตำแหน่ง</label
                    >
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
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.position_id.text
                      }}</span>
                    </div>
                  </div>
                  <div class="col-md-6 mb-7">
                    <label for="section_id" class="form-label required"
                      >สายงาน</label
                    >
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
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.section_id.text
                      }}</span>
                    </div>
                  </div>
                  <div class="col-md-12 mb-7">
                    <label for="line_id" class="form-label required"
                      >สิทธิผู้ใช้งาน</label
                    >
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

                  <div class="col-md-12 mb-7" v-if="item.role_id?.id == 5">
                    <label for="inspector_id" class="form-label required"
                      >กองตรวจ</label
                    >
                    <v-select
                      name="inspector_id"
                      label="name_th"
                      placeholder="กองตรวจ"
                      :options="selectOptions.inspectors"
                      class="form-control"
                      :clearable="false"
                      v-model="item.inspector_id"
                    >
                    </v-select>
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.position_id.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-12 mb-7">
                    <label for="formFile" class="form-label"
                      >แนบบัตรข้าราชการ</label
                    >
                    <input
                      class="form-control"
                      type="file"
                      id="formFile"
                      ref="FileAttach"
                      @change="onFileChange"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.file_attach.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.file_attach.text
                      }}</span>
                    </div>
                    <img
                      v-if="previewImage"
                      :src="previewImage"
                      class="mt-5 w-100 w-md-50"
                    />
                  </div>

                  <div class="col-md-12 mb-7">
                    <button
                      class="finish-button btn text-white btn-success"
                      @click="onValidate()"
                    >
                      บันทึก
                    </button>
                    <button
                      class="btn text-white btn-danger ms-2"
                      @click="onClose"
                      data-bs-dismiss="modal"
                      aria-label="Close"
                    >
                      ยกเลิก
                    </button>
                  </div>
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
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  onUnmounted,
  watch,
  watchEffect,
} from "vue";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
import ApiService from "@/core/services/ApiService";

import { ErrorMessage, Field, Form as VForm } from "vee-validate";

// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";

// Import route
import { useRoute, useRouter } from "vue-router";

// Import Yup Validate
import * as Yup from "yup";
// Use Toast Composables
import useToast from "@/composables/useToast";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

// Use Composables
import useBasicData from "@/composables/useBasicData";
import useOrganizationData from "@/composables/useOrganizationData";

export default defineComponent({
  name: "edit-user",
  props: {
    id: {
      type: Number,
      required: true,
    },
  },
  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    Field,
    VForm,
    ErrorMessage,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

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

    const selectOptions = ref({
      // complaint_channels: <any>[],
      prefix_names: [],
      inspectors: [],
      user_statuses: useBasicData().user_statuses,
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
      roles: [],
      positions: [],
      sections: [],
    });

    const item = reactive<any>({});
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
    const FileAttach = ref<any>(null);
    const previewImage = ref<any>(null);

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const thaiPhoneNumberRegex = /^0\d{9}$/;

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
      //   organization_all: Yup.object()
      //     .required("${path} จำเป็นต้องระบุ")
      //     .label("หน่วยงาน"),
      line_id: Yup.string().nullable().label("Line ID"),
      role_id: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("สิทธิผู้ใช้งาน"),
      officer_code: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("รหัสเจ้าหน้าที่"),
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
      bureau_id: Yup.number().nullable().label("บช"),
      division_id: Yup.number().nullable().label("ภาค"),
      agency_id: Yup.number().nullable().label("สน"),
      birthday: Yup.date()
        .required("${path} จำเป็นต้องระบุ")
        .label("วัน/เดือน/ปีเกิด"),
      status: Yup.object().required("${path} จำเป็นต้องระบุ").label("สถานะ"),
    });

    // Fetch

    const fetchInspector = async () => {
      const { data } = await ApiService.query("inspector", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.inspectors = data.data;
    };

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

    const fetchUser = async () => {
      try {
        const { data } = await ApiService.query("user/" + props.id, {});

        let organzation = "";
        if (data.data.agency) {
          organzation = organzation + data.data.agency.name_th + " > ";
        }
        if (data.data.division) {
          organzation = organzation + data.data.division.name_th + " > ";
        }
        if (data.data.bureau) {
          organzation = organzation + data.data.bureau.name_th;
        }

        Object.assign(item, {
          ...data.data,
          organization_all: {
            label: organzation,
            agency_id: data.data.agency_id,
            division_id: data.data.division_id,
            bureau_id: data.data.bureau_id,
          },
          prefix_name_id:
            data.data.prefix_name_id != null
              ? {
                  name_th: data.data.prefix_name.name_th,
                  id: data.data.prefix_name_id,
                }
              : null,
          position_id:
            data.data.position_id != null
              ? {
                  name_th: data.data.position.name_th,
                  id: data.data.position_id,
                }
              : null,
          section_id:
            data.data.section_id != null
              ? {
                  name_th: data.data.section.name_th,
                  id: data.data.section_id,
                }
              : null,
          role_id:
            data.data.role_id != null
              ? {
                  name_th: data.data.role.name_th,
                  id: data.data.role_id,
                }
              : null,
          status:
            data.data.status != null
              ? selectOptions.value.user_statuses.find((x: any) => {
                  return x.id == data.data.status;
                })
              : null,
          file_attach_old: data.data.file_attach,
          inspector_id:
            data.data.inspector_id != null
              ? {
                  name_th: data.data.inspector.name_th,
                  id: data.data.inspector_id,
                }
              : null,
          //  หน่วยงาน
        });
        previewImage.value = item.file_attach_old;
        console.log(previewImage.value);
      } catch (error) {
        console.log(error);
      }
    };

    //Event
    const onClose = () => {
      mainModalObj.value.hide();
      emit("close-modal");
    };

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
        status: { error: 0, text: "" },
      };

      try {
        await validationItemSchema.validate(item, {
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

        // if (item.value.file_attach == null) {
        //   errors.value["file_attach"].error = 1;
        //   errors.value["file_attach"].text = "หลักฐาน จำเป็นต้องระบุ";
        // }

        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      let check = validateThaiCitizenId(item.id_card);

      if (check == false) {
        errors.value["id_card"].error = 1;
        errors.value["id_card"].text = "หมายเลขบัตรประชาชนไม่ถูกต้อง";
        useToast("หมายเลขบัตรประชาชนไม่ถูกต้อง", "error");
        return false;
      }

      //   Save and swal success
      await onSaveUser();
    };

    const onSaveUser = async () => {
      //
      let data_item = {
        file_attach:
          item.file_attach != null ? item.file_attach : null,
        id_card: item.id_card,
        prefix_name_id: item.prefix_name_id ? item.prefix_name_id.id : null,
        firstname: item.firstname,
        lastname: item.lastname,
        birthday: item.birthday
          ? dayjs(item.birthday).format("YYYY-MM-DD")
          : "",
        phone_number: item.phone_number,
        email: item.email,
        line_id: item.line_id,
        position_id: item.position_id.id,
        section_id: item.section_id.id,

        officer_code: item.officer_code,
        role_id: item.role_id.id,

        status: item.status.id,
        bureau_id: item.bureau_id,
        division_id: item.division_id,
        agency_id: item.agency_id,
        inspector_id: item.inspector_id?.id,
        // updated_by: item.value.firstname + " " + item.value.lastname,
        // รูป
      };

      await ApiService.putFormData("user/" + item.id, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          // Swal
          useToast("แก้ไขข้อมูลเสร็จสิ้น", "success");
          emit("reload");
          emit("close-modal");
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onFileChange = (event: any) => {
      item.file_attach = event.target.files[0];
      if (item.file_attach) {
        previewImage.value = URL.createObjectURL(item.file_attach);
      } else {
        previewImage.value = null;
      }
    };

    // Mounted
    onMounted(async () => {
      await fetchInspector();
      await fetchPrefixName();
      await fetchPosition();
      await fetchSection();
      await fetchRole();
      await fetchUser();
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Watch
    watch(
      () => item.organization_all,
      (organization_all: any) => {
        if (organization_all != null) {
          item.bureau_id = organization_all.hasOwnProperty("bureau_id")
            ? organization_all.bureau_id
            : null;
          item.division_id = organization_all.hasOwnProperty("division_id")
            ? organization_all.division_id
            : null;
          item.agency_id = organization_all.hasOwnProperty("agency_id")
            ? organization_all.agency_id
            : null;
        } else {
          //   item.inspector_id = null;
          item.bureau_id = null;
          item.division_id = null;
          item.agency_id = null;
        }
      },
      { deep: true }
    );

    // Return
    return {
      item,
      errors,
      selectOptions,
      format,
      previewImage,
      onClose,
      mainModalRef,
      FileAttach,
      onFileChange,
      onValidate,
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
