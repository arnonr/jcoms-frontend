<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <!-- Search -->
      <SearchComponent
        :search="search"
        :state_new="false"
        @search="fetchItems"
        @clear="onClear"
      />
    </div>
    <div class="card shadow-sm my-5">
      <!-- Button Add & Export -->
      <div class="card-header bg-white">
        <h4 class="card-title">บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส</h4>
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
              <li><a class="dropdown-item" @click="onExport()">Excel</a></li>
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
          @send1="
              (it: any) => {
                Object.assign(item, it);
                openSend1Modal = true;
              }
            "
          @receive2="
              (it: any) => {
                Object.assign(item, it);
                openReceive2Modal = true;
              }
            "
          @send2="
              (it: any) => {
                Object.assign(item, it);
                openSend2Modal = true;
              }
            "
          @receive3="
              (it: any) => {
                Object.assign(item, it);
                openReceive3Modal = true;
              }
            "
          @sendReport1="
              (it: any) => {
                Object.assign(item, it);
                openSendReport1Modal = true;
              }
            "
          @sendReport2="
              (it: any) => {
                Object.assign(item, it);
                openSendReport2Modal = true;
              }
            "
          @receiveReport1="
              (it: any) => {
                Object.assign(item, it);
                openReceiveReport1Modal = true;
              }
            "
          @receiveReport2="
              (it: any) => {
                Object.assign(item, it);
                openReceiveReport2Modal = true;
              }
            "
          @successReport="  (it: any) => {
                Object.assign(item, it);
                openSuccessReportModal = true;
              }"
          @returnReport1=" (it: any) => {
                Object.assign(item, it);
                openReturnReport1Modal = true;
              }"
          @returnReport2=" (it: any) => {
                Object.assign(item, it);
                openReturnReport2Modal = true;
              }"
          @sendToInspector="
              (it: any) => {
                Object.assign(item, it);
                openSendToInspectorModal = true;
              }
            "
          @receiveInspector=" (it: any) => {
                Object.assign(item, it);
                openReceiveInspectorModal = true;
              }"
          @sendHurry=" (it: any) => {
                Object.assign(item, it);
                openSendHurryModal = true;
              }"
          @receiveHurry=" (it: any) => {
                Object.assign(item, it);
                openReceiveHurryModal = true;
              }"
          @sendExtend=" (it: any) => {
                Object.assign(item, it);
                openSendExtendModal = true;
              }"
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

      <!-- Modal Send ฝรท. ส่งต่อเรื่อง -->
      <div id="send1-modal">
        <Send1Page
          v-if="openSend1Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSend1Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Send ฝรท. ส่งต่อเรื่อง ถึง กองตรวจราชการ -->
      <div id="sendToInspector-modal">
        <SendToInspectorPage
          v-if="openSendToInspectorModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendToInspectorModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive2 บช./ภ. รับเรื่อง -->
      <div id="receive-inspector-modal">
        <ReceiveInspectorPage
          v-if="openReceiveInspectorModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveInspectorModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive2 บช./ภ. รับเรื่อง -->
      <div id="receive2-modal">
        <Receive2Page
          v-if="openReceive2Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceive2Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Send บช./ภ. ส่งต่อเรื่อง -->
      <div id="send2-modal">
        <Send2Page
          v-if="openSend2Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSend2Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive3 บช./ภ. รับเรื่อง -->
      <div id="receive3-modal">
        <Receive3Page
          v-if="openReceive3Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceive3Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Send Report บก./ภจ.ว. ส่งรายงาน -->
      <div id="send-report1-modal">
        <SendReport1Page
          v-if="openSendReport1Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendReport1Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive Report 1 บช./ภ. รับรายงาน -->
      <div id="receive-report1-modal">
        <ReceiveReport1Page
          v-if="openReceiveReport1Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveReport1Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Return Report จต. ส่งกลับรายงาน -->
      <div id="return-report1-modal">
        <ReturnReport1Page
          v-if="openReturnReport1Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReturnReport1Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Send Report บช./ภ.  ส่งรายงาน -->
      <div id="send-report2-modal">
        <SendReport2Page
          v-if="openSendReport2Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendReport2Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive Report 2 จต. รับรายงาน -->
      <div id="receive-report2-modal">
        <ReceiveReport2Page
          v-if="openReceiveReport2Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveReport2Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Return Report จต. ส่งกลับรายงาน -->
      <div id="return-report2-modal">
        <ReturnReport2Page
          v-if="openReturnReport2Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReturnReport2Modal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Success Report จต. ปิดเรื่อง -->
      <div id="success-report-modal">
        <SuccessReportPage
          v-if="openSuccessReportModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSuccessReportModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Flow Inspector -->
      <div id="send-hurry-modal">
        <SendHurryPage
          v-if="openSendHurryModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendHurryModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <div id="receive-hurry-modal">
        <ReceiveHurryPage
          v-if="openReceiveHurryModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveHurryModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <div id="send-extend-modal">
        <SendExtendPage
          v-if="openSendExtendModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendExtendModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>
    </div>
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

