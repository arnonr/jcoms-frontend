<template>
  <div>
    <div class="accordion" id="accordionSearch">
      <div class="accordion-item">
        <h6
          class="accordion-header accordion-button p-5"
          data-bs-toggle="collapse"
          data-bs-target="#collapseOne"
          aria-expanded="false"
          aria-controls="collapseOne"
        >
          <i class="fa fa-search pe-2"></i> กรองรายงาน
        </h6>
        <div
          id="collapseOne"
          class="accordion-collapse collapse hide"
          data-bs-parent="#accordionSearch"
        >
          <div class="accordion-body">
            <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
              <div class="col-6 col-md-6 my-2">
                <label for="">เลือกรูปแบบรายงาน</label>
                <v-select
                  id="slt-search-bureau-id"
                  name="slt-search-report-typr-id"
                  label="name"
                  placeholder="รูปแบบรายงาน"
                  :options="selectOptions.report_types"
                  v-model="search.report_type"
                  class="form-control"
                  :clearable="true"
                ></v-select>
              </div>

              <div class="col-6 col-md-6 my-2" v-if="show_complaint_type_id">
                <label for="">หมวดหมู่เรื่อง : </label>
                <v-select
                  id="slt-search-complain-type-id-2"
                  name="slt-search-complain-type-id-2"
                  label="name_th"
                  placeholder="หมวดหมู่เรื่อง"
                  :options="selectOptions.complaint_types"
                  v-model="search.complaint_type_id"
                  class="form-control"
                  :clearable="true"
                ></v-select>
              </div>

              <div
                class="col-6 col-md-6 my-2"
                v-if="search.report_type?.value == 1"
              >
                <label for="">เลือกช่วงปี</label>
                <VueDatePicker
                  v-model="search.year_range"
                  class="form-control"
                  year-picker
                  :locale="'th'"
                  placeholder="ช่วงปี"
                  :year-range="[2020, 2030]"
                  range
                  :format="yearFormat"
                >
                  <template #year-overlay-value="{ text }">
                    {{ parseInt(text) + 543 }}
                  </template>

                  <template #year="{ value }">
                    {{ value + 543 }}
                  </template>
                </VueDatePicker>
              </div>

              <div
                class="col-6 col-md-6 my-2"
                v-if="search.report_type?.value == 2"
              >
                <label for="">เลือกช่วงเดือน</label>
                <VueDatePicker
                  v-model="search.month_range"
                  class="form-control"
                  month-picker
                  :locale="'th'"
                  placeholder="ช่วงเดือน"
                  range
                  :format="monthFormat"
                >
                  <template #year-overlay-value="{ text }">
                    {{ parseInt(text) + 543 }}
                  </template>

                  <template #year="{ value }">
                    {{ value + 543 }}
                  </template>
                </VueDatePicker>
              </div>

              <div
                class="col-6 col-md-6 my-2"
                v-if="search.report_type?.value == 3"
              >
                <label for="">เลือกช่วงสัปดาห์</label>
                <VueDatePicker
                  v-model="search.week_range"
                  class="form-control"
                  :enable-time-picker="false"
                  week-picker
                  :locale="'th'"
                  placeholder="ช่วงสัปดาห์"
                  range
                  :format="weekFormat"
                >
                  <template #year-overlay-value="{ text }">
                    {{ parseInt(text) + 543 }}
                  </template>

                  <template #year="{ value }">
                    {{ value + 543 }}
                  </template>
                </VueDatePicker>
              </div>

              <div
                class="col-6 col-md-6 my-2"
                v-if="search.report_type?.value == 4"
              >
                <label for="">เลือกช่วงวันที่</label>
                <VueDatePicker
                  v-model="search.day_range"
                  class="form-control"
                  :enable-time-picker="true"
                  :locale="'th'"
                  placeholder="ช่วงวันที่"
                  range
                  :format="dayTimeFormat"
                  time-picker-inline
                >
                  <template #year-overlay-value="{ text }">
                    {{ parseInt(text) + 543 }}
                  </template>

                  <template #year="{ value }">
                    {{ value + 543 }}
                  </template>
                </VueDatePicker>
              </div>
            </div>
            <div class="pt-5">
              <button class="btn btn-success fw-bold" @click="onSearch()">
                ค้นหา
              </button>
              <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
                ล้าง
              </button>
              <!-- data-bs-toggle="modal" data-bs-target="#modal-search" -->
              <button
                id="kt_search_toggle"
                class="btn btn-primary fw-bold float-end"
                data-bs-toggle="tooltip"
                data-bs-placement="left"
                data-bs-dismiss="click"
                data-bs-trigger="hover"
              >
                ค้นหาเพิ่มเติม
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Modal Advanced Search -->
    <div
      id="kt_search"
      class="bg-body"
      data-kt-drawer="true"
      data-kt-drawer-name="search"
      data-kt-drawer-activate="true"
      data-kt-drawer-overlay="true"
      data-kt-drawer-width="{default:'350px', 'md': '525px'}"
      data-kt-drawer-direction="end"
      data-kt-drawer-toggle="#kt_search_toggle"
      data-kt-drawer-close="#kt_search_close"
    >
      <!--begin::Card-->
      <div class="card shadow-none rounded-0 w-100">
        <!--begin::Header-->
        <div class="card-header" id="kt_search_header">
          <h5 class="card-title fw-semibold text-gray-600">ค้นหาเพิ่มเติม</h5>

          <div class="card-toolbar">
            <button
              type="button"
              class="btn btn-sm btn-icon explore-btn-dismiss me-n5"
              id="kt_search_close"
            >
              <KTIcon icon-name="cross" icon-class="fs-2" />
            </button>
          </div>
        </div>
        <!--end::Header-->

        <!--begin::Body-->
        <div class="card-body" id="kt_search_body">
          <!--begin::Content-->
          <div
            id="kt_search_scroll"
            class="hover-scroll-overlay-y ps-5 pe-5 pt-5 ps-md-0 pe-md-0 pt-md-0"
            data-kt-scroll="true"
            data-kt-scroll-height="auto"
            data-kt-scroll-wrappers="#kt_search_body"
            data-kt-scroll-dependencies="#kt_search_header"
            data-kt-scroll-offset="5px"
          >
            <!--end::Support-->
            <!--begin::Link-->

            <h4>ค้นหาจากข้อมูลร้องเรียน</h4>
            <hr />

            <div class="mb-7">
              <label for="">เรื่องร้องเรียน : </label>
              <input
                id="txt-search-complain-title-2"
                name="txt-search-complain-title-2"
                type="text"
                class="form-control"
                v-model="search.complaint_title"
              />
            </div>

            <div class="mb-7">
              <label for="">ชื่อผู้ร้อง</label>
              <input
                id="txt-search-complain-fullname-2"
                name="txt-search-complain-fullname-2"
                type="text"
                class="form-control"
                v-model="search.complainant_fullname"
              />
            </div>

            <div class="mb-7">
              <label for="">ชื่อผู้ถูกร้อง</label>
              <input
                id="txt-search-accused-fullname-2"
                name="txt-search-accused-fullname-2"
                type="text"
                class="form-control"
                v-model="search.accused_fullname"
              />
            </div>

            <div class="row">
              <div class="col-md-6 mb-7">
                <label for="">ประเภทการระบุตัวตน</label>
                <v-select
                  id="slt-search-is-anonymous-2"
                  name="slt-search-is-anonymous-2"
                  label="name"
                  placeholder="ประเภทการระบุตัวตน"
                  :options="selectOptions.is_anonymouses"
                  v-model="search.is_anonymous"
                  class="form-control"
                  :clearable="true"
                ></v-select>
              </div>

              <div class="col-md-6 mb-7">
                <label for="">สถานะเรื่องร้องเรียน</label>
                <v-select
                  id="slt-search-proceed-state-2"
                  name="slt-search-procees-state-2"
                  label="name_th"
                  placeholder="สถานะเรื่องร้องเรียน"
                  :options="selectOptions.states"
                  v-model="search.state_id"
                  class="form-control"
                  :clearable="true"
                ></v-select>
              </div>
            </div>

            <h4>ค้นหาจากข้อมูลหน่วยงาน</h4>
            <hr />
            <div class="mb-7">
              <label for="">กต</label>
              <v-select
                id="slt-search-inspector-id-2"
                name="slt-search-inspector-id-2"
                label="name_th"
                placeholder="กต."
                :options="selectOptions.inspectors"
                v-model="search.inspector_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">บช./ภ.</label>
              <v-select
                id="slt-search-bureau-id-2"
                name="slt-search-bureau-id-2"
                label="name_th"
                placeholder="บช./ภ."
                :options="selectOptions.bureaus"
                v-model="search.bureau_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">บก./ภ.จว.</label>
              <v-select
                id="slt-search-division-id-2"
                name="slt-search-division-id-2"
                label="name_th"
                placeholder="บก./ภ.จว."
                :options="selectOptions.divisions"
                v-model="search.division_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">หน่วยงาน(สถานีตำรวจ)</label>
              <v-select
                id="slt-search-agency-id-2"
                name="slt-search-agency-id-2"
                label="name_th"
                placeholder="หน่วยงาน(สถานีตำรวจ)"
                :options="selectOptions.agencies"
                v-model="search.agency"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <h4>ค้นหาจากข้อมูลที่เกิดเหตุ</h4>
            <hr />

            <div class="mb-7">
              <label for="">วันที่เกิดเหตุ : </label>
              <VueDatePicker
                id="dp-search-incident-date-2"
                name="dp-search-incident-date-2"
                class="form-control"
                v-model="search.incident_date"
                :enable-time-picker="false"
                locale="th"
                auto-apply
                :format="format"
              >
                <template #year-overlay-value="{ text }">
                  {{ parseInt(text) + 543 }}
                </template>
                <template #year="{ value }">
                  {{ value + 543 }}
                </template>
              </VueDatePicker>
            </div>

            <div class="mb-7">
              <label for="">จังหวัด : </label>
              <v-select
                id="slt-search-province-id-2"
                name="slt-search-province-id-2"
                label="name_th"
                placeholder="จังหวัด"
                :options="selectOptions.provinces"
                v-model="search.province_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">อำเภอ : </label>
              <v-select
                id="slt-search-district-id-2"
                name="slt-search-district-id-2"
                label="name_th"
                placeholder="อำเภอ"
                :options="selectOptions.districts"
                v-model="search.district_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">ตำบล : </label>
              <v-select
                id="slt-search-sub-district-id-2"
                name="slt-search-sub-district-id-2"
                label="name_th"
                placeholder="ตำบล"
                :options="selectOptions.subdistricts"
                v-model="search.sub_district_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <h4>ค้นหาจากหมวดหมู่เรื่อง</h4>
            <hr />
            <div class="mb-7">
              <label for="">หมวดหมู่เรื่อง : </label>
              <v-select
                id="slt-search-complain-type-id-2"
                name="slt-search-complain-type-id-2"
                label="name_th"
                placeholder="หมวดหมู่เรื่อง"
                :options="selectOptions.complaint_types"
                v-model="search.complaint_type_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <label for="">ประเภทเรื่อง : </label>
              <v-select
                id="slt-search-topic-type-id-2"
                name="slt-search-topic-type-id-2"
                label="name_th"
                placeholder="ประเภทเรื่อง"
                :options="selectOptions.topic_categories"
                v-model="search.topic_category_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>
            <div class="mb-7">
              <label for="">ลักษณะเรื่อง : </label>
              <v-select
                id="slt-search-topic-category-id-2"
                name="slt-search-topic-category-id-2"
                label="name_th"
                :options="selectOptions.topic_types"
                v-model="search.topic_type_id"
                placeholder="ลักษณะเรื่อง"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <h4>ค้นหาจากเลขเอกสาร</h4>
            <hr />

            <div class="row">
              <div class="col-md-12 mb-7">
                <label for="">เลขที่คำร้องเรียน (Jcom No): </label>
                <input
                  id="slt-search-complain-code-2"
                  name="slt-search-complain-code-2"
                  type="text"
                  class="form-control"
                  v-model="search.jcoms_no"
                />
              </div>
              <!-- <div class="col-md-6 mb-7">
                <label for="">เลขที่ POL : </label>
                <input
                  id="slt-search-pol-no-2"
                  name="slt-search-pol-no-2"
                  type="text"
                  class="form-control"
                  v-model="search.pol_no"
                />
              </div> -->

              <!-- <div class="col-md-6 mb-7">
                <label for="">เลขรับ ฝรท. : </label>
                <input
                  id="slt-search-reveice-no-2"
                  name="slt-search-receive-no-2"
                  type="text"
                  class="form-control"
                  v-model="search.receive_no"
                />
              </div> -->

              <!-- <div class="col-md-6 mb-7">
                <label for="">เลขที่หนังสือส่ง จต./ตร. : </label>
                <input
                  id="slt-search-forward-no-2"
                  name="slt-search-forward-no-2"
                  type="text"
                  class="form-control"
                  v-model="search.forward_no"
                />
              </div> -->
            </div>

            <h4>ค้นหาจากข้อมูลอื่น ๆ</h4>
            <hr />
            <div class="mb-7">
              <label for="">ช่องทางการรับเรื่อง : </label>
              <v-select
                id="slt-search-complain-channel-id"
                name="slt-search-complain-channel-id"
                label="name_th"
                placeholder="ช่องทางการรับเรื่อง"
                :options="selectOptions.complaint_channels"
                v-model="search.complaint_channel_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>

            <div class="mb-7">
              <button class="btn btn-success fw-bold" @click="onSearch()">
                ค้นหา
              </button>
              <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
                ล้าง
              </button>
            </div>

            <!--end::Link-->
          </div>
          <!--end::Content-->
        </div>
        <!--end::Body-->
      </div>
      <!--end::Card-->
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, toRefs, reactive, watch, ref, onMounted } from "vue";
import ApiService from "@/core/services/ApiService";

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

