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

export default defineComponent({
  name: "callback",
  components: {},
  setup() {
    // UI
    const router = useRouter();

    // Mounted
    onMounted(async () => {
      const code = new URLSearchParams(window.location.search).get("code");
      if (code) {
        try {
          const { data } = await ApiService.post(
            "https://thaid.example.com/oauth2/token",
            {
              client_id: "YOUR_CLIENT_ID",
              client_secret: "YOUR_CLIENT_SECRET",
              code: code,
              redirect_uri: "YOUR_REDIRECT_URI",
              grant_type: "authorization_code",
            }
          );
          const token = data.data.access_token;
          console.log("Access Token:", token);
          router.push(import.meta.env.VITE_APP_BASE_URL + "/appeal?type_id=1");
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
