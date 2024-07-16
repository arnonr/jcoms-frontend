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
      const code = 1;
      //   new URLSearchParams(window.location.search).get("code");
      if (code) {
        try {
          //   const { data } = await ApiService.post(
          //     "https://imauth.bora.dopa.go.th/api/v2/oauth2/token/",
          //     {
          //       grant_type: "authorization_code",
          //       redirect_uri: import.meta.env.VITE_APP_THAID_REDIRECT_URI,
          //       code: "Y2QzNjk4MTMtNmJiMi00ZjlhLTgzMzgtYzg1NDQ4YzRkODk5I2IxNmZlNmRmLTBlMTYtNDU0ZC05NTY5LTE2Mzc4NjI4NDFhNQ",
          //       authorization:
          //         "Basic " +
          //         btoa(
          //           import.meta.env.VITE_APP_THAID_CLIENTID +
          //             ":" +
          //             import.meta.env.VITE_APP_THAID_CLIENT_SECRET
          //         ),

          //       //   bbA1vJhFiMYTZPPHYXZGLnRootVdDg17byrnBTyJ
          //     }
          //   );

          const headers = {
            "Content-Type": "application/x-www-form-urlencoded",
            Authorization:
              "Basic " +
              btoa(
                import.meta.env.VITE_APP_THAID_CLIENTID +
                  ":" +
                  import.meta.env.VITE_APP_THAID_CLIENT_SECRET
              ),
          };

          axios
            .post(
              "https://imauth.bora.dopa.go.th/api/v2/oauth2/token/",
              {
                grant_type: "authorization_code",
                redirect_uri: import.meta.env.VITE_APP_THAID_REDIRECT_URI,
                code: "NmY0MTVhNTItMDc3MC00ZjkzLTkyZTUtODI3NDU1Y2FiY2I3IzJlMWYzZGZlLTI5OWItNGNkNi1hODExLWE0NjMxY2RhYzcyNw",
              },
              {
                headers: headers,
              }
            )
            .then((response) => {
              console.log(response);
            })
            .catch((error) => {});

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
