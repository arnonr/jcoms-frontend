<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">ฝรท. รับเรื่อง</h3>
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
                        <!-- <DetailComplaint /> -->
                        <hr />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="surname" class="form-label"
                  >เลขทะเบียนรับหนังสือ ฝรท.</label
                >
                <input
                  v-model="item.receive_doc_no"
                  type="text"
                  class="form-control"
                  placeholder=""
                  aria-label=""
                />
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="surname" class="form-label">วันที่รับหนังสือ</label>

                <VueDatePicker
                  v-model="item.receive_doc_date"
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
                <label for="">หมายเหตุ : </label>
                <input
                  v-model="item.receive_comment"
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
                  ref="receiveDocFilename"
                />
              </div>

              <div class="mt-12 col-12 col-lg-12 text-center">
                <button class="btn btn-success" @click="onValidate(1)">
                  รับเรื่อง
                </button>
                <button class="btn btn-danger ms-2" @click="onValidate(0)">
                  ไม่รับเรื่อง
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
// Import Component
import DetailComplaint from "./Detail.vue";

export default defineComponent({
  name: "receive-2",
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
    const receiveDocFilename = ref<any>(null);
    
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const mounted_success = ref<boolean>(false);

    const selectOptions = ref({
      receive_statuses: useBasicData().receive_statuses,
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
      receive_doc_no: Yup.string().nullable().label("ประเภทระบุตัวตน"),
      receive_doc_date: Yup.date().nullable().label("วันที่รับหนังสือ"),
    });

    // Item Variable
    const item = reactive<any>({
      id: null,
      receive_doc_no: null,
      receive_doc_date: null,
      receive_comment: "",
      receive_status: null,
      receive_doc_filename: [],
    });

    // Item Errors
    const item_errors = reactive<any>({
      receive_doc_no: { error: 0, text: "" },
      receive_doc_date: { error: 0, text: "" },
    });

    //Fetch

    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );
        item.id = data.data.id;
        item.receive_doc_no = data.data.receive_doc_no;
        item.receive_doc_date = data.data.receive_doc_date;
        item.receive_comment = data.data.receive_comment;
        item.receive_status = data.data.receive_status;
        item.state_id = data.data.state_id;
        item.receive_at = data.data.receive_at;
        item.receive_user_id = userData.receive_user_id;

        // Object.assign(item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    // Event
    const onFileChange = (event: any) => {
      item.receive_doc_filename = event.target.files[0];
    };

    const onValidate = async (type: number) => {
      Object.assign(item_errors, {
        receive_doc_no: { error: 0, text: "" },
        receive_doc_date: { error: 0, text: "" },
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

      if (type == 1) {
        // 1 == รับเรื่อง
        item.receive_status = selectOptions.value.receive_statuses[0];
        onSaveComplaint(type);
      } else {
        // type == 0 คือ ไม่รับเรื่อง
        Swal.fire({
          title: "โปรดระบุเหตุผล",
          input: "select",
          inputOptions: {
            2: "ข้อมูลไม่ครบถ้วน",
            3: "เป็นการร้องทุกข์ กล่าวโทษคดีอาญา",
          },
          inputPlaceholder: "เลือกเหตุผล",
          showCancelButton: true,
          confirmButtonText: "ยืนยัน",
          cancelButtonText: `ยกเลิก`,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-success",
            cancelButton: "btn fw-semibold btn-light-danger",
          },
        }).then(async (result: any) => {
          if (result.isConfirmed) {
            item.receive_status = selectOptions.value.receive_statuses.find(
              (x: any) => {
                return x.value == result.value;
              }
            );
            await onSaveComplaint(type);
          } else if (result.isDenied) {
          }
        });
      }

      return true;
    };

    const onSaveComplaint = async (type: number) => {
      let data_item = {
        receive_doc_filename:
          item.receive_doc_filename.length != 0
            ? item.receive_doc_filename
            : undefined,
        receive_doc_no: item.receive_doc_no,
        receive_doc_date: dayjs(item.receive_doc_date).format("YYYY-MM-DD"),
        receive_comment: item.receive_comment,
        receive_status: item.receive_status.value,
        state_id: item.receive_status.state_id,
        receive_at: dayjs().format("YYYY-MM-DD"),
        receive_user_id: userData.id,
      };

      await ApiService.putFormData("complaint/" + item.id, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
          onClose();
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
      //   errors
      item_errors,
      complaint_type,
      // event
      onValidate,
      onClose,
      onFileChange,
      mainModalRef,
      mounted_success,
      format,
      receiveDocFilename,
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