// Component
import SearchComponent from "@/components/complaint/Search.vue";
import ListComponent from "@/components/complaint/List2.vue";
import Preloader from "@/components/preloader/Preloader.vue";
import EditPage from "@/views/new-complaint/Edit.vue";
import DetailPage from "@/views/new-complaint/DetailModal.vue";
import Send1Page from "@/views/complaint/Send1.vue";
import Receive2Page from "@/views/complaint/Receive2.vue";
import Send2Page from "@/views/complaint/Send2.vue";
import Receive3Page from "@/views/complaint/Receive3.vue";
import SendReport1Page from "@/views/complaint/SendReport1.vue";
import SendReport2Page from "@/views/complaint/SendReport2.vue";
import ReceiveReport1Page from "@/views/complaint/ReceiveReport1.vue";
import ReceiveReport2Page from "@/views/complaint/ReceiveReport2.vue";
import SuccessReportPage from "@/views/complaint/SuccessReport.vue";
import ReturnReport1Page from "@/views/complaint/ReturnReport1.vue";
import ReturnReport2Page from "@/views/complaint/ReturnReport2.vue";
import SendToInspectorPage from "@/views/complaint/SendToInspector.vue";
import ReceiveInspectorPage from "@/views/complaint/ReceiveInspector.vue";
import SendHurryPage from "@/views/complaint/SendHurry.vue";
import ReceiveHurryPage from "@/views/complaint/ReceiveHurry.vue";
import SendExtendPage from "@/views/complaint/SendExtend.vue";

export default defineComponent({
  name: "complaint",
  components: {
    SearchComponent,
    ListComponent,
    Preloader,
    EditPage,
    DetailPage,
    Send1Page,
    Receive2Page,
    Send2Page,
    Receive3Page,
    SendReport1Page,
    SendReport2Page,
    ReceiveReport1Page,
    ReceiveReport2Page,
    SuccessReportPage,
    ReturnReport1Page,
    ReturnReport2Page,
    SendToInspectorPage,
    ReceiveInspectorPage,
    SendHurryPage,
    ReceiveHurryPage,
    SendExtendPage,
  },
  setup() {
    // UI Variable
    const isLoading = ref<any>(true);

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
    const openSend1Modal = ref(false);
    const openReceive2Modal = ref(false);
    const openSend2Modal = ref(false);
    const openReceive3Modal = ref(false);
    const openSendReport1Modal = ref(false);
    const openSendReport2Modal = ref(false);
    const openReceiveReport1Modal = ref(false);
    const openReceiveReport2Modal = ref(false);
    const openSuccessReportModal = ref(false);
    const openReturnReport1Modal = ref(false);
    const openReturnReport2Modal = ref(false);

    const openSendToInspectorModal = ref(false);
    const openReceiveInspectorModal = ref(false);
    const openSendHurryModal = ref(false);
    const openReceiveHurryModal = ref(false);
    const openSendExtendModal = ref(false);

    // Fetch Data
    const fetchItems = async () => {
      isLoading.value = true;
      const params = {
        ...search,
        create_year: search.year ?? undefined,
        state_id: search.state_id?.id ?? undefined,
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
        receive_status: 1,
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
        state_id: search.state_id?.id ?? undefined,
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
        receive_status: 1,
      };

      const { data } = await ApiService.query("complaint", {
        params: params,
      });

      items_export.length = 0;
      Object.assign(items_export, data.data);
      isLoading.value = false;
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

          worksheet.columns = [
            {
              header: "วันที่ร้องเรียน",
              key: "created_at",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "รหัสคำร้อง",
              key: "jcoms_no",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ลักษณะความผิด",
              key: "topic_type.name_th",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ลักษณะความผิด",
              key: "topic_type.name_th",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "ผู้ถูกร้อง",
              key: "topic_type.name_th",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "หน่วยงานถูกร้อง",
              key: "topic_type.name_th",
              width: 25,
              outlineLevel: 1,
            },
            {
              header: "สถานะ",
              key: "topic_type.name_th",
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
    const onAddModal = () => {};

    const onDetailModal = (it: any) => {
      Object.assign(item, it);
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
      openSend1Modal,
      openReceive2Modal,
      openSend2Modal,
      openReceive3Modal,
      openSendReport1Modal,
      openSendReport2Modal,
      openReceiveReport1Modal,
      openReceiveReport2Modal,
      openSuccessReportModal,
      openReturnReport1Modal,
      openReturnReport2Modal,
      openSendToInspectorModal,
      openReceiveInspectorModal,
      openSendHurryModal,
      openReceiveHurryModal,
      openSendExtendModal,
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
