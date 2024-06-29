<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container mt-5">
      <div class="card shadow-sm my-5">
        <!-- Search -->
        <SearchComponent
          :search="search"
          :show_complaint_type_id="false"
          :state_new="false"
          @search="fetchItems"
          @clear="onClear"
        />
      </div>

      <!-- Chart -->
      <div class="card mt-15">
        <div class="card-body row responsive">
          <div
            class="col-12 col-md-4 mx-auto"
            style="min-height: 400px; min-width: 800px"
          >
            <v-chart
              v-if="chartData.series[0]?.data.length != 0"
              class="chart"
              :option="chartData"
            />
          </div>
        </div>
      </div>

      <div class="card mt-5">
        <div class="card-header">
          <h6 class="card-title">สถิติหน่วยงานที่ถูกร้องเรียน</h6>
          <div class="card-toolbar">
            <div class="dropdown">
              <button
                class="btn btn-outline btn-outline-success pe-sm-3 ps-sm-5 dropdown-toggle"
                type="button"
                id="dropdownMenuButton"
                data-bs-toggle="dropdown"
                aria-expanded="false"
              >
                <i class="bi bi-file-earmark-arrow-down-fill fs-4"></i>
                <span class="d-none d-lg-inline-block ms-2">ส่งออกข้อมูล</span>
              </button>
              <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <li>
                  <a class="dropdown-item" @click="onExport()">Excel</a>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="card-body row">
          <div class="col-12 col-md-12 mb-3 table-responsive">
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-center text-white">
                    สถิติหน่วยงานที่ถูกร้องเรียน
                  </th>
                  <th
                    class="text-center text-white"
                    v-if="search.report_type.value == 1"
                    v-for="(d, i) in yearsRange"
                    :key="i"
                  >
                    {{ d }}
                  </th>
                  <th
                    class="text-center text-white"
                    v-if="search.report_type.value == 2"
                    v-for="(d, i) in monthsRange"
                    :key="i"
                  >
                    {{ d }}
                  </th>
                  <th
                    class="text-center text-white"
                    v-if="search.report_type.value == 3"
                    v-for="(d, i) in weeksRange"
                    :key="i"
                  >
                    {{ d }}
                  </th>
                  <th
                    class="text-center text-white"
                    v-if="search.report_type.value == 4"
                    v-for="(d, i) in daysRange"
                    :key="i"
                  >
                    {{ d }}
                  </th>
                </tr>
              </thead>
              <tbody v-if="chartData.series.length != 0">
                <tr v-for="(ss, idx) in chartData.series" :key="idx">
                  <td class="text-center">{{ ss.name }}</td>
                  <td class="text-center" v-for="(d, i) in ss.data" :key="i">
                    {{ d }}
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
import isBetween from "dayjs/plugin/isBetween";
dayjs.extend(buddhistEra);
dayjs.extend(isBetween);

