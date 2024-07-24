<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <!-- Search -->
      <SearchComponent
        :search="search"
        :state_new="false"
        @search="
          () => {
            paginationData.currentPage = 1;
            fetchItems();
          }
        "
        @clear="onClear"
      />
    </div>
    <div class="card shadow-sm my-5">
      <!-- Button Add & Export -->
      <div class="card-header bg-white">
        <h4 class="card-title">ค้นหาเรื่องร้องเรียน</h4>
        <div class="card-toolbar">
          <div class="dropdown">
            <button
              class="btn btn-outline btn-outline-success pe-sm-3 ps-sm-5 dropdown-toggle"
              type="button"
              id="dropdownMenuButton"
              data-bs-toggle="dropdown"
              aria-expanded="false"
            >
              <i class="fa fa-download  fs-4"></i>
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
          @send3="
              (it: any) => {
                Object.assign(item, it);
                openSend3Modal = true;
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
          @receiveReport0="
              (it: any) => {
                Object.assign(item, it);
                openReceiveReport0Modal = true;
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
          @successAnotherReport="  (it: any) => {
                Object.assign(item, it);
                openSuccessAnotherReportModal = true;
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
          @sendToCommissioner="
              (it: any) => {
                Object.assign(item, it);
                openSendToCommissionerModal = true;
              }
            "
          @receiveCommissioner=" (it: any) => {
                Object.assign(item, it);
                openReceiveCommissionerModal = true;
              }"
          @sendHurry=" (it: any) => {
                Object.assign(item, it);
                openSendHurryModal = true;
              }"
          @sendCommissionerHurry=" (it: any) => {
                Object.assign(item, it);
                openSendCommissionerHurryModal = true;
              }"
          @receiveHurry=" (it: any) => {
                Object.assign(item, it);
                openReceiveHurryModal = true;
              }"
          @sendExtend=" (it: any) => {
                Object.assign(item, it);
                openSendExtendModal = true;
              }"
          @approveExtend=" (it: any) => {
                Object.assign(item, it);
                openApproveExtendModal = true;
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

      <!-- Modal Send  บก./ภจ.ว. ส่งต่อเรื่อง -->
      <div id="send3-modal">
        <Send3Page
          v-if="openSend3Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSend3Modal = false;
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

      <!-- Modal Receive Report 0 บก./ภจ.ว. รับรายงาน -->
      <div id="receive-report1-modal">
        <ReceiveReport0Page
          v-if="openReceiveReport0Modal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveReport0Modal = false;
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

      <!-- Modal Success Report จต. ยุติเรื่อง -->
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

      <!-- Modal Success Another Report จต. ส่งต่อหน่วยงานอื่น -->
      <div id="success-report-modal">
        <SuccessAnotherReportPage
          v-if="openSuccessAnotherReportModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSuccessAnotherReportModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Flow Inspector -->

      <div id="sendToCommissioner-modal">
        <SendToCommissionerPage
          v-if="openSendToCommissionerModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendToCommissionerModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

      <!-- Modal Receive -->
      <div id="receive-commissioner-modal">
        <ReceiveCommissionerPage
          v-if="openReceiveCommissionerModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openReceiveCommissionerModal = false;
            }
          "
          @reload="fetchItems"
        />
      </div>

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

      <div id="send-commissioner-hurry-modal">
        <SendCommissionerHurryPage
          v-if="openSendCommissionerHurryModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openSendCommissionerHurryModal = false;
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

      <div id="approve-extend-modal">
        <ApproveExtendPage
          v-if="openApproveExtendModal == true"
          :complaint_id="item.id"
          @close-modal="
            () => {
              openApproveExtendModal = false;
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
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  watch,
  computed,
} from "vue";
import ApiService from "@/core/services/ApiService";
// Import Dayjs
import dayjs from "dayjs";
// Excel
import XLSX from "xlsx";
import ExcelJS from "exceljs";
// PDF
import { jsPDF } from "jspdf";
import Vue3Html2pdf from "vue3-html2pdf";
import { useAbility } from "@casl/vue";

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
import Send3Page from "@/views/complaint/Send3.vue";
import SendReport1Page from "@/views/complaint/SendReport1.vue";
import SendReport2Page from "@/views/complaint/SendReport2.vue";
import ReceiveReport0Page from "@/views/complaint/ReceiveReport0.vue";
import ReceiveReport1Page from "@/views/complaint/ReceiveReport1.vue";
import ReceiveReport2Page from "@/views/complaint/ReceiveReport2.vue";
import SuccessReportPage from "@/views/complaint/SuccessReport.vue";
import SuccessAnotherReportPage from "@/views/complaint/SuccessAnotherReport.vue";
import ReturnReport1Page from "@/views/complaint/ReturnReport1.vue";
import ReturnReport2Page from "@/views/complaint/ReturnReport2.vue";
import SendToInspectorPage from "@/views/complaint/SendToInspector.vue";
import ReceiveInspectorPage from "@/views/complaint/ReceiveInspector.vue";
import SendToCommissionerPage from "@/views/complaint/SendToCommissioner.vue";
import ReceiveCommissionerPage from "@/views/complaint/ReceiveCommissioner.vue";
import SendCommissionerHurryPage from "@/views/complaint/SendCommissionerHurry.vue";
import SendHurryPage from "@/views/complaint/SendHurry.vue";
import ReceiveHurryPage from "@/views/complaint/ReceiveHurry.vue";
import SendExtendPage from "@/views/complaint/SendExtend.vue";
import ApproveExtendPage from "@/views/complaint/ApproveExtend.vue";

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
    Send3Page,
    SendReport1Page,
    SendReport2Page,
    ReceiveReport0Page,
    ReceiveReport1Page,
    ReceiveReport2Page,
    SuccessReportPage,
    ReturnReport1Page,
    ReturnReport2Page,
    SendToInspectorPage,
    ReceiveInspectorPage,
    SendToCommissionerPage,
    SendCommissionerHurryPage,
    ReceiveCommissionerPage,
    SuccessAnotherReportPage,
    SendHurryPage,
    ReceiveHurryPage,
    SendExtendPage,
    ApproveExtendPage,
    Vue3Html2pdf,
    jsPDF,
  },
  setup() {
    // UI Variable
    const isLoading = ref<any>(true);
    const html2Pdf = ref<any>(null);

    // Variable
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    const ability = useAbility();
    // let { states } = useStateData();

    const canView = computed(() =>
      ability.can("view", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );
    const canCreate = computed(() =>
      ability.can("create", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );
    const canUpdate = computed(() =>
      ability.can("update", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );

    const canDelete = computed(() =>
      ability.can("delete", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );

    const canExport = computed(() =>
      ability.can("export", "บัญชีรวมเรื่องร้องเรียน/แจ้งเบาะแส")
    );

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
    const openSend3Modal = ref(false);
    const openReceive3Modal = ref(false);
    const openSendReport1Modal = ref(false);
    const openSendReport2Modal = ref(false);
    const openReceiveReport1Modal = ref(false);
    const openReceiveReport2Modal = ref(false);
    const openSuccessReportModal = ref(false);
    const openReceiveReport0Modal = ref(false);
    const openReturnReport1Modal = ref(false);
    const openReturnReport2Modal = ref(false);

    const openSendToInspectorModal = ref(false);
    const openReceiveInspectorModal = ref(false);
    const openSendHurryModal = ref(false);
    const openReceiveHurryModal = ref(false);
    const openSendExtendModal = ref(false);
    const openApproveExtendModal = ref(false);
    const openSendToCommissionerModal = ref(false);
    const openReceiveCommissionerModal = ref(false);
    const openSendCommissionerHurryModal = ref(false);
    const openSuccessAnotherReportModal = ref(false);

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
        state_id: search.state_id?.id ?? undefined,
        inspector_state_id: search.inspector_state_id?.id ?? undefined,
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
        card_type: search.card_type?.id ?? undefined,
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
        receive_status: undefined,
        state_in: undefined,
      };

      if (
        (search.complainant_fullname != null &&
          search.complainant_fullname != "") ||
        (search.card_type != null && search.card_type != "") ||
        (search.id_card != null && search.id_card != "")
      ) {
        params.is_anonymous = 1;
      }

      if (userData.role_id == 1) {
      } else if (userData.role_id == 2) {
      } else if (userData.role_id == 3) {
        params.bureau_id = userData.bureau_id;
        params.state_in = "8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24";
        if (userData.organization_permissions.resp_division_id.length != 0) {
          params.resp_division_id =
            userData.organization_permissions.resp_division_id.join(",");
        }
      } else if (userData.role_id == 4) {
        params.division_id = userData.division_id;
        params.state_in = "8,9,11,12,15,16,17,20,21,22,23,24";
        if (userData.organization_permissions.resp_agency_id.length != 0) {
          params.resp_agency_id =
            userData.organization_permissions.resp_agency_id.join(",");
        }
      } else if (userData.role_id == 5) {
        params.inspector_id = userData.inspector_id;
        params.state_in =
          "3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24";
        if (userData.organization_permissions.resp_bureau_id.length != 0) {
          params.resp_bureau_id =
            userData.organization_permissions.resp_bureau_id.join(",");
        }
      } else if (userData.role_id == 6) {
      } else {
        return false;
      }

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
        inspector_state_id: search.inspector_state_id?.id ?? undefined,
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
        card_type: search.card_type?.id ?? undefined,
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
        receive_status: undefined,
        state_in: undefined,
      };

      if (
        (search.complainant_fullname != null &&
          search.complainant_fullname != "") ||
        (search.card_type != null && search.card_type != "") ||
        (search.id_card != null && search.id_card != "")
      ) {
        params.is_anonymous = 1;
      }

      if (userData.role_id == 1) {
      } else if (userData.role_id == 2) {
      } else if (userData.role_id == 3) {
        params.bureau_id = userData.bureau_id;
        params.state_in = "8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24";
        if (userData.organization_permissions.resp_division_id.length != 0) {
          params.resp_division_id =
            userData.organization_permissions.resp_division_id.join(",");
        }
      } else if (userData.role_id == 4) {
        params.division_id = userData.division_id;
        params.state_in = "8,9,11,12,15,16,17,20,21,22,23,24";
        if (userData.organization_permissions.resp_agency_id.length != 0) {
          params.resp_agency_id =
            userData.organization_permissions.resp_agency_id.join(",");
        }
      } else if (userData.role_id == 5) {
        params.inspector_id = userData.inspector_id;
        params.state_in =
          "3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24";
        if (userData.organization_permissions.resp_bureau_id.length != 0) {
          params.resp_bureau_id =
            userData.organization_permissions.resp_bureau_id.join(",");
        }
      } else if (userData.role_id == 6) {
      } else {
        return false;
      }

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
      Object.assign(search, {
        complaint_type_id: null,
        year: null,
        complaint_title: "",
        jcoms_no: "",
        complainant_fullname: "",
        accused_fullname: "",
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        agency_id: null,
        state_id: null,
        inspector_state_id: null,
        create_from: null,
        create_to: null,
        topic_category_id: null,
        topic_type_id: null,
        complaint_channel_id: null,
        incident_datetime: null,
        province_id: null,
        district_id: null,
        sub_district_id: null,
        card_type: null,
        id_card: "",
        is_anonymous: null,
        receive_doc_no: "",
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
      openSend3Modal,
      openSendReport1Modal,
      openSendReport2Modal,
      openReceiveReport0Modal,
      openReceiveReport1Modal,
      openReceiveReport2Modal,
      openSuccessReportModal,
      openReturnReport1Modal,
      openReturnReport2Modal,
      openSendToInspectorModal,
      openReceiveInspectorModal,
      openSendToCommissionerModal,
      openReceiveCommissionerModal,
      openSendCommissionerHurryModal,
      openSendHurryModal,
      openReceiveHurryModal,
      openSendExtendModal,
      openApproveExtendModal,
      items_export,
      html2Pdf,
      generatePDF,
      userData,
      canView,
      canCreate,
      canUpdate,
      canDelete,
      canExport,
      openSuccessAnotherReportModal,
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
