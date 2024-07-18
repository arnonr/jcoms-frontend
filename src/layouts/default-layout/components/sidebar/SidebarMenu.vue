<template>
  <!--begin::sidebar menu-->
  <div class="app-sidebar-menu overflow-hidden flex-column-fluid">
    <!--begin::Menu wrapper-->
    <div
      id="kt_app_sidebar_menu_wrapper"
      class="app-sidebar-wrapper hover-scroll-overlay-y my-5"
      data-kt-scroll="true"
      data-kt-scroll-activate="true"
      data-kt-scroll-height="auto"
      data-kt-scroll-dependencies="#kt_app_sidebar_logo, #kt_app_sidebar_footer"
      data-kt-scroll-wrappers="#kt_app_sidebar_menu"
      data-kt-scroll-offset="5px"
      data-kt-scroll-save-state="true"
    >
      <!--begin::Menu-->
      <div
        id="#kt_app_sidebar_menu"
        class="menu menu-column menu-rounded menu-sub-indention px-3"
        data-kt-menu="true"
      >
        <template v-for="(item, i) in MainMenuConfig" :key="i">
          <div v-if="item.heading" class="menu-item pt-5">
            <div class="menu-content">
              <span class="menu-heading fw-bold text-uppercase fs-7">
                {{ translate(item.heading) }}
              </span>
            </div>
          </div>
          <template v-for="(menuItem, j) in item.pages" :key="j">
            <template
              v-if="
                (menuItem.route == '/dashboard' && canViewDashboard) ||
                (menuItem.route == '/new-complaint' && canViewNewComplaint) ||
                (menuItem.route == '/complaint' && canViewComplaint) ||
                (menuItem.route == '/report-complaint' && canViewReport) ||
                (menuItem.route == '/report' && canViewReport) ||
                (menuItem.route == '/report-complaint-type' && canViewReport) ||
                (menuItem.route == '/report-complaint-channel' &&
                  canViewReport) ||
                (menuItem.route == '/report-complaint-topic-type' &&
                  canViewReport) ||
                (menuItem.route == '/report-complaint-organization' &&
                  canViewReport) ||
                (menuItem.route == '/report-satisfaction' &&
                  canViewReportSatis) ||
                (menuItem.route == '/report-login' && canViewReportLogin) ||
                (menuItem.route == '/report-visit-website-log' &&
                  canViewReportLogin) ||
                (menuItem.route == '/user' && canViewUser) ||
                (menuItem.route == '/permission-org' && canViewPermissionOrg)
              "
            >
              <!-- v-if="
                (menuItem.heading &&
                  ((menuItem.route == '/user' && userData.role_id == 1) ||
                    (menuItem.route == '/new-complaint' &&
                      (userData.role_id == 1 || userData.role_id == 2)) ||
                    (menuItem.route != '/new-complaint' &&
                      menuItem.route != '/user'))) ||
                (menuItem.route == '/dashboard' && canViewDashboard) ||
                (menuItem.route == '/new-complaint' && canViewNewComplaint)
              " -->
              <div class="menu-item">
                <router-link
                  v-if="menuItem.route"
                  class="menu-link"
                  active-class="active"
                  :to="menuItem.route"
                >
                  <span
                    v-if="menuItem.keenthemesIcon || menuItem.bootstrapIcon"
                    class="menu-icon"
                  >
                    <i
                      v-if="sidebarMenuIcons === 'bootstrap'"
                      :class="menuItem.bootstrapIcon"
                      class="bi fs-3"
                    ></i>
                    <KTIcon
                      v-else-if="sidebarMenuIcons === 'keenthemes'"
                      :icon-name="menuItem.keenthemesIcon"
                      icon-class="fs-2"
                    />
                  </span>
                  <span class="menu-title">
                    {{ menuItem.heading }}
                    <!-- // translate(menuItem.heading) -->
                  </span>
                </router-link>
              </div>
            </template>
            <div
              v-if="menuItem.sectionTitle && menuItem.route"
              :class="{ show: hasActiveChildren(menuItem.route) }"
              class="menu-item menu-accordion"
              data-kt-menu-sub="accordion"
              data-kt-menu-trigger="click"
            >
              <span class="menu-link">
                <span
                  v-if="menuItem.keenthemesIcon || menuItem.bootstrapIcon"
                  class="menu-icon"
                >
                  <i
                    v-if="sidebarMenuIcons === 'bootstrap'"
                    :class="menuItem.bootstrapIcon"
                    class="bi fs-3"
                  ></i>
                  <KTIcon
                    v-else-if="sidebarMenuIcons === 'keenthemes'"
                    :icon-name="menuItem.keenthemesIcon"
                    icon-class="fs-2"
                  />
                </span>
                <span class="menu-title">{{
                  translate(menuItem.sectionTitle)
                }}</span>
                <span class="menu-arrow"></span>
              </span>
              <div
                :class="{ show: hasActiveChildren(menuItem.route) }"
                class="menu-sub menu-sub-accordion"
              >
                <template v-for="(item2, k) in menuItem.sub" :key="k">
                  <div v-if="item2.heading" class="menu-item">
                    <router-link
                      v-if="item2.route"
                      class="menu-link"
                      active-class="active"
                      :to="item2.route"
                    >
                      <span class="menu-bullet">
                        <span class="bullet bullet-dot"></span>
                      </span>
                      <span class="menu-title">{{
                        translate(item2.heading)
                      }}</span>
                    </router-link>
                  </div>
                  <div
                    v-if="item2.sectionTitle && item2.route"
                    :class="{ show: hasActiveChildren(item2.route) }"
                    class="menu-item menu-accordion"
                    data-kt-menu-sub="accordion"
                    data-kt-menu-trigger="click"
                  >
                    <span class="menu-link">
                      <span class="menu-bullet">
                        <span class="bullet bullet-dot"></span>
                      </span>
                      <span class="menu-title">{{
                        translate(item2.sectionTitle)
                      }}</span>
                      <span class="menu-arrow"></span>
                    </span>
                    <div
                      :class="{ show: hasActiveChildren(item2.route) }"
                      class="menu-sub menu-sub-accordion"
                    >
                      <template v-for="(item3, k) in item2.sub" :key="k">
                        <div v-if="item3.heading" class="menu-item">
                          <router-link
                            v-if="item3.route"
                            class="menu-link"
                            active-class="active"
                            :to="item3.route"
                          >
                            <span class="menu-bullet">
                              <span class="bullet bullet-dot"></span>
                            </span>
                            <span class="menu-title">{{
                              translate(item3.heading)
                            }}</span>
                          </router-link>
                        </div>
                      </template>
                    </div>
                  </div>
                </template>
              </div>
            </div>
          </template>
        </template>

        <!--end:Menu item-->
      </div>
      <!--end::Menu-->
    </div>
    <!--end::Menu wrapper-->
  </div>
  <!--end::sidebar menu-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, onMounted, ref, computed } from "vue";
