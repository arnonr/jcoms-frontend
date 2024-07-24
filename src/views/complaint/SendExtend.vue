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
            <h3 class="modal-title">ขอขยายเวลา ({{ item.jcoms_no }})</h3>
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
                          :complaint_id="item.id"
                          :complainant_id="item.complainant_id"
                        />
                        <hr />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-12">
                <div class="row">
                  <div class="mb-7 col-12 col-lg-12">
                    <label for="organization_all" class="form-label"
                      >หน่วยงานระดับ กองตรวจราชการ</label
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
                      v-model="item.extend_doc_no"
                      class="form-control"
                      placeholder=""
                      aria-label=""
                    />
                  </div>

                  <div class="mb-7 col-12 col-lg-6">
                    <label for="surname" class="form-label"
                      >วันที่หนังสือ</label
                    >

                    <VueDatePicker
                      v-model="item.extend_doc_date"
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

                  <div class="mb-7 col-4 col-lg-4">
                    <label for="">ครั้งที่ : </label>
                    <input
                      v-model="item.time_no"
                      type="text"
                      class="form-control"
                      placeholder="ครั้งที่"
                      aria-label="ครั้งที่"
                      aria-describedby="basic-addon2"
                      :disabled="true"
                    />
                  </div>

                  <div class="mb-7 col-4 col-lg-4">
                    <label for="">วันที่สิ้นสุดขอขยายเวลา : </label>
                    <input
                      :value="item.show_due_date"
                      type="text"
                      class="form-control"
                      placeholder="วันที่สิ้นสุด"
                      aria-label="วันที่สิ้นสุด"
                      aria-describedby="basic-addon2"
                      :disabled="true"
                    />
                  </div>

                  <div class="mb-7 col-4 col-lg-4">
                    <label for="">จำนวนวันขอขยายเวลา : </label>
                    <input
                      v-model="item.extend_day"
                      type="text"
                      class="form-control"
                      placeholder="จำนวนวัน"
                      aria-label="จำนวนวัน"
                      aria-describedby="basic-addon2"
                      :disabled="true"
                    />
                  </div>

                  <div class="mb-7 col-12 col-lg-12">
                    <label for="">หมายเหตุ : </label>
                    <input
                      v-model="item.extend_comment"
                      type="text"
                      class="form-control"
                      placeholder="หมายเหตุ"
                      aria-label="หมายเหตุ"
                      aria-describedby="basic-addon2"
                    />
                  </div>

                  <div class="mb-7 col-12 col-lg-12">
                    <label for="formFile" class="form-label"
                      >แนบไฟล์ (ถ้ามี)</label
                    >
                    <input
                      class="form-control"
                      type="file"
                      id="formFile"
                      @change="onFileChange"
                      ref="extendDocFilename"
                    />
                  </div>
                </div>
              </div>

              <div class="mt-12 col-12 col-lg-12 text-center">
                <button class="btn btn-success" @click="onValidate">
                  ขอขยายเวลา
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
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);

import useBasicData from "@/composables/useBasicData";
import useOrganizationData from "@/composables/useOrganizationData";
import useComplaintTypeData from "@/composables/useComplaintTypeData";
// Import Component
import DetailPage from "@/views/new-complaint/Detail.vue";
import Preloader from "@/components/preloader/Preloader.vue";

export default defineComponent({
  name: "send-complaint-1",
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
    const isLoading = ref<any>(true);
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    // Variable
    const extendDocFilename = ref<any>(null);
    const selectOptions = ref({
      organizations: useOrganizationData().organization_mapping("inspector"),
      orders: useBasicData().orders,
      complaint_types: useComplaintTypeData().complaint_types,
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      extend_doc_no: Yup.string().nullable().label(""),
      extend_doc_date: Yup.date().nullable().label("วันที่ส่งหนังสือ"),
    });

    // Item Variable
    const item = reactive<any>({});

    const item_extend = reactive<any>([]);

    // Item Errors
    const item_errors = reactive<any>({
      extend_doc_no: { error: 0, text: "" },
      extend_doc_date: { error: 0, text: "" },
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

        item.id = data.data.id;
        item.complaint_id = data.data.id;
        item.complainant_id = data.data.complainant_id;
        item.jcoms_no = data.data.jcoms_no;
        item.state_id = data.data.state_id;
        item.due_date = data.data.due_date;
        item.due_day = data.data.due_day;
        item.complaint_type_id = data.data.complaint_type_id;
        item.bureau_id = data.data.bureau_id;
        item.time_no = 1;
        item.show_due_date = dayjs(data.data.due_date)
          .utc()
          .locale("th")
          .format("DD MMM BBBB");

        let check_ct = selectOptions.value.complaint_types.find((x: any) => {
          console.log(item);
          return x.id == item.complaint_type_id;
        });
        console.log(check_ct);

        item.extend_day = check_ct.extend_date;
        item.due_date = dayjs(data.data.due_date).add(
          check_ct.extend_date,
          "day"
        );

        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        console.log(error);
      }
    };

    const fetchComplaintExtend = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        Object.assign(item_extend, data.data);

        if (item_extend.length != 0) {
          item.time_no = item_extend.length + 1;
        }

        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        console.log(error);
      }
    };

    // Event
    const onFileChange = (event: any) => {
      item.extend_doc_filename = event.target.files[0];
    };
    const onValidate = async () => {
      isLoading.value = true;
      Object.assign(item_errors, {
        extend_doc_no: { error: 0, text: "" },
        extend_doc_date: { error: 0, text: "" },
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
      let inspector_state_id = 6;

      let data_item = {
        complaint_id: item.complaint_id,
        inspector_id: item.organization_all?.inspector_id,
        extend_comment: item.extend_comment,
        extend_doc_filename:
          item.extend_doc_filename.length != 0
            ? item.extend_doc_filename
            : undefined,
        extend_doc_no: item.extend_doc_no,
        extend_doc_date: dayjs(item.extend_doc_date).format("YYYY-MM-DD"),
        extend_user_id: userData.id,
        bureau_id: item.bureau_id,
        time_no: item.time_no,
        extend_day: item.extend_day,
        due_date: dayjs(item.due_date).format("YYYY-MM-DD"),
        status: 1,
        is_active: 1,
      };

      await ApiService.postFormData("complaint-extend/", data_item)
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          //   ปรับสถานะ
          await ApiService.postFormData("complaint/" + item.complaint_id, {
            inspector_state_id: inspector_state_id,
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
        await fetchComplaintExtend();

        mainModalObj.value = new Modal(mainModalRef.value, {});
        mainModalObj.value.show();
        mainModalRef.value.addEventListener("hidden.bs.modal", () =>
          onClose({ reload: false })
        );
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
      extendDocFilename,
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
