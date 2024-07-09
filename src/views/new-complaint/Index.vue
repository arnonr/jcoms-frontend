<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <!-- Search -->
      <SearchComponent :search="search" @search="fetchItems" @clear="onClear" />
    </div>
    <div class="card shadow-sm my-5">
      <!-- Button Add & Export -->
      <div class="card-header bg-white">
        <h4 class="card-title">รายการเรื่องรอการตรวจสอบ</h4>
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

          <button
            class="btn btn-outline btn-outline-primary me-2 pe-sm-3 ps-sm-5"
            @click="onImport1111()"
          >
            <i class="bi bi-file-earmark-plus-fill fs-4"></i>
            <span class="d-none d-lg-inline-block ms-2">โหลดข้อมูล 1111</span>
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
              <li><a class="dropdown-item" @click="onExport()">Excel</a></li>
              <li><a class="dropdown-item" @click="generatePDF()">PDF</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="card-body table-responsive">
        <Preloader :isLoading="isLoading" :position="'absolute'" />
        <ListComponent
          :items="items"
          :paginationData="paginationData"
          @update:currentPage="paginationData.currentPage = $event"
          @edit="
            (it: any) => {
              Object.assign(item, it);
              openEditModal = true;
            }
          "
          @detail="
            (it: any) => {
              Object.assign(item, it);
              openDetailModal = true;
            }
          "
          @receive1="
            (it: any) => {
              Object.assign(item, it);
              openReceive1Modal = true;
            }
          "
        />
      </div>
    </div>

    <div>
      <!-- Modal Detail ดูข้อมูล -->
      <div id="detail-modal">
        <DetailPage
          v-if="openDetailModal == true"
          :complaint_id="item.id"
          :complainant_id="item.complainant_id"
          @close-modal="
            () => {
              openDetailModal = false;
            }
          "
        />
      </div>

      <!-- Modal Edit แก้ไขข้อมูล -->
      <div id="edit-modal">
        <EditPage
          v-if="openEditModal == true"
          :complaint_id="item.id"
          :complainant_id="item.complainant_id"
          @close-modal="
            () => {
              openEditModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Add เพิ่มข้อมูล -->
      <div id="add-modal">
        <AddPage
          v-if="openAddModal == true"
          @close-modal="
            () => {
              openAddModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive ฝรท. รับเรื่อง -->
      <div id="receive1-modal">
        <Receive1Page
          v-if="openReceive1Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceive1Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>
    </div>

    <!-- PDF -->
    <vue3-html2pdf
      :show-layout="false"
      :float-layout="true"
      :enable-download="true"
      :preview-modal="true"
      filename="jcoms_export_data"
      :pdf-quality="2"
      :manual-pagination="true"
      pdf-format="a4"
      pdf-orientation="landscape"
      pdf-content-width="800px"
      ref="html2Pdf"
    >
      <template v-slot:pdf-content>
        <div
          style="margin-left: 10px; margin-bottom: 50px"
          class="generate-pdf"
        >
          <table class="table table-bordered table-striped" style="width: 100%">
            <thead class="bg-color-police">
              <tr>
                <th class="text-white">วันที่</th>
                <th class="text-white">รหัสคำร้อง</th>
                <th class="text-white">หมวดหมู่เรื่อง</th>
                <th class="text-white">ลักษณะความผิด</th>
                <th class="text-white">หัวข้อเรื่อง</th>
                <th class="text-white">ผู้ร้อง</th>
                <th class="text-white">จังหวัดที่เกิดเหตุ</th>
                <th class="text-white">ผู้ถูกร้อง</th>
                <th class="text-white">บช./ภ.</th>
                <th class="text-white">บก./ภ.จว.</th>
                <th class="text-white">หน่วยงาน</th>
                <th class="text-white">สถานะ</th>
              </tr>
            </thead>
            <tbody v-if="items_export.length != 0">
              <tr v-for="(it, idx) in items_export" :key="idx">
                <td>{{ it.show_created_at }}</td>
                <td>{{ it.show_jcoms_no }}</td>
                <td>{{ it.show_topic_category_name }}</td>
                <td>{{ it.show_topic_type_name }}</td>
                <td>{{ it.show_complaint_title }}</td>
                <td>{{ it.show_complainant_fullname }}</td>
                <td>{{ it.show_province_name }}</td>
                <td>{{ it.show_accused_name }}</td>
                <td>{{ it.show_bureau_name }}</td>
                <td>{{ it.show_division_name }}</td>
                <td>{{ it.show_agency_name }}</td>
                <td>{{ it.show_state_name }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
    </vue3-html2pdf>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from "vue";
import ApiService from "@/core/services/ApiService";

// Import Dayjs
import dayjs from "dayjs";

// Excel
import XLSX from "xlsx";
import ExcelJS from "exceljs";
// PDF
import { jsPDF } from "jspdf";
import Vue3Html2pdf from "vue3-html2pdf";
// Use Toast Composables
import useToast from "@/composables/useToast";

// Component
import SearchComponent from "@/components/complaint/Search.vue";
import ListComponent from "@/components/complaint/List.vue";
import Preloader from "@/components/preloader/Preloader.vue";
import EditPage from "@/views/new-complaint/Edit.vue";
import AddPage from "@/views/new-complaint/Add.vue";
import DetailPage from "@/views/new-complaint/DetailModal.vue";
import Receive1Page from "@/views/new-complaint/Receive1.vue";

export default defineComponent({
  name: "complaint",
  components: {
    SearchComponent,
    ListComponent,
    Preloader,
    EditPage,
    DetailPage,
    Receive1Page,
    AddPage,
    Vue3Html2pdf,
    jsPDF,
  },
  setup() {
    // UI Variable
    const isLoading = ref<any>(false);
    const html2Pdf = ref<any>(null);

    // Variable
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    // let { states } = useStateData();

    const search = reactive<any>({});

    const items = reactive<any[]>([]);
    const items_export = reactive<any[]>([]);
    const item = reactive<any>({});

    const paginationData = reactive<any>({
      perPage: 20,
      currentPage: 1,
      totalPage: 1,
      totalItems: 0,
    });

    const openDetailModal = ref(false);
    const openEditModal = ref(false);
    const openReceive1Modal = ref(false);
    const openAddModal = ref(false);

    const prefix_names = ref([]);
    const fetchPrefixName = async (params: any) => {
      const { data } = await ApiService.query("prefix-name", {
        params: params,
      });

      prefix_names.value = data.data;
    };
    fetchPrefixName({ perPage: 500 });

    const generatePDF = async () => {
      exportExcel().then(() => {
        setTimeout(async () => {
          html2Pdf.value.generatePdf();
        }, 3000);
      });
    };

    // Fetch Data
    const fetchItems = async () => {
      isLoading.value = true;
      const params = {
        ...search,
        create_year: search.year ?? undefined,
        state_id: search.state_id?.id ?? 1,
        inspector_id: search.inspector_id?.id ?? undefined,
        bureau_id: search.bureau_id?.id ?? undefined,
        division_id: search.division_id?.id ?? undefined,
        agency_id: search.agency_id?.id ?? undefined,
        is_anonymous: search.is_anonymous?.value ?? undefined,
        province_id: search.province_id?.id ?? undefined,
        district_id: search.district_id?.id ?? undefined,
        sub_district_id: search.sub_district_id?.id ?? undefined,
        complaint_type_id: search.complaint_type_id?.id ?? undefined,
        topic_category_id: search.topic_category_id?.id ?? undefined,
        topic_type_id: search.topic_type_id?.id ?? undefined,
        complaint_channel_id: search.complaint_channel_id?.id ?? undefined,
        incident_datetime: search.incident_date
          ? dayjs(search.incident_date).format("YYYY-MM-DD")
          : undefined,
        create_from: search.create_from
          ? dayjs(search.create_from).format("YYYY-MM-DD")
          : undefined,
        create_to: search.create_to
          ? dayjs(search.create_to).format("YYYY-MM-DD")
          : undefined,
        orderBy: "created_at",
        order: "desc",
        perPage: paginationData.perPage,
        currentPage: paginationData.currentPage,
      };

      const { data } = await ApiService.query("complaint", {
        params: params,
      });

      items.length = 0;
      Object.assign(items, data.data);
      paginationData.totalPage = data.totalPage;
      paginationData.totalItems = data.totalData;
      paginationData.currentPage = data.currentPage;
      isLoading.value = false;
    };

    const fetchExportItems = async () => {
      isLoading.value = true;
      const params = {
        ...search,
        create_year: search.year ?? undefined,
        state_id: search.state_id?.id ?? 1,
        inspector_id: search.inspector_id?.id ?? undefined,
        bureau_id: search.bureau_id?.id ?? undefined,
        division_id: search.division_id?.id ?? undefined,
        agency_id: search.agency_id?.id ?? undefined,
        is_anonymous: search.is_anonymous?.value ?? undefined,
        province_id: search.province_id?.id ?? undefined,
        district_id: search.district_id?.id ?? undefined,
        sub_district_id: search.sub_district_id?.id ?? undefined,
        complaint_type_id: search.complaint_type_id?.id ?? undefined,
        topic_category_id: search.topic_category_id?.id ?? undefined,
        topic_type_id: search.topic_type_id?.id ?? undefined,
        complaint_channel_id: search.complaint_channel_id?.id ?? undefined,
        incident_datetime: search.incident_date
          ? dayjs(search.incident_date).format("YYYY-MM-DD")
          : undefined,
        create_from: search.create_from
          ? dayjs(search.create_from).format("YYYY-MM-DD")
          : undefined,
        create_to: search.create_to
          ? dayjs(search.create_to).format("YYYY-MM-DD")
          : undefined,
        orderBy: "created_at",
        order: "desc",
        perPage: 1000000,
        currentPage: paginationData.currentPage,
      };

      const { data } = await ApiService.query("complaint", {
        params: params,
      });

      items_export.length = 0;

      Object.assign(
        items_export,
        data.data.map((x: any) => {
          x.show_created_at = dayjs(x.created_at)
            .locale("th")
            .format("DD MMM BB");
          x.show_jcoms_no = x.jcoms_no;
          x.show_complaint_type_name = x.complaint_type?.name_th;
          x.show_complaint_title = x.complaint_title;
          x.show_topic_type_name = x.topic_type?.name_th;
          x.show_topic_category_name = x.topic_type?.topic_category?.name_th;
          x.show_complaint_channel_name = x.complaint_channel?.name_th;
          x.show_state_name = x.state.name_th;
          x.show_inspector_name = x.inspector?.name_th;
          x.show_bureau_name = x.bureau?.name_th;
          x.show_division_name = x.division?.name_th;
          x.show_agency_name = x.agency?.name_th;
          x.show_province_name = x.province?.name_th;
          x.show_district_name = x.district?.name_th;
          x.show_sub_district_name = x.sub_district?.name_th;
          x.show_complainant_fullname =
            x.complainant?.firstname + " " + x.complainant?.lastname;

          x.show_accused_name = convertAccused(x.accused);

          //   x.show_complaint_detail = x.complaint_detail;

          return x;
        })
      );
      isLoading.value = false;
    };

    const convertAccused = (accused: any) => {
      let text = "";

      if (accused != null && accused.length != 0) {
        if (!accused?.length) return "";

        text = accused
          .map((x: any) => {
            const prefix: any = prefix_names.value.find(
              (p: any) => p.id === x.prefix_name_id
            );

            return `${prefix?.name_th !== undefined ? prefix?.name_th : ""}${
              x.firstname || ""
            } ${x.lastname || ""}`;
          })
          .join(", ");
      }
      return text;
    };

    // Event
    const onClear = () => {
      Object.keys(search).forEach((key) => {
        if (typeof search[key] === "object" && search[key] !== null) {
          Object.keys(search[key]).forEach((subKey) => {
            search[key][subKey] = null;
          });
        } else {
          search[key] = null;
        }
      });
    };

    const exportExcel = async () => {
      fetchExportItems();
    };

    const onExport = async () => {
      exportExcel().then(() => {
        setTimeout(async () => {
          const workbook = new ExcelJS.Workbook();
          const worksheet = workbook.addWorksheet("รายการ", {
            pageSetup: { orientation: "landscape" },
            headerFooter: {
              firstHeader: "Hello Exceljs",
              firstFooter: "Hello World",
            },
          });
          //   x.show_accused_name = convertAccused(x.accused);

          worksheet.columns = [
            {
              header: "วันที่ร้องเรียน",
              key: "show_created_at",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "รหัสคำร้อง",
              key: "show_jcoms_no",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ประเภทเรื่อง",
              key: "show_complaint_type_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "หมวดหมู่เรื่อง",
              key: "show_topic_category_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ลักษณะความผิด",
              key: "show_topic_type_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "หัวข้อเรื่อง",
              key: "show_complaint_title",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ผู้ร้อง",
              key: "show_complainant_fullname",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "จังหวัดที่เกิดเหตุ",
              key: "show_province_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "อำเภอที่เกิดเหตุ",
              key: "show_district_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ตำบลที่เกิดเหตุ",
              key: "show_sub_district_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ผู้ถูกร้อง",
              key: "show_accused_name",
              width: 25,
              outlineLevel: 1,
            },

            {
              header: "กองตรวจราชการ",
              key: "show_inspector_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "บช./ภ.",
              key: "show_bureau_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "บก./ภ.จว.",
              key: "show_division_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "หน่วยงาน",
              key: "show_agency_name",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "สถานะ",
              key: "show_state_name",
              width: 25,
              outlineLevel: 1,
            },
          ];

          // worksheet.properties.defaultRowHeight = 20;

          worksheet.addRows(items_export);

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

          worksheet.insertRow(1, "รายการเรื่องร้องเรียน");
          worksheet.mergeCells("A1:K1");
          worksheet.getCell("A1").value = "รายการเรื่องร้องเรียน";
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
          link.download = "รายการเรื่องร้องเรียน.xlsx";
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
        }, 1000);
      });
    };

    // Modal action
    const onAddModal = () => {
      openAddModal.value = true;
    };

    const onDetailModal = (it: any) => {
      Object.assign(item, it);
    };

    const onImport1111 = async () => {
      await ApiService.query("opm/sync-all",{});

      //   prefix_names.value = data.data;
      useToast("นำเข้าข้อมูลเสร็จสิ้น");
    };

    // Mounted
    onMounted(() => {
      fetchItems();
    });

    // Watch
    watch(
      () => paginationData.currentPage,
      () => {
        fetchItems();
      }
    );

    return {
      search,
      items,
      item,
      paginationData,
      isLoading,
      onClear,
      onExport,
      onAddModal,
      onDetailModal,
      fetchItems,
      openDetailModal,
      openEditModal,
      openReceive1Modal,
      openAddModal,
      items_export,
      html2Pdf,
      generatePDF,
      onImport1111,
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
