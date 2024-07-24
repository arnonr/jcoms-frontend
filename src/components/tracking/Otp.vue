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
            <h3 class="modal-title">
              ยืนยันการติดตามเรื่องร้องเรียน/แจ้งเบาะแสด้วย SMS
            </h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <label for="otp_data_phone" class="required form-label"
                >หมายเลขโทรศัพท์มือถือ</label
              >

              <div class="mb-7 col-12 col-lg-12 d-flex">
                <input
                  type="text"
                  disabled
                  class="form-control me-2"
                  placeholder="หมายเลขโทรศัพท์มือถือ"
                  aria-label="หมายเลขโทรศัพท์มือถือ"
                  v-model="request_otp.phone_number_show"
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
                <label for="otpData_code" class="form-label">
                  <span>กรอกรหัส OTP ที่คุณได้รับทาง SMS</span>
                  <div v-if="otpCountdown != 0">
                    รหัส OTP จะหมดอายุภายใน
                    <span class="text-primary">{{
                      otpCountdown > 0 ? otpCountdown + " วินาที" : "หมดเวลา"
                    }}</span
                    ><br />
                    <span> (Ref: {{ otp_secret_key }})</span>
                  </div>
                </label>
                <input
                  type="text"
                  class="form-control"
                  placeholder="กรอกรหัส OTP ที่ได้รับทาง SMS"
                  aria-label="กรอกรหัส OTP ที่ได้รับทาง SMS"
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
import {
  defineComponent,
  ref,
  onMounted,
  onUnmounted,
  watch,
  toRefs,
} from "vue";
import ApiService from "@/core/services/ApiService";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Use Toast Composables
import useToast from "@/composables/useToast";

export default defineComponent({
  name: "otp-tracking",
  props: {
    request_otp: {
      type: Object,
      required: true,
    },
  },
  components: {},
  setup(props, { emit }) {
    // Variable
    const { request_otp } = toRefs(props);

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
      otpWrong.value = "d-none";
      otp_secret_key.value = generateRandomEnglishString(4);

      await ApiService.post("complaint/get-otp-tracking", {
        ...request_otp.value,
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

      await ApiService.post("complaint/verify-otp-tracking", {
        otp: otpDataCheck.value.code,
        otp_secret: otp_secret_key.value,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          const ttl = 10 * 60 * 1000;
          const now = new Date();
          // `item` เป็นอ็อบเจ็กต์ที่เก็บข้อมูลพร้อมเวลาหมดอายุ
          const item_storage = {
            value: data.data.complainant_uuid,
            expiry: now.getTime() + ttl, // ttl เป็นเวลาในมิลลิวินาที
          };
          localStorage.setItem('complainant_uuid', JSON.stringify(item_storage));

          emit("close-otp-modal");
          otpConfirmModalObj.value.hide();
          emit("fetch-complaint", data.data.complainant_uuid);
          otpWrong.value = "d-none";
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
      //   otpData.value.code = props.request_otp.opt_code;

      onOTPModal();
      //   otpCountdown.value = 120;
      //   btnSendOtpDisabled.value = true;
      //   btnConfirmOtpDisabled.value = false;
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
