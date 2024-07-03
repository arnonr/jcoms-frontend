import { createApp } from "vue";
import { createPinia } from "pinia";
import { Tooltip } from "bootstrap";
import App from "./App.vue";

/*
TIP: To get started with clean router change path to @/router/clean.ts.
 */
import router from "./router";
import ElementPlus from "element-plus";
import i18n from "@/core/plugins/i18n";
import VueGtag from "vue-gtag";

//imports for app initialization
import ApiService from "@/core/services/ApiService";
import { initApexCharts } from "@/core/plugins/apexcharts";
import { initInlineSvg } from "@/core/plugins/inline-svg";
import { initVeeValidate } from "@/core/plugins/vee-validate";
import { initKtIcon } from "@/core/plugins/keenthemes";
import "@/core/plugins/prismjs";
import VueGoogleMaps from "@fawmi/vue-google-maps";
import VueMatomo from "vue-matomo";
// import VueMatomo1 from '@betomorrow/vue-matomo';

import { abilitiesPlugin } from "@casl/vue";
import ability from "./services/ability";

const app = createApp(App);

app.use(createPinia());
app.use(router);
app.use(ElementPlus);

app.use(VueGtag, {
  config: {
    id: "G-0B7JRGBX5F",
    params: {
      anonymize_ip: true,
    },
  },
});

app.use(VueMatomo, {
  host: "http://localhost/matomo/", // URL ของ Matomo ที่ติดตั้งบนเครื่อง
  siteId: 2,
  trackerFileName: "matomo", // ชื่อไฟล์ tracker, ค่ามาตรฐานคือ 'matomo'
  router: router, // หากใช้ Vue Router, ให้ผ่าน router เข้ามาด้วย
  enableLinkTracking: true, // เปิดการติดตามลิงก์
  requireConsent: false, // หากต้องการเปิดให้ผู้ใช้ยินยอมก่อนติดตามให้ตั้งค่าเป็น true
  trackInitialView: true, // เปิดการติดตามการเข้าชมหน้าแรก
});

// app.use(VueRecaptchaPlugin, {
//   v2SiteKey: "6Ld8yZopAAAAANpfKVOTJPTC9k_fxynJ_F6lbNtR",
//   v3SiteKey: "6Ld8yZopAAAAANpfKVOTJPTC9k_fxynJ_F6lbNtR"//"6Ld8yZopAAAAANVVQ4oLh9yolLDYvXHPT0_HOGxl",
// });
app.use(VueGoogleMaps, {
  load: {
    key: "AIzaSyAW9TSuY2zGSjL_1CdoaTkhz2gJApl95Zw",
    // โหลดไลบรารีที่คุณต้องการใช้งาน เช่น places หากคุณต้องการใช้งาน Google Places API
    libraries: "places", // หรือ 'places,drawing,visualization' ตามที่คุณต้องการ
  },
  autobindAllEvents: true,
});

app.use(abilitiesPlugin, ability, {
  useGlobalProperties: true,
});

ApiService.init(app);
initApexCharts(app);
initInlineSvg(app);
initKtIcon(app);
initVeeValidate();

app.use(i18n);

app.directive("tooltip", (el) => {
  new Tooltip(el);
});

// ตรวจสอบว่ามี _paq หรือไม่ หากไม่มีให้สร้างขึ้น
window._paq = window._paq || [];

app.mount("#app");
