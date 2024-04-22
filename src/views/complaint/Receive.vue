<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">แก้ไขข้อมูล</h3>
          <button
            @click="onClose"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form-wizard
            color="#800001"
            ref="formStep"
            finishButtonText="บันทึก"
            backButtonText="ย้อนกลับ"
            nextButtonText="ถัดไป"
            step-size="xs"
            id="form"
            @on-change="onTabChange"
            @on-complete="onComplete"
          >
            <tab-content
              :title="`ข้อมูลผู้${complaint_type.name_th}`"
              :before-change="onTab1Validate"
            >
              <Tab1
                v-if="mounted_success == true"
                :complaint_item="item"
                :complainant_item="complainant_item"
                :complaint_type="complaint_type"
                :errors="complainant_item_errors"
              />
            </tab-content>
            <tab-content
              :title="`รายละเอียดเรื่อง${complaint_type.name_th}`"
              :before-change="onTab2Validate"
            >
              <Tab2
                v-if="mounted_success == true"
                :complaint_type="complaint_type"
                :complaint_item="item"
                :accused="accused"
                :errors="item_errors"
                :accused_errors="accused_item_errors"
                @increase-accused="onIncreaseAccused"
                @decrease-accused="onDecreaseAccused"
              />
            </tab-content>

            <tab-content title="รับเรื่อง">
              <Tab3
                v-if="tab_index == 1 && mounted_success == true"
                :complaint_item="item"
                :complainant_item="complainant_item"
                :accused="accused"
                :complaint_type="complaint_type"
              />
            </tab-content>

            <template #footer="props">
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
                  style="background-color: #800001"
                >
                  {{ props.isLastStep ? "บันทึก" : "Next" }}
                </button>
              </div>
            </template>
          </form-wizard>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
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
import customParseFormat from "dayjs/plugin/customParseFormat";
dayjs.extend(buddhistEra);
dayjs.extend(customParseFormat);

