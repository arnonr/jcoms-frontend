<template>
  <!--begin::Header-->
  <div
    v-if="headerDisplay"
    id="kt_app_header"
    class="app-header"
    style="left: 0 !important; height: 100px; background-color: #1abbf8"
  >
    <!--begin::Header container-->
    <div
      class="app-container d-flex align-items-stretch justify-content-between"
      :class="{
        'container-fluid': headerWidthFluid,
        'container-xxl': !headerWidthFluid,
      }"
    >
      <div
        v-if="layout === 'light-header' || layout === 'dark-header'"
        class="d-flex align-items-center flex-grow-1 flex-lg-grow-0 me-lg-15"
      >
        <router-link to="/">
          <img
            v-if="themeMode === 'light' && layout === 'light-header'"
            alt="Logo"
            :src="getAssetPath('media/logos/default.svg')"
            class="h-20px h-lg-30px app-sidebar-logo-default theme-light-show"
          />
          <img
            v-if="
              layout === 'dark-header' ||
              (themeMode === 'dark' && layout === 'light-header')
            "
            alt="Logo"
            :src="getAssetPath('media/logos/default-dark.svg')"
            class="h-20px h-lg-30px app-sidebar-logo-default"
          />
        </router-link>
      </div>
      <template v-else>
        <!--begin::sidebar mobile toggle-->
        <div
          class="d-flex align-items-center d-lg-none ms-n3 me-1 me-md-2"
          v-tooltip
          title="Show sidebar menu"
        >
          <div
            class="btn btn-icon btn-active-color-primary w-35px h-35px"
            id="kt_app_sidebar_mobile_toggle"
          >
            <KTIcon icon-name="abstract-14" icon-class="fs-2 fs-md-1" />
          </div>
        </div>
        <!--end::sidebar mobile toggle-->
        <!--begin::Mobile logo-->
        <div
          class="d-flex align-items-center flex-grow-1 flex-lg-grow-0 d-lg-none d-none"
        >
          <router-link to="/" class="d-lg-none">
            <img
              alt="Logo"
              :src="getAssetPath('media/logos/logo_jaray.svg')"
              class="h-30px"
            />
          </router-link>
        </div>
        <!--end::Mobile logo-->
      </template>
      <!--begin::Header wrapper-->
      <div
        class="d-flex align-items-stretch justify-content-between flex-lg-grow-1"
        id="kt_app_header_wrapper"
      >
        <div>
          <div class="d-inline-block align-top mt-2">
            <img src="/media/logos/logo_jaray.svg" alt="" style="width: 70px" />
          </div>
          <div class="d-inline-block d-none d-lg-inline-block">
            <h2 class="ms-5 mt-7 text-white">ระบบร้องเรียนเจ้าหน้าที่ตำรวจ</h2>
            <h3 class="ms-5 text-white">สำนักงานจเรตำรวจ</h3>
          </div>
          <div class="d-inline-block d-lg-none mt-2">
            <h6 class="ms-5 mt-7 text-white">ระบบร้องเรียนเจ้าหน้าที่ตำรวจ</h6>
            <h6 class="ms-5 text-white">สำนักงานจเรตำรวจ</h6>
          </div>
        </div>
        <KTHeaderMenu />
        <!-- <KTHeaderNavbar /> -->
      </div>
      <!--end::Header wrapper-->
    </div>
    <!--end::Header container-->
  </div>
  <!--end::Header-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent } from "vue";
import KTHeaderMenu from "@/layouts/home-layout/components/header/menu/Menu.vue";
import KTHeaderNavbar from "@/layouts/home-layout/components/header/Navbar.vue";
import {
  headerDisplay,
  headerWidthFluid,
  layout,
  themeMode,
  headerDesktopFixed,
  headerMobileFixed,
} from "@/layouts/default-layout/config/helper";

export default defineComponent({
  name: "layout-header",
  components: {
    KTHeaderMenu,
    KTHeaderNavbar,
  },
  setup() {
    return {
      layout,
      headerWidthFluid,
      headerDisplay,
      themeMode,
      getAssetPath,
      headerDesktopFixed,
      headerMobileFixed,
    };
  },
});
</script>
