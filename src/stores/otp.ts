
import { defineStore } from "pinia";
import { ref } from "vue";

export interface Otp {
  phone: string;
  code: string;
}

export const useOTPStore = defineStore("otp", () => {
  const errors = ref({});
  const otp = ref({} as Otp);

  function setOTP(authOtp: Otp) {
    otp.value = authOtp;
  }

  return {
    otp,
    setOTP,
  };
});
