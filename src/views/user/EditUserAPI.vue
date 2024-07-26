<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">แก้ไขผู้ใช้งาน API</h3>
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
                      :options="[
                        { id: 1, name: 'เปิดใช้งาน' },
                        { id: 0, name: 'ปิดใช้งาน' },
                      ]"
                      class="form-control form-control-lg"
                      :clearable="false"
                      v-model="item.is_active"
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
                    <label for="firstname" class="required form-label"
                      >ชื่อ-นามสกุล</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="ชื่อ-นามสกุล"
                      aria-label="ชื่อ-นามสกุล/name"
                      v-model="item.name"
                    />
                    <div class="d-block mt-1" v-if="errors.name.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.name.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label for="agency" class="required form-label"
                      >หน่วยงาน</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="หน่วยงาน"
                      aria-label="หน่วยงาน/agency"
                      v-model="item.agency"
                    />
                    <div class="d-block mt-1" v-if="errors.agency.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.agency.text
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
                      v-model="item.tel"
                    />
                    <div class="d-block mt-1" v-if="errors.tel.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.tel.text
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

export default defineComponent({
  name: "edit-user",

  components: {
    vSelect,
    VueDatePicker,
    dayjs,
    Field,
    VForm,
    ErrorMessage,
  },
  props: {
    id: {
      type: Number,
      required: true,
    },
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    const item = reactive<any>({});
    const errors = ref<any>({
      name: { error: 0, text: "" },
      email: { error: 0, text: "" },
      tel: { error: 0, text: "" },
      agency: { error: 0, text: "" },
      is_active: { error: 0, text: "" },
    });

    const validationItemSchema = Yup.object().shape({
      name: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("ชื่อ-นามสกุล"),
      tel: Yup.string()
        .required("${path} จำเป็นต้องระบุ")
        .label("หมายเลขโทรศัพท์"),
      email: Yup.string()
        .email()
        .required("${path} จำเป็นต้องระบุ")
        .label("อีเมล"),
      agency: Yup.string()
        .email()
        .required("${path} จำเป็นต้องระบุ")
        .label("อีเมล"),
      is_active: Yup.object().required("${path} จำเป็นต้องระบุ").label("สถานะ"),
    });

    const fetchUserAPI = async () => {
      try {
        const { data } = await ApiService.query("api-user/" + props.id, {});

        Object.assign(item, {
          ...data.data,
          is_active:
            data.data.is_active == 1
              ? { id: 1, name: "เปิดใช้งาน" }
              : { id: 0, name: "ปิดใช้งาน" },
        });
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
        name: { error: 0, text: "" },
        tel: { error: 0, text: "" },
        email: { error: 0, text: "" },
        agency: { error: 0, text: "" },
        is_active: { error: 0, text: "" },
      };

      //   try {
      //     await validationItemSchema.validate(item, {
      //       abortEarly: false,
      //     });
      //   } catch (err: any) {
      //     console.log(err);
      //     err.inner.forEach((error: any) => {
      //       const fieldName = error.path;
      //       const errorMessage = error.message;
      //       errors.value[fieldName].error = 1;
      //       errors.value[fieldName].text = errorMessage;
      //     });

      //     useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
      //     return false;
      //   }
      await onSaveUserAPI();
    };

    const onSaveUserAPI = async () => {
      //
      let data_item = {
        name: item.name,
        email: item.email,
        tel: item.tel,
        agency: item.agency,
        is_active: item.is_active?.id,
      };

      await ApiService.put("api-user/" + props.id, data_item)
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

    // Mounted
    onMounted(async () => {
      fetchUserAPI();
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Return
    return {
      item,
      errors,
      onClose,
      mainModalRef,
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
