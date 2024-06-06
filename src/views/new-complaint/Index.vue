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
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from "vue";
import ApiService from "@/core/services/ApiService";

// Import Dayjs
import dayjs from "dayjs";

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
  },
  setup() {
    // UI Variable
    const isLoading = ref<any>(false);

    // Variable
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    // let { states } = useStateData();

    const search = reactive<any>({});

    const items = reactive<any[]>([]);
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
    const onExport = async () => {};

    // Modal action
    const onAddModal = () => {
      openAddModal.value = true;
    };

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
      openReceive1Modal,
      openAddModal,
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
