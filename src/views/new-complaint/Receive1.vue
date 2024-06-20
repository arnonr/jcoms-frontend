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
            <h3 class="modal-title">ฝรท. รับเรื่อง ({{ item.jcoms_no }})</h3>
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
              <div class="mb-7 col-12 col-lg-12">
                <label for="" class="form-label required">ปรับสถานะ</label>
                <v-select
                  label="name"
                  name="id"
                  placeholder=""
                  :options="[
                    { value: 1, name: 'รับเรื่อง' },
                    { value: 0, name: 'ไม่รับเรื่อง' },
                  ]"
                  class="form-control"
                  :clearable="false"
                  v-model="item.type"
                >
                </v-select>
              </div>

              <div class="mb-7 col-12 col-lg-6">
                <label for="" class="form-label"
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

              <div class="mb-7 col-12 col-lg-12" v-if="item.type?.value == 0">
                <label for="" class="required">ระบุเหตุผล</label>
                <v-select
                  label="name"
                  name="id"
                  placeholder=""
                  :options="[
                    { value: 2, name: 'ข้อมูลไม่ครบถ้วน' },
                    { value: 3, name: 'เป็นการร้องทุกข์ กล่าวโทษคดีอาญา' },
                  ]"
                  class="form-control"
                  :clearable="false"
                  v-model="item.receive_status"
                >
                </v-select>
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
                <label for="formFile" class="form-label">แนบไฟล์ (ถ้ามี)</label>
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
                  ยืนยัน
                </button>
                <!-- <button class="btn btn-danger ms-2" @click="onValidate(0)">
                  ไม่รับเรื่อง
                </button> -->
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
import Preloader from "@/components/preloader/Preloader.vue";
// Import Component
import DetailPage from "@/views/new-complaint/Detail.vue";

export default defineComponent({
  name: "complaint-receive-1",
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
    const receiveDocFilename = ref<any>(null);
    const selectOptions = ref({
      receive_statuses: useBasicData().receive_statuses,
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const complaint_type = ref({});

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      type: Yup.object().required().label("ปรับสถานะ"),
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
      type: null,
    });
    // Item Errors
    const item_errors = reactive<any>({
      receive_doc_no: { error: 0, text: "" },
      receive_doc_date: { error: 0, text: "" },
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
        item.receive_doc_no = data.data.receive_doc_no;
        item.receive_doc_date = data.data.receive_doc_date;
        item.receive_comment = data.data.receive_comment;
        item.receive_status = null;
        // item.receive_status = data.data.receive_status ;
        item.state_id = data.data.state_id;
        item.receive_at = data.data.receive_at;
        item.jcoms_no = data.data.jcoms_no;
        item.complainant_id = data.data.complainant_id;
        item.receive_user_id = userData.receive_user_id;
        item.phone_number = data.data.complainant?.phone_number;
        complaint_type.value = useComplaintTypeData().complaint_types.find(
          (x: any) => x.id == item.complaint_type_id
        );

        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
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

      onSaveComplaint(type);

      //   item.receive_status = selectOptions.value.receive_statuses.find(
      //     (x: any) => {
      //       return x.value == result.value.selectValue;
      //     }
      //   );
      //   item.receive_comment = result.value.textValue;

      return true;
    };
    const onSaveComplaint = async (type: number) => {
      item.receive_status = selectOptions.value.receive_statuses[0];

      let data_item = {
        receive_doc_filename:
          item.receive_doc_filename.length != 0
            ? item.receive_doc_filename
            : undefined,
        receive_doc_no: item.receive_doc_no,
        receive_doc_date: dayjs(item.receive_doc_date).format("YYYY-MM-DD"),
        receive_comment: item.receive_comment,
        receive_status: item.type == 1 ? 1 : item.receive_status.value,
        state_id: item.receive_status.state_id,
        receive_at: dayjs().format("YYYY-MM-DD"),
        receive_user_id: userData.id,
      };

      await ApiService.putFormData("complaint/" + item.id, data_item)
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          //   SMS
          let msisdn = item.phone_number;
          if (msisdn != null) {
            let message =
              "แจ้งสถานะเรื่องร้องเรียน " +
              item.jcoms_no +
              " : ฝรท. ไม่รับเรื่อง ณ วันที่ " +
              dayjs().locale("th").format("DD MMM BBBB");

            if (item.receive_status.state_id == 3) {
              message =
                "แจ้งสถานะเรื่องร้องเรียน " +
                item.jcoms_no +
                " : ฝรท. ลงรับเรื่อง ณ วันที่ " +
                dayjs().locale("th").format("DD MMM BBBB");
            }
            await ApiService.post("sms/send-sms", {
              msisdn,
              message,
            })
              .then(() => {
                useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
                onClose({ reload: true });
              })
              .catch(({ response }) => {
                console.log(response);
              });
          }
        })
        .catch(({ response }) => {
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
      item,
      item_errors,
      complaint_type,
      format,
      receiveDocFilename,
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
  z-index: 9997 !important;
}

.swal2-custom-zindex {
  z-index: 9999 !important; /* ตั้งค่านี้ให้สูงกว่าค่า z-index ของ Bootstrap Modal */
}
</style>
