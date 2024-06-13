<template>
  <template v-for="(item, i) in MainMenuConfig" :key="i">
    <template v-if="!item.heading">
      <template v-for="(menuItem, j) in item.pages" :key="j">
        <div v-if="menuItem.heading" class="menu-item me-lg-1">
          <router-link
            v-if="menuItem.route"
            class="menu-link"
            :to="menuItem.route"
            active-class="active"
          >
            <span class="menu-title">{{ translate(menuItem.heading) }}</span>
          </router-link>
        </div>
      </template>
    </template>
    <div
      v-if="item.heading"
      data-kt-menu-trigger="click"
      data-kt-menu-placement="bottom-start"
      class="menu-item menu-lg-down-accordion me-lg-1"
    >
      <span
        v-if="item.route"
        class="menu-link py-3"
        :class="{ active: hasActiveChildren(item.route) }"
      >
        <span class="menu-title">{{ translate(item.heading) }}</span>
        <span class="menu-arrow d-lg-none"></span>
      </span>
      <div
        class="menu-sub menu-sub-lg-down-accordion menu-sub-lg-dropdown menu-rounded-0 py-lg-4 w-lg-225px"
      >
        <template v-for="(menuItem, j) in item.pages" :key="j">
          <div
            v-if="menuItem.sectionTitle"
            data-kt-menu-trigger="{default:'click', lg: 'hover'}"
            data-kt-menu-placement="right-start"
            class="menu-item menu-lg-down-accordion"
          >
            <span
              v-if="menuItem.route"
              class="menu-link py-3"
              :class="{ active: hasActiveChildren(menuItem.route) }"
            >
              <span class="menu-icon">
                <i
                  v-if="headerMenuIcons === 'bootstrap'"
                  :class="menuItem.bootstrapIcon"
                  class="bi fs-3"
                ></i>
                <KTIcon
                  v-if="headerMenuIcons === 'keenthemes'"
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
              class="menu-sub menu-sub-lg-down-accordion menu-sub-lg-dropdown menu-active-bg py-lg-4 w-lg-225px"
            >
              <template v-for="(menuItem1, k) in menuItem.sub" :key="k">
                <div
                  v-if="menuItem1.sectionTitle"
                  data-kt-menu-trigger="{default:'click', lg: 'hover'}"
                  data-kt-menu-placement="right-start"
                  class="menu-item menu-lg-down-accordion"
                >
                  <span
                    v-if="menuItem1.route"
                    class="menu-link py-3"
                    :class="{ active: hasActiveChildren(menuItem1.route) }"
                  >
                    <span class="menu-bullet">
                      <span class="bullet bullet-dot"></span>
                    </span>
                    <span class="menu-title">{{
                      translate(menuItem1.sectionTitle)
                    }}</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div
                    class="menu-sub menu-sub-lg-down-accordion menu-sub-lg-dropdown menu-active-bg py-lg-4 w-lg-225px"
                  >
                    <template v-for="(menuItem2, l) in menuItem1.sub" :key="l">
                      <div class="menu-item">
                        <router-link
                          v-if="menuItem2.route && menuItem2.heading"
                          class="menu-link py-3"
                          active-class="active"
                          :to="menuItem2.route"
                        >
                          <span class="menu-bullet">
                            <span class="bullet bullet-dot"></span>
                          </span>
                          <span class="menu-title">{{
                            translate(menuItem2.heading)
                          }}</span>
                        </router-link>
                      </div>
                    </template>
                  </div>
                </div>
                <div v-if="menuItem1.heading" class="menu-item">
                  <router-link
                    v-if="menuItem1.route"
                    class="menu-link"
                    active-class="active"
                    :to="menuItem1.route"
                  >
                    <span class="menu-bullet">
                      <span class="bullet bullet-dot"></span>
                    </span>
                    <span class="menu-title">{{
                      translate(menuItem1.heading)
                    }}</span>
                  </router-link>
                </div>
              </template>
            </div>
          </div>
          <div v-if="menuItem.heading" class="menu-item">
            <router-link
              v-if="menuItem.route && menuItem.route"
              class="menu-link"
              active-class="active"
              :to="menuItem.route"
            >
              <span class="menu-icon">
                <KTIcon icon-name="element-8" icon-class="fs-2" />
              </span>
              <span class="menu-title">{{ translate(menuItem.heading) }}</span>
            </router-link>
          </div>
        </template>
      </div>
    </div>
  </template>

  <!-- Change Language -->

  <div
    data-kt-menu-trigger="click"
    data-kt-menu-placement="bottom-start"
    class="menu-item menu-lg-down-accordion me-lg-1"
  >
    <TranslateWidget />
    <!-- <div class="dropdown">
      <button
        class="btn btn-secondary dropdown-toggle"
        type="button"
        id="dropdownMenu2"
        data-bs-toggle="dropdown"
        aria-expanded="false"
      >
        {{ currentLangugeLocale.name }}
        <img
          class="w-15px h-15px rounded-1 ms-2"
          :src="currentLangugeLocale.flag"
          alt="metronic"
        />
      </button>

      <ul class="dropdown-menu" aria-labelledby="dropdownMenu2">
        <li v-for="(country, idx) in countries" :key="idx">
          <button class="dropdown-item" type="button" @click="setLang(idx)">
            {{ country.name }}
            <img
              class="w-15px h-15px rounded-1 ms-2"
              :src="country.flag"
              alt="metronic"
            />
          </button>
        </li>
      </ul>
    </div> -->

    <!-- :class="{ active: hasActiveChildren(item.route) } -->
    <span class="menu-link py-3">
      <span class="menu-arrow d-lg-none"></span>
    </span>
  </div>
  <!--  -->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, computed } from "vue";
