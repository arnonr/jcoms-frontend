<template>
  <!--begin::Wrapper-->
  <div class="container">
    <div class="card shadow-sm my-6">
      <div class="accordion" id="accordionExample">
        <div class="accordion-item">
          <h6
            class="accordion-header p-5 accordion-button"
            data-bs-toggle="collapse"
            data-bs-target="#collapseOne"
            aria-expanded="false"
            aria-controls="collapseOne"
          >
            <i class="fa fa-search pe-2"></i> ค้นหาหน่วยงาน
          </h6>
          <div
            id="collapseOne"
            class="accordion-collapse collapse hide"
            data-bs-parent="#accordionExample"
          >
            <div class="accordion-body">
              <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
                <div class="col-12 col-md-4 my-2">
                  <label for="">ระดับหน่วยงานต้นทาง</label>
                  <v-select
                    id="slt-search-role-id"
                    name="slt-search-role-id"
                    label="name_th"
                    placeholder="ระดับหน่วยงาน"
                    :options="selectOptions.roles"
                    v-model="search.role_id"
                    class="form-control"
                    :clearable="true"
                  ></v-select>
                </div>
                <div class="col-12 col-md-4 my-2">
                  <label for="">ค้นหาหน่วยงานต้นทาง</label>
                  <v-select
                    id="slt-search-source-org"
                    name="slt-search-source-org"
                    label="name_th"
                    :options="selectOptions.orgs"
                    v-model="search.source_org"
                    class="form-control"
                    :clearable="true"
                  ></v-select>
                </div>

                <div class="col-12 col-md-4 my-2">
                  <label for="">ค้นหาหน่วยงานปลายทาง</label>
                  <v-select
                    id="slt-search-destination-org"
                    name="slt-search-destination-org"
                    label="name_th"
                    :options="selectOptions.orgs"
                    v-model="search.destination_org"
                    class="form-control"
                    :clearable="true"
                  ></v-select>
                </div>
              </div>
              <div class="pt-5">
                <button class="btn btn-success fw-bold" @click="onSearch()">
                  ค้นหา
                </button>
                <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
                  ล้าง
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm my-5">
      <div class="card-header bg-white">
        <h4 class="card-title">รายการหน่วยงาน</h4>
        <div class="card-toolbar">
          <button
            class="btn btn-outline btn-outline-primary me-2 pe-sm-3 ps-sm-5"
            @click="openPermissionOrgModal = true"
          >
            <i class="bi bi-file-earmark-plus-fill fs-4"></i>
            <span class="d-none d-lg-inline-block ms-2"
              >เพิ่มสิทธิการแสดงหน่วยงาน</span
            >
          </button>
        </div>
      </div>
      <div class="card-body table-responsive">
        <!-- <div class="overflow-visible"> -->
        <table class="table table-bordered table-striped" style="width: 100%">
          <thead class="bg-color-police">
            <tr>
              <th class="text-center text-white">ระดับหน่วยงานต้นทาง</th>
              <th class="text-center text-white">หน่วยงานต้นทาง</th>
              <th class="text-center text-white">หน่วยงานปลายทาง</th>
              <th class="text-center text-white">จัดการข้อมูล</th>
            </tr>
          </thead>
          <tbody v-if="items.length != 0">
            <tr v-for="(it, idx) in items" :key="idx">
              <td class="text-center"></td>
              <td class="text-center"></td>
              <td class="text-center"></td>
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
                            openEditModal = true;
                          }
                        "
                        >แก้ไข</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="
                          () => {
                            Object.assign(item, it);
                            openPermissionModal = true;
                          }
                        "
                        >ลบ</a
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

    <!-- Modal แก้ไขข้อมูล -->
    <div id="edit-modal">
      <!-- <EditUser
        :id="item.id"
        v-if="openEditModal == true"
        @reload="
          () => {
            fetchItems();
          }
        "
        @close-modal="
          () => {
            openEditModal = false;
          }
        "
      /> -->
    </div>
    <!--  -->

    <!-- Modal สิทธิ์ -->
    <div id="add-modal">
      <!-- <PermissionUser
        v-if="openPermissionModal == true"
        :user_id="item.id"
        :is_custom_role="item.is_custom_role ? item.is_custom_role : 0"
        @reload="
          () => {
            fetchItems();
          }
        "
        @close-modal="
          () => {
            openPermissionModal = false;
          }
        "
      /> -->
    </div>
    <!--  -->
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  onUnmounted,
  watch,
} from "vue";
import { useRouter } from "vue-router";
import { useAbility } from "@casl/vue";
import ApiService from "@/core/services/ApiService";

import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Pagination
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";

import useBasicData from "@/composables/useBasicData";

// Component
export default defineComponent({
  name: "permission-org",
  components: {
    VueDatePicker,
    dayjs,
    vSelect,
    BlogPagination,
  },
  setup() {
    // Variable
    const router = useRouter();
    const ability = useAbility();
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    const selectOptions = ref<any>({
      organizations: [],
      perPage: [
        { title: "20", value: 20 },
        { title: "40", value: 40 },
        { title: "60", value: 60 },
      ],
      user_statuses: useBasicData().user_statuses,
      roles: [],
      inspectors: [],
      bureaus: [],
      divisions: [],
      prefix_names: [],
    });

    const search = ref<any>({});
    const item = reactive<any>({});
    const items = reactive<any>([]);
    const perPage = ref(20);
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);

    const openEditModal = ref(false);
    const openAddModal = ref(false);
    const openPermissionOrgModal = ref(false);

    // Fetch Data
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

    const fetchItems = async () => {
      const params = {
        perPage: perPage.value,
        currentPage: currentPage.value,
        orderBy: "created_at",
        order: "desc",
        ...search.value,
        role_id: search.value.role_id?.id ?? undefined,
        status: search.value.status?.id ?? undefined,
        inspector_id: search.value.inspector_id?.id ?? undefined,
        bureau_id: search.value.bureau_id?.id ?? undefined,
        division_id: search.value.division_id?.id ?? undefined,
        agency_id: search.value.agency_id?.id ?? undefined,
      };

      const { data } = await ApiService.query("user", {
        params: params,
      });

      items.length = 0;
      Object.assign(items, data.data);
      totalPage.value = data.totalPage;
      totalItems.value = data.totalData;
      currentPage.value = data.currentPage;
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };
    const onClear = async () => {
      search.value = {};
    };

    // Show
    const showStatus = (status: any) => {
      let find_status = selectOptions.value.user_statuses.find((x: any) => {
        return x.id == status;
      });
      return find_status;
    };

    const onPermissionGroup = () => {};

    // Mounted
    onMounted(() => {
      fetchInspector();
      fetchBureau();
      fetchItems();
    });

    onUnmounted(() => {});

    // Watch
    watch([currentPage], () => {
      fetchItems();
    });

    watch(
      () => search.value.inspector_id,
      () => {
        search.value.bureau_id = null;
        search.value.division_id = null;
        fetchBureau();
      }
    );

    watch(
      () => search.value.bureau_id,
      () => {
        search.value.division_id = null;

        if (search.value.bureau_id) {
          fetchDivision();
        } else {
          selectOptions.value.divisions = [];
        }
      }
    );

    return {
      totalPage,
      totalItems,
      search,
      items,
      perPage,
      currentPage,
      selectOptions,
      item,
      router,
      showStatus,
      onSearch,
      onClear,
      fetchItems,
      openEditModal,
      openAddModal,
      openPermissionOrgModal,
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
