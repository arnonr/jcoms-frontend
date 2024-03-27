import { ref } from "vue";
import { defineStore } from "pinia";

export const useTypeStore = defineStore("type", () => {
  const errors = ref<object>({});
  const type = ref<object>({});

  function setType(authType: object) {
    type.value = authType;
  }
  
  return {
    type,
    setType,
  };
});
