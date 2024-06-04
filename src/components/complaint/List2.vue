<template>
  <div>
    <table
      class="table table-bordered table-striped"
      style="width: 100%; background-color: #d9f4fe"
    >
      <thead class="bg-color-police">
        <tr>
          <th class="text-center text-white">วันที่ร้องเรียน</th>
          <th class="text-center text-white">ระยะเวลา (วัน)</th>
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
          <td class="text-center">
            {{ convertDueDate(it.forward_doc_date, it.complaint_type_id) }}
          </td>
          <td class="text-center">{{ it.jcoms_no }}</td>

          <td class="text-center">{{ it.topic_type?.name_th }}</td>
          <td>{{ it.complaint_title }}</td>
          <td>{{ convertAccused(it.accused) }}</td>
          <td>
            <div v-if="it.agency_id">
              <span>{{ it.agency.name_th }}</span>
            </div>
            <span v-else-if="it.division_id">{{ it.division.name_th }}</span>
            <span v-else-if="it.bureau_id">{{ it.bureau.name_th }}</span>
            <span v-else-if="it.inspector_id">{{ it.inspector.name_th }}</span>
            <span v-else></span>
          </td>
          <td class="text-center">
            <span
              class="badge p-2 text-black"
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

                <li v-if="it.state_id == 3">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSend1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ฝรท. ส่งต่อเรื่อง</a
                  >
                </li>

                <li v-if="it.state_id == 10">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceive2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. รับเรื่อง</a
                  >
                </li>

                <li v-if="it.state_id == 19">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSend2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. ส่งต่อเรื่อง</a
                  >
                </li>

                <li v-if="it.state_id == 11">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceive3({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บก./ภ.จว. รับเรื่อง</a
                  >
                </li>

                <li v-if="it.state_id == 20 || it.state_id == 29">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendReport1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บก./ภ.จว. ส่งรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 15">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveReport1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. รับรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 15 || it.state_id == 23">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReturnReport1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. ส่งกล้บรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 23 || it.state_id == 30">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendReport2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. ส่งรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 16">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveReport2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >จต. รับรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 24 || it.state_id == 16">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReturnReport2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >จต. ส่งกล้บรายงาน</a
                  >
                </li>

                <li v-if="it.state_id == 24">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSuccessReport({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >จต. ปิดเรื่อง</a
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
  name: "list-complaint-2",
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
    const complaint_types = ref([]);

    const fetchPrefixName = async (params: any) => {
      const { data } = await ApiService.query("prefix-name", {
        params: params,
      });

      prefix_names.value = data.data;
    };
    fetchPrefixName({});

    const fetchComplaintType = async (params: any) => {
      const { data } = await ApiService.query("complaint-type", {
        params: params,
      });

      complaint_types.value = data.data;
    };
    fetchComplaintType({ perPage: 100000 });

    const handleDetail = (item: any) => {
      emit("detail", item);
    };

    const handleEdit = (item: any) => {
      emit("edit", item);
    };

    const handleSend1 = (item: any) => {
      emit("send1", item);
    };

    const handleReceive2 = (item: any) => {
      emit("receive2", item);
    };

    const handleReceive3 = (item: any) => {
      emit("receive3", item);
    };

    const handleSend2 = (item: any) => {
      emit("send2", item);
    };

    const handleSendReport1 = (item: any) => {
      emit("sendReport1", item);
    };

    const handleSendReport2 = (item: any) => {
      emit("sendReport2", item);
    };

    const handleReceiveReport1 = (item: any) => {
      emit("receiveReport1", item);
    };

    const handleReceiveReport2 = (item: any) => {
      emit("receiveReport2", item);
    };

    const handleSuccessReport = (item: any) => {
      emit("successReport", item);
    };

    const handleReturnReport1 = (item: any) => {
      emit("returnReport1", item);
    };

    const handleReturnReport2 = (item: any) => {
      emit("returnReport2", item);
    };

    const convertDate = (date: any) => {
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    const convertState = (state: any) => {
      const findState = states.find((x: any) => x.id === state);
      return {
        name_th: findState?.name_th,
        bg_color: findState?.bg_color,
      };
    };

    const convertDueDate = (date: any, complaint_type_id: any) => {
      if (date == null) {
        return "";
      }

      const findComplaintType: any = complaint_types.value.find(
        (x: any) => x.id === complaint_type_id
      );

      let count_day = dayjs().diff(dayjs(date), "day");
    //   let _day = findComplaintType?.due_date - count_day;
    //   console.log(complaint_types.value)
      //   findComplaintType.due_date

      //   วันครบกำหนด
      //   date + findComplaintType.due_date;
      //   dayjs() - date ใช้ไปกี่วัน 5 วัน
      //   เหลือกี่ วันเอา
      //   findComplaintType.due_date;

      return count_day;
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

    const updateCurrentPage = (newPage: any) => {
      internalCurrentPage.value = newPage;
      emit("update:currentPage", newPage);
    };

    return {
      items,
      handleDetail,
      handleEdit,
      handleSend1,
      handleReceive2,
      handleSend2,
      handleReceive3,
      convertDate,
      convertState,
      convertAccused,
      convertDueDate,
      updateCurrentPage,
      handleSendReport1,
      handleSendReport2,
      handleReceiveReport1,
      handleReceiveReport2,
      handleSuccessReport,
      handleReturnReport1,
      handleReturnReport2,
    };
  },
});
</script>