import { useRoute } from "vue-router";
import MainMenuConfig from "@/layouts/default-layout/config/MainMenuConfig";
import { sidebarMenuIcons } from "@/layouts/default-layout/config/helper";
import { useI18n } from "vue-i18n";
import { useAbility } from "@casl/vue";

export default defineComponent({
  name: "sidebar-menu",
  components: {},
  setup() {
    const { t, te } = useI18n();
    const route = useRoute();
    const scrollElRef = ref<null | HTMLElement>(null);

    const ability = useAbility();

    const canViewDashboard = computed(() => ability.can("view", "Dashboard"));
    const canViewNewComplaint = computed(() =>
      ability.can("view", "เรื่องรอการตรวจสอบ")
    );
    const canViewComplaint = computed(() =>
      ability.can("view", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );
    const canViewReport = computed(() => ability.can("view", "สถิติ/รายงาน"));

    const canViewReportSatis = computed(() =>
      ability.can("view", "รายงานความพึงพอใจ")
    );
    const canViewReportLogin = computed(() =>
      ability.can("view", "รายงานการเข้าใช้งาน")
    );

    const canViewUser = computed(() => ability.can("view", "ทะเบียนผู้ใช้งาน"));
    const canViewPermissionOrg = computed(() =>
      ability.can("view", "สิทธิระหว่างหน่วยงาน")
    );


    onMounted(() => {
      if (scrollElRef.value) {
        scrollElRef.value.scrollTop = 0;
      }
    });

    const translate = (text: string) => {
      if (te(text)) {
        return t(text);
      } else {
        return text;
      }
    };

    const hasActiveChildren = (match: string) => {
      return route.path.indexOf(match) !== -1;
    };

    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    return {
      hasActiveChildren,
      MainMenuConfig,
      sidebarMenuIcons,
      translate,
      getAssetPath,
      userData,
      canViewDashboard,
      canViewNewComplaint,
      canViewComplaint,
      canViewReport,
      canViewReportSatis,
      canViewReportLogin,
      canViewUser,
      canViewPermissionOrg,
    };
  },
});
</script>
