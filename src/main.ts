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

//imports for app initialization
import ApiService from "@/core/services/ApiService";
import { initApexCharts } from "@/core/plugins/apexcharts";
import { initInlineSvg } from "@/core/plugins/inline-svg";
import { initVeeValidate } from "@/core/plugins/vee-validate";
import { initKtIcon } from "@/core/plugins/keenthemes";
import "@/core/plugins/prismjs";
import VueGoogleMaps from "@fawmi/vue-google-maps";

const app = createApp(App);

app.use(createPinia());
app.use(router);
app.use(ElementPlus);

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

ApiService.init(app);
initApexCharts(app);
initInlineSvg(app);
initKtIcon(app);
initVeeValidate();

app.use(i18n);

app.directive("tooltip", (el) => {
  new Tooltip(el);
});

app.mount("#app");
