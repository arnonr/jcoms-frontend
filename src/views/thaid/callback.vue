<template>
  <div>Loading...</div>
</template>

<script setup>
import { onMounted } from "vue";
import axios from "axios";
import { useRouter } from "vue-router";

const router = useRouter();

onMounted(async () => {
  const code = new URLSearchParams(window.location.search).get("code");
  if (code) {
    try {
      const response = await axios.post(
        "https://thaid.example.com/oauth2/token",
        {
          client_id: "YOUR_CLIENT_ID",
          client_secret: "YOUR_CLIENT_SECRET",
          code: code,
          redirect_uri: "YOUR_REDIRECT_URI",
          grant_type: "authorization_code",
        }
      );
      const token = response.data.access_token;
      // ใช้ token สำหรับเรียกข้อมูลผู้ใช้ หรือจัดการ authentication
      console.log("Access Token:", token);
      router.push("/"); // เปลี่ยนเส้นทางหลังจากยืนยันตัวตนสำเร็จ
    } catch (error) {
      console.error("Error fetching access token:", error);
    }
  }
});
</script>
