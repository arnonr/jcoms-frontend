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
                :reduce="(year: any) => year.value"
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

      <div class="mb-5 mt-5">
        <span
          >เรื่อง{{ complaint_type.name_th }} {{ cardStatus[0].description }}
          {{ cardStatus[0].total }} เรื่อง</span
        >
      </div>
      <div class="row justify-content-center ms-1">
        <div
          class="card col-sm-12 col-md-4 col-lg-2 mx-2"
          :style="[{ backgroundColor: it.bgColor }]"
          v-for="(it, idx) in cardStatus.slice(1, 6)"
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
          <div class="col-12 col-md-4">
            <h6>สถิติเรื่อง{{ complaint_type.name_th }}</h6>
            <h6>(แยกตามประเภทเรื่อง{{ complaint_type.name_th }})</h6>
            <div style="width: 400px" class="mx-auto">
              <Doughnut
                ref="chartTopicCategoryRef"
                :data="chartTopicCategoryData"
                :options="pieChartOptions"
              />
            </div>
          </div>
          <div class="col-12 col-md-4">
            <h6>สถิติเรื่อง{{ complaint_type.name_th }}</h6>
            <h6>(แยกตามช่องทางการ{{ complaint_type.name_th }})</h6>
            <div style="width: 400px" class="mx-auto">
              <Doughnut :data="chartChannelData" :options="pieChartOptions" />
            </div>
          </div>
          <div class="col-12 col-md-4">
            <h6>สถิติเรื่อง{{ complaint_type.name_th }}</h6>
            <h6>(แยกตามสายงานที่ถูก{{ complaint_type.name_th }})</h6>
            <div style="width: 400px" class="mx-auto">
              <Doughnut :data="chartSectionData" :options="pieChartOptions" />
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 col-md-12 mb-3 mt-10">
        <h4>สถิติ{{ complaint_type.name_th }} (แยกตามหน่วยงาน)</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 100%; height: 400px" class="mx-auto">
              <Bar
                :data="chartOrganizationData"
                :options="chartOrganizationOptions"
              />
            </div>
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
                  <th class="text-center text-white">จำนวนเรื่อง</th>
                </tr>
              </thead>
              <tbody v-if="topic_category_data.labels.length != 0">
                <tr v-for="(tc, idx) in topic_category_data.labels" :key="idx">
                  <td class="text-center">{{ tc }}</td>
                  <td class="text-center">
                    {{ topic_category_data.data[idx] }}
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
                </tr>
              </thead>
              <tbody v-if="complaint_channel_data.labels.length != 0">
                <tr
                  v-for="(cc, idx) in complaint_channel_data.labels"
                  :key="idx"
                >
                  <td class="text-center">{{ cc }}</td>
                  <td class="text-center">
                    {{ complaint_channel_data.data[idx] }}
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
                </tr>
              </thead>
              <tbody v-if="section_data.labels.length != 0">
                <tr v-for="(ss, idx) in section_data.labels" :key="idx">
                  <td class="text-center">{{ ss }}</td>
                  <td class="text-center">
                    {{ section_data.data[idx] }}
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
                </tr>
              </thead>
              <tbody v-if="organization_data.labels.length != 0">
                <tr v-for="(or, idx) in organization_data.labels" :key="idx">
                  <td class="text-center">{{ or }}</td>
                  <td class="text-center">
                    {{ organization_data.data[idx] }}
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
import { defineComponent, onMounted, ref, reactive, watch } from "vue";
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
// Import Custom Widget Dashboard
import Widget1Custom from "@/components/dashboard-default-widgets/Widget1Custom.vue";
// Chart
import {
  Chart as ChartJS,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement,
} from "chart.js";
import { Pie, Bar, Doughnut } from "vue-chartjs";
ChartJS.register(
  //   Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement
);

// Components
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useComplaintTopicData from "@/composables/useComplaintTopicData";