// Excel
import XLSX from "xlsx";
import ExcelJS from "exceljs";
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
import SearchComponent from "@/components/report/Search.vue";
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";

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
    SearchComponent,
  },
  setup() {
    // UI

    provide(THEME_KEY, "light");

    // Variable
    const router = useRouter();
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

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
      organizations: [
        {
          bureau_th: "สำนักงานยุทธศาสตร์ตำรวจ",
          bureau_th_abbr: "สยศ.ตร.",
          inspector_th: "กองตรวจราชการ 7",
          inspector_th_abbr: "กต.7",
          bureau_id: 1,
          inspector_id: 7,
        },
        {
          bureau_th: "สำนักงานส่งกำลังบำรุง",
          bureau_th_abbr: "สกบ.",
          inspector_th: "กองตรวจราชการ 5",
          inspector_th_abbr: "กต.5",
          bureau_id: 2,
          inspector_id: 5,
        },
        {
          bureau_th: "สำนักงานกำลังพล",
          bureau_th_abbr: "สกพ.",
          inspector_th: "กองตรวจราชการ 5",
          inspector_th_abbr: "กต.5",
          bureau_id: 3,
          inspector_id: 5,
        },
        {
          bureau_th: "สำนักงานงบประมาณและการเงิน",
          bureau_th_abbr: "สงป.",
          inspector_th: "กองตรวจราชการ 4",
          inspector_th_abbr: "กต.4",
          bureau_id: 4,
          inspector_id: 4,
        },
        {
          bureau_th: "สำนักงานกฎหมายและคดี",
          bureau_th_abbr: "กมค.",
          inspector_th: "กองตรวจราชการ 6",
          inspector_th_abbr: "กต.6",
          bureau_id: 5,
          inspector_id: 6,
        },
        {
          bureau_th: "สำนักงานคณะกรรมการข้าราชการตำรวจ",
          bureau_th_abbr: "สง.ก.ตร.",
          inspector_th: "กองตรวจราชการ 6",
          inspector_th_abbr: "กต.6",
          bureau_id: 6,
          inspector_id: 6,
        },
        {
          bureau_th: "สำนักงานจเรตำรวจ",
          bureau_th_abbr: "จต.",
          inspector_th: "กองบังคับการอำนวยการสำนักงานจเรตำรวจ",
          inspector_th_abbr: "บก.อก.จต.",
          bureau_id: 7,
          inspector_id: 11,
        },
        {
          bureau_th: "สำนักงานตรวจสอบภายใน",
          bureau_th_abbr: "สตส.",
          inspector_th: "กองตรวจราชการ 4",
          inspector_th_abbr: "กต.4",
          bureau_id: 8,
          inspector_id: 4,
        },
        {
          bureau_th: "สำนักงานเลขานุการตำรวจแห่งชาติ",
          bureau_th_abbr: "สลก.ตร.",
          inspector_th: "กองตรวจราชการ 4",
          inspector_th_abbr: "กต.4",
          bureau_id: 9,
          inspector_id: 4,
        },
        {
          bureau_th: "กองการต่างประเทศ",
          bureau_th_abbr: "ตท.",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 10,
          inspector_id: 2,
        },
        {
          bureau_th: "กองสารนิเทศ",
          bureau_th_abbr: "สท.",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 11,
          inspector_id: 2,
        },
        {
          bureau_th: "สำนักงานคณะกรรมการนโยบายตำรวจแห่งชาติ",
          bureau_th_abbr: "สง.ก.ต.ช.",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 12,
          inspector_id: 2,
        },
        {
          bureau_th: "กองบินตำรวจ",
          bureau_th_abbr: "บ.ตร.",
          inspector_th: "กองตรวจราชการ 7",
          inspector_th_abbr: "กต.7",
          bureau_id: 13,
          inspector_id: 7,
        },
        {
          bureau_th: "กองวินัย",
          bureau_th_abbr: "วน.",
          inspector_th: "กองตรวจราชการ 5",
          inspector_th_abbr: "กต.5",
          bureau_id: 14,
          inspector_id: 5,
        },
        {
          bureau_th:
            "สถาบันฝึกอบรมระหว่างประเทศว่าด้วยการดำเนินการให้เป็นไปตามกฎหมาย",
          bureau_th_abbr: "ILEA",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 15,
          inspector_id: 1,
        },
        {
          bureau_th: "กองบัญชาการตำรวจสอบสวนกลาง",
          bureau_th_abbr: "บช.ก.",
          inspector_th: "กองตรวจราชการ 9",
          inspector_th_abbr: "กต.9",
          bureau_id: 16,
          inspector_id: 9,
        },
        {
          bureau_th: "กองบัญชาการตำรวจปราบปรามยาเสพติด",
          bureau_th_abbr: "บช.ปส.",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 17,
          inspector_id: 2,
        },
        {
          bureau_th: "กองบัญชาการตำรวจสันติบาล",
          bureau_th_abbr: "บช.ส.",
          inspector_th: "กองตรวจราชการ 3",
          inspector_th_abbr: "กต.3",
          bureau_id: 18,
          inspector_id: 3,
        },
        {
          bureau_th: "สำนักงานตรวจคนเข้าเมือง",
          bureau_th_abbr: "สตม.",
          inspector_th: "กองตรวจราชการ 8",
          inspector_th_abbr: "กต.8",
          bureau_id: 19,
          inspector_id: 8,
        },
        {
          bureau_th: "กองบัญชาการตำรวจตระเวนชายแดน",
          bureau_th_abbr: "ตชด.",
          inspector_th: "กองตรวจราชการ 7",
          inspector_th_abbr: "กต.7",
          bureau_id: 20,
          inspector_id: 7,
        },
        {
          bureau_th: "สำนักงานพิสูจน์หลักฐานตำรวจ",
          bureau_th_abbr: "สพฐ.ตร.",
          inspector_th: "กองตรวจราชการ 10",
          inspector_th_abbr: "กต.10",
          bureau_id: 21,
          inspector_id: 10,
        },
        {
          bureau_th: "สำนักงานเทคโนโลยีสารสนเทศและการสื่อสาร ",
          bureau_th_abbr: "สทส.",
          inspector_th: "กองตรวจราชการ 10",
          inspector_th_abbr: "กต.10",
          bureau_id: 22,
          inspector_id: 10,
        },
        {
          bureau_th: "กองบัญชาการตำรวจท่องเที่ยว",
          bureau_th_abbr: "บช.ทท.",
          inspector_th: "กองตรวจราชการ 9",
          inspector_th_abbr: "กต.9",
          bureau_id: 23,
          inspector_id: 9,
        },
        {
          bureau_th: "กองบัญชาการศึกษา",
          bureau_th_abbr: "บช.ศ.",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 24,
          inspector_id: 2,
        },
        {
          bureau_th: "โรงเรียนนายร้อยตำรวจ",
          bureau_th_abbr: "รร.นรต.",
          inspector_th: "กองตรวจราชการ 7",
          inspector_th_abbr: "กต.7",
          bureau_id: 25,
          inspector_id: 7,
        },
        {
          bureau_th: "โรงพยาบาลตำรวจ",
          bureau_th_abbr: "รพ.ตร.",
          inspector_th: "กองตรวจราชการ 5",
          inspector_th_abbr: "กต.5",
          bureau_id: 26,
          inspector_id: 5,
        },
        {
          bureau_th: "กองบัญชาการตำรวจนครบาล",
          bureau_th_abbr: "บช.น.",
          inspector_th: "กองตรวจราชการ 10",
          inspector_th_abbr: "กต.10",
          bureau_id: 27,
          inspector_id: 10,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 1",
          bureau_th_abbr: "ภ.1",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 28,
          inspector_id: 1,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 2",
          bureau_th_abbr: "ภ.2",
          inspector_th: "กองตรวจราชการ 2",
          inspector_th_abbr: "กต.2",
          bureau_id: 29,
          inspector_id: 2,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 3",
          bureau_th_abbr: "ภ.3",
          inspector_th: "กองตรวจราชการ 3",
          inspector_th_abbr: "กต.3",
          bureau_id: 30,
          inspector_id: 3,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 4",
          bureau_th_abbr: "ภ.4",
          inspector_th: "กองตรวจราชการ 4",
          inspector_th_abbr: "กต.4",
          bureau_id: 31,
          inspector_id: 4,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 5",
          bureau_th_abbr: "ภ.5",
          inspector_th: "กองตรวจราชการ 5",
          inspector_th_abbr: "กต.5",
          bureau_id: 32,
          inspector_id: 5,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 6",
          bureau_th_abbr: "ภ.6",
          inspector_th: "กองตรวจราชการ 6",
          inspector_th_abbr: "กต.6",
          bureau_id: 33,
          inspector_id: 6,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 7",
          bureau_th_abbr: "ภ.7",
          inspector_th: "กองตรวจราชการ 7",
          inspector_th_abbr: "กต.7",
          bureau_id: 34,
          inspector_id: 7,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 8",
          bureau_th_abbr: "ภ.8",
          inspector_th: "กองตรวจราชการ 8",
          inspector_th_abbr: "กต.8",
          bureau_id: 35,
          inspector_id: 8,
        },
        {
          bureau_th: "ตำรวจภูธรภาค 9",
          bureau_th_abbr: "ภ.9",
          inspector_th: "กองตรวจราชการ 9",
          inspector_th_abbr: "กต.9",
          bureau_id: 36,
          inspector_id: 9,
        },
        {
          bureau_th: "หน่วยงานอื่นๆ",
          bureau_th_abbr: "อื่นๆ",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 38,
          inspector_id: 1,
        },
        {
          bureau_th: "กองบัญชาการตำรวจสืบสวนสอบสวนอาชญากรรมทางเทคโนโลยี",
          bureau_th_abbr: "สอท.",
          inspector_th: "กองตรวจราชการ 6",
          inspector_th_abbr: "กต.6",
          bureau_id: 39,
          inspector_id: 6,
        },
        {
          bureau_th: "ศูนย์ปราบปรามการกระทำผิดเกี่ยวกับน้ำมันเชื้อเพลิง",
          bureau_th_abbr: "ศปนม.ตร.",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 40,
          inspector_id: 1,
        },
        {
          bureau_th: "ศปอส.ตร.(ศูนย์ปราบปรามอาชญากรรมทางเทคโนโลยีสารสนเทศ)",
          bureau_th_abbr:
            "ศปอส.ตร.(ศูนย์ปราบปรามอาชญากรรมทางเทคโนโลยีสารสนเทศ)",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 41,
          inspector_id: 1,
        },
        {
          bureau_th: "ศูนย์ปฏิบัติการสำนักงานตำรวจแห่งชาติ",
          bureau_th_abbr: "ศปก.ตร.",
          inspector_th: "กองตรวจราชการ 1",
          inspector_th_abbr: "กต.1",
          bureau_id: 42,
          inspector_id: 1,
        },
      ],
    });

    const defaultSearch = {
      year_range: [new Date().getFullYear(), new Date().getFullYear()],
      month_range: [
        {
          month: new Date().getMonth(),
          year: new Date().getFullYear(),
        },
        {
          month: new Date().getMonth(),
          year: new Date().getFullYear(),
        },
      ],
      week_range: [],
      day_range: [],
      report_type: { value: 1, name: "รายปี" },
      accused_fullname: "",
      complainant_fullname: "",
      complaint_title: "",
    };

    const search = reactive<any>({
      ...defaultSearch,
    });

    const items = reactive<any>([]);
    const receive1_items = ref<any>([]);
    const item = reactive({});
    const yearsRange = ref<any>([]);
    const monthsRange = ref<any>([]);
    const weeksRange = ref<any>([]);
    const daysRange = ref<any>([]);

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
        axisTick: { show: false },
        data: ["2567", "2566"],
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
    const chartData = ref<any>({
      ...defaultBarChart,
      title: {
        text: "สถิติหน่วยงานที่ถูกร้องเรียน",
        left: "center",
      },
    });

    const generateYearRange = (start: number, end: number) => {
      const years: any = [];
      for (let year = end; year >= start; year--) {
        years.push(year);
      }
      return years;
    };

    // Fetch Data
    const fetchItems = async () => {
      try {
        let create_from: any = undefined;
        let create_to: any = undefined;
        const params = {
          perPage: 1000000,
          currentPage: 1,
          ...search,
          create_from: create_from,
          create_to: create_to,
          complaint_type_id: search.complaint_type_id?.id,
        };
        // ได้ DATA ทั้งหมดที่กรองจากปี เดือนและประเภทการร้องเรียน
        const { data } = await ApiService.query("complaint/", {
          params: params,
        });

        // ต้องการแยกเฉพาะส่วนที่รับ และไม่รับ
        Object.assign(items, data.data);
        receive1_items.value = [];

        data.data.forEach((x: any) => {
          if (x.state_id == 18) {
          } else if (x.state_id >= 3) {
            receive1_items.value.push(x);
          } else {
          }
        });

        chartData.value = {
          ...defaultBarChart,
          title: {
            text: "สถิติหน่วยงานที่ถูกร้องเรียน",
            left: "center",
          },
        };

        if (search.report_type.value == 1) {
          reloadData();
        } else if (search.report_type.value == 2) {
          reloadMonthData();
        } else if (search.report_type.value == 3) {
          reloadWeekData();
        } else if (search.report_type.value == 4) {
          reloadDayData();
        }
      } catch (error) {
        console.log(error);
      }
    };

    const reloadData = async () => {
      yearsRange.value = generateYearRange(
        search.year_range[0],
        search.year_range[1]
      ).map((year: any) => year + 543); // Convert to Buddhist calendar year

      chartData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: yearsRange.value,
      };

      let groupedData: any = {};

      const processComplaint = (
        complaint: any,
        year: number,
        bureau_id: any
      ) => {
        bureau_id = complaint.bureau_id ?? 99;

        if (!groupedData[bureau_id]) {
          groupedData[bureau_id] = {
            bureau_id,
            year: [],
            data: [],
          };
        }

        const yearIndex = groupedData[bureau_id].year.indexOf(year);
        if (yearIndex === -1) {
          groupedData[bureau_id].year.push(year);
          groupedData[bureau_id].data.push(1);
        } else {
          groupedData[bureau_id].data[yearIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const year = new Date(complaint.created_at).getFullYear() + 543;

        if (complaint && complaint.bureau_id) {
          processComplaint(complaint, year, complaint.bureau_id);
        } else {
          processComplaint(complaint, year, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.organizations.find(
          (e: any) => e.bureau_id == x.bureau_id
        );
        x.bureau_th_abbr = tc ? tc.bureau_th_abbr : "Unknown";

        x.data = chartData.value.xAxis.data.map((year: string) => {
          const yearIndex = x.year.indexOf(parseInt(year));
          return yearIndex !== -1 ? x.data[yearIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.bureau_th_abbr,
          type: "bar",
          barGap: 0.1,
          emphasis: { focus: "series" },
          data: x.data,
        };

        let _i = 0;
        yearsRange.value.forEach((el: any) => {
          data[el.toString()] = x.data[_i];
          _i = _i + 1;
        });

        return data;
      });
    };

    // Month
    const generateMonthRangeReversed = (
      start: { month: number; year: number },
      end: { month: number; year: number }
    ) => {
      const months: any = [];
      let currentYear: any = end.year;
      let currentMonth: any = end.month;

      while (
        currentYear > start.year ||
        (currentYear === start.year && currentMonth >= start.month)
      ) {
        const date = dayjs().year(currentYear).month(currentMonth);
        const yearMonth = date.locale("th").format("MMM BB"); // แสดงเดือนเป็นภาษาไทยและปีเป็น พ.ศ.
        months.push(yearMonth);

        currentMonth--;
        if (currentMonth === -1) {
          currentMonth = 11;
          currentYear--;
        }
      }
      return months;
    };
    const reloadMonthData = async () => {
      const start = {
        month: search.month_range[0].month,
        year: search.month_range[0].year,
      };
      const end = {
        month: search.month_range[1].month,
        year: search.month_range[1].year,
      };

      monthsRange.value = generateMonthRangeReversed(start, end);

      chartData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: monthsRange.value,
      };

      let groupedData: any = {};

      const processComplaint = (
        complaint: any,
        yearMonth: number,
        bureau_id: any
      ) => {
        bureau_id = complaint.bureau_id ?? 99;

        if (!groupedData[bureau_id]) {
          groupedData[bureau_id] = {
            bureau_id,
            yearMonth: [],
            data: [],
          };
        }

        const monthIndex = groupedData[bureau_id].yearMonth.indexOf(yearMonth);
        if (monthIndex === -1) {
          groupedData[bureau_id].yearMonth.push(yearMonth);
          groupedData[bureau_id].data.push(1);
        } else {
          groupedData[bureau_id].data[monthIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const createdAt: any = dayjs(complaint.created_at)
          .locale("th")
          .format("MMM BB");

        if (complaint && complaint.bureau_id) {
          processComplaint(complaint, createdAt, complaint.bureau_id);
        } else {
          processComplaint(complaint, createdAt, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.organizations.find(
          (e: any) => e.bureau_id == x.bureau_id
        );
        x.bureau_th_abbr = tc ? tc.bureau_th_abbr : "Unknown";

        x.data = chartData.value.xAxis.data.map((yearMonth: string) => {
          const monthIndex = x.yearMonth.indexOf(yearMonth);
          return monthIndex !== -1 ? x.data[monthIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.bureau_th_abbr,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
        };

        let _i = 0;
        monthsRange.value.forEach((el: any) => {
          data[el.toString()] = x.data[_i];
          _i = _i + 1;
        });

        return data;
      });
    };

    // Week
    const generateAllWeeksInRange = (start: Date, end: Date) => {
      let current = dayjs(start);
      const endDay = dayjs(end);
      const weeks: any = [];

      while (current.isBefore(endDay) || current.isSame(endDay, "day")) {
        const startOfWeek = current.startOf("week");
        const endOfWeek = current.endOf("week");
        weeks.push([startOfWeek.toDate(), endOfWeek.toDate()]);
        current = current.add(1, "week");
      }

      return weeks;
    };

    const generateWeekLabels = (weeks: any[]) => {
      return weeks.map((range: any) => {
        const startOfWeek = dayjs(range[0]).locale("th").format("DD MMM BB");
        const endOfWeek = dayjs(range[1]).locale("th").format("DD MMM BB");
        return `${startOfWeek} - ${endOfWeek}`;
      });
    };

    const reloadWeekData = async () => {
      const allWeeks = generateAllWeeksInRange(
        search.week_range[0][0],
        search.week_range[search.week_range.length - 1][1]
      );
      weeksRange.value = generateWeekLabels(allWeeks);

      chartData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: weeksRange.value,
        axisLabel: {
          rotate: 20,
        },
      };

      let groupedData: any = {};

      const processComplaint = (
        complaint: any,
        weekRange: string,
        bureau_id: any
      ) => {
        bureau_id = complaint.bureau_id ?? 99;

        if (!groupedData[bureau_id]) {
          groupedData[bureau_id] = {
            bureau_id,
            weekRange: [],
            data: [],
          };
        }

        const weekIndex =
          groupedData[bureau_id].weekRange.indexOf(weekRange);
        if (weekIndex === -1) {
          groupedData[bureau_id].weekRange.push(weekRange);
          groupedData[bureau_id].data.push(1);
        } else {
          groupedData[bureau_id].data[weekIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const complaintDate = dayjs(complaint.created_at);

        allWeeks.forEach((range: any) => {
          const startOfWeek = dayjs(range[0]);
          const endOfWeek = dayjs(range[1]);

          if (complaintDate.isBetween(startOfWeek, endOfWeek, null, "[]")) {
            const weekRange = `${startOfWeek
              .locale("th")
              .format("DD MMM BB")} - ${endOfWeek
              .locale("th")
              .format("DD MMM BB")}`;

            if (complaint && complaint.bureau_id) {
              processComplaint(
                complaint,
                weekRange,
                complaint.bureau_id
              );
            } else {
              processComplaint(complaint, weekRange, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.complaint_channels.find(
          (e: any) => e.bureau_id == x.bureau_id
        );
        x.bureau_th_abbr = tc ? tc.bureau_th_abbr : "Unknown";

        x.data = chartData.value.xAxis.data.map((weekRange: string) => {
          const weekIndex = x.weekRange.indexOf(weekRange);
          return weekIndex !== -1 ? x.data[weekIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.bureau_th_abbr,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
        };
        let _i = 0;
        weeksRange.value.forEach((el: any) => {
          data[el.toString()] = x.data[_i];
          _i = _i + 1;
        });

        return data;
      });
    };

    // Day

    // ฟังก์ชันเพื่อสร้างช่วงวันที่ทั้งหมดในช่วงที่กำหนด
    function generateAllDaysInRange(startDate: any, endDate: any) {
      let days: any = [];
      let currentDate = dayjs(startDate);

      while (currentDate.isBefore(endDate) || currentDate.isSame(endDate)) {
        days.push(currentDate);
        currentDate = currentDate.add(1, "day");
      }

      return days;
    }

    // ฟังก์ชันเพื่อสร้าง label ของวันที่ในรูปแบบที่ต้องการ
    function generateDayLabels(days: any) {
      return days.map((day: any) => day.locale("th").format("DD MMM BB"));
    }

    const reloadDayData = async () => {
      const allDays = generateAllDaysInRange(
        search.day_range[0],
        search.day_range[1]
      );
      daysRange.value = generateDayLabels(allDays);

      chartData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: daysRange.value,
        axisLabel: {
          rotate: 20, // ตั้งค่ามุมที่ต้องการให้ label เฉียง
        },
      };

      let groupedData = {};

      const processComplaint = (
        complaint: any,
        day: any,
        bureau_id: any
      ) => {
        bureau_id = complaint.bureau_id ?? 99;

        if (!groupedData[bureau_id]) {
          groupedData[bureau_id] = {
            bureau_id,
            day: [],
            data: [],
          };
        }

        const dayIndex = groupedData[bureau_id].day.indexOf(day);
        if (dayIndex === -1) {
          groupedData[bureau_id].day.push(day);
          groupedData[bureau_id].data.push(1);
        } else {
          groupedData[bureau_id].data[dayIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const complaintDate: any = dayjs(complaint.created_at);

        allDays.forEach((day: any) => {
          const formattedDay = day.locale("th").format("DD MMM BB");

          if (complaintDate.isSame(day, "day")) {
            if (complaint && complaint.bureau_id) {
              processComplaint(
                complaint,
                formattedDay,
                complaint.bureau_id
              );
            } else {
              processComplaint(complaint, formattedDay, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.organizations.find(
          (e: any) => e.bureau_id == x.bureau_id
        );
        x.bureau_th_abbr = tc ? tc.bureau_th_abbr : "Unknown";

        x.data = chartData.value.xAxis.data.map((day: any) => {
          const dayIndex = x.day.indexOf(day);
          return dayIndex !== -1 ? x.data[dayIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x) => {
        let data = {
          name: x.bureau_th_abbr,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
        };

        let _i = 0;
        daysRange.value.forEach((el: any) => {
          data[el.toString()] = x.data[_i];
          _i = _i + 1;
        });
        return data;
      });
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };

    const onClear = async () => {
      Object.assign(search, { ...defaultSearch });
    };

    const onExport = async () => {
      setTimeout(async () => {
        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet("รายการ", {
          pageSetup: { orientation: "landscape" },
          headerFooter: {
            firstHeader: "Hello Exceljs",
            firstFooter: "Hello World",
          },
        });

        let columns = [
          {
            header: "หน่วยงานที่ถูกร้องเรียน",
            key: "name",
            width: 25,
            outlineLevel: 1,
          },
        ];

        if (search.report_type.value == 1) {
          yearsRange.value.forEach((el: any) => {
            columns.push({
              header: el.toString(),
              key: el.toString(),
              width: 25,
              outlineLevel: 1,
            });
          });
        } else if (search.report_type.value == 2) {
          monthsRange.value.forEach((el: any) => {
            columns.push({
              header: el.toString(),
              key: el.toString(),
              width: 25,
              outlineLevel: 1,
            });
          });
        } else if (search.report_type.value == 3) {
          weeksRange.value.forEach((el: any) => {
            columns.push({
              header: el.toString(),
              key: el.toString(),
              width: 25,
              outlineLevel: 1,
            });
          });
        } else if (search.report_type.value == 4) {
          daysRange.value.forEach((el: any) => {
            columns.push({
              header: el.toString(),
              key: el.toString(),
              width: 25,
              outlineLevel: 1,
            });
          });
        }

        worksheet.columns = [...columns];

        // worksheet.properties.defaultRowHeight = 20;
        worksheet.addRows(chartData.value.series);
        worksheet.eachRow((row) => {
          // row.height = 45;
          row.eachCell(function (cell) {
            cell.alignment = {
              vertical: "middle",
              horizontal: "center",
              wrapText: true,
            };
          });
        });
        const row = worksheet.getRow(1);
        row.height = 20;
        worksheet.insertRow(1, "สถิติหน่วยงานที่ถูกร้องเรียน");
        worksheet.mergeCells("A1:K1");
        worksheet.getCell("A1").value = "หน่วยงานที่ถูกร้องเรียน";
        worksheet.getCell("A1").alignment = {
          vertical: "middle",
          horizontal: "center",
        };
        const font = { name: "Arial", size: 18, bold: true };
        worksheet.getCell("A1").font = font;
        const font1 = { name: "Arial", size: 18, bold: true };
        worksheet.getCell("A1").font = font1;
        // Images
        const buffer = await workbook.xlsx.writeBuffer();
        const blob = new Blob([buffer], {
          type: "application/octet-stream",
        });
        const href = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = href;
        link.download = "หน่วยงานที่ถูกร้องเรียน.xlsx";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }, 1000);
    };

    // Mounted
    onMounted(async () => {
      search.year = selectOptions.value.years[0];
      await fetchItems();
    });

    return {
      selectOptions,
      search,
      items,
      item,
      router,
      format,
      chartData,
      onSearch,
      onClear,
      fetchItems,
      yearsRange,
      monthsRange,
      weeksRange,
      daysRange,
      onExport,
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

<style scoped>
.chart-container {
  width: 100%;
  height: 500px; /* สามารถปรับความสูงตามที่ต้องการได้ */
}
</style>
