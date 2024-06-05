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
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted } from "vue";
// Import Recaptcha
import vueRecaptcha from "vue3-recaptcha2";
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
    first_action: {
      type: Boolean,
      required: true,
    },
  },
  components: {
    vueRecaptcha,
  },
  setup(props, { emit }) {
    // Variable

    let showRecaptcha = ref(true);
    let loadingTimeout = ref(30000);
    const captchaModalRef = ref<any>(null);
    const captchaModalObj = ref<any>(null);

    // Event
    const onCaptchaModal = () => {
      if (props.first_action == true) {
        captchaModalObj.value.show();
      }
    };

    const recaptchaVerified = (res: any) => {
      captchaModalObj.value.hide();
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

    const onCancel = () => {
      captchaModalObj.value.hide();
      emit("close-captcha-modal");
    };

    // Mounted
    onMounted(() => {
      captchaModalObj.value = new Modal(captchaModalRef.value, {});
      onCaptchaModal();
    });

    onUnmounted(() => {
      captchaModalObj.value.hide();
    });

    // Watch

    // Return
    return {
      showRecaptcha,
      loadingTimeout,
      captchaModalRef,
      captchaModalObj,
      onCaptchaModal,
      onCancel,
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
