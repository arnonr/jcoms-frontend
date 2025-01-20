<template>
  <div>
    <table
      class="table table-bordered table-striped"
      style="width: 100%; background-color: #d9f4fe"
    >
      <thead class="bg-color-police">
        <tr>
          <th class="text-white">วันที่ร้องเรียน</th>
          <th class="text-white">ระยะเวลา (วัน)</th>
          <th class="text-white">รหัสคำร้อง</th>
          <th class="text-white">เลขรับ ฝรท.</th>
          <th class="text-white">ลักษณะความผิด</th>
          <th class="text-white">เรื่องร้องเรียน</th>
          <th class="text-white">ผู้ถูกร้อง</th>
          <th class="text-white">หน่วยงานถูกร้อง</th>
          <th class="text-white">สถานะเรื่องร้องเรียน</th>
          <th class="text-white">สถานะกองตรวจดำเนินการ</th>
          <th class="text-white">จัดการข้อมูล</th>
        </tr>
      </thead>
      <tbody v-if="items.length != 0">
        <tr v-for="(it, idx) in items" :key="idx">
          <td>
            {{ convertDate(it.created_at) }}
          </td>
          <td>
            {{ convertDueDate(it.forward_doc_date, it.due_day) }}
          </td>
          <td>{{ it.jcoms_no }}</td>
          <td>{{ it.receive_doc_no }}</td>

          <td>{{ it.topic_type?.name_th }}</td>
          <td>{{ it.complaint_title }}</td>
          <td>{{ convertAccused(it.accused) }}</td>
          <td>
            <div v-if="it.agency_id">
              <span>{{ it.agency.name_th_abbr }}</span>
            </div>
            <span v-else-if="it.division_id">{{
              it.division.name_th_abbr
            }}</span>
            <span v-else-if="it.bureau_id">{{ it.bureau.name_th_abbr }}</span>
            <span v-else-if="it.inspector_id">{{
              it.inspector.name_th_abbr
            }}</span>
            <span v-else></span>
          </td>
          <td>
            <span
              class="badge p-2 text-black"
              :style="`background-color: ${
                convertState(it.state_id).bg_color
              };`"
              >{{ convertState(it.state_id).name_th }}</span
            >
          </td>

          <td>
            <span
              class="badge p-2 text-black"
              :style="`background-color: ${
                convertInspectorState(it.inspector_state_id).bg_color
              };`"
              >{{ convertInspectorState(it.inspector_state_id).name_th }}</span
            >
          </td>

          <td>
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
                <li v-if="it.state_id != 17">
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleEdit({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    v-if="canUpdate"
                    >แก้ไขข้อมูล</a
                  >
                </li>

                <li v-if="it.state_id == 3">
                  <a
                    class="dropdown-item cursor-pointer"
                    v-if="userData.role_id == 1 || userData.role_id == 2"
                    @click="
                      handleSend1({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ฝรท. ส่งต่อเรื่อง บช./ภ.</a
                  >
                </li>

                <li v-if="it.state_id == 10">
                  <a
                    class="dropdown-item cursor-pointer"
                    v-if="userData.role_id == 1 || userData.role_id == 3"
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
                    v-if="userData.role_id == 1 || userData.role_id == 3"
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
                    v-if="userData.role_id == 1 || userData.role_id == 4"
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

                <li v-if="it.state_id == 20">
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 4"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSend3({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บก./ภ.จว. ส่งต่อเรื่อง</a
                  >
                </li>

                <li
                  v-if="
                    it.state_id == 20 || it.state_id == 12 || it.state_id == 29
                  "
                >
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 4"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveReport0({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บก./ภ.จว. รับรายงาน</a
                  >
                </li>

                <li
                  v-if="
                    it.state_id == 20 || it.state_id == 22 || it.state_id == 29
                  "
                >
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 4"
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
                    v-if="userData.role_id == 1 || userData.role_id == 3"
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
                    v-if="userData.role_id == 1 || userData.role_id == 3"
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
                    v-if="userData.role_id == 1 || userData.role_id == 3"
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
                    v-if="
                      userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5
                    "
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
                    v-if="
                      userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5
                    "
                    @click="
                      handleReturnReport2({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >จต. ส่งกล้บรายงาน</a
                  >
                </li>

                <li v-if="it.state_id != 17">
                  <a
                    class="dropdown-item cursor-pointer"
                    v-if="
                      userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5
                    "
                    @click="
                      handleSuccessReport({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >จต. ยุติเรื่อง</a
                  >
                </li>

                <li v-if="it.state_id != 17">
                  <a
                    class="dropdown-item cursor-pointer"
                    v-if="
                      userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5
                    "
                    @click="
                      handleSuccessAnotherReport({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ส่งเรื่องให้หน่วยอื่นดำเนินการ</a
                  >
                </li>

                <!--  -->
                <li v-if="it.inspector_state_id == null && it.state_id != 17">
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 2"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendToInspector({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ฝรท. ส่งต่อเรื่องกองตรวจราชการ</a
                  >
                </li>

                <li v-if="it.inspector_state_id == 1 && it.state_id != 17">
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 5"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveInspector({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >กองตรวจราชการรับเรื่อง
                  </a>
                </li>

                <!--  -->
                <li
                  v-if="
                    it.inspector_state_id > 1 &&
                    it.inspector_state_id != 9 &&
                    it.inspector_state_id != 10 &&
                    it.inspector_state_id != 14 &&
                    it.inspector_state_id != 4 &&
                    it.state_id != 17
                  "
                >
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 2"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendToCommissioner({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ส่งต่อเรื่องถึง ตร.</a
                  >
                </li>

                <li v-if="it.inspector_state_id == 9 && it.state_id != 17">
                  <a
                    v-if="userData.role_id == 1 || userData.role_id == 6"
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveCommissioner({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ตร. รับเรื่อง
                  </a>
                </li>
                <!--  -->

                <li
                  v-if="
                    it.state_id > 4 &&
                    it.state_id != 17 &&
                    it.state_id != 18 &&
                    it.inspector_state_id > 1 &&
                    (userData.role_id == 6 || userData.role_id == 1)
                  "
                >
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendCommissionerHurry({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >ผบ. ตร. เร่งรัดเรื่อง
                  </a>
                </li>

                <li
                  v-if="
                    it.state_id > 4 &&
                    it.state_id != 17 &&
                    it.state_id != 18 &&
                    it.inspector_state_id > 1 &&
                    (userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5)
                  "
                >
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendHurry({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >เร่งรัดเรื่อง
                  </a>
                </li>

                <li
                  v-if="
                    it.inspector_state_id == 3 &&
                    it.state_id != 17 &&
                    (userData.role_id == 1 || userData.role_id == 3)
                  "
                >
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleReceiveHurry({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. รับเรื่องติดตาม
                  </a>
                </li>

                <li
                  v-if="
                    (it.state_id == 10 ||
                      it.state_id == 11 ||
                      it.state_id == 15 ||
                      it.state_id == 19 ||
                      it.state_id == 20 ||
                      it.state_id == 23 ||
                      it.state_id == 28 ||
                      it.state_id == 29 ||
                      it.state_id == 30) &&
                    it.inspector_state_id != 6 &&
                    (userData.role_id == 1 || userData.role_id == 3)
                  "
                >
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleSendExtend({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >บช./ภ. ขยายเวลา
                  </a>
                </li>

                <li
                  v-if="
                    it.inspector_state_id == 6 &&
                    (userData.role_id == 1 ||
                      userData.role_id == 2 ||
                      userData.role_id == 5)
                  "
                >
                  <a
                    class="dropdown-item cursor-pointer"
                    @click="
                      handleApproveExtend({
                        id: it.id,
                        complainant_id: it.complainant_id,
                      })
                    "
                    >อนุมัติการขยายเวลา
                  </a>
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
import { defineComponent, toRefs, ref, computed } from "vue";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);
import { useAbility } from "@casl/vue";

// Import Pagination
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";

import useStateData from "@/composables/useStateData";
import useInspectorStateData from "@/composables/useInspectorStateData";

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
    let { inspector_states } = useInspectorStateData();
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    // fetch
    const prefix_names = ref([]);
    const complaint_types = ref([]);

    const ability = useAbility();

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

    const fetchPrefixName = async (params: any) => {
      const { data } = await ApiService.query("prefix-name", {
        params: params,
      });

      prefix_names.value = data.data;
    };
    fetchPrefixName({ perPage: 500 });

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

    const handleSendToInspector = (item: any) => {
      emit("sendToInspector", item);
    };

    const handleSendToCommissioner = (item: any) => {
      emit("sendToCommissioner", item);
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

    const handleSend3 = (item: any) => {
      emit("send3", item);
    };

    const handleSendReport1 = (item: any) => {
      emit("sendReport1", item);
    };

    const handleSendReport2 = (item: any) => {
      emit("sendReport2", item);
    };

    const handleReceiveReport0 = (item: any) => {
      emit("receiveReport0", item);
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

    const handleReceiveInspector = (item: any) => {
      emit("receiveInspector", item);
    };

    const handleReceiveCommissioner = (item: any) => {
      emit("receiveCommissioner", item);
    };

    const handleSendHurry = (item: any) => {
      emit("sendHurry", item);
    };

    const handleSendCommissionerHurry = (item: any) => {
      emit("sendCommissionerHurry", item);
    };

    const handleReceiveHurry = (item: any) => {
      emit("receiveHurry", item);
    };

    const handleSendExtend = (item: any) => {
      emit("sendExtend", item);
    };

    const handleApproveExtend = (item: any) => {
      emit("approveExtend", item);
    };

    const handleSuccessAnotherReport = (item: any) => {
      emit("successAnotherReport", item);
    };

    const convertDate = (date: any) => {
      return dayjs(date).utc().locale("th").format("DD MMM BBBB");
    };

    const convertState = (state: any) => {
      const findState = states.find((x: any) => x.id === state);
      return {
        name_th: findState?.name_th,
        bg_color: findState?.bg_color,
      };
    };

    const convertInspectorState = (inspector_state: any) => {
      const findInspectorState = inspector_states.find(
        (x: any) => x.id === inspector_state
      );
      return {
        name_th: findInspectorState?.name_th,
        bg_color: findInspectorState?.bg_color,
      };
    };

    const convertDueDate = (date: any, due_day: any) => {
      if (date == null) {
        return "";
      }

      //   const findComplaintType: any = complaint_types.value.find(
      //     (x: any) => x.id === complaint_type_id
      //   );

      let count_day = dayjs().diff(dayjs(date), "day");

      //   let _day = findComplaintType?.due_date - count_day;
      //   findComplaintType.due_date

      //   วันครบกำหนด
      //   date + findComplaintType.due_date;
      //   dayjs() - date ใช้ไปกี่วัน 5 วัน
      //   เหลือกี่ วันเอา
      //   findComplaintType.due_date;

      return count_day + "/" + due_day;
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

            let prefix_name = "";
            if (prefix && prefix.name_th_abbr !== "ไม่ระบุ") {
              prefix_name = prefix.name_th_abbr || ""; // กำหนดค่าเริ่มต้น
            }

            // คืนค่า firstname และ lastname พร้อม fallback
            const firstname = x.firstname || "";
            const lastname = x.lastname || "";

            return `${prefix_name}${firstname} ${lastname}`.trim();
          })
          .filter((name: string) => name !== "") // กรองค่าที่ว่างออก
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
      handleSend3,
      handleReceive3,
      convertDate,
      convertState,
      convertInspectorState,
      convertAccused,
      convertDueDate,
      updateCurrentPage,
      handleSendReport1,
      handleSendReport2,
      handleReceiveReport1,
      handleReceiveReport2,
      handleReceiveReport0,
      handleSuccessReport,
      handleSuccessAnotherReport,
      handleReturnReport1,
      handleReturnReport2,
      handleSendToInspector,
      handleReceiveInspector,
      handleSendHurry,
      handleReceiveHurry,
      handleSendExtend,
      handleApproveExtend,
      userData,
      handleSendToCommissioner,
      handleReceiveCommissioner,
      handleSendCommissionerHurry,
      canView,
      canCreate,
      canUpdate,
      canDelete,
      canExport,
    };
  },
});
</script>
