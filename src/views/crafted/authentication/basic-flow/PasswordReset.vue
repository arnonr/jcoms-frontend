<template>
  <!--begin::Wrapper-->
  <div class="w-lg-500px p-10">
    <div class="row">
      <!--begin::Heading-->
      <div class="text-center mb-10">
        <!--begin::Title-->
        <h1 class="text-gray-900 mb-3">ลืมรหัสผ่าน ?</h1>
        <!--end::Title-->

        <!--begin::Link-->
        <div class="text-gray-500 fw-semibold fs-4">
          กรุณาระบุอีเมลเพื่อทำการรีเซ็ตรหัสผ่าน
        </div>
        <!--end::Link-->
      </div>
      <!--begin::Heading-->

      <label for="otp_data_phone" class="required form-label">Email</label>

      <div class="mb-7 col-12 col-lg-12 d-flex">
        <input
          type="text"
          class="form-control me-2"
          placeholder="Email"
          aria-label="ิอีเมล"
          v-model="otpData.email"
        />
        <button
          class="btn btn-success"
          @click="onSendOTP"
          :disabled="btnSendOtpDisabled"
        >
          ส่ง OTP
          {{
            btnSendOtpDisabled == true ? "(" + (otpCountdown - 60) + ")" : ""
          }}
        </button>
      </div>
      <hr />
      <div class="mb-7 col-12 col-lg-12">
        <label for="otpData_code" class="form-label required">
          <span>กรอกรหัส OTP ที่คุณได้รับทาง Email</span>
          <div v-if="otpCountdown != 0">
            <!-- รหัส OTP จะหมดอายุภายใน
            <span class="text-primary">{{
              otpCountdown > 0 ? otpCountdown + " วินาที" : "หมดเวลา"
            }}</span
            ><br /> -->
            <span> (Ref: {{ otp_secret_key }})</span>
          </div>
        </label>
        <input
          type="text"
          class="form-control"
          placeholder="กรอกรหัส OTP ที่ได้รับทาง Email"
          aria-label="กรอกรหัส OTP ที่ได้รับทาง Email"
          v-model="otpDataCheck.code"
        />
        <span class="text-danger mt-2" :class="[otpWrong]"
          >รหัส OTP ไม่ถูกต้อง</span
        >
      </div>
      <div class="mb-7 col-12 col-lg-12">
        <label for="" class="required form-label">ตั้งรหัสผ่านใหม่</label>
        <input
          type="password"
          class="form-control me-2"
          placeholder="ตั้งรหัสผ่านใหม่"
          aria-label="ตั้งรหัสผ่านใหม่"
          v-model="otpDataCheck.password"
        />
      </div>
      <div class="col-12 col-lg-12 text-center">
        <button
          class="btn btn-primary"
          @click="onConfirmOTP"
          :disabled="btnConfirmOtpDisabled"
        >
          ยืนยัน
        </button>
        <button class="btn btn-secondary ms-3" @click="onCancel">ยกเลิก</button>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
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
// Use Toast Composables
import useToast from "@/composables/useToast";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "password-reset",
  components: {},
  setup() {
    const router = useRouter();

    const otpData = ref<any>({
      email: "",
      code: "",
    });

    const otpDataCheck = ref<any>({
      email: "",
      code: "",
      password: "",
    });

    const otp_secret_key = ref<any>(null);

    let loadingTimeout = ref(30000);
    const btnSendOtpDisabled = ref<any>(false);
    const btnConfirmOtpDisabled = ref<any>(true);
    const otpCountdown = ref<any>(0);
    const otpWrong = ref<any>("d-none");

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

    //Form submit function
    const onSendOTP = async () => {
      otpWrong.value = "d-none";
      otp_secret_key.value = generateRandomEnglishString(4);

      await ApiService.post("user/forgot-password", {
        email: otpData.value.email,
        ref_code: otp_secret_key.value,
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
          useToast(response.data.msg, "error");
        });
    };

    const onConfirmOTP = async () => {
      btnConfirmOtpDisabled.value = true;

      await ApiService.post("user/reset-password", {
        email: otpData.value.email,
        ref_code: otp_secret_key.value,
        code: otpDataCheck.value.code,
        password: otpDataCheck.value.password,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          otpWrong.value = "d-none";
          //   redirect หน้า Login
          useToast("เปลี่ยนรหัสผ่านเสร็จสิ้น", "success");
          router.push({ name: "sign-in" });
        })
        .catch(({ response }) => {
          btnConfirmOtpDisabled.value = false;
          otpWrong.value = "d-block";
          useToast("OTP ไม่ถูกต้อง", "error");
          console.log(response);
        });
    };

    const onCancel = () => {
      otpWrong.value = "d-none";
    };

    // Watch
    watch(
      otpCountdown,
      (value: any) => {
        if (value > 0) {
          setTimeout(() => {
            otpCountdown.value = otpCountdown.value - 1;
          }, 1000);
        } else {
          //   btnConfirmOtpDisabled.value = true;
        }

        if (value < 60 && btnSendOtpDisabled.value == true) {
          btnSendOtpDisabled.value = false;
        }
      },
      { immediate: true }
    );

    return {
      loadingTimeout,
      otpData,
      otpDataCheck,
      btnSendOtpDisabled,
      btnConfirmOtpDisabled,
      otpCountdown,
      otpWrong,
      otp_secret_key,
      APP_BASE_URL: import.meta.env.VITE_APP_BASE_URL,
      onSendOTP,
      onConfirmOTP,
      onCancel,
    };
  },
});
</script>
