<template>
  <!--begin::Authentication Layout -->
  <div class="container">
    <div class="row">
      <div class="col-12 text-center mt-10">
        <router-link to="/" class="mb-0 mb-lg-12">
          <img
            alt="Logo"
            :src="getAssetPath('media/logos/logo_jaray.svg')"
            class="mx-auto"
            style="width: 10rem"
          />
        </router-link>
      </div>
      <div class="col-12">
        <div class="p-10">
          <router-view></router-view>
        </div>

      </div>
    </div>
  </div>

  <!--end::Authentication Layout -->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, onMounted } from "vue";
import LayoutService from "@/core/services/LayoutService";
import { useBodyStore } from "@/stores/body";

export default defineComponent({
  name: "auth-layout",
  components: {},
  setup() {
    const store = useBodyStore();

    onMounted(() => {
      LayoutService.emptyElementClassesAndAttributes(document.body);

      store.addBodyClassname("app-blank");
      store.addBodyClassname("bg-body");
    });

    return {
      getAssetPath,
    };
  },
});
</script>
