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
import axios from "axios";

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
            console.log("FREEDOM");
            // router.push({
            //   name: "appeal",
            //   query: {
            //     pid: data.pid,
            //     firstname: data.given_name,
            //     lastname: data.family_name,
            //   },
            // });
            console.log(data1);
            setTimeout(function () {
              console.log(
                `https://jcoms2.police.go.th/appeal?type_id=1&pid=${data1.pid}&firstname=${data1.given_name}&lastname=${data1.family_name}`
              );
            }, 3000);

            // router.push({
            //   path: `https://jcoms2.police.go.th/appeal?type_id=1&pid=${data.pid}&firstname=${data.given_name}&lastname=${data.family_name}`,
            // });
          });
          //   state
          //   const encodedJson = encodeURIComponent(JSON.stringify(data));
        } catch (error) {
          console.error("Error fetching access token:", error);
        }
      }
    });

    onUnmounted(() => {});

    // Return
    return {};
  },
});
</script>
