<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container mt-5">
      <div class="card shadow-sm my-5">
        <!-- Search -->
        <div class="card-body">
          <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
            <!-- ปีที่ร้องเรียน -->
            <div class="col-12 col-md-6 my-2">
              <label for="slt-search-year">ปีที่ร้องเรียน</label>
              <v-select
                id="slt-search-year"
                name="slt-search-year"
                label="name"
                placeholder="ปีที่ร้องเรียน"
                :options="selectOptions.years"
                v-model="search.year"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <!-- เดือน -->
            <div class="col-12 col-md-6 my-2">
              <label for="slt-search-month">เดือน</label>
              <v-select
                id="slt-search-month"
                name="slt-search-month"
                label="name"
                placeholder="ทั้งหมด"
                :options="selectOptions.months"
                v-model="search.month"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <!-- หน่วยงาน บช./ภ. -->
            <div class="col-12 col-md-5 my-2">
              <label for="slt-search-month">บช./ภ.</label>
              <v-select
                id="slt-search-bureau-id"
                name="slt-search-bureau-id"
                label="name_th_abbr"
                placeholder="บช./ภ."
                :options="selectOptions.bureaus"
                v-model="search.bureau_id"
                class="form-control"
                :clearable="true"
                :disabled="disabledSearchBureau"
              ></v-select>
            </div>

            <!-- หน่วยงาน บก./ภ.จว -->
            <div class="col-12 col-md-5 my-2">
              <label for="slt-search-month">บก./ภ.จว.</label>
              <v-select
                id="slt-search-division-id"
                name="slt-search-division-id"
                label="name_th_abbr"
                placeholder="บก./ภ.จว."
                :options="selectOptions.divisions"
                v-model="search.division_id"
                class="form-control"
                :clearable="true"
                :disabled="disabledSearchDivision"
              ></v-select>
            </div>

            <!-- ปุ่มค้นหา -->
            <div class="col-12 col-md-2 my-2 d-flex align-items-end">
              <button class="btn btn-success fw-bold w-100" @click="onSearch()">
                ค้นหา
              </button>
            </div>
          </div>
        </div>

        <!-- Menu Button -->
        <div class="card-footer">
          <nav class="nav nav-pills nav-fill">
            <a
              class="nav-link"
              v-for="(ct, idx) in selectOptions.complaint_types"
              :key="idx"
              :class="{ active: activeTab === ct.name_abbr_en, 'fs-3': true }"
              aria-current="page"
              href="#"
              style="line-height: 3em"
              @click.prevent="setActiveTab(ct.name_abbr_en)"
            >
              {{ ct.name_th }}
            </a>
          </nav>
        </div>
      </div>

      <div class="row justify-content-center ms-1 d-flex">
        <div
          class="card col-sm-12 col-md-2 col-lg-2 mx-1"
          :style="[{ backgroundColor: it.bgColor }]"
          v-for="(it, idx) in cardStatus.slice(0, 5)"
          :key="idx"
        >
          <a
            class="cursor-pointer"
            @click="
              () => {
                search.status = it.status_id;
                onSearch();
              }
            "
          >
            <div class="card-body text-center px-1">
              <h5 class="card-title text-white">{{ it.description }}</h5>
              <h1 class="card-title text-dark">{{ it.total }}</h1>
            </div>
          </a>
        </div>
      </div>

      <!-- Chart -->
      <div class="card mt-15">
        <div class="card-body row">
          <div
            class="col-12 col-md-4 mx-auto"
            style="min-height: 300px; min-width: 300px"
          >
            <v-chart
              v-if="chartTopicCategoryData.series[0].data.length != 0"
              class="chart"
              :option="chartTopicCategoryData"
            />
          </div>
          <div
            class="col-12 col-md-4 mx-auto"
            style="min-height: 300px; min-width: 300px"
          >
            <v-chart
              v-if="chartChannelData.series[0].data.length != 0"
              class="chart"
              :option="chartChannelData"
            />
          </div>
          <div
            class="col-12 col-md-4 mx-auto"
            style="min-height: 300px; min-width: 300px"
          >
            <v-chart
              v-if="chartSectionData.series[0].data.length != 0"
              class="chart"
              :option="chartSectionData"
            />
          </div>
        </div>
      </div>

      <div class="col-12 col-md-12 mb-3 mt-15 card">
        <div class="card-body">
          <v-chart
            class="chart"
            :option="chartOrganizationData"
            style="height: 400px; width: 100%"
          />
        </div>
      </div>

      <div class="card mt-5">
        <div class="card-body row">
          <div class="col-12 col-md-12 mb-3 mt-10">
            <h6>สถิติเรื่องร้องเรียน (แยกตามหน่วยงาน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">หน่วยงาน</th>
                  <th class="text-center text-white">รับเรื่อง</th>
                  <th class="text-center text-white">ค้าง</th>
                  <th class="text-center text-white">เสร็จ</th>
                </tr>
              </thead>
              <tbody v-if="organization_data.datas.length != 0">
                <tr v-for="(or, idx) in organization_data.datas" :key="idx">
                  <td
                    class="text-center fw-bold cursor-pointer"
                    @click="openSubOrganizationModal(or.divisions)"
                  >
                    {{ or.name }}
                  </td>
                  <td class="text-center">
                    {{ or.receive }}
                  </td>

                  <td class="text-center">
                    {{ or.send }}
                  </td>

                  <td class="text-center">
                    {{ or.success }}
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="10">
                    <div class="text-center"><span>ไม่พบข้อมูล</span></div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="card mt-5">
        <div class="card-body row">
          <div class="col-12 col-md-12 mb-3 mt-10">
            <h6>สถิติเรื่องร้องเรียน (แยกตามสายงาน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">หน่วยงาน</th>
                  <th
                    class="text-center text-white"
                    v-for="(sc, idx) in selectOptions.sections"
                    :key="idx"
                  >
                    {{ sc.name_th }}
                  </th>
                </tr>
              </thead>
              <tbody v-if="organization_data.datas.length != 0">
                <tr v-for="(or, idx) in organization_data.datas" :key="idx">
                  <td class="text-center fw-bold">{{ or.name }}</td>
                  <td
                    class="text-center"
                    v-for="(ors, idx) in or.sections"
                    :key="idx"
                  >
                    {{ ors.count_section_org }}
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="10">
                    <div class="text-center"><span>ไม่พบข้อมูล</span></div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="row card-body">
          <div class="col-12 col-md-6 mb-3 mt-10">
            <h6>สถิติเรื่องร้องเรียน (แยกตามประเภทเรื่องร้องเรียน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">
                    ประเภทเรื่อง {{ complaint_type.name_th }}
                  </th>
                  <th class="text-center text-white">รับเรื่อง</th>
                  <th class="text-center text-white">ค้าง</th>
                  <th class="text-center text-white">เสร็จ</th>
                </tr>
              </thead>
              <tbody v-if="topic_category_data.datas.length != 0">
                <tr v-for="(tc, idx) in topic_category_data.datas" :key="idx">
                  <td class="fw-bold">{{ tc.name }}</td>

                  <td class="text-center">
                    {{ tc.count_receive }}
                  </td>
                  <td class="text-center">
                    {{ tc.count_send }}
                  </td>
                  <td class="text-center">
                    {{ tc.count_success }}
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="10">
                    <div class="text-center"><span>ไม่พบข้อมูล</span></div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="col-12 col-md-6 mb-3 mt-10">
            <h6>สถิติเรื่องร้องเรียน (แยกตามช่องทางร้องเรียน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">ช่องทางการร้องเรียน</th>
                  <th class="text-center text-white">รับเรื่อง</th>
                  <th class="text-center text-white">ค้าง</th>
                  <th class="text-center text-white">เสร็จ</th>
                </tr>
              </thead>
              <tbody v-if="complaint_channel_data.datas.length != 0">
                <tr
                  v-for="(cc, idx) in complaint_channel_data.datas"
                  :key="idx"
                >
                  <td class="fw-bold">{{ cc.name }}</td>
                  <!-- <td class="text-center">
                        {{ cc.value }}
                    </td> -->

                  <td class="text-center">
                    {{ cc.count_receive }}
                  </td>
                  <td class="text-center">
                    {{ cc.count_send }}
                  </td>
                  <td class="text-center">
                    {{ cc.count_success }}
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="10">
                    <div class="text-center"><span>ไม่พบข้อมูล</span></div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div>
      <sub-organization-modal
        v-if="openSubOrgModal == true"
        :subOrganizations="selectedSubOrganizations"
        @close-modal="
          () => {
            openSubOrgModal = false;
          }
        "
      ></sub-organization-modal>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref, reactive, watch, provide } from "vue";
import ApiService from "@/core/services/ApiService";
import { Modal } from "bootstrap";
import { useRouter } from "vue-router";
// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// Import echarts
import * as echarts from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { PieChart, BarChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
} from "echarts/components";
import VChart, { THEME_KEY } from "vue-echarts";

// Import Store
import { useSearchComplaintStore } from "@/stores/searchComplaint";

// Components
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useOrganizationData from "@/composables/useOrganizationData";
import SubOrganizationModal from "@/components/dashboard/SubOrganizationModal.vue";

echarts.use([
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  BarChart,
  PieChart,
  CanvasRenderer,
]);

export default defineComponent({
  name: "dashboard",
  components: {
    VueDatePicker,
    dayjs,
    vSelect,
    BlogPagination,
    VChart,
    SubOrganizationModal,
  },
  setup() {
    // UI
    provide(THEME_KEY, "light");
    const activeTab = ref("complaints"); // ค่าเริ่มต้น
    const searchComplaintStore = useSearchComplaintStore();
    const setActiveTab = (tab: string) => {
      activeTab.value = tab;
      complaint_type.value = selectOptions.value.complaint_types.find(
        (x: any) => {
          return x.name_abbr_en == activeTab.value;
        }
      );
    };

    const openSubOrgModal = ref(false);

    const complaint_type = ref({
      id: 1,
      name_th: "ร้องเรียน",
      name_en: null,
      name_abbr_en: "complaints",
      is_active: 1,
    });

    // Variable
    const router = useRouter();
    const selectedSubOrganizations = ref([]);

    const openSubOrganizationModal = (subOrgs: any) => {
      selectedSubOrganizations.value = subOrgs;
      console.log(subOrgs);
      openSubOrgModal.value = true;
    };

    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };
    const disabledSearchDivision = ref(true);
    const disabledSearchBureau = ref(true);

    const cardStatus = ref([
      {
        status_id: 1,
        description: "ทั้งหมด",
        bgColor: "#1B84FF",
        total: 0,
      },
      {
        status_id: 2,
        description: "รอตรวจสอบ",
        bgColor: "#F8285A",
        total: 0,
      },
      {
        status_id: 3,
        description: "รับเรื่อง/รอดำเนินการ",
        bgColor: "#FFC107",
        total: 0,
      },
      {
        status_id: 4,
        description: "ส่งหน่วย/ระหว่างดำเนินการ",
        bgColor: "#A00001",
        total: 0,
      },
      {
        status_id: 5,
        description: "ตรวจสอบเสร็จสิ้น",
        bgColor: "#17c653",
        total: 0,
      },
    ]);

    const defaultTopicCategories = [
      {
        id: 1,
        name_th: "ทุจริตต่อหน้าที่",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 2,
        name_th: "ปฎิบัติหน้าที่มิชอบ",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 3,
        name_th: "ประพฤติตนไม่สมควร",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 4,
        name_th: "ไม่บริการประชาชน",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 5,
        name_th: "ขอความเป็นธรรม",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 6,
        name_th: "บัตรสนเท่ห์ร้องเรียนการปฏิบัติหน้าที่ของเจ้าหน้าที่ตำรวจ",
        name_en: null,
        complaint_type_id: 1,
        count: 0,
        count_accused: 0,
      },
      {
        id: 7,
        name_th: "ขอความช่วยเหลือ",
        name_en: null,
        complaint_type_id: 2,
        count: 0,
        count_accused: 0,
      },
      {
        id: 8,
        name_th: "แจ้งเบาะแส/แนะนำ",
        name_en: null,
        complaint_type_id: 2,
        count: 0,
        count_accused: 0,
      },
      {
        id: 10,
        name_th: "แจ้งเบาะแสยาเสพติด",
        name_en: null,
        complaint_type_id: 2,
        count: 0,
        count_accused: 0,
      },
      {
        id: 11,
        name_th: "แจ้งเบาะแสยาเสพติด",
        name_en: null,
        complaint_type_id: 3,
        count: 0,
        count_accused: 0,
      },
      {
        id: 12,
        name_th: "ทุจริตต่อหน้าที่",
        name_en: null,
        complaint_type_id: 4,
        count: 0,
        count_accused: 0,
      },
    ];

    const defaultBureaus = [
      {
        id: 27,
        name_th: "กองบัญชาการตำรวจนครบาล",
        name_th_abbr: "บช.น.",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 10,
        count_org: 0,
      },
      {
        id: 28,
        name_th: "ตำรวจภูธรภาค 1",
        name_th_abbr: "ภ.1",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 1,
        count_org: 0,
      },
      {
        id: 29,
        name_th: "ตำรวจภูธรภาค 2",
        name_th_abbr: "ภ.2",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 2,
        count_org: 0,
      },
      {
        id: 30,
        name_th: "ตำรวจภูธรภาค 3",
        name_th_abbr: "ภ.3",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 3,
        count_org: 0,
        count_section: 0,
      },
      {
        id: 31,
        name_th: "ตำรวจภูธรภาค 4",
        name_th_abbr: "ภ.4",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 4,
        count_org: 0,
      },
      {
        id: 32,
        name_th: "ตำรวจภูธรภาค 5",
        name_th_abbr: "ภ.5",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 5,
        count_org: 0,
      },
      {
        id: 33,
        name_th: "ตำรวจภูธรภาค 6",
        name_th_abbr: "ภ.6",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 6,
        count_org: 0,
      },
      {
        id: 34,
        name_th: "ตำรวจภูธรภาค 7",
        name_th_abbr: "ภ.7",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 7,
        count_org: 0,
      },
      {
        id: 35,
        name_th: "ตำรวจภูธรภาค 8",
        name_th_abbr: "ภ.8",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 8,
        count_org: 0,
      },
      {
        id: 36,
        name_th: "ตำรวจภูธรภาค 9",
        name_th_abbr: "ภ.9",
        name_en: null,
        name_en_abbr: null,
        inspector_id: 9,
        count_org: 0,
      },
      {
        id: 100,
        name_th: "อื่น ๆ",
        name_th_abbr: "อื่น ๆ",
        name_en: null,
        count_org: 0,
      },
    ];

    const defaultDivisions = useOrganizationData().division_organizations;

    const defaultAgencys = useOrganizationData().agency_organizations;

    const selectOptions = ref<any>({
      inspectors: [],
      bureaus: [],
      divisions: [],
      agency: [],
      years: [],
      months: [
        { value: null, name: "ทั้งหมด" },
        { value: "01", name: "มกราคม" },
        { value: "02", name: "กุมภาพันธ์" },
        { value: "03", name: "มีนาคม" },
        { value: "04", name: "เมษายน" },
        { value: "05", name: "พฤษภาคม" },
        { value: "06", name: "มิถุนายน" },
        { value: "07", name: "กรกฏาคม" },
        { value: "08", name: "สิงหาคม" },
        { value: "09", name: "กันยายน" },
        { value: "10", name: "ตุลาคม" },
        { value: "11", name: "พฤศจิกายน" },
        { value: "12", name: "ธันวาคม" },
      ],
      complaint_types: useComplaintTypeData().complaint_types.map((x: any) => {
        if (x.id == 1) x.name_abbr_en = "complaints";
        if (x.id == 2) x.name_abbr_en = "tips";
        if (x.id == 3) x.name_abbr_en = "drug-tips";
        if (x.id == 4) x.name_abbr_en = "police-complaints";
        return x;
      }),
      complaint_statuses: [
        { name: "ทั้งหมด", value: 1 },
        { name: "เรื่องร้องเรียนใหม่", value: 2 },
        { name: "รับเข้าระบบ", value: 3 },
        { name: "ส่งหน่วยตรวจสอบ", value: 4 },
        { name: "อยู่ระหว่างตรวจสอบ", value: 6 },
        { name: "ตรวจสอบเสร็จสิ้น", value: 5 },
      ],
      sections: [
        {
          id: 2,
          name_th: "งานอำนวยการ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 1,
          name_th: "งานป้องกันและปราบปราม",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 6,
          name_th: "งานจราจร",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 4,
          name_th: "งานสืบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 5,
          name_th: "งานสอบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 999,
          name_th: "อื่น ๆ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
        {
          id: 11,
          name_th: "ไม่ระบุ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
          count_section_org: 0,
        },
      ],
      complaint_channels: [
        {
          id: 1,
          name_th: "ร้องเรียนด้วยตนเอง",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 2,
          name_th: "จดหมาย",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 3,
          name_th: "สำนักงานปลัดสำนักนายกรัฐมนตรี",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 4,
          name_th: "1599 ศปก.ตร.",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 5,
          name_th: "ผู้บังคับบัญชา",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 6,
          name_th: "หนังสือพิมพ์, social, สื่อมวลชน",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 7,
          name_th: "หน่วยงานราชการอื่น ๆ",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 8,
          name_th: "JCOM ร้องเรียน/แจ้งเบาะแส ",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
        {
          id: 9,
          name_th: "อื่น ๆ",
          name_en: null,
          count: 0,
          count_accused: 0,
        },
      ],
      organizations: defaultBureaus,
      topic_categories: [],
    });

    const search = reactive<any>({});

    const items = reactive<any>([]);
    const item = reactive({});
    const reject_items = ref<any>([]);
    const receive1_items = ref<any>([]);
    const send1_items = ref<any>([]);
    const during_items = ref<any>([]);
    const success_items = ref<any>([]);
    const wating1_items = ref<any>([]);

    const filter_type = ref<any>(1);

    const item_statuses = ref<any>({
      all_items: [],
      wating_items: <any>[],
      receive_items: [],
      send_items: [],
      success_items: [],
    });

    const defaultParams = { perPage: 100000, orderBy: "name_th", order: "asc" };

    const calYear = () => {
      let year = new Date().getFullYear();
      for (let i = 0; i <= 10; i++) {
        selectOptions.value.years.push({
          name: year - i + 543,
          value: Number(year - i),
        });
      }
      selectOptions.value.years.push({
        name: "ทั้งหมด",
        value: null,
      });
    };
    calYear();

    //
    const defaultPieChart = {
      title: {
        text: "",
        left: "center",
      },
      tooltip: {
        trigger: "item",
      },
      labels: [],
      series: [
        {
          name: "",
          type: "pie",
          radius: "55%",
          // avoidLabelOverlap: false,
          // center: ["50%", "60%"],
          data: [],
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: "rgba(0, 0, 0, 0.5)",
            },
          },
          label: {
            show: true,
            position: "outside",
            fontSize: 10,
            formatter: "{b}",
            overflow: "breakAll",
            width: 300, // เพิ่ม width
            alignTo: "none",
            bleedMargin: 10,
            minAngle: 0,
            lineHeight: 20,
          },
          labelLine: {
            show: true,
          },
        },
      ],
      responsive: true,
      maintainAspectRatio: true,
    };
    const topic_category_data = ref<any>({
      labels: [],
      datas: [],
    });
    const chartTopicCategoryData = ref<any>({
      ...defaultPieChart,
      title: {
        text: "สถิติเรื่องร้องเรียน (แยกตามประเภทเรื่อง)",
        left: "center",
      },
    });
    //
    const complaint_channel_data = ref<any>({
      labels: [],
      datas: [],
    });
    const chartChannelData = ref<any>({
      ...defaultPieChart,
      title: {
        text: "สถิติเรื่องร้องเรียน (แยกตามช่องทางการร้องเรียน)",
        left: "center",
      },
    });
    //
    const section_data = ref<any>({
      labels: [],
      datas: [],
    });
    const chartSectionData = ref<any>({
      ...defaultPieChart,
      title: {
        text: "สถิติเรื่องร้องเรียน (แยกตามสายงาน)",
        left: "center",
      },
    });

    const organization_data = ref<any>({
      labels: [],
      datas: [],
      backgroundColor: [],
    });

    const defaultBarChart = {
      title: {
        text: "",
        left: "center",
      },
      tooltip: {
        trigger: "axis",
        axisPointer: {
          type: "shadow",
        },
      },
      xAxis: {
        type: "category",
        data: selectOptions.value.organizations.map((x: any) => {
          return x.name_th_abbr;
        }),
        axisLabel: {
          rotate: 45,
          overflow: "truncate",
        },
      },
      yAxis: {
        type: "value",
      },
      series: [
        {
          data: [],
          type: "bar",
        },
      ],
    };

    const chartOrganizationData = ref<any>({
      ...defaultBarChart,
      title: {
        text: "สถิติเรื่องร้องเรียน (แยกตามหน่วยงาน)",
        left: "center",
      },
    });

    const getRandomColor = () => {
      const letters = "0123456789ABCDEF";
      let color = "#";
      for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
      }
      return color;
    };

    const isLeapYear = (year: any) => {
      return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
    };

    // Fetch Data
    const fetchItems = async () => {
      try {
        // check ว่าเป็นการกรองระดับไหน 1 ใหญ่, 2 ภาค, 3, จังหวัด

        let status_api_1: any = null;
        let status_api_2: any = null;
        let status_api_3: any = null;
        let status_api_4: any = null;
        if (search.division_id) {
          filter_type.value = 3;
          status_api_1 = 11;
          status_api_2 = 20;
          status_api_3 = "12,13,14,21,22,25,26,27,28,29";
          status_api_4 = "15,16,17,22,24";

          selectOptions.value.organizations = [...defaultAgencys].filter(
            (x: any) => {
              x.id = x.agency_id;
              x.name_th_abbr =
                x.agency_th_abbr != null ? x.agency_th_abbr : x.agency_th;
              return x.division_id == search.division_id.id;
            }
          );
        } else if (search.bureau_id) {
          filter_type.value = 2;
          status_api_1 = 10;
          status_api_2 = 19;
          status_api_3 = "11,12,13,14,15,20,21,22,23,25,26,27,28,29,30";
          status_api_4 = "16,17,24";
          selectOptions.value.organizations = [...defaultDivisions].filter(
            (x: any) => {
              x.id = x.division_id;
              x.name_th_abbr = x.division_th_abbr;
              return x.bureau_id == search.bureau_id.id;
            }
          );
        } else {
          filter_type.value = 1;
          status_api_1 = 1;
          status_api_2 = 3;
          status_api_3 =
            "10,11,12,13,14,15,16,19,20,21,22,23,24,25,26,27,28,29,30";
          status_api_4 = "17";
          selectOptions.value.organizations = [...defaultBureaus];
        }

        let create_from: any = undefined;
        let create_to: any = undefined;
        if (search.month?.value != null) {
          let last_day_month = "31";
          if (search.month?.name.includes("พันธ์")) {
            if (isLeapYear(search.year.value)) {
              last_day_month = "29";
            } else {
              last_day_month = "28";
            }
          }

          if (search.month?.name.includes("ยน")) {
            last_day_month = "30";
          }

          create_from = search.year.value + "-" + search.month.value + "-01";
          create_to =
            search.year.value + "-" + search.month.value + "-" + last_day_month;
        } else if (search.year?.value != null) {
          create_from = search.year.value + "-01-01";
          create_to = search.year.value + "-12-31";
        } else {
        }

        item_statuses.value.all_items = [];
        item_statuses.value.wating_items = [];
        item_statuses.value.receive_items = [];
        item_statuses.value.send_items = [];
        item_statuses.value.success_items = [];

        // api 1 get สถานะรอรับเรื่องของแต่ละหน่วยงาน
        const params1 = {
          ...search,
          perPage: 1000000,
          currentPage: 1,
          complaint_type_id: complaint_type.value.id,
          create_from: create_from,
          create_to: create_to,
          bureau_id: search.bureau_id ? search.bureau_id.id : undefined,
          division_id: search.division_id ? search.division_id.id : undefined,

          state_id: status_api_1,
        };

        const res1 = await ApiService.query("complaint", {
          params: params1,
        });
        item_statuses.value.wating_items = res1.data.data;
        cardStatus.value[1].total = item_statuses.value.wating_items.length;

        // api 2 get
        const params2 = {
          ...search,
          perPage: 1000000,
          currentPage: 1,
          complaint_type_id: complaint_type.value.id,
          create_from: create_from,
          create_to: create_to,
          bureau_id: search.bureau_id ? search.bureau_id.id : undefined,
          division_id: search.division_id ? search.division_id.id : undefined,

          state_id: status_api_2,
        };
        const res2 = await ApiService.query("complaint", {
          params: params2,
        });
        item_statuses.value.receive_items = res2.data.data;
        cardStatus.value[2].total = item_statuses.value.receive_items.length;

        // api 3 get
        const params3 = {
          ...search,
          perPage: 1000000,
          currentPage: 1,
          complaint_type_id: complaint_type.value.id,
          create_from: create_from,
          create_to: create_to,
          bureau_id: search.bureau_id ? search.bureau_id.id : undefined,
          division_id: search.division_id ? search.division_id.id : undefined,

          state_in: status_api_3,
        };
        const res3 = await ApiService.query("complaint", {
          params: params3,
        });
        item_statuses.value.send_items = res3.data.data;
        cardStatus.value[3].total = item_statuses.value.send_items.length;

        // api 4 get
        const params4 = {
          ...search,
          perPage: 1000000,
          currentPage: 1,
          complaint_type_id: complaint_type.value.id,
          create_from: create_from,
          create_to: create_to,
          bureau_id: search.bureau_id ? search.bureau_id.id : undefined,
          division_id: search.division_id ? search.division_id.id : undefined,

          state_in: status_api_4,
        };

        const res4 = await ApiService.query("complaint", {
          params: params4,
        });
        item_statuses.value.success_items = res4.data.data;
        cardStatus.value[4].total = item_statuses.value.success_items.length;

        item_statuses.value.all_items = [
          ...item_statuses.value.receive_items,
          ...item_statuses.value.send_items,
          ...item_statuses.value.success_items,
        ];

        cardStatus.value[0].total = item_statuses.value.all_items.length;

        reloadData();
      } catch (error) {
        console.log(error);
      }
    };

    const reloadData = async () => {
      // chart1
      selectOptions.value.topic_categories = defaultTopicCategories
        .filter((x: any) => {
          return x.complaint_type_id == complaint_type.value.id;
        })
        .map((x: any) => {
          x.count = 0;
          x.count_accused = 0;
          x.count_receive = 0;
          x.count_send = 0;
          x.count_success = 0;
          return x;
        });
      selectOptions.value.topic_categories.push({
        name_th: "ไม่ระบุ",
        id: 999,
        count: 0,
        count_accused: 0,
        count_receive: 0,
        count_send: 0,
        count_success: 0,
      });

      //   item_statuses.value.all_items.forEach((e: any) => {
      //     if (e.topic_type.topic_category.id) {
      //       let check = selectOptions.value.topic_categories.find((x: any) => {
      //         return e.topic_type.topic_category.id == x.id;
      //       });

      //       if (check) {
      //         check.count = check.count + 1;
      //         check.count_accused = check.count_accused + e.accused.length;
      //       } else {
      //         console.log(e);
      //         selectOptions.value.topic_categories[
      //           selectOptions.value.topic_categories.length - 1
      //         ].count =
      //           selectOptions.value.topic_categories[
      //             selectOptions.value.topic_categories.length - 1
      //           ].count + 1;
      //         // accused
      //         selectOptions.value.topic_categories[
      //           selectOptions.value.topic_categories.length - 1
      //         ].count_accused =
      //           selectOptions.value.topic_categories[
      //             selectOptions.value.topic_categories.length - 1
      //           ].count_accused + e.accused.length;
      //       }
      //     } else {
      //       selectOptions.value.topic_categories[
      //         selectOptions.value.topic_categories.length - 1
      //       ].count =
      //         selectOptions.value.topic_categories[
      //           selectOptions.value.topic_categories.length - 1
      //         ].count + 1;
      //       // accused
      //       selectOptions.value.topic_categories[
      //         selectOptions.value.topic_categories.length - 1
      //       ].count_accused =
      //         selectOptions.value.topic_categories[
      //           selectOptions.value.topic_categories.length - 1
      //         ].count_accused + e.accused.length;
      //     }
      //   });

      item_statuses.value.receive_items.forEach((e: any) => {
        if (e.topic_type.topic_category.id) {
          let check = selectOptions.value.topic_categories.find((x: any) => {
            return e.topic_type.topic_category.id == x.id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_receive += 1;
          } else {
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count + 1;
            // accused
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count_accused + e.accused.length;

            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_receive += 1;
          }
        } else {
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count + 1;
          // accused
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_accused =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused + e.accused.length;

          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_receive += 1;
        }
      });

      item_statuses.value.send_items.forEach((e: any) => {
        if (e.topic_type.topic_category.id) {
          let check = selectOptions.value.topic_categories.find((x: any) => {
            return e.topic_type.topic_category.id == x.id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_send += 1;
          } else {
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count + 1;
            // accused
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count_accused + e.accused.length;

            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_send += 1;
          }
        } else {
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count + 1;
          // accused
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_accused =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused + e.accused.length;

          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_send += 1;
        }
      });

      item_statuses.value.success_items.forEach((e: any) => {
        if (e.topic_type.topic_category.id) {
          let check = selectOptions.value.topic_categories.find((x: any) => {
            return e.topic_type.topic_category.id == x.id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_success += 1;
          } else {
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count + 1;
            // accused
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused =
              selectOptions.value.topic_categories[
                selectOptions.value.topic_categories.length - 1
              ].count_accused + e.accused.length;

            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_success += 1;
          }
        } else {
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count + 1;
          // accused
          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_accused =
            selectOptions.value.topic_categories[
              selectOptions.value.topic_categories.length - 1
            ].count_accused + e.accused.length;

          selectOptions.value.topic_categories[
            selectOptions.value.topic_categories.length - 1
          ].count_success += 1;
        }
      });

      topic_category_data.value = {
        labels: selectOptions.value.topic_categories.map((x: any) => {
          return x.name_th;
        }),
        datas: selectOptions.value.topic_categories.map((x: any) => {
          return {
            name: x.name_th,
            value: x.count,
            count_accused: x.count_accused,
            count_receive: x.count_receive,
            count_send: x.count_send,
            count_success: x.count_success,
          };
        }),
      };

      chartTopicCategoryData.value.series = [
        {
          ...chartTopicCategoryData.value.series[0],
          data: topic_category_data.value.datas.filter((x: any) => {
            return x.value != 0;
          }),
        },
      ];

      // chart2
      selectOptions.value.complaint_channels =
        selectOptions.value.complaint_channels.map((x: any) => {
          x.count = 0;
          x.count_accused = 0;
          x.count_receive = 0;
          x.count_send = 0;
          x.count_success = 0;
          return x;
        });

      //   item_statuses.value.all_items.forEach((e: any) => {
      //     if (e.complaint_channel_id) {
      //       let check = selectOptions.value.complaint_channels.find((x: any) => {
      //         return x.id == e.complaint_channel_id;
      //       });

      //       if (check) {
      //         check.count = check.count + 1;
      //         check.count_accused = check.count_accused + e.accused.length;
      //       } else {
      //         selectOptions.value.complaint_channels[8]["count"] =
      //           selectOptions.value.complaint_channels[8]["count"] + 1;

      //         selectOptions.value.complaint_channels[8]["count_accused"] =
      //           selectOptions.value.complaint_channels[8]["count_accused"] +
      //           e.accused.length;
      //       }
      //     } else {
      //       selectOptions.value.complaint_channels[8]["count"] =
      //         selectOptions.value.complaint_channels[8]["count"] + 1;

      //       selectOptions.value.complaint_channels[8]["count_accused"] =
      //         selectOptions.value.complaint_channels[8]["count_accused"] +
      //         e.accused.length;
      //     }
      //   });

      console.log(selectOptions.value.complaint_channels);

      item_statuses.value.receive_items.forEach((e: any) => {
        if (e.complaint_channel_id) {
          let check = selectOptions.value.complaint_channels.find((x: any) => {
            return x.id == e.complaint_channel_id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_receive += 1;
          } else {
            selectOptions.value.complaint_channels[8]["count"] =
              selectOptions.value.complaint_channels[8]["count"] + 1;

            selectOptions.value.complaint_channels[8]["count_accused"] =
              selectOptions.value.complaint_channels[8]["count_accused"] +
              e.accused.length;

            selectOptions.value.complaint_channels[8].count_receive += 1;
          }
        } else {
          selectOptions.value.complaint_channels[8]["count"] =
            selectOptions.value.complaint_channels[8]["count"] + 1;

          selectOptions.value.complaint_channels[8]["count_accused"] =
            selectOptions.value.complaint_channels[8]["count_accused"] +
            e.accused.length;

          selectOptions.value.complaint_channels[8].count_receive += 1;
        }
      });

      item_statuses.value.send_items.forEach((e: any) => {
        if (e.complaint_channel_id) {
          let check = selectOptions.value.complaint_channels.find((x: any) => {
            return x.id == e.complaint_channel_id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_send += 1;
          } else {
            selectOptions.value.complaint_channels[8]["count"] =
              selectOptions.value.complaint_channels[8]["count"] + 1;

            selectOptions.value.complaint_channels[8]["count_accused"] =
              selectOptions.value.complaint_channels[8]["count_accused"] +
              e.accused.length;
            selectOptions.value.complaint_channels[8].count_send += 1;
          }
        } else {
          selectOptions.value.complaint_channels[8]["count"] =
            selectOptions.value.complaint_channels[8]["count"] + 1;

          selectOptions.value.complaint_channels[8]["count_accused"] =
            selectOptions.value.complaint_channels[8]["count_accused"] +
            e.accused.length;
          selectOptions.value.complaint_channels[8].count_send += 1;
        }
      });

      item_statuses.value.success_items.forEach((e: any) => {
        if (e.complaint_channel_id) {
          let check = selectOptions.value.complaint_channels.find((x: any) => {
            return x.id == e.complaint_channel_id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
            check.count_success += 1;
          } else {
            selectOptions.value.complaint_channels[8]["count"] =
              selectOptions.value.complaint_channels[8]["count"] + 1;

            selectOptions.value.complaint_channels[8]["count_accused"] =
              selectOptions.value.complaint_channels[8]["count_accused"] +
              e.accused.length;
            selectOptions.value.complaint_channels[8].count_success += 1;
          }
        } else {
          selectOptions.value.complaint_channels[8]["count"] =
            selectOptions.value.complaint_channels[8]["count"] + 1;

          selectOptions.value.complaint_channels[8]["count_accused"] =
            selectOptions.value.complaint_channels[8]["count_accused"] +
            e.accused.length;
          selectOptions.value.complaint_channels[8].count_success += 1;
        }
      });

      complaint_channel_data.value = {
        datas: selectOptions.value.complaint_channels.map((x: any) => {
          return {
            name: x.name_th,
            value: x.count,
            count_accused: x.count_accused,
            count_receive: x.count_receive,
            count_send: x.count_send,
            count_success: x.count_success,
          };
        }),
      };

      chartChannelData.value.series = [
        {
          ...chartTopicCategoryData.value.series[0],
          data: complaint_channel_data.value.datas.filter((x: any) => {
            return x.value != 0;
          }),
        },
      ];

      // chart 3
      selectOptions.value.sections = selectOptions.value.sections.map(
        (x: any) => {
          x.count_section = 0;
          return x;
        }
      );

      item_statuses.value.all_items.forEach((e: any) => {
        e.accused.forEach((a: any) => {
          if (a.section_id) {
            let check = selectOptions.value.sections.find((x: any) => {
              return x.id == a.section_id;
            });

            if (check) {
              check.count_section = check.count_section + 1;
            } else {
              selectOptions.value.sections[5]["count_section"] =
                selectOptions.value.sections[5]["count_section"] + 1;
            }
          } else {
            selectOptions.value.sections[6]["count_section"] =
              selectOptions.value.sections[6]["count_section"] + 1;
          }
        });
      });

      section_data.value = {
        datas: selectOptions.value.sections
          .map((x: any) => {
            return {
              name: x.name_th,
              value: x.count_section,
              count_accused: x.count_section,
            };
          })
          .filter((x: any) => {
            return x.value != 0;
          }),
      };

      chartSectionData.value.series = [
        {
          ...chartSectionData.value.series[0],
          data: section_data.value.datas,
        },
      ];

      // chart4  filter_type 1
      if (filter_type.value == 1) {
        selectOptions.value.organizations =
          selectOptions.value.organizations.map((x: any) => {
            x.count_org = 0;
            x.count_receive = 0;
            x.count_send = 0;
            x.count_success = 0;
            x.sections = JSON.parse(
              JSON.stringify(selectOptions.value.sections)
            );
            // [...selectOptions.value.sections];
            return x;
          });

        item_statuses.value.receive_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            const bureau = a.bureau_id
              ? selectOptions.value.organizations.find(
                  (x: any) => x.id === a.bureau_id
                )
              : selectOptions.value.organizations[10];

            if (bureau) {
              bureau.count_receive += 1;

              const section =
                bureau.sections.find((s: any) => s.id === a.section_id) ||
                bureau.sections[6];
              section.count_section_org += 1;
            }
          });
        });

        // item_statuses.value.receive_items.forEach((e: any) => {
        //   e.accused.forEach((a: any) => {
        //     if (a.bureau_id) {
        //       let check = selectOptions.value.organizations.find((x: any) => {
        //         return x.id == a.bureau_id;
        //       });

        //       if (check) {
        //         check.count_receive = check.count_receive + 1;

        //         let check_sc = check.sections.find((s: any) => {
        //           return s.id == a.section_id;
        //         });

        //         check_sc.count_section_org += 1;
        //       } else {
        //         selectOptions.value.organizations[10]["count_receive"] =
        //           selectOptions.value.organizations[10]["count_receive"] + 1;

        //         selectOptions.value.organizations[10].sections[5].count_section_org += 1;
        //       }
        //     } else {
        //       selectOptions.value.organizations[10]["count_receive"] =
        //         selectOptions.value.organizations[10]["count_receive"] + 1;

        //       let check_sc =
        //         selectOptions.value.organizations[10].sections.find(
        //           (s: any) => {
        //             return s.id == a.section_id;
        //           }
        //         );

        //       if (check_sc) {
        //         check_sc.count_section_org += 1;
        //       } else {
        //         selectOptions.value.organizations[10].sections[6].count_section_org += 1;
        //       }
        //     }

        //     //
        //   });
        // });

        item_statuses.value.send_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.bureau_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.bureau_id;
              });

              if (check) {
                check.count_send = check.count_send + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });

                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_send"] =
                  selectOptions.value.organizations[10]["count_send"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_send"] =
                selectOptions.value.organizations[10]["count_send"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        item_statuses.value.success_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.bureau_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.bureau_id;
              });

              if (check) {
                check.count_success = check.count_success + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_success"] =
                  selectOptions.value.organizations[10]["count_success"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_success"] =
                selectOptions.value.organizations[10]["count_success"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        organization_data.value = {
          datas: selectOptions.value.organizations.map((x: any) => {
            return {
              name: x.name_th_abbr,
              // value: x.count_org,
              // count_accused: x.count_org,
              receive: x.count_receive,
              send: x.count_send,
              success: x.count_success,
              sections: x.sections,
            };
          }),
        };

        chartOrganizationData.value.series = [
          {
            name: "รับเรื่อง",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.receive, name: x.name };
            }),
            itemStyle: { color: "#FFC107" }, // กำหนดสีสำหรับแถบ 'Received'
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "อยู่ระหว่างตรวจสอบ",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.send, name: x.name };
            }),
            itemStyle: { color: "#A00001" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "เสร็จสิ้น",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.success, name: x.name };
            }),
            itemStyle: { color: "#17c653" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          // {
          //   data: organization_data.value.datas.map((x: any) => {
          //     return { value: x.value, itemStyle: { color: getRandomColor() } };
          //   }),
          //   type: "bar",
          // },
        ];

        chartOrganizationData.value = {
          ...chartOrganizationData.value,
          legend: {
            data: ["รับเรื่อง", "อยู่ระหว่างตรวจสอบ", "เสร็จสิ้น"],
            top: "bottom", // ย้าย legend ไปด้านล่างของกราฟ
            left: "center",
          },
          xAxis: {
            type: "category",
            data: organization_data.value.datas.map((x: any) => x.name),
            axisLabel: {
              interval: 0,
              rotate: 45, // หมุนป้ายหมวดหมู่ให้ทำมุม 45 องศา
            },
          },
          yAxis: {
            type: "value",
          },
          series: chartOrganizationData.value.series,
        };

        console.log(organization_data.value);
      }

      // End Chart 4  filter_type 1

      // chart4  filter_type 2
      if (filter_type.value == 2) {
        selectOptions.value.organizations =
          selectOptions.value.organizations.map((x: any) => {
            x.count_org = 0;
            x.count_receive = 0;
            x.count_send = 0;
            x.count_success = 0;
            x.sections = JSON.parse(
              JSON.stringify(selectOptions.value.sections)
            );
            return x;
          });

        item_statuses.value.receive_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.division_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.division_id;
              });

              if (check) {
                check.count_receive = check.count_receive + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_receive"] =
                  selectOptions.value.organizations[10]["count_receive"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_receive"] =
                selectOptions.value.organizations[10]["count_receive"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        item_statuses.value.send_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.division_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.division_id;
              });

              if (check) {
                check.count_send = check.count_send + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_send"] =
                  selectOptions.value.organizations[10]["count_send"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_send"] =
                selectOptions.value.organizations[10]["count_send"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        item_statuses.value.success_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.division_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.division_id;
              });

              if (check) {
                check.count_success = check.count_success + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_success"] =
                  selectOptions.value.organizations[10]["count_success"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_success"] =
                selectOptions.value.organizations[10]["count_success"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        organization_data.value = {
          datas: selectOptions.value.organizations.map((x: any) => {
            return {
              name: x.name_th_abbr,
              // value: x.count_org,
              // count_accused: x.count_org,
              receive: x.count_receive,
              send: x.count_send,
              success: x.count_success,
              sections: x.sections,
            };
          }),
        };

        chartOrganizationData.value.series = [
          {
            name: "รับเรื่อง",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.receive, name: x.name };
            }),
            itemStyle: { color: "#FFC107" }, // กำหนดสีสำหรับแถบ 'Received'
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "อยู่ระหว่างตรวจสอบ",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.send, name: x.name };
            }),
            itemStyle: { color: "#A00001" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "เสร็จสิ้น",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.success, name: x.name };
            }),
            itemStyle: { color: "#17c653" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          // {
          //   data: organization_data.value.datas.map((x: any) => {
          //     return { value: x.value, itemStyle: { color: getRandomColor() } };
          //   }),
          //   type: "bar",
          // },
        ];

        chartOrganizationData.value = {
          ...chartOrganizationData.value,
          legend: {
            data: ["รับเรื่อง", "อยู่ระหว่างตรวจสอบ", "เสร็จสิ้น"],
            top: "bottom", // ย้าย legend ไปด้านล่างของกราฟ
            left: "center",
          },
          xAxis: {
            type: "category",
            data: organization_data.value.datas.map((x: any) => x.name),
            axisLabel: {
              interval: 0,
              rotate: 45, // หมุนป้ายหมวดหมู่ให้ทำมุม 45 องศา
            },
          },
          yAxis: {
            type: "value",
          },
          series: chartOrganizationData.value.series,
        };
      }
      // End Chart 4 filter_type 2

      // chart4  filter_type 3
      if (filter_type.value == 3) {
        selectOptions.value.organizations =
          selectOptions.value.organizations.map((x: any) => {
            x.count_org = 0;
            x.count_receive = 0;
            x.count_send = 0;
            x.count_success = 0;
            x.sections = JSON.parse(
              JSON.stringify(selectOptions.value.sections)
            );
            return x;
          });

        item_statuses.value.receive_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.agency_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.agency_id;
              });

              if (check) {
                check.count_receive = check.count_receive + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_receive"] =
                  selectOptions.value.organizations[10]["count_receive"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_receive"] =
                selectOptions.value.organizations[10]["count_receive"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        item_statuses.value.send_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.agency_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.agency_id;
              });

              if (check) {
                check.count_send = check.count_send + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_send"] =
                  selectOptions.value.organizations[10]["count_send"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_send"] =
                selectOptions.value.organizations[10]["count_send"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        item_statuses.value.success_items.forEach((e: any) => {
          e.accused.forEach((a: any) => {
            if (a.agency_id) {
              let check = selectOptions.value.organizations.find((x: any) => {
                return x.id == a.agency_id;
              });

              if (check) {
                check.count_success = check.count_success + 1;

                let check_sc = check.sections.find((s: any) => {
                  return s.id == a.section_id;
                });
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10]["count_success"] =
                  selectOptions.value.organizations[10]["count_success"] + 1;

                selectOptions.value.organizations[10].sections[5].count_section_org += 1;
              }
            } else {
              selectOptions.value.organizations[10]["count_success"] =
                selectOptions.value.organizations[10]["count_success"] + 1;

              let check_sc =
                selectOptions.value.organizations[10].sections.find(
                  (s: any) => {
                    return s.id == a.section_id;
                  }
                );

              if (check_sc) {
                check_sc.count_section_org += 1;
              } else {
                selectOptions.value.organizations[10].sections[6].count_section_org += 1;
              }
            }
          });
        });

        organization_data.value = {
          datas: selectOptions.value.organizations.map((x: any) => {
            return {
              name: x.name_th_abbr,
              receive: x.count_receive,
              send: x.count_send,
              success: x.count_success,
              sections: x.sections,
            };
          }),
        };

        chartOrganizationData.value.series = [
          {
            name: "รับเรื่อง",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.receive, name: x.name };
            }),
            itemStyle: { color: "#FFC107" }, // กำหนดสีสำหรับแถบ 'Received'
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "อยู่ระหว่างตรวจสอบ",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.send, name: x.name };
            }),
            itemStyle: { color: "#A00001" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
          {
            name: "เสร็จสิ้น",
            type: "bar",
            //   stack: "total",
            data: organization_data.value.datas.map((x: any) => {
              return { value: x.success, name: x.name };
            }),
            itemStyle: { color: "#17c653" },
            label: {
              show: true,
              position: "top",
              formatter: (params: any) =>
                params.value === 0 ? "" : params.value,
            },
          },
        ];

        chartOrganizationData.value = {
          ...chartOrganizationData.value,
          legend: {
            data: ["รับเรื่อง", "อยู่ระหว่างตรวจสอบ", "เสร็จสิ้น"],
            top: "bottom", // ย้าย legend ไปด้านล่างของกราฟ
            left: "center",
          },
          xAxis: {
            type: "category",
            data: organization_data.value.datas.map((x: any) => x.name),
            axisLabel: {
              interval: 0,
              rotate: 45, // หมุนป้ายหมวดหมู่ให้ทำมุม 45 องศา
            },
          },
          yAxis: {
            type: "value",
          },
          series: chartOrganizationData.value.series,
        };
      }
      // End Chart 4 filter_type 3
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };

    const onClear = async () => {
      //   search.value = {};
      Object.assign(search, {});
    };

    // Mounted
    onMounted(async () => {
      selectOptions.value.inspectors =
        await searchComplaintStore.fetchInspector({
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        });

      selectOptions.value.bureaus = await searchComplaintStore.fetchBureau({
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
      });

      search.year = selectOptions.value.years[0];

      if (userData.role_id == 1) {
        disabledSearchBureau.value = false;
        disabledSearchDivision.value = false;
      } else if (userData.role_id == 2) {
        disabledSearchBureau.value = false;
        disabledSearchDivision.value = false;
      } else if (userData.role_id == 3) {
        search.bureau_id = {
          id: userData.bureau_id,
          name_th_abbr: userData.bureau.name_th,
        };
        disabledSearchDivision.value = false;
      } else if (userData.role_id == 4) {
        search.bureau_id = {
          id: userData.bureau_id,
          name_th_abbr: userData.bureau.name_th_abbr,
        };
        search.division_id = {
          id: userData.division_id,
          name_th_abbr: userData.division.name_th_abbr,
        };
      } else if (userData.role_id == 5) {
        disabledSearchBureau.value = false;
        disabledSearchDivision.value = false;
        search.inspector_id = userData.inspector_id;
        // params.state_in =
        //   "4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,28,29,30";
      } else if (userData.role_id == 6) {
        disabledSearchBureau.value = false;
        disabledSearchDivision.value = false;
        // params.state_in =
        //   "4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,28,29,30";
      } else {
        return false;
      }

      await fetchItems();
    });

    // watch
    watch(
      () => activeTab.value,
      () => {
        fetchItems();
      }
    );

    watch(
      () => search.bureau_id,
      async () => {
        search.division_id = null;
        search.agency_id = null;
        selectOptions.value.divisions = [];

        if (search.bureau_id) {
          selectOptions.value.divisions =
            await searchComplaintStore.fetchDivision({
              ...defaultParams,
              bureau_id: search.bureau_id?.id,
            });

          if (userData.role_id == 4) {
            search.division_id = {
              id: userData.division_id,
              name_th_abbr: userData.division.name_th_abbr,
            };
          }
        }
      }
    );

    watch(
      () => search.division_id,
      async () => {
        search.agency_id = null;
        selectOptions.agencies = [];

        if (search.division_id) {
          selectOptions.agencies = await searchComplaintStore.fetchAgency({
            ...defaultParams,
            division_id: search.division_id?.id,
          });
        }
      }
    );

    return {
      selectOptions,
      cardStatus,
      search,
      items,
      item,
      router,
      format,
      chartTopicCategoryData,
      chartChannelData,
      chartSectionData,
      chartOrganizationData,
      onSearch,
      onClear,
      activeTab,
      setActiveTab,
      complaint_type,
      topic_category_data,
      complaint_channel_data,
      section_data,
      organization_data,
      disabledSearchDivision,
      disabledSearchBureau,
      openSubOrgModal,
      selectedSubOrganizations,
      openSubOrganizationModal,
    };
  },
});
</script>

<style>
.vs__dropdown-toggle {
  border: none;
}

.v-select {
  padding: 0.4em 0.5em;
}

.dp__main {
  padding: 0.35em 0em;
}

.dp__input {
  border: none !important;
}
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
  .nav-link {
    width: 100%;
    margin-top: 5px;
  }
}

.bg-color-police {
  background-color: #800001;
}

.nav-link {
  margin-left: 0.5rem;
  margin-right: 0.5rem;
  padding-top: 0.75rem;
  border-radius: 50px;
}

.nav-link.active {
  background-color: #0d6efd;
  color: white;
}

.nav-link:not(.active) {
  background-color: #6c757d;
  color: white;
}

.form-control {
  border-color: #800001;
  border-width: 0.1em;
}

.bg-sky {
  background-color: #d9f4fe;
}

.table-bordered td,
.table-bordered th {
  /* font-weight: bold; */
  font-size: 1.4em;
  border: 2px solid #000; /* เปลี่ยนสีและความหนาของเส้นขอบ */
}
</style>

<style scoped></style>