import { useRoute } from "vue-router";
import { useI18n } from "vue-i18n";
import MainMenuConfig from "@/layouts/home-layout/config/MainMenuConfig";
import { headerMenuIcons } from "@/layouts/home-layout/config/helper";
import TranslateWidget from "@/components/translate/TranslateWidget.vue";

export default defineComponent({
  name: "KTMenu",
  components: { TranslateWidget },
  setup() {
    const { t, te } = useI18n();
    const route = useRoute();
    const i18n = useI18n();

    const hasActiveChildren = (match: string) => {
      return route.path.indexOf(match) !== -1;
    };

    const translate = (text: string) => {
      if (te(text)) {
        return t(text);
      } else {
        return text;
      }
    };

    i18n.locale.value = localStorage.getItem("lang")
      ? (localStorage.getItem("lang") as string)
      : "th";

    const countries = {
      th: {
        flag: getAssetPath("media/flags/thailand.svg"),
        name: "Thai",
      },
      en: {
        flag: getAssetPath("media/flags/united-states.svg"),
        name: "English",
      },
    };

    const currentLangugeLocale = computed(() => {
      return countries[i18n.locale.value as keyof typeof countries];
    });

    const setLang = (lang: string) => {
      localStorage.setItem("lang", lang);
      i18n.locale.value = lang;
    };

    return {
      hasActiveChildren,
      headerMenuIcons,
      MainMenuConfig,
      translate,
      getAssetPath,
      currentLangugeLocale,
      countries,
      setLang,
    };
  },
});
</script>

<style scoped>
.app-header-menu .menu .menu-item .menu-link .menu-title {
  color: #000;
}
</style>

<style>

/* .goog-te-combo > option[value="th"] {
  display: visible !important;
} */
/* :not([value='th'] */

/* .goog-te-menu2 .goog-te-menu2-item-selected {
  display: block;
}

.goog-te-menu2 .goog-te-menu2-item span.text:lang(en),
.goog-te-menu2 .goog-te-menu2-item span.text:lang(es),
.goog-te-menu2 .goog-te-menu2-item span.text:lang(fr) {
  display: block;
} */
</style>
