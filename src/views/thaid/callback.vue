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
              client_id: import.meta.env.VITE_APP_THAID_CLIENTID,
              client_secret: import.meta.env.VITE_APP_THAID_CLIENT_SECRET,
              code: code,
              redirect_uri: import.meta.env.VITE_APP_THAID_REDIRECT_URI,
              grant_type: "authorization_code",
              //   bbA1vJhFiMYTZPPHYXZGLnRootVdDg17byrnBTyJ
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