// Import Component
import Tab1 from "@/components/complaint/receive/Tab1.vue";
import Tab2 from "@/components/complaint/receive/Tab2.vue";
import Tab3 from "@/components/complaint/receive/Tab3.vue";

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
  name: "receive-1",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
    complainant_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    FormWizard,
    TabContent,
    Tab1,
    Tab2,
    Tab3,
  },
  setup(props, context) {
    // Variable
    const route = useRoute();
    const emit = context.emit;

    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const mounted_success = ref<boolean>(false);

    const complaint_type = useComplaintTypeData().complaint_types.find(
      (x: any) => x.id == 1 //Number(route.query.type_id)
    );

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

    // Item Variable
    const item = reactive<any>({
      complaint_type_id: 1,
      is_anonymous: null,
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
    const complainant_item = reactive<any>({
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
    const accused = reactive([
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

    const accused_old = reactive([
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

    // Item Errors
    const item_errors = reactive<any>({
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
    const accused_item_errors = reactive<any>({
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
    });
    const complainant_item_errors = reactive<any>({
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
    const is_complainant_old = ref<boolean>(false);

    //Fetch
    const fetchComplainant = async () => {
      try {
        const params = { id: props.complainant_id };
        const { data } = await ApiService.query("complainant", { params });

        if (data.data.length > 0) {
          Object.assign(complainant_item, {
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
                      data.data[0].sub_district?.name_th +
                      " > " +
                      data.data[0].district?.name_th +
                      " > " +
                      data.data[0].province?.name_th +
                      " > " +
                      data.data[0].postal_code,
                    province_th: data.data[0].province?.name_th,
                    district_th: data.data[0].district?.name_th,
                    sub_district_th: data.data[0].sub_district?.name_th,
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
          });
          is_complainant_old.value = true;
        } else {
          is_complainant_old.value = false;
        }

        fetchComplaint();
      } catch (error) {
        is_complainant_old.value = false;
        console.log(error);
      }
    };

    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );
        Object.assign(item, data.data);
        Object.assign(accused, data.data.accused);
        Object.assign(accused_old, data.data.accused);
      } catch (error) {
        console.log(error);
      }
    };

    // Event
    const onIncreaseAccused = () => {
      accused.push({
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
      accused.splice(index, 1);
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
      Object.assign(complainant_item_errors, {
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

      //   ต้องเป็น 1
      if (item.is_anonymous == 1) {
        try {
          await validationComplainantSchema.validate(complainant_item, {
            abortEarly: false,
          });
        } catch (err: any) {
          err.inner.forEach((error: any) => {
            const fieldName = error.path;
            const errorMessage = error.message;
            complainant_item_errors[fieldName].error = 1;
            complainant_item_errors[fieldName].text = errorMessage;
          });

          if (
            complainant_item.card_photo == null &&
            complainant_item.card_photo_old == null
          ) {
            complainant_item_errors["card_photo"].error = 1;
            complainant_item_errors["card_photo"].text =
              "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          }

          useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
          return false;
        }

        if (
          complainant_item.card_photo == null &&
          complainant_item.card_photo_old == null
        ) {
          complainant_item_errors["card_photo"].error = 1;
          complainant_item_errors["card_photo"].text =
            "รูปถ่ายตนเองพร้อมบัตร จำเป็นต้องระบุ";
          return false;
        }
        //     .required("${path} จำเป็นต้องระบุ")
        //     .label("รูปถ่ายตนเองพร้อมบัตร"),

        if (complainant_item.card_type.value == 1) {
          let check = validateThaiCitizenId(complainant_item.id_card);

          if (check == false) {
            complainant_item_errors["id_card"].error = 1;
            complainant_item_errors["id_card"].text =
              "หมายเลขบัตรประชาชนไม่ถูกต้อง";
            useToast("หมายเลขบัตรประชาชนไม่ถูกต้อง", "error");
            return false;
          }
        }
      } else {
        if (
          complainant_item.phone_number == "" ||
          complainant_item.phone_number == null
        ) {
          complainant_item_errors["phone_number"].error = 1;
          complainant_item_errors["phone_number"].text =
            "Phone number is required";
          useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
          return false;
        }
      }

      return true;
    };
    const onTab2Validate = async () => {
      Object.assign(item_errors, {
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

      Object.assign(accused_item_errors, {
        prefix_name_id: { error: 0, text: "" },
        firstname: { error: 0, text: "" },
        lastname: { error: 0, text: "" },
        organization_all: { error: 0, text: "" },
      });

      try {
        await validationItemSchema.validate(item, {
          abortEarly: false,
        });
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          item_errors[fieldName].error = 1;
          item_errors[fieldName].text = errorMessage;
        });
        console.log(item_errors);
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      try {
        if (accused.length > 0) {
          await validationAccusedSchema.validate(accused[0], {
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
          accused_item_errors[fieldName].error = 1;
          accused_item_errors[fieldName].text = errorMessage;
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

    const onSaveComplainant = async () => {
      //
      let data_complainant_item = {
        card_photo:
          complainant_item.card_photo.length != 0
            ? complainant_item.card_photo
            : undefined,
        card_type: complainant_item.card_type
          ? complainant_item.card_type?.value
          : undefined,
        id_card: complainant_item.id_card,
        prefix_name_id: complainant_item.prefix_name_id
          ? complainant_item.prefix_name_id?.id
          : undefined,
        firstname: complainant_item.firstname,
        lastname: complainant_item.lastname,
        birthday: complainant_item.birthday
          ? dayjs(complainant_item.birthday).format("YYYY-MM-DD")
          : undefined,
        occupation_id: undefined,
        occupation_text: complainant_item.occupation_text,
        phone_number: complainant_item.phone_number,
        email: complainant_item.email,
        line_id: complainant_item.line_id,
        house_number: complainant_item.house_number,
        building: complainant_item.building,
        moo: complainant_item.moo,
        soi: complainant_item.soi,
        road: complainant_item.road,
        postal_code: complainant_item.postal_code,
        sub_district_id: complainant_item.sub_district_id,
        district_id: complainant_item.district_id,
        province_id: complainant_item.province_id,
        id: complainant_item.id,
        complainant_type: item.id == 4 ? 2 : 1,
        position_id: complaint_type.id == 4 ? null : null,
        section_id: complaint_type.id == 4 ? null : null,
        inspection_id: complaint_type.id == 4 ? null : null,
        bureau_id: complaint_type.id == 4 ? null : null,
        division_id: complaint_type.id == 4 ? null : null,
        agency_id: complaint_type.id == 4 ? null : null,
        // updated_by: item.firstname + " " + props.item.lastname,
      };

      await ApiService.putFormData(
        "complainant/" + complainant_item.id,
        data_complainant_item
      )
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onSaveComplaint = async () => {
      let d1 = <any>null;
      if (item.incident_date) {
        if (item.incident_time) {
          d1 = dayjs(item.incident_date)
            .set("hour", item.incident_time.hours)
            .set("minute", item.incident_time.minutes)
            .format("YYYY-MM-DDTHH:mm:ss.SSS[Z]");
        }
      }

      let data_item = {
        complaint_type_id: item.complaint_topic.complaint_type_id,
        complainant_id: complainant_item.complainant_id,
        is_anonymous: item.is_anonymous,
        complaint_title: item.complaint_title,
        complaint_detail: item.complaint_detail,
        complaint_channel_ids: item.complaint_channel_all,
        incident_date: item.incident_date
          ? dayjs(item.incident_date).format("YYYY-MM-DD")
          : null,
        incident_datetime: d1,
        location_coordinates: item.location_coordinates,
        incident_location: item.incident_location,
        day_time: item.day_time.value,
        complaint_channel_id: item.complaint_channel_id.id,
        inspector_id: item.inspector_id,
        bureau_id: item.bureau_id,
        division_id: item.division_id,
        agency_id: item.agency_id,
        topic_type_id: item.complaint_topic.topic_type_id,
        topic_category_id: item.complaint_topic.topic_category_id,
        house_number: "",
        building: "",
        moo: "",
        soi: "",
        road: "",
        postal_code: item.postal_code,
        sub_district_id: item.sub_district_id,
        district_id: item.district_id,
        province_id: item.province_id,
        // updated_by: item.firstname + " " + item.lastname,
      };

      await ApiService.putFormData("complaint/" + item.id, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onSaveAccused = async () => {
      for (let i = 0; i < accused.length; i++) {
        let data_accused_item = {
          id: accused[i].id,
          prefix_name_id: accused[i].prefix_name_id
            ? accused[i].prefix_name_id.id
            : null,
          firstname: accused[i].firstname,
          lastname: accused[i].lastname,

          position_id: accused[i].position_id,
          section_id: accused[i].section_id,

          inspector_id: accused[i].inspector_id,
          bureau_id: accused[i].bureau_id,
          division_id: accused[i].division_id,
          agency_id: accused[i].agency_id,
          complaint_id: item.id,
          type: 2,
          detail: "",
        };

        let api = {
          type: "post",
          url: "accused/",
        };

        if (data_accused_item.id != null) {
          api.type = "put";
          api.url = "accused/" + data_accused_item.id;
        }

        await ApiService[api.type](api.url, data_accused_item)
          .then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
          });
      }

      //   accused_old
      for (let i = 0; i < accused_old.length; i++) {
        let check = accused.find((x: any) => {
          return x.id == accused_old[i].id;
        });

        if (!check) {
          await ApiService.delete("accused/" + accused_old[i].id)
            .then(({ data }) => {
              if (data.msg != "success") {
                throw new Error("ERROR");
              }
            })
            .catch(({ response }) => {
              console.log(response);
            });
        }
      }
    };

    const onComplete = async () => {
      //   console.log(item);
      //   console.log(complainant_item);
      //   console.log(accused);
      await onSaveComplainant();
      await onSaveComplaint();
      await onSaveAccused();
      useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
      onClose();
    };

    const onClose = () => {
      mainModalObj.value.hide();
      emit("reload");
      emit("close-modal");
    };

    onMounted(async () => {
      try {
        mainModalObj.value = new Modal(mainModalRef.value, {});
        mainModalObj.value.show();
        await fetchComplainant();
        await fetchComplaint();
        mounted_success.value = true;
      } catch (error) {
        console.error("Error:", error);
      }
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Watch

    // Return
    return {
      // items
      item,
      complainant_item,
      accused,
      //   errors
      item_errors,
      complainant_item_errors,
      accused_item_errors,
      is_complainant_old,

      complaint_type,
      tab_index,
      // event
      onTab1Validate,
      onTab2Validate,
      onIncreaseAccused,
      onDecreaseAccused,
      onTabChange,
      onComplete,
      onClose,
      mainModalRef,
      mounted_success,
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
