<template>
  <!--begin::Wrapper-->
  <div class="container p-10 mt-2 pb-0">
    <div class="text-end">
      <router-link
        to="/sign-in"
        class="fw-bold text-gray-800 text-hover-primary fs-7"
        >{{ $t('sign_in') }}</router-link
      >
    </div>

    <h2 class="mt-5 mb-5 text-black">{{ $t("Choose_Menu") }}</h2>
    <div class="row g-4 g-xl-4">
      <div class="col-xl-6 mt-3" v-for="(hm, idx) in home_menus" :key="idx">
        <div class="card card-xl-stretch" :class="[`bg-${hm.bgColor}`]">
          <div
            class="card-body d-flex align-items-center pt-4 pb-6 cursor-pointer"
            :class="[`text-${hm.textColor}`, `text-hover-${hm.textHoverColor}`]"
            @click="onRouterLink(hm)"
          >
            <KTIcon
              :icon-name="hm.icon"
              :icon-class="`text-${hm.iconColor} fs-5x mx-n1`"
            />

            <div class="d-flex flex-column flex-grow-1 py-2 py-lg-10 ms-8">
              <span class="fw-bold fs-2 mb-2">{{ $t(hm.name) }}</span>

              <span
                class="fw-semibold text-muted fs-5"
                :class="[
                  `text-${hm.textColor}`,
                  `text-hover-${hm.textHoverColor}`,
                ]"
                >{{ hm.subName }}</span
              >
            </div>
          </div>
          <!--  -->
        </div>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref } from "vue";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "home",
  components: {},
  setup() {
    const router = useRouter();

    const home_menus = [
      {
        id: 1,
        name: "Complaint_Menu",
        name_short: "ร้องเรียน",
        subName: "",
        route: "/appeal",
        icon: "document",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "primary",
      },
      {
        id: 2,
        name: "TipOff_Menu",
        name_short: "แจ้งเบาะแส",
        subName: "",
        route: "/appeal",
        icon: "message-text-2",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "primary",
      },
      {
        id: 3,
        name: "Drug_Menu",
        name_short: "แจ้งเบาะแสยาเสพติด",
        subName: "",
        route: "/appeal",
        icon: "virus",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "danger",
      },
      {
        id: 4,
        name: "Police_Complaint_Menu",
        name_short: "ร้องเรียน",
        subName: "",
        route: "/appeal",
        icon: "address-book",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "warning",
      },
      {
        name: "Tracking",
        subName: "",
        route: "/tracking",
        icon: "notification-on",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "success",
      },
      {
        name: "Manual",
        subName: "",
        route: "/manual",
        icon: "book",
        textColor: "white",
        textHoverColor: "dark",
        iconColor: "white",
        bgColor: "info",
      },
    ];

    const onRouterLink = (hm: any) => {
      router.push({
        path: hm.route,
        query: {
          type_id: hm.id,
        },
      });
    };

    return {
      getAssetPath,
      home_menus,
      onRouterLink,
    };
  },
});
</script>
