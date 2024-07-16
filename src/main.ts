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
// import VueGtag from "vue-gtag";

import { abilitiesPlugin } from "@casl/vue";
import ability from "./services/ability";
import abilityPlugin from "./plugins/abilityPlugin";
import { useAbilityStore } from "@/stores/ability";

//imports for app initialization
import ApiService from "@/core/services/ApiService";
import { initApexCharts } from "@/core/plugins/apexcharts";
import { initInlineSvg } from "@/core/plugins/inline-svg";
import { initVeeValidate } from "@/core/plugins/vee-validate";
import { initKtIcon } from "@/core/plugins/keenthemes";
import "@/core/plugins/prismjs";
// import VueGoogleMaps from "@fawmi/vue-google-maps";
const app = createApp(App);

app.use(createPinia());
app.use(router);
app.use(ElementPlus);

// app.use(VueGtag, {
//   config: {
//     id: "G-0B7JRGBX5F",
//     params: {
//       anonymize_ip: true,
//     },
//   },
// });

const abilityStore = useAbilityStore();
abilityStore.loadAbility();

app.use(abilitiesPlugin, abilityStore.ability, {
  useGlobalProperties: true,
});
// app.use(abilitiesPlugin, ability);
app.use(abilityPlugin);

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
