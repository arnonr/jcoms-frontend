<template>
  <!--begin::Wrapper-->
  <div class="container p-lg-10 mt-5">
    <h2 class="mt-10 mb-5 text-black">ติดตามเรื่องร้องเรียน</h2>

    <div class="card">
      <div class="card-body px-5 py-5 pt-10">
        <div class="mb-10">
          <h4 class="text-center">
            ระบุรหัสคำร้องเรียน/หมายเลขบัตรประชาชน/หนังสือเดินทาง
          </h4>
        </div>
        <div class="d-flex justify-content-center mb-7">
          <div class="form-check form-check-custom form-check-solid me-5 mb-2">
            <input
              class="form-check-input"
              name="type_of_identity"
              type="radio"
              value="1"
              checked
              v-model="item.type_of_identity"
              id="flexCheckboxLg"
            />
            <label class="form-check-label fs-5" for="flexCheckboxLg">
              เลขที่ร้องเรียน
            </label>
          </div>
          <div class="form-check form-check-custom form-check-solid mb-2">
            <input
              class="form-check-input"
              name="type_of_identity"
              type="radio"
              value="2"
              v-model="item.type_of_identity"
              id="flexCheckboxLg"
            />
            <label class="form-check-label fs-5" for="flexCheckboxLg">
              หมายเลขบัตรประชาชน/หนังสือเดินทาง
            </label>
          </div>
        </div>
        <div class="mb-7 d-flex justify-content-center">
          <input
            style="max-width: 600px"
            type="text"
            class="form-control"
            placeholder="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
            aria-label="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
            aria-describedby="basic-addon2"
          />
        </div>
        <div class="d-flex justify-content-center">
          <button class="btn btn-bg-primary text-white">ค้นหา</button>
        </div>
        <div class="separator my-10 mt-15"></div>

        <div class="row">
          <div class="col-md-12 mb-5">
            <h4>รายการเรื่องร้องเรียน</h4>
          </div>
          <div class="col-md-12 table-responsive">
            <table class="table table-bordered table-striped">
              <thead>
                <tr>
                  <th class="text-center">วันที่แจ้ง</th>
                  <th class="text-center">เรื่องร้องเรียน</th>
                  <th class="text-center">รหัสคำร้อง</th>
                  <th class="text-center">สถานะ</th>
                  <th class="text-center">รายละอียด</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="text-center">15 ก.พ. 67</td>
                  <td>โดนเจ้าหน้าที่ทำร้าย</td>
                  <td class="text-center">A001</td>
                  <td class="text-center">อยู่ระหว่าง บก. ดำเนินการ</td>
                  <td class="text-center">
                    <button class="btn btn-success" @click="onShowModal()">
                      ดูรายละเอียด
                    </button>
                  </td>
                </tr>
                <tr>
                  <td class="text-center">15 ก.พ. 67</td>
                  <td>โดนเจ้าหน้าที่ทำร้าย</td>
                  <td class="text-center">A001</td>
                  <td class="text-center">อยู่ระหว่าง บก. ดำเนินการ</td>
                  <td class="text-center">
                    <button
                      class="btn btn-success"
                      data-bs-toggle="modal"
                      data-bs-target="#kt_modal_1"
                    >
                      ดูรายละเอียด
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" tabindex="-1" id="modal-detail">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">เรื่องร้องเรียนเลขที่ A001</h3>

          <!--begin::Close-->
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
          <!--end::Close-->
        </div>

        <div class="modal-body">
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
              <span class="fst-italic">1100200629414</span>
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
              <span class="fst-italic">0802112900</span>
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
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">
            Close
          </button>
          <!-- <button type="button" class="btn btn-primary">Save changes</button> -->
        </div>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch } from "vue";
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
// import * as bootstrap from "bootstrap";
import { Modal } from "bootstrap";

export default defineComponent({
  name: "sign-in",
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
    const showModal = ref<any>(null);

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
    const item = ref({
      organization: "",
      type_of_document_id: "",
      type_of_identity: 1,
      name: "",
      id_number: "",
      id_file: "",
      address_all: "",
      prefix_name_1: "",
    });

    const submitButton = ref<HTMLButtonElement | null>(null);

    //Create form validation object
    const login = Yup.object().shape({
      email: Yup.string().email().required().label("Email"),
      password: Yup.string().min(4).required().label("Password"),
    });

    //Form submit function
    const onSubmitLogin = async (values: any) => {
      values = values as User;
      // Clear existing errors
      store.logout();

      if (submitButton.value) {
        // eslint-disable-next-line
        submitButton.value!.disabled = true;
        // Activate indicator
        submitButton.value.setAttribute("data-kt-indicator", "on");
      }

      // Send login request
      await store.login(values);
      const error = Object.values(store.errors);

      if (error.length === 0) {
        Swal.fire({
          text: "You have successfully logged in!",
          icon: "success",
          buttonsStyling: false,
          confirmButtonText: "Ok, got it!",
          heightAuto: false,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-primary",
          },
        }).then(() => {
          // Go to page after successfully login
          router.push({ name: "dashboard" });
        });
      } else {
        Swal.fire({
          text: error[0] as string,
          icon: "error",
          buttonsStyling: false,
          confirmButtonText: "Try again!",
          heightAuto: false,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-danger",
          },
        }).then(() => {
          store.errors = {};
        });
      }

      //Deactivate indicator
      submitButton.value?.removeAttribute("data-kt-indicator");
      // eslint-disable-next-line
      submitButton.value!.disabled = false;
    };

    const onShowModal = () => {
      showModal.value.show();
    };

    onMounted(() => {
      showModal.value = new Modal("#modal-detail", {});
    });

    return {
      onSubmitLogin,
      login,
      submitButton,
      getAssetPath,
      selectOptions,
      item,
      format,
      onShowModal,
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
