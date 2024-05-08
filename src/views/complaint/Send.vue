<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">ส่งต่อเรื่อง ({{ header }})</h3>
          <button
            @click="onClose"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <div class="container">
            <div class="row">
              <div class="mb-7 col-12 col-lg-12 text-end">
                <button
                  class="btn btn-primary"
                  type="button"
                  data-bs-toggle="collapse"
                  data-bs-target="#flush-collapseOne"
                  aria-expanded="false"
                  aria-controls="flush-collapseOne"
                >
                  ดูข้อมูลเรื่องร้องเรียน
                </button>
              </div>
              <div class="mb-7 col-12 col-lg-12">
                <div
                  class="accordion accordion-flush"
                  id="accordionFlushExample"
                >
                  <div class="accordion-item">
                    <div
                      id="flush-collapseOne"
                      class="accordion-collapse collapse"
                      aria-labelledby="flush-headingOne"
                      data-bs-parent="#accordionFlushExample"
                    >
                      <div class="accordion-body" style="padding: 0">
                        <DetailComplaint :complaint_id="complaint_id" />
                        <hr />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="mb-7 col-12 col-lg-12">
                <label for="organization_all" class="form-label"
                  >หน่วยงาน</label
                >
                <v-select
                  name="accused_organization_all"
                  placeholder="หน่วยงาน/Organization"
                  :options="selectOptions.organizations"
                  class="form-control"
                  :clearable="false"
                  v-model="item.organization_all"
                >
                </v-select>
                <div
                  class="d-block mt-1"
                  v-if="item_errors.organization_all.error == 1"
                >
                  <span role="alert" class="text-danger">{{
                    item_errors.organization_all.text
                  }}</span>
                </div>
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="send" class="form-label"
                  >เลขทะเบียนหนังสือส่ง</label
                >
                <input
                  type="text"
                  v-model="item.forward_doc_no"
                  class="form-control"
                  placeholder=""
                  aria-label=""
                />
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="surname" class="form-label">วันที่หนังสือ</label>

                <VueDatePicker
                  v-model="item.forward_doc_date"
                  :max-date="new Date()"
                  :enable-time-picker="false"
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
              </div>

              <div class="mb-7 col-12 col-lg-12">
                <label for="">ข้อสั่งการ : </label>
                <v-select
                  v-model="item.order_id"
                  id="slt-search-order-id-2"
                  name="slt-search-order-2"
                  :options="selectOptions.orders"
                  label="name"
                  placeholder="ข้อสั่งการ"
                  class="form-control"
                  :clearable="true"
                ></v-select>
              </div>

              <div class="mb-7 col-12 col-lg-12">
                <label for="">หมายเหตุ : </label>
                <input
                  v-model="item.order_detail"
                  type="text"
                  class="form-control"
                  placeholder="หมายเหตุ"
                  aria-label="หมายเหตุ"
                  aria-describedby="basic-addon2"
                />
              </div>

              <div class="mb-7 col-12 col-lg-12">
                <label for="formFile" class="form-label">แนบไฟล์</label>
                <input
                  class="form-control"
                  type="file"
                  id="formFile"
                  @change="onFileChange"
                  ref="forwardDocFilename"
                />
              </div>

              <div class="mt-12 col-12 col-lg-12 text-center">
                <button class="btn btn-success" @click="onValidate()">
                  ส่งต่อ
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
import ApiService from "@/core/services/ApiService";

// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Use Toast Composables
import useToast from "@/composables/useToast";
// Import Yup Validate
import * as Yup from "yup";
// Vue Select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Vue Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import router
import { useRouter } from "vue-router";
// Use Address Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";
// SweetAleart
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import customParseFormat from "dayjs/plugin/customParseFormat";
dayjs.extend(buddhistEra);
dayjs.extend(customParseFormat);

import useBasicData from "@/composables/useBasicData";
import useOrganizationData from "@/composables/useOrganizationData";
// Import Component
import DetailComplaint from "./Detail.vue";

