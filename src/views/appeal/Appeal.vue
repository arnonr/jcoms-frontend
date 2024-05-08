<template>
  <!--begin::Wrapper-->
  <div class="container p-lg-10 mt-5" id="container">
    <h2 class="mt-10 mb-5 text-black">แบบฟอร์ม{{ complant_type.name_th }}</h2>
    <div class="card">
      <div class="card-body">
        <!-- color="#ffcb05" -->
        <!-- disable-back -->
        <!-- hide-buttons -->
        <form-wizard
          color="#800001"
          ref="formStep"
          finishButtonText="ส่งข้อมูล"
          backButtonText="ย้อนกลับ"
          nextButtonText="ถัดไป"
          step-size="xs"
          id="form"
          @on-change="onTabChange"
          @on-complete="onComplete"
        >
          <!-- 
            :before-change="beforeTabSwitch(1)" -->
          <tab-content
            :title="`ระบุข้อมูลผู้${complant_type.name_th}`"
            :before-change="beforeTabSwitch"
          >
            <Tab1
              :item="complainant_item"
              :complaint_item="item"
              :complant_type="complant_type"
              :change_phone_number="change_phone_number"
              :errors="complainant_item_errors"
              @update-phone-number-data="
                () => {
                  change_phone_number = true;
                  captcha_modal = true;
                  first_action = false;
                }
              "
            />
          </tab-content>
          <tab-content
            :title="`ระบุรายละเอียดเรื่อง${complant_type.name_th}`"
            :before-change="beforeTabSwitch2"
          >
            <Tab2
              :item="item"
              :complant_type="complant_type"
              :accused="accused"
              :r="r"
              :errors="item_errors"
              :accused_errors="accused_item_errors"
              @increase-accused="onIncreaseAccused"
              @decrease-accused="onDecreaseAccused"
            />
          </tab-content>
          <tab-content title="ยืนยันข้อมูล">
            <!-- จะส่งรูปจาก Uppy ไปยังไง -->
            <Tab3
              v-if="tab_index == 1"
              :item="item"
              :complainant_item="complainant_item"
              :accused="accused"
              :complant_type="complant_type"
              @change-policy="
                (e) => {
                  policy_checkbox = e;
                }
              "
            />
          </tab-content>

          <template v-slot:footer="props">
            <div class="wizard-footer-left">
              <button
                v-if="props.activeTabIndex > 0"
                @click.native="props.prevTab()"
                class="btn text-white float-left"
                style="background-color: #800001"
              >
                ย้อนกลับ
              </button>
            </div>

            <div class="wizard-footer-right">
              <button
                v-if="!props.isLastStep"
                @click.native="props.nextTab()"
                class="btn text-white"
                style="background-color: #800001"
              >
                ถัดไป
              </button>

              <button
                v-else
                @click.native="onComplete"
                class="finish-button btn text-white"
                :class="[policy_checkbox == false ? 'disabled' : '']"
                style="background-color: #800001"
              >
                {{ props.isLastStep ? "ส่งข้อมูล" : "Next" }}
              </button>
            </div>
          </template>
        </form-wizard>
      </div>
    </div>
  </div>

  <div id="captcha">
    <Captcha
      :item="complainant_item"
      v-if="captcha_modal"
      :complaint_item="item"
      :change_phone_number="change_phone_number"
      :errors="complainant_item_errors"
      :first_action="first_action"
      @update-phone-number-data="
        (new_phone) => {
          complainant_item.phone_number = new_phone;
          change_phone_number = false;
          fetchComplainant();
        }
      "
      @close-captcha-modal="
        () => {
          captcha_modal = false;
        }
      "
    />
  </div>

  <div id="otp-before-confirm">
    <Otp
      :item="complainant_item"
      :complaint_item="item"
      :is_complainant_old="is_complainant_old"
      :accused="accused"
      :complant_type="complant_type"
      :r="r"
      v-if="otp_modal"
      @close-otp-modal="
        () => {
          otp_modal = false;
        }
      "
    />
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch, watchEffect } from "vue";
import ApiService from "@/core/services/ApiService";

// Import FormWizard
import { FormWizard, TabContent } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Use Toast Composables
import useToast from "@/composables/useToast";
// Import Yup Validate
import * as Yup from "yup";
// Import route
import { useRoute } from "vue-router";
// Use Address Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

