<template>
  <!--begin::Wrapper-->
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
        <div class="accordion accordion-flush" id="accordionFlushExample">
          <div class="accordion-item">
            <div
              id="flush-collapseOne"
              class="accordion-collapse collapse"
              aria-labelledby="flush-headingOne"
              data-bs-parent="#accordionFlushExample"
            >
              <div class="accordion-body" style="padding:0">
                <!-- <DetailComplaint /> -->
                <hr />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="surname" class="required form-label">หน่วยงานส่งต่อ</label>
        <v-select
          label="name"
          name="id"
          placeholder="ห้วงเวลาเกิดเหตุ"
          :options="selectOptions.dayornight"
          class="form-control"
          :clearable="false"
          v-model="item.day_or_night"
        >
        </v-select>
      </div>

      <div class="mb-7 col-12 col-lg-4">
        <label for="surname" class="required form-label"
          >เลขที่หนังสือส่ง</label
        >
        <input
          type="text"
          class="form-control"
          placeholder="หมายเหตุ"
          aria-label="หมายเหตุ"
          aria-describedby="basic-addon2"
        />
      </div>

      <div class="mb-7 col-12 col-lg-4">
        <label for="surname" class="required form-label">วันที่หนังสือ</label>
        <v-select
          label="name"
          name="id"
          placeholder="ห้วงเวลาเกิดเหตุ"
          :options="selectOptions.dayornight"
          class="form-control"
          :clearable="false"
          v-model="item.day_or_night"
        >
        </v-select>
      </div>

      <div class="mb-7 col-12 col-lg-4">
        <label for="">ข้อสั่งการ : </label>
        <v-select
          id="slt-search-order-id-2"
          name="slt-search-order-2"
          label="name"
          placeholder="ข้อสั่งการ"
          class="form-control"
          :clearable="true"
        ></v-select>
      </div>

      <div class="mb-7 col-12 col-lg-12">
        <label for="">หมายเหตุ : </label>
        <input
          type="text"
          class="form-control"
          placeholder="หมายเหตุ"
          aria-label="หมายเหตุ"
          aria-describedby="basic-addon2"
        />
      </div>

      <div class="mt-12 col-12 col-lg-12 text-center">
        <button class="btn btn-success" @click="onValidate(1)">ส่งต่อ</button>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref } from "vue";
import { ErrorMessage, Field, Form as VForm } from "vee-validate";
import { useAuthStore, type User } from "@/stores/auth";
import { useRouter } from "vue-router";
import Swal from "sweetalert2/dist/sweetalert2.js";
import * as Yup from "yup";
import { FormWizard, TabContent } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
import useAddressData from "@/composables/useAddressData";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import DetailComplaint from "./Detail.vue";

export default defineComponent({
  name: "send-complaint",
  components: {
    Field,
    VForm,
    ErrorMessage,
    FormWizard,
    TabContent,
    vSelect,
    VueDatePicker,
    dayjs,
    DetailComplaint,
  },
  setup() {
    const store = useAuthStore();
    const router = useRouter();

    const address_all = ref([]);
    address_all.value = useAddressData().addresses.map((el) => {
      el.label =
        el.district +
        " > " +
        el.amphoe +
        " > " +
        el.province +
        " > " +
        el.zipcode;
      return el;
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const selectOptions = {
      type_of_document: [
        {
          name: "หมายเลขบัตรประชาชน",
          value: 1,
        },
        {
          name: "หนังสือเดินทาง",
          value: 2,
        },
      ],
      prefix_name: [
        { name: "นาย", value: 1 },
        { name: "นาง", value: 1 },
        { name: "นางสาว", value: 1 },
      ],
      prefix_name_1: [
        { name: "พล.ต.อ.", value: 1 },
        { name: "พล.ต.ท.", value: 2 },
        { name: "พล.ต.ต.", value: 3 },
      ],
      address_all: address_all.value,
      dayornight: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      organizations: [
        {
          name: "สถานีตำรวจภูธรเจาะไอ้ร้อง > บก... > บช.. > สังกัด ...",
          value: 1,
        },
        {
          name: "สถานีตำรวจภูธรจักราช > บก... > บช.. > สังกัด ...",
          value: 2,
        },
      ],
    };
    const item = ref<any>({
      organization: "",
      type_of_document_id: "",
      type_of_identity: 1,
      name: "",
      id_number: "",
      id_file: "",
      address_all: "",
      prefix_name_1: "",
      prefix_name: "",
      inspection_date: "",
      day_or_night: "",
    });

    //Create form validation object
    const login = Yup.object().shape({
      email: Yup.string().email().required().label("Email"),
      password: Yup.string().min(4).required().label("Password"),
    });

    //Form submit function
    const onValidate = (type) => {
      if (type != 1) {
        // Sweetalert

        // Swal.fire({
        //   title: "ยืนยันไม่รับเรื่อง",
        //   icon: "question",
        //   showCancelButton: true,
        //   confirmButtonText: "ยืนยัน",
        //   heightAuto: false,
        //   customClass: {
        //     confirmButton: "btn fw-semibold btn-light-primary",
        //   },
        // }).then(() => {
        //   onSubmit(type);
        // });

        Swal.fire({
          title: "โปรดระบุเหตุผล",
          input: "select",
          inputOptions: {
            1: "ข้อมูลไม่ครบถ้วน1",
            2: "ข้อมูลไม่ครบถ้วน2",
          },
          inputPlaceholder: "เลือกเหตุผล",
          showCancelButton: true,
          confirmButtonText: "ยืนยัน",
          cancelButtonText: `ยกเลิก`,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-success",
            cancelButton: "btn fw-semibold btn-light-danger",
          },
        }).then((result) => {
          if (result.isConfirmed) {
            let comment = Number(result.value);
            onSubmit(type);
          } else if (result.isDenied) {
          }
        });
      } else {
        onSubmit(type);
      }
    };
    const onSubmit = async (type: any) => {
      //
    };

    return {
      selectOptions,
      login,
      getAssetPath,
      item,
      format,

      onValidate,
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
