<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container mt-5">
      <div class="card shadow-sm my-5">
        <!-- Search -->
        <SearchComponent
          :search="search"
          :show_complaint_type_id="true"
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
          <h6 class="card-title">สถิติประเภทเรื่องร้องเรียน</h6>
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
                  <th class="text-center text-white">ประเภทเรื่อง</th>
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

      <!-- Map Chart -->
      <div class="card mt-15">
        <div class="card-body row responsive">
          <div class="col-12 col-md-6 mx-auto" style="min-height: 800px">
            <table
              class="table table-bordered table-striped bg-sky"
              style="width: 100%"
              v-if="chartMapData?.series[0]?.data?.length != 0"
            >
              <thead class="bg-color-police">
                <tr>
                  <th class="text-white">จังหวัด</th>
                  <th class="text-center text-white">จำนวน</th>
                  <th
                    class="text-center text-white"
                    v-for="(tc, idx) in selectOptions.topic_categories"
                    :key="idx"
                  >
                    {{ tc.name_th }}
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(d, idx) in chartMapData.series[0].data" :key="idx">
                  <td>{{ d.name }}</td>
                  <td class="text-center">{{ d.value }}</td>
                  <td
                    class="text-center"
                    v-for="(tc, idx) in selectOptions.topic_categories"
                  >
                    {{ showCategory(tc, d.category) }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="col-12 col-md-6 mx-auto" style="min-height: 800px">
            <button
              @click="backToProvinces"
              v-if="showDistricts"
              class="btn btn-primary"
            >
              Back to Provinces
            </button>
            <v-chart
              class="chart-container3"
              :option="chartMapData"
              style="min-height: 800px"
              @click="handleMapClick"
            />
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
// Geo
import provinceJson from "@/assets/geo/provinces.json";
import districtJson from "@/assets/geo/districts.json";

// Excel
import XLSX from "xlsx";
import ExcelJS from "exceljs";
// Import echarts
import * as echarts from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { PieChart, BarChart, MapChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  GeoComponent,
  VisualMapComponent,
  ToolboxComponent,
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
  GeoComponent,
  VisualMapComponent,
  ToolboxComponent,
  MapChart,
]);

