<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container p-lg-10 mt-5">
      <h2 class="mt-10 mb-5 text-black">ติดตามเรื่องร้องเรียน/แจ้งเบาะแส</h2>

      <div class="card">
        <div class="card-body bg-sky px-5 py-5 pt-10">
          <div class="div-search">
            <div class="mb-10">
              <h4 class="text-center">
                ระบุเลขที่ร้องเรียน/หมายเลขบัตรประชาชน/หนังสือเดินทาง
              </h4>
            </div>
            <div class="d-flex justify-content-center mb-7">
              <div
                class="form-check form-check-custom form-check-solid me-5 mb-2"
              >
                <input
                  class="form-check-input"
                  name="type_of_track"
                  type="radio"
                  value="1"
                  checked
                  v-model="search.type_of_track"
                  id="flexCheckboxLg"
                />
                <label class="form-check-label fs-5" for="flexCheckboxLg">
                  เลขที่ร้องเรียน
                </label>
              </div>
              <div class="form-check form-check-custom form-check-solid mb-2">
                <input
                  class="form-check-input"
                  name="type_of_track"
                  type="radio"
                  value="2"
                  v-model="search.type_of_track"
                  id="flexCheckboxLg"
                />
                <label class="form-check-label fs-5" for="flexCheckboxLg">
                  หมายเลขบัตรประชาชน/หนังสือเดินทาง
                </label>
              </div>
            </div>
            <div class="mb-7 d-flex justify-content-center">
              <input
                style="max-width: 600px"
                type="text"
                class="form-control"
                placeholder="เลขที่ร้องเรียน/หมายเลขบัตรประชาชน/หนังสือเดินทาง"
                aria-label="เลขที่ร้องเรียน/หมายเลขบัตรประชาชน/หนังสือเดินทาง"
                aria-describedby="basic-addon2"
                v-model="search.id_card_or_jcoms_no"
              />
            </div>
            <div class="d-flex justify-content-center">
              <button class="btn btn-bg-primary text-white" @click="onSearch">
                ค้นหา
              </button>
            </div>
          </div>
          <div class="separator my-10 mt-5"></div>

          <div class="row">
            <div class="col-md-12 mb-5">
              <h4>รายการเรื่องร้องเรียน/แจ้งเบาะแส</h4>
            </div>
            <div class="col-md-12 table-responsive">
              <Preloader :isLoading="isLoading" :position="'absolute'" />
              <ListComponent
                :items="items"
                :paginationData="paginationData"
                @update:currentPage="paginationData.currentPage = $event"
                @detail="
                (it: any) => {
                  Object.assign(item, it);
                  openDetailModal = true;
                }
              "
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div id="detail-modal">
      <!-- item.tracking_satisfaction == null ?
      //   onEvalModal() : ""  -->
      <DetailPage
        v-if="
          openDetailModal == true &&
          item.id != null &&
          item.complainant_id != null
        "
        :complaint_id="item.id"
        :complainant_id="item.complainant_id"
        @update-tracking-satisfaction="(event: any) => {
              item.tracking_satisfaction = event
          }"
        @close-modal="
          () => {
            openDetailModal = false;
            onEvalModal();
          }
        "
      />
    </div>

    <div id="otp-before-fetch-complaint">
      <Otp
        v-if="openOtpModal"
        :request_otp="request_otp"
        @close-otp-modal="
          () => {
            openOtpModal = false;
          }
        "
        @fetch-complaint="fetchItems"
      />
    </div>

    <!-- Modal Evaluate -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="evalModalRef"
      id="eval-modal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">
              ขอบคุณสำหรับการใช้งานระบบร้องเรียน/แจ้งเบาะแส
            </h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-md-12 text-center mt-3">
                <div class="mb-3">โปรดคลิกที่ EMOJI <br>เพื่อให้คะแนนความพึงพอใจการใช้งานระบบ</div>
                <div class="text-center mx-auto">
                  <span
                    v-for="(emoji, index) in emojis"
                    :key="index"
                    @click="setRating(index + 1)"
                    class="rating-emoji"
                  >
                    {{ emoji }}
                  </span>
                </div>
                <div>
                  <h4>{{ rating_text }}</h4>
                </div>
                <!--  -->
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-12 text-center mt-5">
                <button
                  class="btn btn-success"
                  @click="onEvalConfirm"
                  :disabled="rating > 0 ? false : true"
                >
                  ตกลง
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!--end::Wrapper-->

    <div id="captcha">
      <!-- first_action -->
      <Captcha
        v-if="captcha_modal"
        @close-captcha-modal="
          () => {
            captcha_modal = false;
          }
        "
      />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, reactive, watch } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// Import Modal Bootstrap
import { Modal } from "bootstrap";

// Composable
import useToast from "@/composables/useToast";
// Component
import Preloader from "@/components/preloader/Preloader.vue";
import Otp from "@/components/tracking/Otp.vue";
import ListComponent from "@/components/tracking/List.vue";
import DetailPage from "@/views/tracking/DetailModal.vue";
import Captcha from "@/components/tracking/Captcha.vue";

