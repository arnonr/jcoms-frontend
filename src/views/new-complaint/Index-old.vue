<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <!-- Search -->
      <Search
        :selectOptions="selectOptions"
        :search="search"
        @search="onSearch"
        @clear="onClear"
      />
    </div>

    <div class="card shadow-sm my-5">
      <div class="card-header bg-white">
        <h4 class="card-title">รายการเรื่องร้องเรียน/แจ้งเบาะแส</h4>
        <div class="card-toolbar">
          <button
            class="btn btn-outline btn-outline-primary me-2 pe-sm-3 ps-sm-5"
            @click="onAddModal()"
          >
            <i class="bi bi-file-earmark-plus-fill fs-4"></i>
            <span class="d-none d-lg-inline-block ms-2"
              >เพิ่มเรื่องร้องเรียน</span
            >
          </button>

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
              <!-- <li><a class="dropdown-item" href="#">PDF</a></li> -->
              <li><a class="dropdown-item" @click="onExport()">Excel</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="card-body table-responsive">
        <!-- <div class="overflow-visible"> -->
        <table class="table table-bordered table-striped" style="width: 100%">
          <thead class="bg-color-police">
            <tr>
              <th class="text-center text-white">วันที่ร้องเรียน</th>
              <th class="text-center text-white">รหัสคำร้อง</th>
              <th class="text-center text-white">ลักษณะความผิด</th>
              <th class="text-center text-white">เรื่องร้องเรียน</th>
              <th class="text-center text-white">ผู้ถูกร้อง</th>
              <th class="text-center text-white">หน่วยงานถูกร้อง</th>
              <th class="text-center text-white">สถานะ</th>
              <th class="text-center text-white">จัดการข้อมูล</th>
            </tr>
          </thead>
          <tbody v-if="items.length != 0">
            <tr v-for="(it, idx) in items" :key="idx">
              <td class="text-center">
                {{ convert_date(it.created_at) }}
              </td>
              <td class="text-center">{{ it.jcoms_no }}</td>

              <td class="text-center">{{ it.topic_type?.name_th }}</td>
              <td>{{ it.complaint_title }}</td>
              <td>{{ showAccused(it.accused) }}</td>
              <td>
                <span v-if="it.agency_id">{{ it.agency.name_th }}</span>
                <span v-else-if="it.division_id">{{
                  it.division.name_th
                }}</span>
                <span v-else-if="it.bureau_id">{{ it.bureau.name_th }}</span>
                <span v-else-if="it.inspector_id">{{
                  it.inspector.name_th
                }}</span>
                <span v-else></span>
              </td>
              <td class="text-center">
                <span
                  class="badge p-2 text-white"
                  :style="`background-color: ${
                    showState(it.state_id).bg_color
                  };`"
                  >{{ showState(it.state_id).name_th }}</span
                >
              </td>

              <td class="text-center">
                <div class="dropdown">
                  <button
                    class="btn btn-primary btn-sm dropdown-toggle"
                    type="button"
                    id="dropdownMenuButton"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    <i
                      class="bi bi-pencil-square fs-4 d-sm-inline-block d-lg-none"
                    ></i>
                    <span class="d-none d-lg-inline-block">จัดการ</span>
                  </button>
                  <ul
                    class="dropdown-menu"
                    aria-labelledby="dropdownMenuButton"
                  >
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="
                          () => {
                            Object.assign(item, it);
                            openDetailModal = true;
                          }
                        "
                        >รายละเอียด</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="
                          () => {
                            Object.assign(item, it);
                            openReceiveModal = true;
                          }
                        "
                        >แก้ไขข้อมูล</a
                      >
                    </li>

                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="
                          () => {
                            Object.assign(item, it);
                            openReceiveModal2 = true;
                          }
                        "
                        >ฝรท. พิจารณา</a
                      >
                    </li>
                  </ul>
                </div>
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
        <div class="col-xxl-12">
          <div class="tp-pagination mt-30">
            <BlogPagination
              :totalItems="totalItems"
              :totalPage="totalPage"
              :currentPage="currentPage"
              @update:currentPage="currentPage = $event"
            />
          </div>
        </div>
        <!-- </div> -->
      </div>
    </div>

    <!-- Modal ดูรายละเอียด -->
    <div id="detail-modal">
      <DetailComplaint
        :complaint_id="item.id"
        :jcoms_no="item.jcoms_no"
        v-if="openDetailModal == true"
        @close-modal="
          () => {
            openDetailModal = false;
          }
        "
      />
    </div>

    <!-- Modal Edit แก้ไขข้อมูล -->
    <div id="edit-modal">
      <ReceiveComplaint
        :complaint_id="item.id"
        :complainant_id="item.complainant_id"
        v-if="openReceiveModal == true"
        @close-modal="
          () => {
            openReceiveModal = false;
          }
        "
        @reload="
          () => {
            fetchItems();
          }
        "
      />
    </div>

    <!-- Modal Receive ฝรท.รับเรื่อง -->
    <div id="receive-modal-2">
      <ReceiveComplaint2
        :complaint_id="item.id"
        v-if="openReceiveModal2 == true"
        @close-modal="
          () => {
            openReceiveModal2 = false;
          }
        "
        @reload="
          () => {
            fetchItems();
          }
        "
      />
    </div>

    <!-- Modal Send ฝรท.ส่งต่อเรื่อง -->
    <div id="send-modal">
      <SendComplaint
        :complaint_id="item.id"
        v-if="openSendModal == true"
        @close-modal="
          () => {
            openSendModal = false;
          }
        "
        @reload="
          () => {
            fetchItems();
          }
        "
      />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from "vue";
import { useAbility } from "@casl/vue";
import ApiService from "@/core/services/ApiService";

// Import Dayjs
import dayjs from "dayjs";

// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Pagination
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";
// Import ExcelJS
// import ExcelJS from "exceljs";

// import useAddressData from "@/composables/useAddressData";
import useStateData from "@/composables/useStateData";

// Component
import Search from "@/components/complaint/Search.vue";

import DetailComplaint from "./DetailComplaint.vue";
import ReceiveComplaint from "@/views/complaint/Receive.vue";
import ReceiveComplaint2 from "@/views/complaint/Receive2.vue";
import ReceiveComplaint3 from "@/views/complaint/Receive3.vue";
import SendComplaint from "@/views/complaint/Send.vue";
import SendReport from "@/views/complaint/SendReport.vue";
import ReceiveReport from "@/views/complaint/ReceiveReport.vue";

export default defineComponent({
  name: "complaint",
  components: {
    VueDatePicker,
    dayjs,
    vSelect,
    BlogPagination,
    DetailComplaint,
    ReceiveComplaint,
    ReceiveComplaint2,
    ReceiveComplaint3,
    SendReport,
    ReceiveReport,
    SendComplaint,
    Search,
  },
  setup() {
    // Variable
    const ability = useAbility();
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    let { states } = useStateData();

    const selectOptions = ref<any>({
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
    const search = ref<any>({
      year: null,
      complaint_title: "",
      jcoms_no: "",
      complainant_fullname: "",
      accused_fullname: "",
      state_id: null,
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      create_from: null,
      create_to: null,
      is_anonymous: null,
      incident_date: null,
      province_id: null,
      district_id: null,
      sub_district_id: null,
      complaint_type_id: null,
      topic_category_id: null,
      topic_type_id: null,
      pol_no: "",
      receive_no: "",
      forward_no: "",
      complaint_channel_id: null,
    });
    const item = reactive<any>({});
    const items = reactive<any>([]);
    const perPage = ref(20);
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);
    const json_data = ref([]);

    const openDetailModal = ref(false);
    const openReceiveModal = ref(false);
    const openReceiveModal2 = ref(false);
    const openReceiveModal3 = ref(false);
    const openSendModal = ref(false);
    const openSendReportModal = ref(false);
    const openReceiveReportModal = ref(false);

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

    // Fetch Data
    const fetchPrefixName = async () => {
      const { data } = await ApiService.query("prefix-name", {
        params: {
          is_active: 1,
          perPage: 500,
        },
      });
      selectOptions.value.prefix_names = data.data;
    };

    const fetchState = async () => {
      const { data } = await ApiService.query("state", {
        params: {
          perPage: 100,
        },
      });
      selectOptions.value.states = data.data.filter((x: any) => {
        return x.id == 1 || x.id == 18;
      });
    };

    const fetchInspector = async () => {
      const { data } = await ApiService.query("inspector", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.inspectors = data.data;
    };

    const fetchBureau = async () => {
      const { data } = await ApiService.query("bureau", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          inspector_id: search.value.inspector_id?.id,
        },
      });
      selectOptions.value.bureaus = data.data;
    };

    const fetchDivision = async () => {
      const { data } = await ApiService.query("division", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          bureau_id: search.value.bureau_id?.id,
        },
      });
      selectOptions.value.divisions = data.data;
    };

    const fetchAgency = async () => {
      const { data } = await ApiService.query("agency", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          division_id: search.value.division_id?.id,
        },
      });
      selectOptions.value.agency = data.data;
    };

    const fetchProvince = async () => {
      const { data } = await ApiService.query("province", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.provinces = data.data;
    };

    const fetchDistrict = async () => {
      const { data } = await ApiService.query("district", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          province_id: search.value.province_id?.id,
        },
      });
      selectOptions.value.districts = data.data;
    };

    const fetchSubdistrict = async () => {
      const { data } = await ApiService.query("sub-district", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          district_id: search.value.district_id?.id,
        },
      });
      selectOptions.value.subdistricts = data.data;
    };

    const fetchComplaintType = async () => {
      const { data } = await ApiService.query("complaint-type", {
        params: {
          perPage: 100000,
        },
      });
      selectOptions.value.complaint_types = data.data;
    };

    const fetchTopicCategory = async () => {
      const { data } = await ApiService.query("topic-category", {
        params: {
          perPage: 100000,
          complaint_type_id: search.value.complaint_type_id?.id,
        },
      });
      selectOptions.value.topic_categories = data.data;
    };

    const fetchTopicType = async () => {
      const { data } = await ApiService.query("topic-type", {
        params: {
          perPage: 100000,
          topic_category_id: search.value.topic_category_id?.id,
        },
      });
      selectOptions.value.topic_types = data.data;
    };

    const fetchComplaintChannel = async () => {
      const { data } = await ApiService.query("complaint-channel", {
        params: {
          perPage: 100000,
        },
      });
      selectOptions.value.complaint_channels = data.data;
    };

    const fetchItems = async () => {
      console.log(search.value);
      const params = {
        perPage: perPage.value,
        currentPage: currentPage.value,
        orderBy: "created_at",
        order: "desc",
        ...search.value,
        create_year: search.value.year?.value ?? undefined,
        state_id: search.value.state_id?.id ?? 1,
        inspector_id: search.value.inspector_id?.id ?? undefined,
        bureau_id: search.value.bureau_id?.id ?? undefined,
        division_id: search.value.division_id?.id ?? undefined,
        agency_id: search.value.agency_id?.id ?? undefined,
        is_anonymous: search.value.is_anonymous?.value ?? undefined,
        province_id: search.value.province_id?.id ?? undefined,
        district_id: search.value.district_id?.id ?? undefined,
        sub_district_id: search.value.sub_district_id?.id ?? undefined,
        complaint_type_id: search.value.complaint_type_id?.id ?? undefined,
        topic_category_id: search.value.topic_category_id?.id ?? undefined,
        topic_type_id: search.value.topic_type_id?.id ?? undefined,
        complaint_channel_id:
          search.value.complaint_channel_id?.id ?? undefined,
        incident_datetime: search.value.incident_date
          ? dayjs(search.value.incident_date).format("YYYY-MM-DD")
          : undefined,
        create_from: search.value.create_from
          ? dayjs(search.value.create_from).format("YYYY-MM-DD")
          : undefined,
        create_to: search.value.create_to
          ? dayjs(search.value.create_to).format("YYYY-MM-DD")
          : undefined,
      };

      const { data } = await ApiService.query("complaint", {
        params: params,
      });

      items.length = 0;
      Object.assign(items, data.data);
      totalPage.value = data.totalPage;
      totalItems.value = data.totalData;
      currentPage.value = data.currentPage;
    };

    const fetchItemsExport = async () => {
      let params = {
        ...search.value,
        asset_type_id:
          search.value.asset_type_id == null
            ? undefined
            : search.value.asset_type_id.value,
        budget_type_id:
          search.value.budget_type_id == null
            ? undefined
            : search.value.budget_type_id.value,
        department_id:
          search.value.department_id == null
            ? undefined
            : search.value.department_id.value,
        input_year:
          search.value.input_year == null
            ? undefined
            : search.value.input_year.id,
        created_at_from:
          search.value.created_at_from == null
            ? undefined
            : dayjs(search.value.created_at_from).format("YYYY-MM-DD"),
        created_at_to:
          search.value.created_at_to == null
            ? undefined
            : dayjs(search.value.created_at_to).format("YYYY-MM-DD"),
        status:
          search.value.status != null ? search.value.status.id : undefined,
        perPage: 100000,
        currentPage: currentPage.value,
        lang: "th",
        orderBy: "created_at",
        order: "desc",
      };
    };

    // Event
    const onSearch = async () => {
      //   console.log(search.value);
      fetchItems();
    };
    const onClear = async () => {
      search.value = {
        year: selectOptions.value.years[0],
        complaint_title: "",
        jcoms_no: "",
        complainant_fullname: "",
        accused_fullname: "",
        state_id: null,
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        agency_id: null,
        create_from: null,
        create_to: null,
        is_anonymous: null,
        incident_date: null,
        province_id: null,
        district_id: null,
        sub_district_id: null,
        complaint_type_id: null,
        topic_category_id: null,
        topic_type_id: null,
        pol_no: "",
        receive_no: "",
        forward_no: "",
        complaint_channel_id: null,
      };
    };
    const onExport = async () => {
      //   setTimeout(async () => {
      //     const workbook = new ExcelJS.Workbook();
      //     const worksheet = workbook.addWorksheet("รายการเรื่องร้องเรียน", {
      //       pageSetup: { orientation: "landscape" },
      //       headerFooter: {
      //         firstHeader: "Hello Exceljs",
      //         firstFooter: "Hello World",
      //       },
      //     });
      //     worksheet.columns = [
      //       {
      //         header: "หมายเลขคำร้อง",
      //         key: "หมายเลขครุภัณฑ์",
      //         width: 25,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "วันที่ขอเปลี่ยน",
      //         key: "วันที่ขอเปลี่ยน",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "ผู้แจ้ง",
      //         key: "ผู้แจ้ง",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "สถานะ",
      //         key: "สถานะ",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //     ];
      //     worksheet.properties.defaultRowHeight = 45;
      //     worksheet.addRows(json_data.value);
      //     worksheet.eachRow((row) => {
      //       row.height = 45;
      //       row.eachCell(function (cell) {
      //         cell.alignment = {
      //           vertical: "middle",
      //           horizontal: "center",
      //           wrapText: true,
      //         };
      //       });
      //     });
      //     const row = worksheet.getRow(1);
      //     row.height = 20;
      //     worksheet.insertRow(1, "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์");
      //     worksheet.mergeCells("A1:K1");
      //     worksheet.getCell("A1").value =
      //       "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์";
      //     worksheet.getCell("A1").alignment = {
      //       vertical: "middle",
      //       horizontal: "center",
      //     };
      //     const font = { name: "Arial", size: 18, bold: true };
      //     worksheet.getCell("A1").font = font;
      //     let start_date =
      //       search.created_at_from != null
      //         ? dayjs(search.created_at_from).locale("th").format("DD MMM BBBB")
      //         : "-";
      //     let end_date =
      //       search.created_at_to != null
      //         ? dayjs(search.created_at_to).locale("th").format("DD MMM BBBB")
      //         : "-";
      //     worksheet.insertRow(2);
      //     worksheet.mergeCells("A2:K2");
      //     worksheet.getCell("A2").value =
      //       "ระหว่างวันที่ " + start_date + " ถึง " + end_date;
      //     worksheet.getCell("A2").alignment = {
      //       vertical: "middle",
      //       horizontal: "center",
      //     };
      //     const font1 = { name: "Arial", size: 18, bold: true };
      //     worksheet.getCell("A1").font = font1;
      //     const buffer = await workbook.xlsx.writeBuffer();
      //     const blob = new Blob([buffer], { type: "application/octet-stream" });
      //     const href = URL.createObjectURL(blob);
      //     const link = document.createElement("a");
      //     link.href = href;
      //     link.download = "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์.xlsx";
      //     document.body.appendChild(link);
      //     link.click();
      //     document.body.removeChild(link);
      //   }, 3000);
    };

    // Modal action
    const onAddModal = () => {};
    const onEditModal = (it: any) => {
      Object.assign(item, it);
    };
    const onDetailModal = (it: any) => {
      Object.assign(item, it);
    };

    // Show
    const showState = (state: number) => {
      const findState = states.find((x: any) => x.id === state);
      return {
        name_th: findState.name_th,
        bg_color: findState.bg_color,
      };
    };

    const convert_date = (date: any) => {
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    const showAccused = (accused: any) => {
      let text = "";

      if (accused != null && accused.length != 0) {
        if (!accused?.length) return "";

        return accused
          .map((x: any) => {
            const prefix =
              selectOptions.value.prefix_names.find(
                (p) => p.id === x.prefix_name_id
              )?.name_th || "";
            return `${prefix}${x.firstname || ""} ${x.lastname || ""}`;
          })
          .join(", ");
      }
      return text;
    };

    // Mounted
    onMounted(() => {
      calYear();
      fetchPrefixName();
      fetchState();
      fetchInspector();
      fetchBureau();
      fetchProvince();
      fetchComplaintType();
      fetchComplaintChannel();
      fetchItems();

      search.value.year = selectOptions.value.years[0];
    });

    // Watch
    watch([currentPage], () => {
      fetchItems();
    });

    return {
      totalPage,
      totalItems,
      search,
      items,
      item,
      perPage,
      currentPage,
      selectOptions,
      format,
      showState,
      onSearch,
      onClear,
      onExport,
      onAddModal,
      onEditModal,
      onDetailModal,
      fetchItems,
      ability,
      showAccused,
      convert_date,
      openDetailModal,
      openReceiveModal,
      openReceiveModal2,
      openReceiveModal3,
      openSendReportModal,
      openReceiveReportModal,
      openSendModal,
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
}

.bg-color-police {
  background-color: #800001;
}
</style>

<!-- Get ข้อมูล count -->
<!-- สิทธิ์การมองเห็น เมนูย่อย และข้อมูลกับ Filter -->
