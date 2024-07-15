import { useAbility } from "@casl/vue";

export default {
  install: (app: any) => {
    app.config.globalProperties.$useAbility = useAbility;
    app.provide("useAbility", useAbility);
  },
};