export default defineComponent({
  name: "dashboard",
  components: {
    VueDatePicker,
    dayjs,
    vSelect,
    Doughnut,
    Bar,
    Widget1Custom,
    BlogPagination,
  },
  setup() {
    // UI
    const activeTab = ref("complaints"); // ค่าเริ่มต้น
    const setActiveTab = (tab: string) => {
      activeTab.value = tab;
      complaint_type.value = selectOptions.value.complaint_types.find(
        (x: any) => {
          return x.name_abbr_en == activeTab.value;
        }
      );
    };
    const chartTopicCategoryRef = ref(null);
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
        description: "ข้อมูลไม่ครบถ้วน",
        bgColor: "#F8285A",
        total: 0,
      },
      {
        status_id: 3,
        description: "รับเข้าระบบ",
        bgColor: "#FFC107",
        total: 0,
      },
      {
        status_id: 4,
        description: "ส่งหน่วยตรวจสอบ",
        bgColor: "#A00001",
        total: 0,
      },

      {
        status_id: 5,
        description: "ตรวจสอบเสร็จสิ้น",
        bgColor: "#17c653",
        total: 0,
      },

      {
        status_id: 6,
        description: "อยู่ระหว่างตรวจสอบ",
        bgColor: "#1B84FF",
        total: 0,
      },
    ]);

    const defaultTopicCategories = [
      {
        id: 1,
        name_th: "ทุจริตต่อหน้าที่",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 2,
        name_th: "ปฎิบัติหน้าที่มิชอบ",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 3,
        name_th: "ประพฤติตนไม่สมควร",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 4,
        name_th: "ไม่บริการประชาชน",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 5,
        name_th: "ขอความเป็นธรรม",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 6,
        name_th: "บัตรสนเท่ห์ร้องเรียนการปฏิบัติหน้าที่ของเจ้าหน้าที่ตำรวจ",
        name_en: null,
        complaint_type_id: 1,
      },
      {
        id: 7,
        name_th: "ขอความช่วยเหลือ",
        name_en: null,
        complaint_type_id: 2,
      },
      {
        id: 8,
        name_th: "แจ้งเบาะแส/แนะนำ",
        name_en: null,
        complaint_type_id: 2,
      },
      {
        id: 10,
        name_th: "แจ้งเบาะแสยาเสพติด",
        name_en: null,
        complaint_type_id: 2,
      },
      {
        id: 11,
        name_th: "แจ้งเบาะแสยาเสพติด",
        name_en: null,
        complaint_type_id: 3,
      },
      {
        id: 12,
        name_th: "ทุจริตต่อหน้าที่",
        name_en: null,
        complaint_type_id: 4,
      },
    ];

    const selectOptions = ref<any>({
      years: [],
      months: [
        { value: null, name: "ทั้งหมด" },
        { value: 1, name: "มกราคม" },
        { value: 2, name: "กุมภาพันธ์" },
        { value: 3, name: "มีนาคม" },
        { value: 4, name: "เมษายน" },
        { value: 5, name: "พฤษภาคม" },
        { value: 6, name: "มิถุนายน" },
        { value: 7, name: "กรกฏาคม" },
        { value: 8, name: "สิงหาคม" },
        { value: 9, name: "กันยายน" },
        { value: 10, name: "ตุลาคม" },
        { value: 11, name: "พฤศจิกายน" },
        { value: 12, name: "ธันวาคม" },
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
        { name: "ข้อมูลไม่ครบถ้วน", value: 2 },
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
        },
        {
          id: 2,
          name_th: "อำนวยการ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 3,
          name_th: "บริหาร",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 4,
          name_th: "สืบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 5,
          name_th: "สอบสวน",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 6,
          name_th: "จราจร",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 7,
          name_th: "ป้องกันปราบปรามยาเสพติด",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 8,
          name_th: "กิจการพิเศษ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 9,
          name_th: "ธุรการ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 10,
          name_th: "ปฎิบัติการพิเศษ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
        {
          id: 11,
          name_th: "อื่นๆ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
        },
      ],
      complaint_channels: [
        {
          id: 1,
          name_th: "ร้องเรียนด้วยตนเอง",
          name_en: null,
        },
        {
          id: 2,
          name_th: "จดหมาย",
          name_en: null,
        },
        {
          id: 3,
          name_th: "สำนักงานปลัดสำนักนายกรัฐมนตรี",
          name_en: null,
        },
        {
          id: 4,
          name_th: "1599 ศปก.ตร.",
          name_en: null,
        },
        {
          id: 5,
          name_th: "ผู้บังคับบัญชาสั่งการ",
          name_en: null,
        },
        {
          id: 6,
          name_th: "หนังสือพิมพ์, social, สื่อมวลชน",
          name_en: null,
        },
        {
          id: 7,
          name_th: "หน่วยงานราชการอื่นๆ",
          name_en: null,
        },
        {
          id: 8,
          name_th: "JCOM ร้องเรียน/แจ้งเบาะแส ",
          name_en: null,
        },
        {
          id: 9,
          name_th: "อื่น ๆ",
          name_en: null,
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
        },
        {
          id: 28,
          name_th: "ตำรวจภูธรภาค 1",
          name_th_abbr: "ภ.1",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 1,
        },
        {
          id: 29,
          name_th: "ตำรวจภูธรภาค 2",
          name_th_abbr: "ภ.2",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 2,
        },
        {
          id: 30,
          name_th: "ตำรวจภูธรภาค 3",
          name_th_abbr: "ภ.3",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 3,
        },
        {
          id: 31,
          name_th: "ตำรวจภูธรภาค 4",
          name_th_abbr: "ภ.4",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 4,
        },
        {
          id: 32,
          name_th: "ตำรวจภูธรภาค 5",
          name_th_abbr: "ภ.5",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 5,
        },
        {
          id: 33,
          name_th: "ตำรวจภูธรภาค 6",
          name_th_abbr: "ภ.6",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 6,
        },
        {
          id: 34,
          name_th: "ตำรวจภูธรภาค 7",
          name_th_abbr: "ภ.7",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 7,
        },
        {
          id: 35,
          name_th: "ตำรวจภูธรภาค 8",
          name_th_abbr: "ภ.8",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 8,
        },
        {
          id: 36,
          name_th: "ตำรวจภูธรภาค 9",
          name_th_abbr: "ภ.9",
          name_en: null,
          name_en_abbr: null,
          inspector_id: 9,
        },
        {
          id: 100,
          name_th: "อื่น ๆ",
          name_en: null,
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

    const getRandomHexColor = () => {
      const randomColor = Math.floor(Math.random() * 16777215).toString(16);
      return `#${randomColor.padStart(6, "0")}`;
    };

    const pieChartOptions = <any>{
      plugins: {
        legend: {
          display: true,
          position: "right",
          labels: {
            boxWidth: 8, // ความกว้างของลูกศร
            boxHeight: 8, // ความสูงของลูกศร
            padding: 8, // ระยะห่างระหว่างลูกศรกับข้อความ
            // generateLabels: (chart: any) => {
            //   const sortedData = [...chart.data.datasets[0].data].sort(
            //     (a, b) => b - a
            //   );

            //   return sortedData.map((data, i) => ({
            //     text: `${chart.data.labels[i]} (${data})`,
            //     fillStyle: chart.data.datasets[0].backgroundColor[i],
            //   }));
            // },
          },
        },
      },
      layout: {
        width: 400,
      },
      responsive: true,
    };

    const topic_category_data = ref<any>({
      labels: [],
      data: [],
      backgroundColor: [],
    });

    const chartTopicCategoryData = ref<any>({
      labels: topic_category_data.value.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: topic_category_data.value.data,
          backgroundColor: topic_category_data.value.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });

    const complaint_channel_data = ref<any>({
      labels: [],
      data: [],
      backgroundColor: [],
    });

    const chartChannelData = ref<any>({
      labels: complaint_channel_data.value.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: complaint_channel_data.value.data,
          backgroundColor: complaint_channel_data.value.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });

    const section_data = ref<any>({
      labels: [],
      data: [],
      backgroundColor: [],
    });

    const chartSectionData = ref<any>({
      labels: section_data.value.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: section_data.value.data,
          backgroundColor: section_data.value.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
        },
      ],
    });

    const organization_data = ref<any>({
      labels: [],
      data: [],
      backgroundColor: [],
    });

    const chartOrganizationOptions = <any>{
      plugins: {
        legend: {
          display: false,
          position: "right",
          labels: {
            boxWidth: 15, // ความกว้างของลูกศร
            boxHeight: 15, // ความสูงของลูกศร
            padding: 15, // ระยะห่างระหว่างลูกศรกับข้อความ
            generateLabels: (chart) => {
              const sortedData = [...chart.data.datasets[0].data].sort(
                (a, b) => b - a
              );

              return sortedData.map((data, i) => ({
                text: `${chart.data.labels[i]} (${data} เรื่อง)`,
                fillStyle: chart.data.datasets[0].backgroundColor[i],
              }));
            },
          },
        },
      },
      layout: {
        width: 800,
      },
      responsive: true,
    };
    const chartOrganizationData = ref<any>({
      labels: organization_data.value.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: organization_data.value.data,
          backgroundColor: organization_data.value.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
        },
      ],
    });

    // Fetch Data
    const fetchItems = async () => {
      try {
        const params = {
          perPage: 1000000,
          currentPage: 1,
          ...search,
          complaint_type_id: complaint_type.value.id,
          year: search.year.value,
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

        data.data.forEach((x: any) => {
          if (x.state_id == 18) {
            reject_items.value.push(x);
          } else {
            receive1_items.value.push(x);
          }
        });

        receive1_items.value.forEach((x: any) => {
          if (x.state_id != 3) {
            send1_items.value.push(x);
          }

          if (x.state_id == 17) {
            success_items.value.push(x);
          } else {
            if (x.state_id != 3) {
              during_items.value.push(x);
            }
          }
        });

        cardStatus.value[0].total = items.length;
        cardStatus.value[1].total = reject_items.value.length;
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
      selectOptions.value.topic_categories = defaultTopicCategories.filter(
        (x: any) => {
          return x.complaint_type_id == complaint_type.value.id;
        }
      );

      topic_category_data.value = {
        labels: selectOptions.value.topic_categories.map((x: any) => {
          return x.name_th;
        }),
        data: selectOptions.value.topic_categories.map((x: any) => {
          let count = receive1_items.value.filter((e: any) => {
            return e.topic_type.topic_category.id == x.id;
          });
          return count.length;
        }),
        backgroundColor: selectOptions.value.topic_categories.map((x: any) => {
          return getRandomHexColor();
        }),
      };

      //   let spit_zero: any = [];
      //   topic_category_data.value.data.forEach((x: any, idx: any) => {
      //     if (x == 0) {
      //       spit_zero.push(idx);
      //     }
      //   });

      //   spit_zero.forEach((x: any) => {
      //     topic_category_data.value.labels.splice(x, 1);
      //     topic_category_data.value.data.splice(x, 1);
      //     topic_category_data.value.backgroundColor.splice(x, 1);
      //   });

      chartTopicCategoryData.value = {
        labels: topic_category_data.value.labels,
        datasets: [
          {
            data: topic_category_data.value.data,
            backgroundColor: topic_category_data.value.backgroundColor,
          },
        ],
      };

      // labels: selectOptions.value.complaint_channels.map((x: any) => {
      //     return x.name_th;
      //   }),
      //   data: selectOptions.value.complaint_channels.map((x: any) => {
      //     return Math.floor(Math.random() * 50) + 1;
      //   }),
      //   backgroundColor: selectOptions.value.complaint_channels.map((x: any) => {
      //     return getRandomHexColor();
      //   }),

      // chart2
      complaint_channel_data.value = {
        labels: selectOptions.value.complaint_channels.map((x: any) => {
          return x.name_th;
        }),
        data: selectOptions.value.complaint_channels.map((x: any) => {
          let count = receive1_items.value.filter((e: any) => {
            return e.complaint_channel_id == x.id;
          });
          return count.length;
        }),
        backgroundColor: selectOptions.value.complaint_channels.map(
          (x: any) => {
            return getRandomHexColor();
          }
        ),
      };

      //   let spit_zero2: any = [];
      //   complaint_channel_data.value.data.forEach((x: any, idx: any) => {
      //     if (x == 0) {
      //       spit_zero2.push(idx);
      //     }
      //   });

      //   spit_zero2.forEach((x: any) => {
      //     complaint_channel_data.value.labels.splice(x, 1);
      //     complaint_channel_data.value.data.splice(x, 1);
      //     complaint_channel_data.value.backgroundColor.splice(x, 1);
      //   });

      chartChannelData.value = {
        labels: complaint_channel_data.value.labels,
        datasets: [
          {
            data: complaint_channel_data.value.data,
            backgroundColor: complaint_channel_data.value.backgroundColor,
          },
        ],
      };

      // chart3
      section_data.value = {
        labels: selectOptions.value.sections.map((x: any) => {
          return x.name_th;
        }),
        // [5,10,29]
        data: selectOptions.value.sections.map((x: any) => {
          let count_section_ac = 0;
          receive1_items.value.forEach((e: any) => {
            let count_ac = e.accused.filter((a: any) => {
              return a.section_id == x.id;
            });
            count_section_ac = count_section_ac + count_ac.length;
          });

          return count_section_ac;
        }),
        backgroundColor: selectOptions.value.sections.map((x: any) => {
          return getRandomHexColor();
        }),
      };
      chartSectionData.value = {
        labels: section_data.value.labels,
        datasets: [
          {
            data: section_data.value.data,
            backgroundColor: section_data.value.backgroundColor,
          },
        ],
      };

      //   chart4
      organization_data.value = {
        labels: selectOptions.value.organizations.map((x: any) => {
          return x.name_th_abbr;
        }),
        data: selectOptions.value.organizations.map((x: any) => {
          let count_org_ac = 0;
          receive1_items.value.forEach((e: any) => {
            let count_ac = e.accused.filter((a: any) => {
              return a.bureau_id == x.id;
            });
            count_org_ac = count_org_ac + count_ac.length;
          });

          return count_org_ac;
        }),
        backgroundColor: selectOptions.value.organizations.map((x: any) => {
          return getRandomHexColor();
        }),
      };
      chartOrganizationData.value = {
        labels: organization_data.value.labels,
        datasets: [
          {
            label: "จำนวนเรื่อง",
            data: organization_data.value.data,
            backgroundColor: organization_data.value.backgroundColor,
            hoverOffset: 10,
            borderRadius: 3,
          },
        ],
      };
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };

    const onClear = async () => {
      search.value = {};
    };
    // const onExport = async () => {print};

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
      pieChartOptions,
      chartTopicCategoryData,
      chartChannelData,
      chartSectionData,
      chartOrganizationOptions,
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
      chartTopicCategoryRef,
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