export default defineComponent({
  name: "tracking",
  components: {
    dayjs,
    Otp,
    ListComponent,
    DetailPage,
    Preloader,
    Captcha,
  },
  setup() {
    // UI
    const isLoading = ref<any>(false);
    const openOtpModal = ref(false);
    const openDetailModal = ref(false);
    const evalModalRef = ref<any>(null);
    const evalModalObj = ref<any>(null);
    const captcha_modal = ref(false);

    const checkComplainantUUID = ref(null);
    const request_otp = reactive<any>({
      jcoms_no: undefined,
      id_card: undefined,
      phone_number_show: undefined,
    });
    // Variable

    const rating = ref(0);
    const rating_text = ref("");
    const setRating = (value) => {
      rating.value = value;
      if (value == 1) {
        rating_text.value = "ไม่พอใจมาก";
      }
      if (value == 2) {
        rating_text.value = "ไม่พอใจ";
      }
      if (value == 3) {
        rating_text.value = "พอใช้";
      }
      if (value == 4) {
        rating_text.value = "พึงพอใจ";
      }
      if (value == 5) {
        rating_text.value = "พึงพอใจมาก";
      }
      console.log("Selected rating:", value);
    };

    // const rating = ref(0);
    const search = reactive({ type_of_track: 1, id_card_or_jcoms_no: "" });
    const items = reactive<any>([]);
    const item = ref({
      id: null,
      complainant_id: null,
      tracking_satisfaction: null,
    });

    // const setRating = (rate: number) => {
    //   rating.value = rate;
    // };

    const paginationData = reactive<any>({
      perPage: 20,
      currentPage: 1,
      totalPage: 1,
      totalItems: 0,
    });

    // Fetch
    const fetchItems = async (complainant_uuid: any) => {
      isLoading.value = true;

      await ApiService.query("complaint/get-complaint-by-otp", {
        params: {
          complainant_uuid: complainant_uuid,
          perPage: paginationData.perPage,
          currentPage: paginationData.currentPage,
          orderBy: "created_at",
          order: "desc",
        },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          items.length = 0;
          Object.assign(items, data.data);
          paginationData.totalPage = data.totalPage;
          paginationData.totalItems = data.totalData;
          paginationData.currentPage = data.currentPage;

          checkComplainantUUID.value = getComplainantUUIDWithExpiry();
          isLoading.value = false;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Event
    const onSearch = async () => {
      if (
        search.type_of_track == null ||
        search.id_card_or_jcoms_no == null ||
        search.id_card_or_jcoms_no == ""
      ) {
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return;
      }

      Object.assign(items, []);

      Object.assign(request_otp, {
        jcoms_no: undefined,
        id_card: undefined,
        phone_number: undefined,
        phone_number_show: undefined,
      });

      if (search.type_of_track == 1) {
        request_otp.jcoms_no = search.id_card_or_jcoms_no;
      } else if (search.type_of_track == 2) {
        request_otp.id_card = search.id_card_or_jcoms_no;
      } else if (search.type_of_track == 3) {
        request_otp.phone_number_show = search.id_card_or_jcoms_no;
      } else {
        useToast("พบข้อผิดพลาด", "error");
        return;
      }

      // Generate a random string of 4 English characters
      await ApiService.post("complaint/get-phonenumber", {
        ...request_otp,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          request_otp.phone_number_show = data.data.phone_number;
          openOtpModal.value = true;
        })
        .catch(({ response }) => {
          useToast("ไม่พบข้อมูล", "error");
          console.log(response);
        });
    };

    const getComplainantUUIDWithExpiry = () => {
      const itemStr = localStorage.getItem("complainant_uuid");
      // ถ้าข้อมูลไม่มีใน LocalStorage
      if (!itemStr) {
        return null;
      }
      const item = JSON.parse(itemStr);
      const now = new Date();

      // ตรวจสอบเวลาหมดอายุ
      if (now.getTime() > item.expiry) {
        // ถ้าหมดอายุแล้ว ให้ลบข้อมูลและคืนค่า null
        localStorage.removeItem("complainant_uuid");
        return null;
      }

      return item.value;
    };

    const onEvalModal = () => {
      //   if (item.value.tracking_satisfaction == null) {

      evalModalObj.value.show();

      //   }
    };

    const onEvalConfirm = async () => {
      // save Eval
      let eval_data = {
        tracking_satisfaction: rating.value,
        tracking_satisfaction_at: dayjs().format("YYYY-MM-DD HH:mm:ss"),
      };
      //   fetch

      await ApiService.post("complaint/" + item.value.id, eval_data)
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          evalModalObj.value.hide();
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Mounted
    onMounted(async () => {
      evalModalObj.value = new Modal(evalModalRef.value, {});
      checkComplainantUUID.value = getComplainantUUIDWithExpiry();
      if (checkComplainantUUID.value != null) {
        fetchItems(checkComplainantUUID.value);
      } else {
        captcha_modal.value = true;
      }
    });

    // Watch
    watch(
      () => paginationData.currentPage,
      () => {
        fetchItems(checkComplainantUUID.value);
      }
    );

    const emojis = ["😡", "😟", "😐", "😊", "😁"];

    return {
      search,
      item,
      items,
      request_otp,
      rating,
      paginationData,
      isLoading,
      onSearch,
      fetchItems,
      openDetailModal,
      openOtpModal,
      onEvalModal,
      onEvalConfirm,
      setRating,
      evalModalRef,
      evalModalObj,
      captcha_modal,
      emojis,
      rating_text,
    };
  },
});
</script>

<style>
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}
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

.bg-color-police {
  background-color: #800001;
}

.bg-sky {
  background-color: #d9f4fe;
}

.rating-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
.rating-emoji {
  font-size: 4rem;
  cursor: pointer;
  margin: 0 0.5rem;
}
</style>
