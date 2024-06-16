<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container mt-5">
      <div class="card shadow-sm my-5">
        <!-- Search -->
        <div class="card-body">
          <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
            <!-- ปีที่ร้องเรียน -->
            <div class="col-12 col-md-5 my-2">
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
            <div class="col-12 col-md-5 my-2">
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
              :class="{ active: activeTab === ct.name_abbr_en }"
              aria-current="page"
              href="#"
              @click.prevent="setActiveTab(ct.name_abbr_en)"
            >
              {{ ct.name_th }}
            </a>
          </nav>
        </div>
      </div>

      <!-- <div class="mb-5 mt-5">
        <span
          >เรื่อง{{ complaint_type.name_th }} {{ cardStatus[0].description }}
          {{ cardStatus[0].total }} เรื่อง</span
        >
      </div> -->
      <div class="row justify-content-center ms-1 d-flex">
        <div
          class="card col-sm-12 col-md-2 col-lg-2 mx-1"
          :style="[{ backgroundColor: it.bgColor }]"
          v-for="(it, idx) in cardStatus.slice(1, 7)"
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
                  <th class="text-center text-white">จำนวนเรื่อง</th>
                  <th class="text-center text-white">จำนวนผู้ถูกร้องเรียน</th>
                </tr>
              </thead>
              <tbody v-if="topic_category_data.datas.length != 0">
                <tr v-for="(tc, idx) in topic_category_data.datas" :key="idx">
                  <td class="text-center">{{ tc.name }}</td>

                  <td class="text-center">
                    {{ tc.value }}
                  </td>
                  <td class="text-center">
                    {{ tc.count_accused }}
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
                  <th class="text-center text-white">จำนวนเรื่อง</th>
                  <th class="text-center text-white">จำนวนผู้ถูกร้องเรียน</th>
                </tr>
              </thead>
              <tbody v-if="complaint_channel_data.datas.length != 0">
                <tr
                  v-for="(cc, idx) in complaint_channel_data.datas"
                  :key="idx"
                >
                  <td class="text-center">{{ cc.name }}</td>
                  <td class="text-center">
                    {{ cc.value }}
                  </td>
                  <td class="text-center">
                    {{ cc.count_accused }}
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
        <div class="card-body row">
          <div class="col-12 col-md-6 mb-3 mt-10">
            <h6>สถิติเรื่องร้องเรียน (แยกตามสายงาน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">สายงาน</th>
                  <th class="text-center text-white">จำนวนเรื่อง</th>
                  <th class="text-center text-white">จำนวนผู้ถูกร้องเรียน</th>
                </tr>
              </thead>
              <tbody v-if="section_data.datas.length != 0">
                <tr v-for="(ss, idx) in section_data.datas" :key="idx">
                  <td class="text-center">{{ ss.name }}</td>
                  <td class="text-center">
                    {{ ss.value }}
                  </td>
                  <td class="text-center">
                    {{ ss.count_accused }}
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
            <h6>สถิติเรื่องร้องเรียน (แยกตามหน่วยงาน)</h6>
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">หน่วยงาน</th>
                  <th class="text-center text-white">จำนวนเรื่อง</th>
                  <th class="text-center text-white">จำนวนผู้ถูกร้องเรียน</th>
                </tr>
              </thead>
              <tbody v-if="organization_data.datas.length != 0">
                <tr v-for="(or, idx) in organization_data.datas" :key="idx">
                  <td class="text-center">{{ or.name }}</td>
                  <td class="text-center">
                    {{ or.value }}
                  </td>
                  <td class="text-center">
                    {{ or.count_accused }}
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
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  ref,
  reactive,
  watch,
  provide,
  shallowRef,
} from "vue";
import ApiService from "@/core/services/ApiService";
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
} from "echarts/components";
import VChart, { THEME_KEY } from "vue-echarts";

// Components
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";
import useComplaintTypeData from "@/composables/useComplaintTypeData";