export default defineComponent({
  name: "send-complaint",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    DetailComplaint,
  },
  setup(props, context) {
    // Variable
    const router = useRouter();
    const emit = context.emit;
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const forwardDocFilename = ref<any>(null);

    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const mounted_success = ref<boolean>(false);
    const header = ref("");

    const selectOptions = ref({
      organizations: useOrganizationData().organization_mapping(),
      orders: useBasicData().orders,
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const complaint_type = useComplaintTypeData().complaint_types.find(
      (x: any) => x.id == 1 //Number(route.query.type_id)
    );

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      forward_doc_no: Yup.string().nullable().label(""),
      forward_doc_date: Yup.date().nullable().label("วันที่รับหนังสือ"),
    });

    // Item Variable
    const item = reactive<any>({
      id: null,
      complaint_id: props.complaint_id,
      forward_doc_no: null,
      forward_doc_date: null,
      forward_doc_filename: [],
      forward_user_id: null,
      forward_at: dayjs().format("YYYY-MM-DD"),
      from_inspector_id: 1,
      organization_all: null,

      order_id: null,
      order_detail: "",

      receive_status: null, //1 รับ 2 ไม่รับ
      state_id: null, //
      //   receive_doc_filename: [],
    });

    // Item Errors
    const item_errors = reactive<any>({
      forward_doc_no: { error: 0, text: "" },
      forward_doc_date: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
    });

    //Fetch

    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );
        item.complaint_id = data.data.id;
        item.state_id = data.data.state_id;

        if (item.state_id == 3) {
          header.value = "ฝรท.บก.อก.จต. ส่งถึง หน่วย บช./ภ. ดำเนินการ";
          // ฝรท. ส่งต่อได้ หน่วยงานให้เลือกต้องเป็น ภ. หรือ กต.
        } else if (item.state_id == 19) {
          header.value = "หน่วย บช./ภ. ส่งถึง หน่วย ภ.จว./บก. ดำเนินการ";
          // ภ. ส่งต่อได้ หน่วยงานให้เลือกต้องเป็น จ.
        } else if (item.state_id == 20) {
          header.value = "หน่วย ภ.จว./บก. ส่งถึง กก./สถานี ดำเนินการ";
          // จ. ส่งต่อได้  หน่วยงานให้เลือกต้องเป็น agency
        } else {
          // disabled
        }

        // Object.assign(item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    // Event

    const onFileChange = (event: any) => {
      item.forward_doc_filename = event.target.files[0];
    };

    const onValidate = async () => {
      Object.assign(item_errors, {
        forward_doc_no: { error: 0, text: "" },
        forward_doc_date: { error: 0, text: "" },
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

      onSaveComplaint();
    };

    const onSaveComplaint = async () => {
      let state_id = 0;
      if (item.state_id == 3) {
        state_id = 10;
      } else if (item.state_id == 19) {
        state_id = 11;
      } else if (item.state_id == 20) {
        state_id = 12;
      } else {
      }

      let data_item = {
        forward_doc_filename:
          item.forward_doc_filename.length != 0
            ? item.forward_doc_filename
            : undefined,
        complaint_id: item.complaint_id,
        forward_doc_no: item.forward_doc_no,
        forward_doc_date: dayjs(item.forward_doc_date).format("YYYY-MM-DD"),
        forward_user_id: userData.id,
        forward_at: dayjs().format("YYYY-MM-DD"),
        to_bureau_id: item.organization_all?.bureau_id,
        to_division_id: item.organization_all?.division_id,
        to_agency_id: item.organization_all?.agency_id,
        order_id: item.order_id?.value,
        order_detail: item.order_detail,
        state_id: state_id,
        is_active: 1,
      };

      await ApiService.postFormData("complaint-forward/", data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          ApiService.postFormData("complaint/" + item.complaint_id, {
            state_id: state_id,
          }).then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }

            useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
            onClose();
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
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
      onFileChange,
      //   errors
      item_errors,
      complaint_type,
      // event
      onValidate,
      onClose,
      mainModalRef,
      mounted_success,
      format,
      selectOptions,
      header,
      forwardDocFilename,
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
