<template>
  <div>
    <div
      class="modal fade"
      tabindex="-1"
      ref="mainModalRef"
      id="main-modal"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
          <div class="modal-header" v-if="item.id != null">
            <h3 class="modal-title">จต. ส่งกลับรายงาน ({{ item.jcoms_no }})</h3>
            <button
              @click="onClose({ reload: false })"
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>

          <div class="modal-body" v-if="item.id != null">
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
                        <DetailPage
                          v-if="item.id"
                          :complaint_id="item.complaint_id"
                          :complainant_id="item.complainant_id"
                        />
                        <hr />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="send" class="form-label"
                  >เลขทะเบียนหนังสือส่ง</label
                >
                <input
                  type="text"
                  v-model="item.return_doc_no"
                  class="form-control"
                  placeholder=""
                  aria-label=""
                />
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="surname" class="form-label">วันที่หนังสือ</label>

                <VueDatePicker
                  v-model="item.return_doc_date"
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
                <label for="return_detail">รายละเอียด : </label>
                <input
                  v-model="item.return_detail"
                  type="text"
                  class="form-control"
                  placeholder="รายละเอียด"
                  aria-label="รายละเอียด"
                  aria-describedby="basic-addon2"
                />
              </div>

              <div class="mb-7 col-12 col-lg-12">
                <label for="formFile" class="form-label">แนบไฟล์ (ถ้ามี)</label>
                <input
                  class="form-control"
                  type="file"
                  id="formFile"
                  @change="onFileChange"
                  ref="returnDocFilename"
                />
              </div>

              <div class="mt-12 col-12 col-lg-12 text-center">
                <button class="btn btn-success" @click="onValidate">
                  ส่งกลับรายงานผล
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <Preloader :isLoading="isLoading" :position="'absolute'" />
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
import DetailPage from "@/views/new-complaint/Detail.vue";
import Preloader from "@/components/preloader/Preloader.vue";

export default defineComponent({
  name: "return-report2-complaint",
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
    Preloader,
    DetailPage,
  },
  setup(props, { emit }) {
    // UI Variable
    const isLoading = ref<any>(false);
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    // Variable
    const returnDocFilename = ref<any>(null);
    const selectOptions = ref({
      organizations: useOrganizationData().organization_mapping("bureau"),
      orders: useBasicData().orders,
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      return_doc_no: Yup.string().nullable().label(""),
      return_doc_date: Yup.date().nullable().label("วันที่ส่งหนังสือ"),
    });

    // Item Variable
    const item = reactive<any>({
      id: null,
      complaint_id: props.complaint_id,
      return_doc_no: null,
      return_doc_date: null,
      return_doc_filename: [],
      return_user_id: null,
      return_at: dayjs().format("YYYY-MM-DD"),
      organization_all: null,
      return_detail: null,
      status: null,
      state_id: null, //
    });
    // Item Errors
    const item_errors = reactive<any>({
      return_doc_no: { error: 0, text: "" },
      return_doc_date: { error: 0, text: "" },
      organization_all: { error: 0, text: "" },
    });

    //Fetch
    const fetchComplaint = async () => {
      try {
        isLoading.value = true;
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        item.complaint_id = data.data.id;
        item.complainant_id = data.data.complainant_id;
        item.jcoms_no = data.data.jcoms_no;
        item.state_id = data.data.state_id;
      } catch (error) {
        isLoading.value = false;
        console.log(error);
      }
    };

    const fetchComplaintReport = async () => {
      try {
        const { data } = await ApiService.query("complaint-report/", {
          params: { complaint_id: props.complaint_id, state_id: 16 },
        });
        item.id = data.data[0].id;
        item.return_doc_no = data.data[0].return_doc_no;
        item.return_doc_date = data.data[0].return_doc_date;
        item.return_detail = data.data[0].return_detail;

        console.log(item);
      } catch (error) {
        console.log(error);
      }
    };

    // Event
    const onFileChange = (event: any) => {
      item.return_doc_filename = event.target.files[0];
    };
    const onValidate = async () => {
      isLoading.value = true;
      Object.assign(item_errors, {
        return_doc_no: { error: 0, text: "" },
        return_doc_date: { error: 0, text: "" },
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
          isLoading.value = false;
        });

        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      onSaveComplaint();
    };
    const onSaveComplaint = async () => {
      //
      let state_id = 30;

      let data_item = {
        return_doc_filename:
          item.return_doc_filename.length != 0
            ? item.return_doc_filename
            : undefined,
        id: item.id,
        complaint_id: item.complaint_id,
        return_doc_no: item.return_doc_no,
        return_doc_date: dayjs(item.return_doc_date).format("YYYY-MM-DD"),
        return_user_id: userData.id,
        return_detail: item.return_detail,
        return_at: dayjs().format("YYYY-MM-DD"),
        status: 3,
        is_active: 1,
      };

      await ApiService.putFormData("complaint-report/" + item.id, data_item)
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          //   ปรับสถานะ
          await ApiService.postFormData("complaint/" + item.complaint_id, {
            state_id: state_id,
          }).then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }

            isLoading.value = true;
            useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
            onClose({ reload: true });
          });
        })
        .catch(({ response }) => {
          isLoading.value = false;
          console.log(response);
        });
    };

    const onClose = ({ reload = false }: { reload?: boolean }) => {
      mainModalObj.value.hide();
      if (reload === true) {
        emit("reload");
      }
      emit("close-modal");
    };

    onMounted(async () => {
      try {
        await fetchComplaint();
        await fetchComplaintReport();
        mainModalObj.value = new Modal(mainModalRef.value, {});
        mainModalObj.value.show();
        mainModalRef.value.addEventListener("hidden.bs.modal", () =>
          onClose({ reload: false })
        );
        isLoading.value = false;
      } catch (error) {
        console.error("Error:", error);
      }
    });

    onUnmounted(() => {
      if (mainModalRef.value) {
        mainModalRef.value.addEventListener("hidden.bs.modal", () =>
          onClose({ reload: false })
        );
      }
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Watch

    // Return
    return {
      isLoading,
      selectOptions,
      item,
      item_errors,
      format,
      returnDocFilename,
      // event
      onValidate,
      onFileChange,
      onClose,
      mainModalRef,
    };
  },
});
</script>

<style scoped>
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}
.modal-content {
  background-color: #d9f4fe;
}

.form-control {
  border-color: #800001;
  border-width: 0.1em;
}
</style>

<style>
.pac-container {
  z-index: 9999 !important;
}
</style>