echarts.use([
  TitleComponent,
  TooltipComponent,
  GridComponent,
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
  },
  setup() {
    // UI

    provide(THEME_KEY, "light");
    const activeTab = ref("complaints"); // ค่าเริ่มต้น
    const setActiveTab = (tab: string) => {
      activeTab.value = tab;
      complaint_type.value = selectOptions.value.complaint_types.find(
        (x: any) => {
          return x.name_abbr_en == activeTab.value;
        }
      );
    };

    const complaint_type = ref({
      id: 1,
      name_th: "ร้องเรียน",
      name_en: null,
      name_abbr_en: "complaints",
      is_active: 1,
    });

    // Variable
    const router = useRouter();
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const cardStatus = ref([
      {
        status_id: 1,
        description: "ทั้งหมด",
        bgColor: "#F8285A",
        total: 0,
      },
      {
        status_id: 2,
        description: "เรื่องร้องเรียนใหม่",
        bgColor: "#F8285A",
        total: 0,
      },
      {
        status_id: 3,
        description: "รับเข้าระบบ",
        bgColor: "#FFC107",
        total: 0,
      },
    //   {
    //     status_id: 7,
    //     description: "ฝรท. ตรวจสอบ",
    //     bgColor: "#FFC107",
    //     total: 0,
    //   },
      {
        status_id: 4,
        description: "ส่งหน่วยดำเนินการ",
        bgColor: "#A00001",
        total: 0,
      },

      {
        status_id: 6,
        description: "อยู่ระหว่างดำเนินการ",
        bgColor: "#1B84FF",
        total: 0,
      },
      {
        status_id: 5,
        description: "ดำเนินการเสร็จสิ้น",
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

    const selectOptions = ref<any>({
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
        { name: "ตรวจสอบเสร็จสิ้น", value: 5 },
        { name: "อยู่ระหว่างตรวจสอบ", value: 6 },
      ],
      sections: [
        {
          id: 1,
          name_th: "การป้องกันและปราบปราม",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 2,
          name_th: "อำนวยการ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 3,
          name_th: "บริหาร",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 4,
          name_th: "สืบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 5,
          name_th: "สอบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 6,
          name_th: "จราจร",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 7,
          name_th: "ป้องกันปราบปรามยาเสพติด",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 8,
          name_th: "กิจการพิเศษ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 9,
          name_th: "ธุรการ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 10,
          name_th: "ปฎิบัติการพิเศษ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
        },
        {
          id: 11,
          name_th: "อื่นๆ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
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
          name_th: "ผู้บังคับบัญชาสั่งการ",
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
          name_th: "หน่วยงานราชการอื่นๆ",
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
      organizations: [
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
      ],
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

    const chartOrganizationData = ref({
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

        const params = {
          perPage: 1000000,
          currentPage: 1,
          ...search,
          complaint_type_id: complaint_type.value.id,
          create_from: create_from,
          create_to: create_to,
        };
        // ได้ DATA ทั้งหมดที่กรองจากปี เดือนและประเภทการร้องเรียน
        const { data } = await ApiService.query("complaint/", {
          params: params,
        });

        // ต้องการแยกเฉพาะส่วนที่รับ และไม่รับ
        Object.assign(items, data.data);
        items.value = [];
        reject_items.value = [];
        receive1_items.value = [];
        send1_items.value = [];
        during_items.value = [];
        success_items.value = [];
        wating1_items.value = [];

        data.data.forEach((x: any) => {
          if (x.state_id == 18) {
            reject_items.value.push(x);
          } else if (x.state_id >= 3) {
            receive1_items.value.push(x);
          } else {
          }

          if (x.state_id == 1) {
            wating1_items.value.push(x);
          }
        });

        receive1_items.value.forEach((x: any) => {
          if (x.state_id != 3) {
            send1_items.value.push(x);
          }

          if (x.state_id == 17) {
            success_items.value.push(x);
          } else {
            if (x.state_id > 3) {
              during_items.value.push(x);
            }
          }
        });

        cardStatus.value[0].total = items.length;

        cardStatus.value[1].total = wating1_items.value.length;
        // cardStatus.value[1].total = reject_items.value.length;
        cardStatus.value[2].total = receive1_items.value.length;
        cardStatus.value[3].total = send1_items.value.length;
        cardStatus.value[4].total = success_items.value.length;
        cardStatus.value[5].total = during_items.value.length;

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
          return x;
        });

      receive1_items.value.forEach((e: any) => {
        if (e.topic_type.topic_category.id) {
          let check = selectOptions.value.topic_categories.find((x: any) => {
            return e.topic_type.topic_category.id == x.id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
          }
        }
      });

      topic_category_data.value = {
        labels: selectOptions.value.topic_categories.map((x: any) => {
          return x.name_th;
        }),
        datas: selectOptions.value.topic_categories
          .map((x: any) => {
            return {
              name: x.name_th,
              value: x.count,
              count_accused: x.count_accused,
            };
          })
          .filter((x: any) => {
            return x.value != 0;
          }),
      };

      chartTopicCategoryData.value.series = [
        {
          ...chartTopicCategoryData.value.series[0],
          data: topic_category_data.value.datas,
        },
      ];

      // chart2

      selectOptions.value.complaint_channels =
        selectOptions.value.complaint_channels.map((x: any) => {
          x.count = 0;
          x.count_accused = 0;
          return x;
        });

      receive1_items.value.forEach((e: any) => {
        if (e.complaint_channel_id) {
          let check = selectOptions.value.complaint_channels.find((x: any) => {
            return x.id == e.complaint_channel_id;
          });

          if (check) {
            check.count = check.count + 1;
            check.count_accused = check.count_accused + e.accused.length;
          } else {
            selectOptions.value.complaint_channels[8]["count"] =
              selectOptions.value.complaint_channels[8]["count"] + 1;

            selectOptions.value.complaint_channels[8]["count_accused"] =
              selectOptions.value.complaint_channels[8]["count_accused"] +
              e.accused.length;
          }
        } else {
          selectOptions.value.complaint_channels[8]["count"] =
            selectOptions.value.complaint_channels[8]["count"] + 1;

          selectOptions.value.complaint_channels[8]["count_accused"] =
            selectOptions.value.complaint_channels[8]["count_accused"] +
            e.accused.length;
        }
      });

      complaint_channel_data.value = {
        datas: selectOptions.value.complaint_channels
          .map((x: any) => {
            return {
              name: x.name_th,
              value: x.count,
              count_accused: x.count_accused,
            };
          })
          .filter((x: any) => {
            return x.value != 0;
          }),
      };

      chartChannelData.value.series = [
        {
          ...chartTopicCategoryData.value.series[0],
          data: complaint_channel_data.value.datas,
        },
      ];

      //   Section
      selectOptions.value.sections = selectOptions.value.sections.map(
        (x: any) => {
          x.count_section = 0;
          return x;
        }
      );

      receive1_items.value.forEach((e: any) => {
        e.accused.forEach((a: any) => {
          if (a.section_id) {
            let check = selectOptions.value.sections.find((x: any) => {
              return x.id == a.section_id;
            });

            if (check) {
              check.count_section = check.count_section + 1;
            } else {
              selectOptions.value.sections[10]["count_section"] =
                selectOptions.value.sections[10]["count_section"] + 1;
            }
          } else {
            selectOptions.value.sections[10]["count_section"] =
              selectOptions.value.sections[10]["count_section"] + 1;
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

      //   chart4
      selectOptions.value.organizations = selectOptions.value.organizations.map(
        (x: any) => {
          x.count_org = 0;
          return x;
        }
      );

      receive1_items.value.forEach((e: any) => {
        e.accused.forEach((a: any) => {
          if (a.bureau_id) {
            let check = selectOptions.value.organizations.find((x: any) => {
              return x.id == a.bureau_id;
            });

            if (check) {
              check.count_org = check.count_org + 1;
            } else {
              selectOptions.value.organizations[10]["count_org"] =
                selectOptions.value.organizations[10]["count_org"] + 1;
            }
          } else {
            selectOptions.value.organizations[10]["count_org"] =
              selectOptions.value.organizations[10]["count_org"] + 1;
          }
        });
      });

      organization_data.value = {
        datas: selectOptions.value.organizations.map((x: any) => {
          return {
            name: x.name_th_abbr,
            value: x.count_org,
            count_accused: x.count_org,
          };
        }),
      };

      chartOrganizationData.value.series = [
        {
          data: organization_data.value.datas.map((x: any) => {
            return { value: x.value, itemStyle: { color: getRandomColor() } };
          }),
          type: "bar",
        },
      ];
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };

    const onClear = async () => {
      search.value = {};
    };

    // Mounted
    onMounted(async () => {
      search.year = selectOptions.value.years[0];
      await fetchItems();
    });

    // watch
    watch(
      () => activeTab.value,
      () => {
        fetchItems();
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
</style>

<style scoped></style>
