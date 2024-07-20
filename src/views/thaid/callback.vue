<template>
  <div>Loading...</div>
</template>

<script lang="ts">
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  onUnmounted,
  toRefs,
} from "vue";
import ApiService from "@/core/services/ApiService";
import { useRouter } from "vue-router";
import useToast from "@/composables/useToast";

export default defineComponent({
  name: "callback",
  components: {},
  setup() {
    // UI
    const router = useRouter();

    // Mounted
    onMounted(async () => {
      const code: any = new URLSearchParams(window.location.search).get("code");
      const state: any = new URLSearchParams(window.location.search).get(
        "state"
      );
      if (code) {
        try {
          await ApiService.query("thaid/token-request", {
            params: { code: code },
          }).then((data1: any) => {
            useToast("ยืนยันตัวตนสำเร็จ", "error");
            setTimeout(function () {
              window.location.href = `https://jcoms2.police.go.th/appeal?type_id=${state}&pid=${data1.data.data.pid}&firstname=${data1.data.data.given_name}&lastname=${data1.data.data.family_name}`;
            }, 3000);
          });
          //   state
          //   const encodedJson = encodeURIComponent(JSON.stringify(data));
        } catch (error) {
          console.error("Error fetching access token:", error);
        }
      } else {
        useToast("ยืนยันตัวตนไม่สำเร็จ", "error");
        setTimeout(function () {
          window.location.href = `https://jcoms2.police.go.th/appeal?type_id=${state}`;
        }, 3000);
      }
    });

    onUnmounted(() => {});

    // Return
    return {};
  },
});
</script>