echarts.registerMap("TH", provinceJson as any, {});

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
      topic_categories: [],
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
      complaint_type_id: {
        id: 1,
        name_th: "ร้องเรียน",
      },
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
      legend: {
        data: [],
        top: "top", // แสดง legend ที่ด้านล่างของกราฟ
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
          label: {
            show: true,
            position: "top",
          },
        },
      ],
    };
    const chartData = ref<any>({
      ...defaultBarChart,
      title: {
        text: "สถิติประเภทเรื่องร้องเรียน",
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

    // Start Map Data
    const showDistricts = ref(false);

    const defaultMapChart = {
      title: {
        text: "จำนวนเรื่องร้องเรียนเชิงพื้นที่",
        //     subtext: "Data from www.census.gov",
        //     sublink: "http://www.census.gov/popest/data/datasets.html",
        left: "center",
      },
      tooltip: {
        trigger: "item",
        showDelay: 0,
        transitionDuration: 0.2,
        formatter: (params: any) => {
          const data = params.data;
          let text = "";
          data?.category?.forEach((x: any) => {
            text = text + `${x.name} : ${x.value}<br/>`;
          });

          return `
            จังหวัด: ${data?.name}<br/>
            จำนวนเรื่อง: ${data?.value}<br/>
            ${text}
          `;
        },
      },
      visualMap: {
        left: "right",
        min: 0,
        max: 1000,
        text: ["High", "Low"],
        inRange: {
          color: [
            "#313695",
            "#4575b4",
            "#74add1",
            "#abd9e9",
            "#e0f3f8",
            "#ffffbf",
            "#fee090",
            "#fdae61",
            "#f46d43",
            "#d73027",
            "#a50026",
          ],
        },
        top: "bottom",
        calculable: true,
      },
      geo: {
        map: "TH",
        aspectScale: 0.9,
        emphasis: {
          label: {
            show: false,
          },
          //   itemStyle: {
          //     areaColor: "#000000",
          //   },
        },
        itemStyle: {
          areaColor: "#eeeeee",
          borderColor: "#111",
        },
      },
      toolbox: {
        show: true,
        //orient: 'vertical',
        left: "left",
        top: "top",
        feature: {
          dataView: { readOnly: false },
          restore: {},
          saveAsImage: {},
        },
      },
      series: [
        {
          name: "จำนวนเรื่องร้องเรียน",
          type: "map",
          geoIndex: 0,
          emphasis: {
            label: {
              show: true,
            },
          },
        },
      ],
    };
    const chartMapData = ref<any>({ ...defaultMapChart });

    const reloadMapData = async () => {
      yearsRange.value = generateYearRange(
        search.year_range[0],
        search.year_range[1]
      ).map((year: any) => year + 543); // Convert to Buddhist calendar year

      let groupedMapData: any = [];

      for (const complaint of receive1_items.value) {
        let checkSearchRange: any = false;

        if (search.report_type.value == 1) {
          let year = new Date(complaint.created_at).getFullYear() + 543;
          if (yearsRange.value.includes(year)) {
            checkSearchRange = true;
          }
        } else if (search.report_type.value == 2) {
          // Month
          const createdAt: any = dayjs(complaint.created_at)
            .locale("th")
            .format("MMM BB");

          if (monthsRange.value.includes(createdAt)) {
            checkSearchRange = true;
          } else {
            checkSearchRange = false;
          }
        } else if (search.report_type.value == 3) {
          // Week
          const complaintDate = dayjs(complaint.created_at);
          const allWeeks = generateAllWeeksInRange(
            search.week_range[0][0],
            search.week_range[search.week_range.length - 1][1]
          );

          checkSearchRange = false; // Initialize to false

          allWeeks.forEach((range: any) => {
            const startOfWeek = dayjs(range[0]);
            const endOfWeek = dayjs(range[1]);
            if (complaintDate.isBetween(startOfWeek, endOfWeek, null, "[]")) {
              checkSearchRange = true;
            }
          });
        } else if (search.report_type.value == 4) {
          // day
          const complaintDate: any = dayjs(complaint.created_at);
          const allDays = generateAllDaysInRange(
            search.day_range[0],
            search.day_range[1]
          );

          checkSearchRange = false; // Initialize to false
          allDays.forEach((day: any) => {
            if (complaintDate.isSame(day, "day")) {
              checkSearchRange = true;
            }
          });
        }

        if (checkSearchRange == true) {
          const provinceName = complaint.province.name_th; // Assuming complaint has a province object with name_th

          let checkPro: any = groupedMapData.find((x: any) => {
            return x.name == provinceName;
          });

          if (checkPro) {
            checkPro.value++;

            let type = complaint.topic_type.topic_category.name_th;

            let checkCategory = checkPro.category.find((x: any) => {
              return x.name == type;
            });

            if (checkCategory) {
              checkCategory.value++;
            } else {
              checkPro.category.push({
                name: type,
                value: 1,
              });
            }
          } else {
            let type = complaint.topic_type.topic_category.name_th;
            groupedMapData.push({
              name: provinceName,
              value: 1,
              category: [
                {
                  name: type,
                  value: 1,
                },
              ],
            });

            console.log(groupedMapData);
          }
        }
      }

      chartMapData.value.series[0].data = groupedMapData;
    };

    const getDistrictDataForProvince = (provinceName: any) => {
      if (provinceName != "") {
        const districts = districtJson.features.filter(
          (feature) => feature.properties.pro_th === provinceName
        );
        let districtsGeo: any = { ...districtJson, features: districts };
        echarts.registerMap("districts", districtsGeo as any, {});

        let districtComplaintData: any = [];

        districts.forEach((district: any) => {
          const districtName = district.properties.name; // Replace with actual property name for district name

          let complaintCheck = receive1_items.value.filter((complaint: any) => {
            return complaint.province.name_th == provinceName;
          });

          complaintCheck = complaintCheck.filter((complaint: any) => {
            return complaint.district.name_th == districtName;
          });

          complaintCheck = complaintCheck.filter((complaint: any) => {
            let checkSearchRange: any = false;

            if (search.report_type.value == 1) {
              let year = new Date(complaint.created_at).getFullYear() + 543;
              if (yearsRange.value.includes(year)) {
                checkSearchRange = true;
              }
            } else if (search.report_type.value == 2) {
              // Month
              const createdAt: any = dayjs(complaint.created_at)
                .locale("th")
                .format("MMM BB");

              if (monthsRange.value.includes(createdAt)) {
                checkSearchRange = true;
              } else {
                checkSearchRange = false;
              }
            } else if (search.report_type.value == 3) {
              // Week
              const complaintDate = dayjs(complaint.created_at);
              const allWeeks = generateAllWeeksInRange(
                search.week_range[0][0],
                search.week_range[search.week_range.length - 1][1]
              );

              checkSearchRange = false; // Initialize to false

              allWeeks.forEach((range: any) => {
                const startOfWeek = dayjs(range[0]);
                const endOfWeek = dayjs(range[1]);
                if (
                  complaintDate.isBetween(startOfWeek, endOfWeek, null, "[]")
                ) {
                  checkSearchRange = true;
                }
              });
            } else if (search.report_type.value == 4) {
              // day
              const complaintDate: any = dayjs(complaint.created_at);
              const allDays = generateAllDaysInRange(
                search.day_range[0],
                search.day_range[1]
              );

              checkSearchRange = false; // Initialize to false
              allDays.forEach((day: any) => {
                if (complaintDate.isSame(day, "day")) {
                  checkSearchRange = true;
                }
              });
            }

            return checkSearchRange == true;
          });

          let category: any = [];
          complaintCheck.forEach((el: any) => {
            let type = el.topic_type.topic_category.name_th;
            let checkCategory: any = category.find((x: any) => {
              return x.name == type;
            });
            if (checkCategory) {
              checkCategory.value++;
            } else {
              category.push({
                name: type,
                value: 1,
              });
            }
          });

          let complaintCount = complaintCheck.length;

          if (complaintCount > 0) {
            districtComplaintData.push({
              name: districtName,
              value: complaintCount,
              category: category,
              //   [
              //     {
              //       name: type,
              //       value: 1,
              //     },
              //   ],
            });
          }
        });

        return districtComplaintData;
      }

      // This function should return data for the districts in the given province
      return [];
    };

    const renderDistrictChart = (provinceName: any) => {
      const districtData = getDistrictDataForProvince(provinceName);

      const districtChartData = {
        title: {
          text: `จำนวนเรื่องร้องเรียนเชิงพื้นที่: ${provinceName}`,
          left: "center",
        },
        tooltip: {
          trigger: "item",
          //   formatter: "{b}: {c}",
          showDelay: 0,
          transitionDuration: 0.2,
          formatter: (params: any) => {
            const data = params.data;
            let text = "";
            data?.category?.forEach((x: any) => {
              text = text + `${x.name} : ${x.value}<br/>`;
            });

            return `
            จังหวัด: ${data?.name}<br/>
            จำนวนเรื่อง: ${data?.value}<br/>
            ${text}
          `;
          },
        },
        visualMap: {
          left: "right",
          min: 0,
          max: 1000,
          text: ["High", "Low"],
          inRange: {
            color: [
              "#313695",
              "#4575b4",
              "#74add1",
              "#abd9e9",
              "#e0f3f8",
              "#ffffbf",
              "#fee090",
              "#fdae61",
              "#f46d43",
              "#d73027",
              "#a50026",
            ],
          },
          top: "bottom",
          calculable: true,
        },
        geo: {
          map: "districts",
          aspectScale: 0.9,
          roam: true,
          layoutCenter: ["50%", "50%"],
          layoutSize: "100%",
          emphasis: {
            label: {
              show: false,
            },
          },
          itemStyle: {
            areaColor: "#eeeeee",
            borderColor: "#111",
          },
        },
        toolbox: {
          show: true,
          //   orient: "vertical",
          left: "left",
          top: "top",
          feature: {
            dataView: { readOnly: false },
            restore: {},
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: "จำนวนเรื่องร้องเรียน",
            type: "map",
            geoIndex: 0,
            emphasis: {
              label: {
                show: true,
              },
            },
            data: districtData,
            // nameProperty: "amp_th",
          },
        ],
      };

      chartMapData.value = districtChartData;
    };

    const handleMapClick = (params: any) => {
      if (params.componentType === "series" && params.seriesType === "map") {
        showDistricts.value = true;
        const provinceName = params.name;
        renderDistrictChart(provinceName);
      }
    };

    const backToProvinces = () => {
      showDistricts.value = false;
      chartMapData.value = { ...defaultMapChart };
    };
    // End Map

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

        selectOptions.value.topic_categories = defaultTopicCategories
          .filter((x: any) => {
            return x.complaint_type_id == search.complaint_type_id.id;
          })
          .map((x: any) => {
            return x;
          });

        chartData.value = {
          ...defaultBarChart,
          title: {
            text: "สถิติประเภทเรื่องร้องเรียน",
            left: "center",
          },
        };

        if (search.report_type.value == 1) {
          reloadData();
          reloadMapData();
        } else if (search.report_type.value == 2) {
          reloadMonthData();
          reloadMapData();
        } else if (search.report_type.value == 3) {
          reloadWeekData();
          reloadMapData();
        } else if (search.report_type.value == 4) {
          reloadDayData();
          reloadMapData();
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
        topic_category: any
      ) => {
        const category_id = topic_category?.id ?? 99;

        if (!groupedData[category_id]) {
          groupedData[category_id] = {
            category_id,
            year: [],
            data: [],
          };
        }

        const yearIndex = groupedData[category_id].year.indexOf(year);
        if (yearIndex === -1) {
          groupedData[category_id].year.push(year);
          groupedData[category_id].data.push(1);
        } else {
          groupedData[category_id].data[yearIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const year = new Date(complaint.created_at).getFullYear() + 543;

        if (complaint.topic_type && complaint.topic_type.topic_category) {
          processComplaint(
            complaint,
            year,
            complaint.topic_type.topic_category
          );
        } else {
          processComplaint(complaint, year, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.topic_categories.find(
          (e: any) => e.id == x.category_id
        );
        x.topic_category_name = tc ? tc.name_th : "Unknown";

        x.data = chartData.value.xAxis.data.map((year: string) => {
          const yearIndex = x.year.indexOf(parseInt(year));
          return yearIndex !== -1 ? x.data[yearIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.topic_category_name,
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

        chartData.value.legend.data = result.map((x) => x.topic_category_name);

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
        topic_category: any
      ) => {
        const category_id = topic_category?.id ?? 99;

        if (!groupedData[category_id]) {
          groupedData[category_id] = {
            category_id,
            yearMonth: [],
            data: [],
          };
        }

        const monthIndex =
          groupedData[category_id].yearMonth.indexOf(yearMonth);
        if (monthIndex === -1) {
          groupedData[category_id].yearMonth.push(yearMonth);
          groupedData[category_id].data.push(1);
        } else {
          groupedData[category_id].data[monthIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const createdAt: any = dayjs(complaint.created_at)
          .locale("th")
          .format("MMM BB");

        if (complaint.topic_type && complaint.topic_type.topic_category) {
          processComplaint(
            complaint,
            createdAt,
            complaint.topic_type.topic_category
          );
        } else {
          processComplaint(complaint, createdAt, null);
        }
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.topic_categories.find(
          (e: any) => e.id == x.category_id
        );
        x.topic_category_name = tc ? tc.name_th : "Unknown";

        x.data = chartData.value.xAxis.data.map((yearMonth: string) => {
          const monthIndex = x.yearMonth.indexOf(yearMonth);
          return monthIndex !== -1 ? x.data[monthIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.topic_category_name,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
          label: {
            show: true,
            position: "top",
          },
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
        topic_category: any
      ) => {
        const category_id = topic_category?.id ?? 99;

        if (!groupedData[category_id]) {
          groupedData[category_id] = { category_id, weekRange: [], data: [] };
        }

        const weekIndex = groupedData[category_id].weekRange.indexOf(weekRange);
        if (weekIndex === -1) {
          groupedData[category_id].weekRange.push(weekRange);
          groupedData[category_id].data.push(1);
        } else {
          groupedData[category_id].data[weekIndex]++;
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

            if (complaint.topic_type && complaint.topic_type.topic_category) {
              processComplaint(
                complaint,
                weekRange,
                complaint.topic_type.topic_category
              );
            } else {
              processComplaint(complaint, weekRange, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.topic_categories.find(
          (e: any) => e.id == x.category_id
        );
        x.topic_category_name = tc ? tc.name_th : "Unknown";

        x.data = chartData.value.xAxis.data.map((weekRange: string) => {
          const weekIndex = x.weekRange.indexOf(weekRange);
          return weekIndex !== -1 ? x.data[weekIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x: any) => {
        let data = {
          name: x.topic_category_name,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
          label: {
            show: true,
            position: "top",
          },
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
        topic_category: any
      ) => {
        const category_id = topic_category?.id ?? 99;

        if (!groupedData[category_id]) {
          groupedData[category_id] = { category_id, day: [], data: [] };
        }

        const dayIndex = groupedData[category_id].day.indexOf(day);
        if (dayIndex === -1) {
          groupedData[category_id].day.push(day);
          groupedData[category_id].data.push(1);
        } else {
          groupedData[category_id].data[dayIndex]++;
        }
      };

      receive1_items.value.forEach((complaint: any) => {
        const complaintDate: any = dayjs(complaint.created_at);

        allDays.forEach((day: any) => {
          const formattedDay = day.locale("th").format("DD MMM BB");

          if (complaintDate.isSame(day, "day")) {
            if (complaint.topic_type && complaint.topic_type.topic_category) {
              processComplaint(
                complaint,
                formattedDay,
                complaint.topic_type.topic_category
              );
            } else {
              processComplaint(complaint, formattedDay, null);
            }
          }
        });
      });

      const result = Object.values(groupedData).map((x: any) => {
        const tc = selectOptions.value.topic_categories.find(
          (e: any) => e.id == x.category_id
        );
        x.topic_category_name = tc ? tc.name_th : "Unknown";

        x.data = chartData.value.xAxis.data.map((day: any) => {
          const dayIndex = x.day.indexOf(day);
          return dayIndex !== -1 ? x.data[dayIndex] : 0;
        });

        return x;
      });

      chartData.value.series = result.map((x) => {
        let data = {
          name: x.topic_category_name,
          type: "bar",
          barGap: 0,
          emphasis: { focus: "series" },
          data: x.data,
          label: {
            show: true,
            position: "top",
          },
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
            header: "ประเภทเรื่องร้องเรียน",
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
        worksheet.insertRow(1, "สถิติประเภทเรื่องร้องเรียน");
        worksheet.mergeCells("A1:K1");
        worksheet.getCell("A1").value = "ประเภทเรื่องร้องเรียน";
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
        link.download = "ประเภทเรื่องร้องเรียน.xlsx";
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

    const showCategory = (tc: any, category: any) => {
      let check = category.find((x: any) => {
        return x.name == tc.name_th;
      });

      return check ? check.value : 0;
    };

    // watch

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
      chartMapData,
      handleMapClick,
      showDistricts,
      backToProvinces,
      showCategory,
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
