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
              v-if="chartSectionData.series[0].data.length != 0"
              class="chart"
              :option="chartSectionData"
            />
          </div>
        </div>
      </div>

      <div class="card mt-5">
        <div class="card-header">
          <h6 class="card-title">สถิติสายงานที่ถูกร้องเรียน</h6>
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
                  <th class="text-center text-white">สายงาน</th>
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
              <tbody v-if="chartSectionData.series.length != 0">
                <tr v-for="(ss, idx) in chartSectionData.series" :key="idx">
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
        {
          id: 12,
          name_th: "ไม่ระบุ",
          name_th_abbr: null,
          name_en: null,
          name_en_abbr: null,
          count_section: 0,
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
      complaint_title: "",
      complainant_fullname: "",
      accused_fullname: "",
      is_anonymous: null,
      state_id: null,
      inspector_state_id: null,
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      incident_datetime: null,
      province_id: null,
      district_id: null,
      sub_district_id: null,
      complaint_type_id: null,
      topic_category_id: null,
      topic_type_id: null,
      jcoms_no: "",
      complaint_channel_id: null,
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
    const chartSectionData = ref<any>({
      ...defaultBarChart,
      title: {
        text: "สถิติสายงานที่ถูกร้องเรียน",
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

        chartSectionData.value = {
          ...defaultBarChart,
          title: {
            text: "สถิติสายงานที่ถูกร้องเรียน",
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

      chartSectionData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: yearsRange.value,
      };

      let groupedData: any = {};

      const processAccused = (
        accused: any,
        year: number,
        section_id: number | null
      ) => {
        section_id = section_id ?? 12; // default to 12 if section_id is null

        if (!groupedData[section_id]) {
          groupedData[section_id] = { section_id, year: [], data: [] };
        }

        const yearIndex = groupedData[section_id].year.indexOf(year);
        if (yearIndex === -1) {
          groupedData[section_id].year.push(year);
          groupedData[section_id].data.push(1);
        } else {
          groupedData[section_id].data[yearIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const year = new Date(complaint.created_at).getFullYear() + 543;

        if (complaint.accused.length > 0) {
          complaint.accused.forEach((accused: any) =>
            processAccused(accused, year, accused.section_id)
          );
        } else {
          processAccused(null, year, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const section = selectOptions.value.sections.find(
          (e: any) => e.id == x.section_id
        );
        x.section_name = section ? section.name_th : "Unknown";

        x.data = chartSectionData.value.xAxis.data.map((year: string) => {
          const yearIndex = x.year.indexOf(parseInt(year));
          return yearIndex !== -1 ? x.data[yearIndex] : 0;
        });

        return x;
      });

      chartSectionData.value.series = result.map((x: any) => {
        let data = {
          name: x.section_name,
          type: "bar",
          barGap: 0.1,
          emphasis: { focus: "series" },
          data: x.data,
          label: {
            show: true,
            position: "top",
          },
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

      chartSectionData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: monthsRange.value,
      };

      let groupedData: any = {};

      const processAccused = (
        accused: any,
        yearMonth: string,
        section_id: number | null
      ) => {
        section_id = section_id ?? 12; // default to 12 if section_id is null

        if (!groupedData[section_id]) {
          groupedData[section_id] = { section_id, yearMonth: [], data: [] };
        }

        const monthIndex = groupedData[section_id].yearMonth.indexOf(yearMonth);
        if (monthIndex === -1) {
          groupedData[section_id].yearMonth.push(yearMonth);
          groupedData[section_id].data.push(1);
        } else {
          groupedData[section_id].data[monthIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const createdAt = dayjs(complaint.created_at)
          .locale("th")
          .format("MMM BB");

        if (complaint.accused.length > 0) {
          complaint.accused.forEach((accused: any) =>
            processAccused(accused, createdAt, accused.section_id)
          );
        } else {
          processAccused(null, createdAt, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const section = selectOptions.value.sections.find(
          (e: any) => e.id == x.section_id
        );
        x.section_name = section ? section.name_th : "Unknown";

        x.data = chartSectionData.value.xAxis.data.map((yearMonth: string) => {
          const monthIndex = x.yearMonth.indexOf(yearMonth);
          return monthIndex !== -1 ? x.data[monthIndex] : 0;
        });

        return x;
      });

      chartSectionData.value.series = result.map((x: any) => ({
        name: x.section_name,
        type: "bar",
        barGap: 0,
        emphasis: { focus: "series" },
        data: x.data,
        label: {
          show: true,
          position: "top",
        },
      }));
    };

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

      chartSectionData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: weeksRange.value,
        axisLabel: {
          rotate: 20, // ตั้งค่ามุมที่ต้องการให้ label เฉียง
          //   formatter: (value: any) => {
          //     return value.split(" ").join("\n"); // แยกบรรทัด label หากจำเป็น
          //   },
        },
      };

      let groupedData: any = {};

      const processAccused = (
        accused: any,
        weekRange: string,
        section_id: number | null
      ) => {
        section_id = section_id ?? 12; // default to 12 if section_id is null

        if (!groupedData[section_id]) {
          groupedData[section_id] = { section_id, weekRange: [], data: [] };
        }

        const weekIndex = groupedData[section_id].weekRange.indexOf(weekRange);
        if (weekIndex === -1) {
          groupedData[section_id].weekRange.push(weekRange);
          groupedData[section_id].data.push(1);
        } else {
          groupedData[section_id].data[weekIndex]++;
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

            if (complaint.accused.length > 0) {
              complaint.accused.forEach((accused: any) =>
                processAccused(accused, weekRange, accused.section_id)
              );
            } else {
              processAccused(null, weekRange, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const section = selectOptions.value.sections.find(
          (e: any) => e.id == x.section_id
        );
        x.section_name = section ? section.name_th : "Unknown";

        x.data = chartSectionData.value.xAxis.data.map((weekRange: string) => {
          const weekIndex = x.weekRange.indexOf(weekRange);
          return weekIndex !== -1 ? x.data[weekIndex] : 0;
        });

        return x;
      });

      chartSectionData.value.series = result.map((x: any) => ({
        name: x.section_name,
        type: "bar",
        barGap: 0,
        emphasis: { focus: "series" },
        data: x.data,
        label: {
          show: true,
          position: "top",
        },
      }));
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

      chartSectionData.value.xAxis = {
        type: "category",
        axisTick: { show: false },
        data: daysRange.value,
        axisLabel: {
          rotate: 20, // ตั้งค่ามุมที่ต้องการให้ label เฉียง
        },
      };

      let groupedData = {};

      const processAccused = (accused: any, day: any, section_id: any) => {
        section_id = section_id ?? 12; // default to 12 if section_id is null

        if (!groupedData[section_id]) {
          groupedData[section_id] = { section_id, day: [], data: [] };
        }

        const dayIndex = groupedData[section_id].day.indexOf(day);
        if (dayIndex === -1) {
          groupedData[section_id].day.push(day);
          groupedData[section_id].data.push(1);
        } else {
          groupedData[section_id].data[dayIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const complaintDate: any = dayjs(complaint.created_at);

        allDays.forEach((day: any) => {
          const formattedDay = day.locale("th").format("DD MMM BB");
          if (complaintDate.isSame(day, "day")) {
            if (complaint.accused.length > 0) {
              complaint.accused.forEach((accused: any) =>
                processAccused(accused, formattedDay, accused.section_id)
              );
            } else {
              processAccused(null, formattedDay, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const section = selectOptions.value.sections.find(
          (e: any) => e.id == x.section_id
        );
        x.section_name = section ? section.name_th : "Unknown";

        x.data = chartSectionData.value.xAxis.data.map((day: any) => {
          const dayIndex = x.day.indexOf(day);
          return dayIndex !== -1 ? x.data[dayIndex] : 0;
        });

        return x;
      });

      chartSectionData.value.series = result.map((x) => ({
        name: x.section_name,
        type: "bar",
        barGap: 0,
        emphasis: { focus: "series" },
        data: x.data,
        label: {
          show: true,
          position: "top",
        },
      }));
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
            header: "สายงาน",
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
        worksheet.addRows(chartSectionData.value.series);
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
        worksheet.insertRow(1, "สถิติสายงานที่ถูกร้องเรียน");
        worksheet.mergeCells("A1:K1");
        worksheet.getCell("A1").value = "สถิติสายงานที่ถูกร้องเรียน";
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
        link.download = "สถิติสายงานที่ถูกร้องเรียน.xlsx";
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
      chartSectionData,
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
