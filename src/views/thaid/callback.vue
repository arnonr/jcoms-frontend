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
      const code = new URLSearchParams(window.location.search).get("code");
      if (code) {
        try {
          const { data } = await ApiService.post("getThaiD", {
            grant_type: "authorization_code",
            redirect_uri: import.meta.env.VITE_APP_THAID_REDIRECT_URI,
            code: code,
            authorization:
              "Basic " +
              btoa(
                import.meta.env.VITE_APP_THAID_CLIENTID +
                  ":" +
                  import.meta.env.VITE_APP_THAID_CLIENT_SECRET
              ),
          });

          router.push(import.meta.env.VITE_APP_BASE_URL + "/appeal?type_id=1");

          //   const headers = {
          //     "Content-Type": "application/x-www-form-urlencoded",
          //     Authorization:
          //       "Basic " +
          //       btoa(
          //         import.meta.env.VITE_APP_THAID_CLIENTID +
          //           ":" +
          //           import.meta.env.VITE_APP_THAID_CLIENT_SECRET
          //       ),
          //   };

          //   console.log(headers.Authorization);

          //   axios
          //     .post(
          //       "https://imauth.bora.dopa.go.th/api/v2/oauth2/token/",
          //       {
          //         grant_type: "authorization_code",
          //         redirect_uri: import.meta.env.VITE_APP_THAID_REDIRECT_URI,
          //         code: code,
          //       },
          //       {
          //         headers: headers,
          //       }
          //     )
          //     .then((response) => {
          //       console.log(response);
          //     })
          //     .catch((error) => {});

          //   const token = data.data.access_token;
          //   console.log("Access Token:", token);
          //   router.push(import.meta.env.VITE_APP_BASE_URL + "/appeal?type_id=1");
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
