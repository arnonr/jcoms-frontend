<template>
  <div>
    <!-- Modal Captcha -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="captchaModalRef"
      id="captcha-modal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
    >
      <div class="modal-dialog modal-dialog-centered modal-xs">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">ตรวจสอบ</h3>
          </div>

          <div class="modal-body mx-auto pb-10 pt-10">
            <vue-recaptcha
              v-show="showRecaptcha"
              sitekey="6LdeSpwpAAAAAOBv4gXwHsVRvstiq6juHnGMxZcT"
              size="normal"
              theme="light"
              hl="en"
              :loading-timeout="loadingTimeout"
              @verify="recaptchaVerified"
              @expire="recaptchaExpired"
              @fail="recaptchaFailed"
              @error="recaptchaError"
              ref="vueRecaptcha"
            >
            </vue-recaptcha>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal OTP -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="otpModalRef"
      id="otp-modal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">ยืนยันตัวตนด้วย SMS</h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <label for="otp_data_phone" class="required form-label"
                >หมายเลขโทรศัพท์</label
              >
              <div class="mb-7 col-12 col-lg-12 d-flex">
                <input
                  type="text"
                  class="form-control me-2"
                  placeholder="หมายเลขโทรศัพท์"
                  aria-label="หมายเลขโทรศัพท์"
                  v-model="otpData.phone"
                />

                <button
                  class="btn btn-success"
                  @click="onSendOTP"
                  :disabled="btnSendOtpDisabled"
                >
                  ส่ง OTP
                  {{
                    btnSendOtpDisabled == true
                      ? "(" + (otpCountdown - 60) + ")"
                      : ""
                  }}
                </button>
              </div>
              <hr />
              <div class="mb-7 col-12 col-lg-12">
                <label for="otpData_code" class="required form-label">
                  รหัส OTP ที่คุณได้รับทาง SMS จะหมดอายุภายใน
                  <span class="text-primary">{{
                    otpCountdown > 0 ? otpCountdown + " วินาที" : "หมดเวลา"
                  }}</span
                  ><br />
                  <span>OTP TEST : {{ otpData.code }}</span>
                </label>
                <input
                  type="text"
                  class="form-control"
                  placeholder="รหัส OTP"
                  aria-label="รหัส OTP"
                  v-model="otpDataCheck.code"
                />
                <span class="text-danger mt-2" :class="[otpWrong]"
                  >รหัส OTP ไม่ถูกต้อง</span
                >
              </div>
              <div class="col-12 col-lg-12 text-center">
                <button
                  class="btn btn-primary"
                  @click="onConfirmOTP"
                  :disabled="btnConfirmOtpDisabled"
                >
                  ยืนยัน
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
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, watch } from "vue";
import { useOTPStore, type Otp } from "@/stores/otp";
// Import Recaptcha
import vueRecaptcha from "vue3-recaptcha2";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Axios
import axios from "axios";
// Import Modal Bootstrap
import { Modal } from "bootstrap";

