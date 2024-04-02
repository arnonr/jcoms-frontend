<template>
  <div>
    <!-- Modal OTP -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="otpConfirmModalRef"
      id="otp-confirm-modal"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">ยืนยัน OTP</h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <div
                class="mb-4 col-12 col-lg-12 d-flex justify-content-center align-items-center"
              >
                <div class="text-center">
                  หมายเลขโทรศัพท์ : {{ otp_send.phone_number_res }}<br />
                  (Ref:
                  {{
                    otp_secret_key != null
                      ? otp_secret_key
                      : otp_send.otp_secret
                  }})
                </div>
              </div>
              <div class="d-flex justify-content-center align-items-cente mb-7">
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
                  }}</span>
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
                <button class="btn btn-secondary ms-3" @click="onCancel">
                  ยกเลิก
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
import { defineComponent, ref, onMounted, onUnmounted, watch } from "vue";
import { useOTPStore, type Otp } from "@/stores/otp";
import type { PropType } from "vue";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Axios
import axios from "axios";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Import Dayjs
import dayjs from "dayjs";
import { useRouter } from "vue-router";
import ApiService from "@/core/services/ApiService";
// Use Toast Composables
import useToast from "@/composables/useToast";

export default defineComponent({
  name: "tracking-otp",
  props: {
    otp_send: {
      type: Object,
      required: true,
    },
  },
  components: {},
  setup(props, context) {
    // Variable
    const router = useRouter();
    const emit = context.emit;

    const store = useOTPStore();
    const otpData = ref<any>({
      phone: "",
      code: "",
    });
    const otpDataCheck = ref<any>({
      phone: "",
      code: "",
    });

    const otp_secret_key = ref<any>(null);
    let loadingTimeout = ref(30000);
    const otpConfirmModalRef = ref<any>(null);
    const otpConfirmModalObj = ref<any>(null);
    const btnSendOtpDisabled = ref<any>(false);
    const btnConfirmOtpDisabled = ref<any>(true);
    const otpCountdown = ref<any>(0);
    const otpWrong = ref<any>("d-none");

    // Event
    const onOTPModal = () => {
      otpConfirmModalObj.value.show();
    };

    const getRandomEnglishCharacter = () => {
      const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      const randomIndex = Math.floor(Math.random() * characters.length);
      return characters.charAt(randomIndex);
    };

    const generateRandomEnglishString = (length: any) => {
      let result = "";

      for (let i = 0; i < length; i++) {
        const randomChar = getRandomEnglishCharacter();
        result += randomChar;
      }

      return result;
    };

    const onSendOTP = async () => {
      // generate otp แล้วเก็บใน storage
      otpWrong.value = "d-none";
      // Generate a random string of 4 English characters
      otp_secret_key.value = generateRandomEnglishString(4);

      let api = {
        type: "post",
        url: "complaint/get-otp-tracking",
      };

      await ApiService[api.type](api.url, {
        ...props.otp_send,
        otp_secret: otp_secret_key.value,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          otpCountdown.value = 120;
          btnSendOtpDisabled.value = true;
          btnConfirmOtpDisabled.value = false;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onConfirmOTP = async () => {
      btnConfirmOtpDisabled.value = true;

      let api = {
        type: "post",
        url: "complaint/verify-otp-tracking",
      };

      await ApiService[api.type](api.url, {
        otp: otpDataCheck.value.code,
        otp_secret:
          otp_secret_key.value != null
            ? otp_secret_key.value
            : props.otp_send.otp_secret,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

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
            emit("close-otp-modal");
            otpConfirmModalObj.value.hide();
            emit("fetch-complaint", data.data.complainant_uuid);
            otpWrong.value = "d-none";
          });
        })
        .catch(({ response }) => {
          btnConfirmOtpDisabled.value = false;
          otpWrong.value = "d-block";
          useToast("OTP ไม่ถูกต้อง", "error");
          console.log(response);
        });
    };

    const onCancel = () => {
      otpConfirmModalObj.value.hide();
      otpWrong.value = "d-none";
      emit("close-otp-modal");
    };

    // Mounted
    onMounted(() => {
      otpConfirmModalObj.value = new Modal(otpConfirmModalRef.value, {});
      otpData.value.code = props.otp_send.opt_code;
      onOTPModal();
      otpCountdown.value = 120;
      btnSendOtpDisabled.value = true;
      btnConfirmOtpDisabled.value = false;
    });

    onUnmounted(() => {
      otpConfirmModalObj.value.hide();
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

    // Return
    return {
      loadingTimeout,
      otpConfirmModalRef,
      otpConfirmModalObj,
      otpData,
      otpDataCheck,
      btnSendOtpDisabled,
      btnConfirmOtpDisabled,
      otpCountdown,
      otpWrong,
      otp_secret_key,

      APP_BASE_URL: import.meta.env.VITE_APP_BASE_URL,
      onOTPModal,
      onSendOTP,
      onConfirmOTP,
      onCancel,
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