// Import Store
import { useSearchComplaintStore } from "@/stores/searchComplaint";

export default defineComponent({
  name: "search-complaint",
  components: {
    vSelect,
    VueDatePicker,
  },
  props: {
    search: {
      type: Object,
      required: true,
    },
    state_new: {
      type: Boolean,
      default: true,
    },

    show_complaint_type_id: {
      type: Boolean,
      default: false,
    },
  },
  setup(props, { emit }) {
    // Variable
    const searchComplaintStore = useSearchComplaintStore();
    const { search } = toRefs(props);

    const selectOptions = ref<any>({
      report_types: [
        { name: "รายปี", value: 1 },
        { name: "รายเดือน", value: 2 },
        { name: "รายสัปดาห์", value: 3 },
        { name: "รายวัน", value: 4 },
      ],
      years: [],
      complain_statuses: [
        { name: "รอตรวจสอบ/รับเรื่อง", value: 1 },
        { name: "อยู่ระหว่างดำเนินการ", value: 2 },
        { name: "รอรายงานผล", value: 3 },
        { name: "เสร็จสิ้น", value: 4 },
      ],
      is_anonymouses: [
        { name: "ระบุตัวตน", value: 1 },
        { name: "ไม่ระบุตัวตน", value: 2 },
      ],
      dayornight: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      organizations: [],
      states: [],
      perPage: [
        { title: "20", value: 20 },
        { title: "40", value: 40 },
        { title: "60", value: 60 },
      ],
      inspectors: [],
      bureaus: [],
      divisions: [],
      agency: [],
      provinces: [],
      districts: [],
      subdistricts: [],
      complaint_types: [],
      topic_categories: [],
      topic_types: [],
      prefix_names: [],
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const yearFormat = (date: any) => {
      let year1 = date[0].getFullYear() + 543;
      let year2 = null;
      if (date[1] != undefined) year2 = date[1].getFullYear() + 543;

      return year1 + "-" + year2;
    };

    const monthFormat = (date: any) => {
      let month1: any = dayjs(date[0]).locale("th").format("MMM BBBB");
      let month2: any = null;
      if (date[1] != undefined)
        month2 = dayjs(date[1]).locale("th").format("MMM BBBB");

      return month1 + "-" + month2;
    };

    const weekFormat = (date: any) => {
      console.log();
      let week1: any = dayjs(date[0]).locale("th").format("MMM BBBB");
      let week2: any = null;
      if (date[1] != undefined)
        week2 = dayjs(date[1]).locale("th").format("MMM BBBB");

      return week1 + "-" + week2;
    };

    const dayFormat = (date: any) => {
      let day1 = dayjs(date[0]).locale("th").format("DD");
      let month1 = dayjs(date[0]).locale("th").format("MMM");
      let year1 = date[0].getFullYear() + 543;

      let day2: any = null;
      let month2: any = null;
      let year2: any = null;

      if (date[1] != undefined) {
        day2 = dayjs(date[1]).locale("th").format("DD");
        month2 = dayjs(date[1]).locale("th").format("MMM");
        year2 = date[1].getFullYear() + 543;
      } else {
        day2 = dayjs(date[0]).locale("th").format("DD");
        month2 = dayjs(date[0]).locale("th").format("MMM");
        year2 = date[0].getFullYear() + 543;
      }

      return `${day1} ${month1} ${year1} - ${day2} ${month2} ${year2}`;
    };

    const dayTimeFormat = (date: any) => {
      let day1 = dayjs(date[0]).locale("th").format("DD");
      let month1 = dayjs(date[0]).locale("th").format("MMM");
      let year1 = date[0].getFullYear() + 543;
      let hour1 = dayjs(date[0]).locale("th").format("HH");
      let minute1 = dayjs(date[0]).locale("th").format("mm");

      let day2: any = null;
      let month2: any = null;
      let year2: any = null;
      let hour2: any = null;
      let minute2: any = null;

      if (date[1] != undefined) {
        day2 = dayjs(date[1]).locale("th").format("DD");
        month2 = dayjs(date[1]).locale("th").format("MMM");
        year2 = date[1].getFullYear() + 543;
        hour2 = dayjs(date[1]).locale("th").format("HH");
        minute2 = dayjs(date[1]).locale("th").format("mm");
      } else {
        day2 = dayjs(date[0]).locale("th").format("DD");
        month2 = dayjs(date[0]).locale("th").format("MMM");
        year2 = date[0].getFullYear() + 543;
        hour2 = dayjs(date[0]).locale("th").format("HH");
        minute2 = dayjs(date[0]).locale("th").format("mm");
      }

      return `${day1} ${month1} ${year1} ${hour1}:${minute1} - ${day2} ${month2} ${year2} ${hour2}:${minute2}`;
    };

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

    const onSearch = () => {
      emit("search");
    };

    const onClear = () => {
      emit("clear");
    };

    //

    onMounted(async () => {
      selectOptions.value.prefix_names =
        await searchComplaintStore.fetchPrefixName({
          is_active: 1,
          perPage: 500,
        });

      let states = await searchComplaintStore.fetchState({
        perPage: 500,
      });

      if (props.state_new == true) {
        selectOptions.value.states = states.filter((x: any) => {
          return x.id == 1 || x.id == 18;
        });
      } else {
        selectOptions.value.states = states.filter((x: any) => {
          return x.id != 1 && x.id != 18;
        });
      }

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

      selectOptions.value.provinces = await searchComplaintStore.fetchProvince({
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
      });

      selectOptions.value.complaint_types =
        await searchComplaintStore.fetchComplaintType({
          perPage: 100000,
        });

      selectOptions.value.complaint_channels =
        await searchComplaintStore.fetchComplaintChannel({
          perPage: 100000,
        });
    });

    // Watch
    const defaultParams = { perPage: 100000, orderBy: "name_th", order: "asc" };
    watch(
      () => search.value.inspector_id,
      async () => {
        search.value.bureau_id = null;
        search.value.division_id = null;
        search.value.agency_id = null;

        selectOptions.value.bureaus = await searchComplaintStore.fetchBureau({
          ...defaultParams,
          inspector_id: search.value.inspector_id?.id,
        });
      }
    );

    watch(
      () => search.value.bureau_id,
      async () => {
        search.value.division_id = null;
        search.value.agency_id = null;
        selectOptions.value.divisions = [];

        if (search.value.bureau_id) {
          selectOptions.value.divisions =
            await searchComplaintStore.fetchDivision({
              ...defaultParams,
              bureau_id: search.value.bureau_id?.id,
            });
        }
      }
    );

    watch(
      () => search.value.division_id,
      async () => {
        search.value.agency_id = null;
        selectOptions.value.agencies = [];

        if (search.value.division_id) {
          selectOptions.value.agencies = await searchComplaintStore.fetchAgency(
            {
              ...defaultParams,
              division_id: search.value.division_id?.id,
            }
          );
        }
      }
    );

    watch(
      () => search.value.province_id,
      async () => {
        search.value.district_id = null;
        search.value.sub_district_id = null;
        selectOptions.value.districts = [];

        if (search.value.province_id) {
          selectOptions.value.districts =
            await searchComplaintStore.fetchDistrict({
              ...defaultParams,
              province_id: search.value.province_id?.id,
            });
        }
      }
    );

    watch(
      () => search.value.district_id,
      async () => {
        search.value.sub_district_id = null;
        selectOptions.value.subdistricts = [];

        if (search.value.district_id) {
          selectOptions.value.subdistricts =
            await searchComplaintStore.fetchSubdistrict({
              ...defaultParams,
              district_id: search.value.district_id?.id,
            });
        }
      }
    );

    watch(
      () => search.value.complaint_type_id,
      async () => {
        search.value.topic_category_id = null;
        search.value.topic_type_id = null;
        selectOptions.value.topic_categories = [];

        if (search.value.complaint_type_id) {
          selectOptions.value.topic_categories =
            await searchComplaintStore.fetchTopicCategory({
              ...defaultParams,
              complaint_type_id: search.value.complaint_type_id?.id,
            });
        }
      }
    );

    watch(
      () => search.value.topic_category_id,
      async () => {
        search.value.topic_type_id = null;

        selectOptions.value.topic_types = [];

        if (search.value.topic_category_id) {
          selectOptions.value.topic_types =
            await searchComplaintStore.fetchTopicType({
              ...defaultParams,
              topic_category_id: search.value.topic_category_id?.id,
            });
        }
      }
    );

    return {
      selectOptions,
      search,
      onSearch,
      onClear,
      format,
      yearFormat,
      monthFormat,
      weekFormat,
      dayFormat,
      dayTimeFormat,
    };
  },
});
</script>