export default defineComponent({
  name: "captcha",
  props: {
    item: {
      type: Object,
      required: true,
    },
    complaint_item: {
      type: Object,
      required: true,
    },
    errors: {
      type: Object,
      required: true,
    },
    change_phone_number: {
      type: Boolean,
      required: true,
    },
  },
  components: {
    vueRecaptcha,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;

    const onChangePhoneNumber = () => {
      emit("update-phone-number-data", otpData.value.phone);
    };

    const store = useOTPStore();
    const otpData = ref<any>({
      phone: "",
      code: "",
    });
    const otpDataCheck = ref<any>({
      phone: "",
      code: "",
    });
    let showRecaptcha = ref(true);
    let loadingTimeout = ref(30000);
    const captchaModalRef = ref<any>(null);
    const captchaModalObj = ref<any>(null);
    const otpModalRef = ref<any>(null);
    const otpModalObj = ref<any>(null);
    const btnSendOtpDisabled = ref<any>(false);
    const btnConfirmOtpDisabled = ref<any>(true);
    const otpCountdown = ref<any>(0);
    const otpWrong = ref<any>("d-none");

    // Event
    const onCaptchaModal = () => {
      //   captchaModalObj.value.show();
      // otpModalObj.value.show();
    };

    const onOTPModal = () => {
      otpModalObj.value.show();

      setTimeout(() => {
        captchaModalObj.value.hide();
      }, 5000);
    };

    const onSendOTP = () => {
      // generate otp แล้วเก็บใน storage
      otpWrong.value = "d-none";

      let digits = "0123456789";
      let otpLength = 4;
      otpData.value.code = "";
      for (let i = 1; i <= otpLength; i++) {
        let index = Math.floor(Math.random() * digits.length);
        otpData.value.code = otpData.value.code + digits[index];
      }

      store.setOTP({
        phone: otpData.value.phone,
        code: otpData.value.code,
      });

      otpCountdown.value = 120;
      btnSendOtpDisabled.value = true;
      btnConfirmOtpDisabled.value = false;

      let params = {
        msisdn: otpData.value.phone,
        message: `รหัสยืนยันของคุณคือ ${store.otp}`,
        sender: "สำนักงานจเรตำรวจ",
        force: "standard",
        // Shorten_url: true,
        // tracking_url: true,
        // expire:
      };
      let auth = {
        username: "tRYlZ4Ddn8dOKUwCRBgASLMg5vDMLQ",
        password: "4F5ioK0jg9ZmQ0h8KpYzCgrFqc9mLC",
      };
      //   axios.post(`https://api-v2.thaibulksms.com/sms`, params, { auth: auth });
      // h
    };

    const onConfirmOTP = () => {
      if (otpData.value.code == otpDataCheck.value.code) {
        Swal.fire({
          text: "ยืนยัน OTP สำเร็จ",
          icon: "success",
          buttonsStyling: false,
          confirmButtonText: "ตกลง",
          heightAuto: false,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-primary",
          },
        }).then(() => {
          onChangePhoneNumber();
          otpModalObj.value.hide();
          otpWrong.value = "d-none";
        });
      } else {
        otpWrong.value = "d-block";
      }
    };

    const recaptchaVerified = (res: any) => {
      captchaModalObj.value.hide();
      otpModalObj.value.show();
    };

    const recaptchaExpired = (res: any) => {
      console.log(res);
    };

    const recaptchaFailed = (res: any) => {
      console.log(res);
    };

    const recaptchaError = (reason: any) => {
      console.log(reason);
    };

    // Mounted
    onMounted(() => {
      captchaModalObj.value = new Modal(captchaModalRef.value, {});
      otpModalObj.value = new Modal(otpModalRef.value, {});
      onCaptchaModal();
    });

    // Watch
    watch(
      otpCountdown,
      (value: any) => {
        if (value > 0) {
          setTimeout(() => {
            otpCountdown.value = otpCountdown.value - 1;
          }, 1000);
        } else {
          btnConfirmOtpDisabled.value = true;
        }

        if (value < 60 && btnSendOtpDisabled.value == true) {
          btnSendOtpDisabled.value = false;
        }
      },
      { immediate: true }
    );

    // watch(
    //   props.change_phone_number,
    //   (value: any) => {
    //     if (props.change_phone_number == true) {
    //       otpModalObj.value.show();
    //     }
    //   },
    //   { immediate: true }
    // );

    watch(
      () => props.change_phone_number,
      (newValue, oldValue) => {
        // ทำสิ่งที่ต้องการเมื่อ propValue มีการเปลี่ยนแปลง

        if (newValue == true) {
          otpData.value = {
            phone: "",
            code: "",
          };

          otpDataCheck.value = {
            phone: "",
            code: "",
          };
          otpCountdown.value = 0;
          otpModalObj.value.show();
        }
      }
    );

    // Return
    return {
      showRecaptcha,
      loadingTimeout,
      captchaModalRef,
      captchaModalObj,
      otpModalRef,
      otpModalObj,
      otpData,
      otpDataCheck,
      btnSendOtpDisabled,
      btnConfirmOtpDisabled,
      otpCountdown,
      otpWrong,

      onCaptchaModal,
      onOTPModal,
      onSendOTP,
      onConfirmOTP,
      recaptchaVerified,
      recaptchaExpired,
      recaptchaFailed,
      recaptchaError,
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
