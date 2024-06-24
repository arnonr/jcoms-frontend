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
      </div>

      <div class="mb-5 mt-5">
        <span
          >เรื่อง{{ complaint_type.name_th }} {{ cardStatus[0].description }}
          {{ cardStatus[0].total }} เรื่อง</span
        >
      </div>

      <div class="card">
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
                  <th class="text-center text-white">ดำเนินการแล้วเสร็จ</th>
                  <th class="text-center text-white">อยู่ระหว่างดำเนินการ</th>
                  <th class="text-center text-white">ผลปฏิบัติ</th>
                </tr>
              </thead>
              <tbody v-if="organization_data.labels.length != 0">
                <tr v-for="(or, idx) in organization_data.labels" :key="idx">
                  <td >{{ idx+1 }}. {{ or}}</td>
                  <td class="text-center">
                    {{ organization_data.data[idx] }}
                  </td>
                  <td class="text-center">
                    {{ organization_data.data[idx] }}
                  </td>
                  <td class="text-center">
                    {{ organization_data.data[idx] }}
                  </td>
                  <td class="text-center">
                    {{ organization_data.data[idx] }}%
                  </td>
                </tr>
                <tr>
                  <td class="text-center">รวม</td>
                  <td class="text-center">
                    {{ 380 }}
                  </td>
                  <td class="text-center">
                    {{ 100 }}
                  </td>
                  <td class="text-center">
                    {{ 180 }}
                  </td>
                  <td class="text-center">{{ 55.56 }}%</td>
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
        total: "380",
      },
      {
        status_id: 2,
        description: "ข้อมูลไม่ครบถ้วน",
        bgColor: "#F8285A",
        total: "200",
      },
      {
        status_id: 3,
        description: "รับเข้าระบบ",
        bgColor: "#FFC107",
        total: "180",
      },
      {
        status_id: 4,
        description: "ส่งหน่วยตรวจสอบ",
        bgColor: "#A00001",
        total: "180",
      },

      {
        status_id: 5,
        description: "ตรวจสอบเสร็จสิ้น",
        bgColor: "#17c653",
        total: "100",
      },

      {
        status_id: 6,
        description: "อยู่ระหว่างตรวจสอบ",
        bgColor: "#1B84FF",
        total: "80",
      },
    ]);

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
      topic_categories: [
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
      ],
    });

    const bureau_organizations = [
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
        bureau_th_abbr: "ศปอส.ตร.(ศูนย์ปราบปรามอาชญากรรมทางเทคโนโลยีสารสนเทศ)",
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
    ];

    const search = reactive<any>({});

    const items = reactive<any>([]);
    const item = reactive({});

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
            generateLabels: (chart) => {
              const sortedData = [...chart.data.datasets[0].data].sort(
                (a, b) => b - a
              );

              return sortedData.map((data, i) => ({
                text: `${chart.data.labels[i]} (${data})`,
                fillStyle: chart.data.datasets[0].backgroundColor[i],
              }));
            },
          },
        },
      },
      layout: {
        width: 400,
      },
      responsive: true,
    };

    const topic_category_data = reactive<any>({
      labels: selectOptions.value.topic_categories.map((x: any) => {
        return x.name_th;
      }),
      data: selectOptions.value.topic_categories.map((x: any) => {
        return Math.floor(Math.random() * 50) + 1;
      }),
      backgroundColor: selectOptions.value.topic_categories.map((x: any) => {
        return getRandomHexColor();
      }),
    });

    const chartTopicCategoryData = ref({
      labels: topic_category_data.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: topic_category_data.data,
          backgroundColor: topic_category_data.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });

    const complaint_channel_data = reactive<any>({
      labels: selectOptions.value.complaint_channels.map((x: any) => {
        return x.name_th;
      }),
      data: selectOptions.value.complaint_channels.map((x: any) => {
        return Math.floor(Math.random() * 50) + 1;
      }),
      backgroundColor: selectOptions.value.complaint_channels.map((x: any) => {
        return getRandomHexColor();
      }),
    });

    const chartChannelData = ref({
      labels: complaint_channel_data.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: complaint_channel_data.data,
          backgroundColor: complaint_channel_data.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });

    const section_data = reactive<any>({
      labels: selectOptions.value.sections.map((x: any) => {
        return x.name_th;
      }),
      data: selectOptions.value.sections.map((x: any) => {
        return Math.floor(Math.random() * 50) + 1;
      }),
      backgroundColor: selectOptions.value.sections.map((x: any) => {
        return getRandomHexColor();
      }),
    });

    const chartSectionData = ref({
      labels: section_data.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: section_data.data,
          backgroundColor: section_data.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });

    const organization_data = reactive<any>({
      labels: bureau_organizations.map((x: any) => {
        return x.bureau_th;
      }),
      data: bureau_organizations.map((x: any) => {
        return Math.floor(Math.random() * 50) + 1;
      }),
      backgroundColor: bureau_organizations.map((x: any) => {
        return getRandomHexColor();
      }),
    });

    const chartOrganizationOptions = <any>{
      plugins: {
        legend: {
          display: true,
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
        width: 600,
      },
      responsive: true,
    };
    const chartOrganizationData = ref({
      labels: organization_data.labels,
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: organization_data.data,
          backgroundColor: organization_data.backgroundColor,
          hoverOffset: 10,
          borderRadius: 3,
        },
      ],
    });

    // Fetch Data
    const fetchItems = () => {
      const params = {
        perPage: 1000000,
        currentPage: 1,
        ...search,
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
