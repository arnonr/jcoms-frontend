<template>
  <div>
    <table
      class="table table-bordered table-striped bg-sky"
      style="width: 100%"
    >
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
            {{ convertDate(it.created_at) }}
          </td>
          <td class="text-center">{{ it.jcoms_no }}</td>

          <td class="text-center">{{ it.topic_type?.name_th }}</td>
          <td>{{ it.complaint_title }}</td>
          <td>{{ convertAccused(it.accused) }}</td>
          <td>
            <span v-if="it.agency_id">{{ it.agency.name_th }}</span>
            <span v-else-if="it.division_id">{{ it.division.name_th }}</span>
            <span v-else-if="it.bureau_id">{{ it.bureau.name_th }}</span>
            <span v-else-if="it.inspector_id">{{ it.inspector.name_th }}</span>
            <span v-else></span>
          </td>
          <td class="text-center">
            <span
              class="badge p-2 text-white"
              :style="`background-color: ${
                convertState(it.state_id).bg_color
              };`"
              >{{ convertState(it.state_id).name_th }}</span
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
              <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <li>
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleDetail({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >รายละเอียด</a
                  >
                </li>
                <li>
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleEdit({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >แก้ไขข้อมูล</a
                  >
                </li>

                <li>
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceive1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ฝรท. รับเรื่อง</a
                  >
                </li>

                <!-- <li>
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
                </li> -->
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
          :totalItems="paginationData.totalItems"
          :totalPage="paginationData.totalPage"
          :currentPage="paginationData.currentPage"
          @update:currentPage="updateCurrentPage"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, toRefs, ref } from "vue";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

// Import Pagination
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";

import useStateData from "@/composables/useStateData";

import ApiService from "@/core/services/ApiService";

export default defineComponent({
  name: "list-complaint",
  components: {
    BlogPagination,
  },
  props: {
    items: {
      type: Array as () => any[],
      required: true,
    },
    paginationData: {
      type: Object,
      required: true,
    },
  },
  setup(props, { emit }) {
    const { items } = toRefs(props);
    const { paginationData } = toRefs(props);
    const internalCurrentPage = ref(paginationData.value.currentPage);
    let { states } = useStateData();

    // fetch
    const prefix_names = ref([]);

    const fetchPrefixName = async (params: any) => {
      const { data } = await ApiService.query("prefix-name", {
        params: params,
      });

      prefix_names.value = data.data;
    };
    fetchPrefixName({});

    const handleDetail = (item: any) => {
      emit("detail", item);
    };

    const handleEdit = (item: any) => {
      emit("edit", item);
    };

    const handleReceive1 = (item: any) => {
      emit("receive1", item);
    };

    const convertDate = (date: any) => {
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    const convertState = (state: any) => {
      const findState = states.find((x: any) => x.id === state);
      return {
        name_th: findState.name_th,
        bg_color: findState.bg_color,
      };
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

            return `${prefix?.name_th}${x.firstname || ""} ${x.lastname || ""}`;
          })
          .join(", ");
      }
      return text;
    };

    const updateCurrentPage = (newPage: any) => {
      internalCurrentPage.value = newPage;
      emit("update:currentPage", newPage);
    };

    return {
      items,
      handleDetail,
      handleEdit,
      handleReceive1,
      convertDate,
      convertState,
      convertAccused,
      updateCurrentPage,
    };
  },
});
</script>

<style scoped>
.bg-sky {
  background-color: #d9f4fe;
}
</style>
