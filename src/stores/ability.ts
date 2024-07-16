import { defineStore } from "pinia";
import { createMongoAbility } from "@casl/ability";

export const useAbilityStore = defineStore("ability", {
  state: () => ({
    ability: createMongoAbility(),
  }),
  actions: {
    setAbility(rules: any) {
      // ability.update(
      //   userAbilities.map((a: any) => ({ action: a.action, subject: a.menu }))
      // );
      this.ability.update(
        rules.map((a: any) => ({ action: a.action, subject: a.menu }))
      );
      localStorage.setItem("ability", JSON.stringify(rules));
    },
    loadAbility() {
      const rules = JSON.parse(localStorage.getItem("ability") || "[]");
      this.setAbility(rules);
    },
  },
});