// Import Component
import Tab1 from "@/components/appeal/Tab1.vue";
import Tab2 from "@/components/appeal/Tab2.vue";
import Tab3 from "@/components/appeal/Tab3.vue";
import Captcha from "@/components/appeal/Captcha.vue";
import Otp from "@/components/appeal/Otp.vue";

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
  name: "appeal",
  components: {
    FormWizard,
    TabContent,
    Tab1,
    Tab2,
    Tab3,
    Captcha,
    Otp,
  },
  setup() {
    // Variable
    const route = useRoute();

    const r = (Math.random() + 1).toString(36).substring(7);
    const complant_type = useComplaintTypeData().complaint_types.find(
      (x: any) => x.id == Number(route.query.type_id)
    );
    const policy_checkbox = ref<boolean>(false);

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
      complaint_channel_id: Yup.object().nullable(),
      complaint_topic: Yup.object()
        .required("${path} จำเป็นต้องระบุ")
        .label("ประเภทเรื่อง"),
      complaint_channel_all: Yup.array()
        .nullable()
        .label("เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด"),
    });
    const item = ref<any>({
      complaint_type_id: 1,
      is_anonymous: 1,
      complaint_title: "",
      house_number: "",
      building: "",
      moo: "",
      soi: "",
      road: "",
      address_all: null,
      incident_location: "",
      incident_date: null,
      incident_time: null,
      day_time: null,
      location_coordinates: "",
      complaint_detail: "",
      complaint_channel_id: {
        id: 8,
        name_th: "JCOM ร้องเรียน/แจ้งเบาะแส",
      },
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      topic_type_id: null,
      notice_type: null,
      complaint_topic: null,
      complaint_channel_all: [],
      //   state_id
    });

    const item_errors = ref<any>({
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
    });

    const validationAccusedSchema = Yup.object().shape({
      prefix_name_id: Yup.object().nullable().label("คำนำหน้า"),
      firstname: Yup.string().nullable().label("ชื่อ"),
      lastname: Yup.string().nullable().label("นามสกุล"),
      organization_all: Yup.object().nullable().label("หน่วยงาน"),
    });

  

    const accused = ref([
      {
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
      },
    ] as accused_itf[]);

    const accused_item_errors = ref<any>({
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
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
    const complainant_item = ref<any>({
      phone_number: "",
      card_type: null,
      id_card: "",
      prefix_name_id: null,
      firstname: "",
      lastname: "",
      birthday: "",
      occupation_text: "",
      house_number: "",
      building: "",
      moo: "",
      soi: "",
      road: "",
      address_all: null,
      card_photo: [],
      email: "",
      line_id: "",
      card_photo_old: null,
    });
    const complainant_item_errors = ref<any>({
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
    });
    const change_phone_number = ref<boolean>(false);

    const is_complainant_old = ref<boolean>(false);
    //Fetch
    const fetchComplainant = () => {
      const params = {
        phone_number: complainant_item.value.phone_number,
      };
      ApiService.query("complainant", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          if (data.data.length != 0) {
            complainant_item.value = {
              id: data.data[0].id,
              phone_number: data.data[0].phone_number,
              card_type:
                data.data[0].card_type != null
                  ? {
                      name:
                        data.data[0].card_type == 2
                          ? "หนังสือเดินทาง"
                          : "หมายเลขบัตรประชาชน",
                      value: data.data[0].card_type,
                    }
                  : "-",

              id_card: data.data[0].id_card,
              prefix_name_id:
                data.data[0].prefix_name_id != null
                  ? {
                      name_th: data.data[0].prefix_name.name_th,
                      id: data.data[0].prefix_name_id,
                    }
                  : null,
              firstname: data.data[0].firstname,
              lastname: data.data[0].lastname,
              birthday: data.data[0].birthday
                ? dayjs(data.data[0].birthday).format("YYYY-MM-DD")
                : null,
              occupation_text: data.data[0].occupation_text,
              house_number: data.data[0].house_number,
              building: data.data[0].building,
              moo: data.data[0].moo,
              soi: data.data[0].soi,
              road: data.data[0].road,
              address_all:
                data.data[0].sub_district_id != null
                  ? {
                      label:
                        data.data[0].sub_district.name_th +
                        " > " +
                        data.data[0].district.name_th +
                        " > " +
                        data.data[0].province.name_th +
                        " > " +
                        data.data[0].postal_code,
                      province_th: data.data[0].province.name_th,
                      district_th: data.data[0].district.name_th,
                      sub_district_th: data.data[0].sub_district.name_th,
                      post_code: data.data[0].postal_code,
                      sub_district_id: data.data[0].sub_district_id,
                      district_id: data.data[0].district_id,
                      province_id: data.data[0].province_id,
                    }
                  : null,
              province_id: data.data[0].province_id,
              district_id: data.data[0].district_id,
              sub_district_id: data.data[0].sub_district_id,
              postal_code: data.data[0].postal_code,
              card_photo_old: data.data[0].card_photo,
              email: data.data[0].email,
              line_id: data.data[0].line_id,
            };

            is_complainant_old.value = true;
          } else {
            is_complainant_old.value = false;
          }

          //   complainant_item.value
        })
        .catch(({ response }) => {
          is_complainant_old.value = false;
          console.log(response.data.errors);
        });
    };

    // Event
    const nextTodoId = ref(1);
    const onIncreaseAccused = () => {
      accused.value.push({
        id: null, //(nextTodoId.value += nextTodoId.value),
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
    const beforeTabSwitch = () => {
      return onTab1Validate();
    };
    const beforeTabSwitch2 = () => {
      return onTab2Validate();
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
    const onTab1Validate = async () => {
      complainant_item_errors.value = {
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

      //   ต้องเป็น 1
      if (item.value.is_anonymous == 1) {
        try {
          await validationComplainantSchema.validate(complainant_item.value, {
            abortEarly: false,
          });
        } catch (err: any) {
          err.inner.forEach((error: any) => {
            const fieldName = error.path;
            const errorMessage = error.message;
            complainant_item_errors.value[fieldName].error = 1;
            complainant_item_errors.value[fieldName].text = errorMessage;
          });

          if (
            complainant_item.value.card_photo == null &&
            complainant_item.value.card_photo_old == null
          ) {
            complainant_item_errors.value["card_photo"].error = 1;
            complainant_item_errors.value["card_photo"].text =
              "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          }

          useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
          return false;
        }

        if (
          complainant_item.value.card_photo == null &&
          complainant_item.value.card_photo_old == null
        ) {
          complainant_item_errors.value["card_photo"].error = 1;
          complainant_item_errors.value["card_photo"].text =
            "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          return false;
        }
        //     .required("${path} จำเป็นต้องระบุ")
        //     .label("รูปถ่ายตนเองพร้อมบัตร"),

        if (complainant_item.value.card_type.value == 1) {
          let check = validateThaiCitizenId(complainant_item.value.id_card);

          if (check == false) {
            complainant_item_errors.value["id_card"].error = 1;
            complainant_item_errors.value["id_card"].text =
              "หมายเลขบัตรประชาชนไม่ถูกต้อง";
            useToast("หมายเลขบัตรประชาชนไม่ถูกต้อง", "error");
            return false;
          }
        }
      } else {
        if (
          complainant_item.value.phone_number == "" ||
          complainant_item.value.phone_number == null
        ) {
          complainant_item_errors.value["phone_number"].error = 1;
          complainant_item_errors.value["phone_number"].text =
            "Phone number is required";
          useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
          return false;
        }
      }

      return true;
    };
    const onTab2Validate = async () => {
      item_errors.value = {
        complaint_type_id: { error: 0, text: "" },
        is_anonymous: { error: 0, text: "" },
        //
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

      accused_item_errors.value = {
        prefix_name_id: { error: 0, text: "" },
        firstname: { error: 0, text: "" },
        lastname: { error: 0, text: "" },
        organization_all: { error: 0, text: "" },
      };

      try {
        await validationItemSchema.validate(item.value, {
          abortEarly: false,
        });
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          item_errors.value[fieldName].error = 1;
          item_errors.value[fieldName].text = errorMessage;
        });
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      try {
        if (accused.value.length > 0) {
          await validationAccusedSchema.validate(accused.value[0], {
            abortEarly: false,
          });
          //   for (let index = 0; index < accused.value.length; index++) {
          //     const el = accused.value[index];
          //     await validationAccusedSchema.validate(el, {
          //       abortEarly: false,
          //     });
          //   }
        }
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          accused_item_errors.value[fieldName].error = 1;
          accused_item_errors.value[fieldName].text = errorMessage;
        });
        useToast("ข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      return true;
    };

    const tab_index = ref(0);
    const onTabChange = (currentIndex: number) => {
      tab_index.value = currentIndex;
    };

    const otp_modal = ref(false);
    const captcha_modal = ref(true);
    const first_action = ref(true);
    const onComplete = () => {
      otp_modal.value = true;
      return false;
    };

    // Mounted
    onMounted(() => {});

    // Watch

    // Return
    return {
      item,
      complainant_item,
      accused,
      item_errors,
      complainant_item_errors,
      accused_item_errors,
      change_phone_number,
      complant_type,
      r,
      tab_index,
      policy_checkbox,
      otp_modal,
      captcha_modal,
      first_action,
      is_complainant_old,

      onTab1Validate,
      onIncreaseAccused,
      onDecreaseAccused,
      beforeTabSwitch,
      beforeTabSwitch2,
      onTabChange,
      onComplete,
      fetchComplainant,
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
</style>
