<template>
  <div class="container">
    <div class="row">
      <div class="mb-5"><h4>การดำเนินการ</h4></div>
      <div>
        <span> วันที่ 12 ก.พ. 67 : </span>
        <span class="fw-bold"> สำนักงานจเรตำรวจรับเรื่อง </span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span> วันที่ 14 ก.พ. 67 : </span>
        <span class="fw-bold">
          กองตรวจราชการ... ส่งเรื่องต่อ กองบัญชาการ....
        </span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span> วันที่ 16 ก.พ. 67 : </span>
        <span class="fw-bold">
          กองบัญชาการ.... ส่งเรื่องต่อ กองบังคับการภาค....
        </span>
        <div class="separator separator-dotted my-2"></div>
      </div>

      <div class="mb-5 mt-5"><h4>1. ข้อมูลส่วนตัว</h4></div>
      <div>
        <span>หมายเลขบัตรประชาชน/หนังสือเดินทาง : </span>
        <span class="fst-italic">110020********</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>ชื่อ-นามกุล ผู้ร้อง : </span>
        <span class="fst-italic">นายอานนท์ รักจักร์</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>วัน/เดือน/ปีเกิด : </span>
        <span class="fst-italic">19 มีนาคม 2534</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>อาชีพ : </span>
        <span class="fst-italic">พนักงานบริษัท</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>หมายเลขโทรศัพท์ : </span>
        <span class="fst-italic">08021*****</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>ที่อยู่ที่สามารถติดต่อได้ : </span>
        <span class="fst-italic">705 ซ.จรัญสนิทวงศ์ 89</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>ตำบล/อำเภอ/จังหวัด : </span>
        <span class="fst-italic">แขวงบางอ้อ เขตบางพลัด กทม. 10700</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div v-if="item.type_of_identity == 1">
        <span>รูปถ่ายพร้อมบัตร : </span>
        <span class="fst-italic">IMG</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div class="mb-5 mt-5">
        <h4>2. ข้อมูลร้องเรียน/แจ้งเบาะแส</h4>
      </div>
      <div>
        <span>เรื่องร้องเรียน/แจ้งเบาะแส : </span>
        <span class="fst-italic">โดนเจ้าหน้าที่ทำร้ายร่างกาย</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>สถานที่เกิดเหตุ : </span>
        <span class="fst-italic">แขวงบางอ้อ เขตบางพลัด กทม. 10700</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>ข้อมูลสถานที่เกิดเหตุ : </span>
        <span class="fst-italic">..........</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>วันที่เกิดเหตุ : </span>
        <span class="fst-italic"
          >15 กุมภาพันธ์ 2567 เวลา 16.00 น. (กลางวัน)</span
        >
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>ผู้ถูกร้อง : </span>
        <span class="fst-italic">พล.ต.ท สมชาย รักดี</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
      <div>
        <span>หน่วยงานผู้ถูกร้อง : </span>
        <span class="fst-italic"
          >สถานีตำรวจภูธรเจาะไอ้ร้อง > บก... > บช.. > สังกัด ...</span
        >
        <div class="separator separator-dotted my-2"></div>
      </div>

      <div>
        <span>พฤติกรรมการกระทำความผิด : </span>
        <span class="fst-italic">............</span>
        <div class="separator separator-dotted my-2"></div>
      </div>

      <div>
        <span>ไฟล์หลักฐานเพิ่มเติม : </span>
        <span class="fst-italic">PDF</span>
        <div class="separator separator-dotted my-2"></div>
      </div>

      <div>
        <span>ไฟล์หลักฐานเพิ่มเติม : </span>
        <span class="fst-italic">PDF</span>
        <div class="separator separator-dotted my-2"></div>
      </div>
    </div>
    <div class="row">
        <div class="col-12 text-center mt-7">
            <button class="btn btn-primary">
                <i class="fa fa-print"></i>
                พิมพ์ข้อมูล</button>
        </div>
    </div>
  </div>
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

export default defineComponent({
  name: "detail-complaint",
  components: {
    Field,
    VForm,
    ErrorMessage,
    FormWizard,
    TabContent,
    vSelect,
    VueDatePicker,
    dayjs,
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

    const submitButton = ref<HTMLButtonElement | null>(null);

    //Create form validation object
    const login = Yup.object().shape({
      email: Yup.string().email().required().label("Email"),
      password: Yup.string().min(4).required().label("Password"),
    });

    //Form submit function
    return {
      login,
      submitButton,
      getAssetPath,
      selectOptions,
      item,
      format,
    };
  },
});
</script>
