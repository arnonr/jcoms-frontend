<template>
  <div>
    <!-- Modal OTP -->
    <div
      class="modal fade"
      tabindex="-1"
      ref="otpConfirmModalRef"
      id="otp-confirm-modal"
      data-bs-backdrop="static"
      data-bs-keyboard="false"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">ยืนยันการร้องเรียน/แจ้งเบาะแสด้วย SMS</h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <label for="otp_data_phone" class="required form-label"
                >หมายเลขโทรศัพท์</label
              >
              <div class="mb-7 col-12 col-lg-12 d-flex">
                <input
                  type="text"
                  disabled
                  class="form-control me-2"
                  placeholder="หมายเลขโทรศัพท์"
                  aria-label="หมายเลขโทรศัพท์"
                  v-model="item.phone_number"
                />

                <button
                  class="btn btn-success"
                  @click="onSendOTP"
                  :disabled="btnSendOtpDisabled"
                >
                  ส่ง OTP
                  {{
                    btnSendOtpDisabled == true
                      ? "(" + (otpCountdown - 60) + ")"
                      : ""
                  }}
                </button>
              </div>
              <hr />
              <div class="mb-7 col-12 col-lg-12">
                <label for="otpData_code" class="required form-label">
                  รหัส OTP ที่คุณได้รับทาง SMS จะหมดอายุภายใน
                  <span class="text-primary">{{
                    otpCountdown > 0 ? otpCountdown + " วินาที" : "หมดเวลา"
                  }}</span
                  ><br />
                  <span> (Ref: {{ otp_secret_key }})</span>
                </label>
                <input
                  type="text"
                  class="form-control"
                  placeholder="รหัส OTP"
                  aria-label="รหัส OTP"
                  v-model="otpDataCheck.code"
                />
                <span class="text-danger mt-2" :class="[otpWrong]"
                  >รหัส OTP ไม่ถูกต้อง</span
                >
              </div>
              <div class="col-12 col-lg-12 text-center">
                <button
                  class="btn btn-primary"
                  @click="onConfirmOTP"
                  :disabled="btnConfirmOtpDisabled"
                >
                  ยืนยัน
                </button>
                <button class="btn btn-secondary ms-3" @click="onCancel">
                  ยกเลิก
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
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
            <h3 class="modal-title">ขอบคุณสำหรับการร้องเรียน/แจ้งเบาะแส</h3>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-md-12 text-center">
                <span>สำนักงานจเรตำรวจได้รับคำร้องของท่านเรียบร้อยแล้ว</span
                ><br />
                <span>เลขคำร้องของท่าน (JCOM No.) : </span><br />
                <span class="fst-italic fs-3 text-success">{{
                  result_complaint.jcoms_no
                }}</span
                ><br />
                <span>ท่านสามารถตรวจสอบสถานะคำร้องได้ที่ : </span><br />
                <span class="fst-italic"
                  >{{ APP_BASE_URL }}/jcoms/tracking</span
                >
                <div class="separator separator-dotted my-2"></div>
              </div>
              <div class="col-md-12 text-center mt-3">
                <div class="mb-3">โปรดให้คะแนนความพึงพอใจการใช้งานระบบ</div>
                <div class="text-center mx-auto">
                  <star-rating
                    class="justify-content-center"
                    :glow="10"
                    :rounded-corners="true"
                    @update:rating="setRating"
                    :star-points="[
                      23, 2, 14, 17, 0, 19, 10, 34, 7, 50, 23, 43, 38, 50, 36,
                      34, 46, 19, 31, 17,
                    ]"
                  ></star-rating>
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
  </div>
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref, onMounted, onUnmounted, watch } from "vue";
import { useOTPStore, type Otp } from "@/stores/otp";
import type { PropType } from "vue";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Axios
import axios from "axios";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Import Dayjs
import dayjs from "dayjs";
// Import Rating
import StarRating from "vue-star-rating";
import { useRouter } from "vue-router";
import ApiService from "@/core/services/ApiService";
// Use Toast Composables
import useToast from "@/composables/useToast";

interface accused_itf {
  id: any;
  prefix_name_id: any;
  firstname: any;
  lastname: any;
  position_id: any;
  section_id: any;
  agency_id: any;
  inspector_id: any;
  bureau_id: any;
  division_id: any;
  complaint_id: any;
  type: any;
  detail: any;
  organization_all: any;
  // other properties
}

export default defineComponent({
  name: "otp",
  props: {
    item: {
      type: Object,
      required: true,
    },
    complaint_item: {
      type: Object,
      required: true,
    },
    complant_type: {
      type: Object,
      required: true,
    },
    accused: {
      type: Array as PropType<accused_itf[]>,
      required: true,
    },
    r: {
      type: String,
      required: true,
    },
    is_complainant_old: {
      type: Boolean,
      required: true,
    },
  },
  components: { StarRating },
  setup(props, context) {
    // Variable
    const router = useRouter();
    const emit = context.emit;

    const store = useOTPStore();
    const otpData = ref<any>({
      phone: "",
      code: "",
    });
    const otpDataCheck = ref<any>({
      phone: "",
      code: "",
    });

    const otp_secret_key = ref<any>(null);
    const rating = ref(0);
    const result_complaint = ref<any>({
      complainant_id: null,
      complaint_id: null,
      jcoms_no: "",
    });

    let loadingTimeout = ref(30000);
    const otpConfirmModalRef = ref<any>(null);
    const otpConfirmModalObj = ref<any>(null);
    const btnSendOtpDisabled = ref<any>(false);
    const btnConfirmOtpDisabled = ref<any>(true);
    const otpCountdown = ref<any>(0);
    const otpWrong = ref<any>("d-none");

    const evalModalRef = ref<any>(null);
    const evalModalObj = ref<any>(null);

    // Event
    const onOTPModal = () => {
      otpConfirmModalObj.value.show();
    };

    const getRandomEnglishCharacter = () => {
      const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      const randomIndex = Math.floor(Math.random() * characters.length);
      return characters.charAt(randomIndex);
    };

    const generateRandomEnglishString = (length: any) => {
      let result = "";

      for (let i = 0; i < length; i++) {
        const randomChar = getRandomEnglishCharacter();
        result += randomChar;
      }

      return result;
    };

    const onSendOTP = async () => {
      // generate otp แล้วเก็บใน storage
      otpWrong.value = "d-none";

      otp_secret_key.value = generateRandomEnglishString(4);

      let api_1 = {
        type: "post",
        url: "sms/send-otp",
      };

      await ApiService[api_1.type](api_1.url, {
        phone_number: props.item.phone_number,
        otp_secret: otp_secret_key.value,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          otpCountdown.value = 120;
          btnSendOtpDisabled.value = true;
          btnConfirmOtpDisabled.value = false;
        })
        .catch(({ response }) => {
          console.log(response);
        });

      //   Send otp backend
    };

    const onConfirmOTP = async () => {
      btnConfirmOtpDisabled.value = true;

      let api_2 = {
        type: "post",
        url: "sms/verify-otp",
      };

      await ApiService[api_2.type](api_2.url, {
        otp: otpDataCheck.value.code,
        otp_secret: otp_secret_key.value,
        phone_number: props.item.phone_number,
      })
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          try {
            await onSaveComplainant();
            await onSaveComplaint();
            await onSaveAccused();

            Swal.fire({
              text: "ยืนยัน OTP สำเร็จ",
              icon: "success",
              buttonsStyling: false,
              confirmButtonText: "ตกลง",
              heightAuto: false,
              customClass: {
                confirmButton: "btn fw-semibold btn-light-primary",
              },
            }).then(() => {
              // Save Complaint and Send SMS
              otpConfirmModalObj.value.hide();
              otpWrong.value = "d-none";
              onEvalModal();
            });
          } catch (error) {
            btnConfirmOtpDisabled.value = false;
            console.error("Error saving data:", error);
          }
        })
        .catch(({ response }) => {
          btnConfirmOtpDisabled.value = false;
          otpWrong.value = "d-block";
          useToast("OTP ไม่ถูกต้อง", "error");
          console.log(response);
        });
    };

    const onSaveComplainant = async () => {
      //
      let data_complainant_item = {
        card_photo:
          props.item.card_photo != null ? props.item.card_photo : null,
        card_type: props.item.card_type ? props.item.card_type.value : null,
        id_card: props.item.id_card,
        prefix_name_id: props.item.prefix_name_id
          ? props.item.prefix_name_id.id
          : null,
        firstname: props.item.firstname,
        lastname: props.item.lastname,
        birthday: props.item.birthday
          ? dayjs(props.item.birthday).format("YYYY-MM-DD")
          : "",
        occupation_id: null,
        occupation_text: props.item.occupation_text,
        phone_number: props.item.phone_number,
        email: props.item.email,
        line_id: props.item.line_id,
        house_number: props.item.house_number,
        building: props.item.building,
        moo: props.item.moo,
        soi: props.item.soi,
        road: props.item.road,
        postal_code: props.item.postal_code,
        sub_district_id: props.item.sub_district_id,
        district_id: props.item.district_id,
        province_id: props.item.province_id,
        // complainant_type : null
        complainant_type: props.complant_type.id == 4 ? 2 : 1,
        position_id: props.complant_type.id == 4 ? null : null,
        section_id: props.complant_type.id == 4 ? null : null,
        inspection_id: props.complant_type.id == 4 ? null : null,
        bureau_id: props.complant_type.id == 4 ? null : null,
        division_id: props.complant_type.id == 4 ? null : null,
        agency_id: props.complant_type.id == 4 ? null : null,
        created_by: props.item.firstname + " " + props.item.lastname,
        updated_by: props.item.firstname + " " + props.item.lastname,
        // รุป
      };

      let api = {
        type: "postFormData",
        url: "complainant/",
        textToast: "เพิ่มข้อมูลเสร็จสิ้น",
      };

      if (props.is_complainant_old == true) {
        api = {
          type: "putFormData",
          url: "complainant/" + props.item.id,
          textToast: "แก้ไขข้อมูลเสร็จสิ้น",
        };
      }
      await ApiService[api.type](api.url, data_complainant_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          //   await
          result_complaint.value.complainant_id = data.id;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onSaveComplaint = async () => {
      console.log(props.complaint_item);

      let date_time = <any>null;
      if (props.complaint_item.incident_date) {
        date_time = dayjs(props.complaint_item.incident_date);

        if (props.complaint_item.incident_time) {
          date_time = date_time.set(
            "hour",
            props.complaint_item.incident_time.hours
          );
          date_time = date_time.set(
            "minute",
            props.complaint_item.incident_time.minutes
          );
        }

        date_time = date_time.format("YYYY-MM-DD HH:mm:ss");
      }
      let data_item = {
        complaint_type_id:
          props.complaint_item.complaint_topic.complaint_type_id,
        complainant_id: result_complaint.value.complainant_id,
        is_anonymous: props.complaint_item.is_anonymous, //props.complaint_item.is_anonymous.value,
        complaint_title: props.complaint_item.complaint_title,
        complaint_detail: props.complaint_item.complaint_detail,
        complaint_channel_ids: props.complaint_item.complaint_channel_all
          ? props.complaint_item.complaint_channel_all.reverse().join(",")
          : undefined,
        incident_date: props.complaint_item.incident_date
          ? dayjs(props.complaint_item.incident_date).format("YYYY-MM-DD")
          : null,
        incident_datetime: date_time,
        // incident_time: props.complaint_item.incident_time
        //   ? props.complaint_item.incident_time.hours +
        //     ":" +
        //     props.complaint_item.incident_time.minutes +
        //     ":00"
        //   : null,
        location_coordinates: props.complaint_item.location_coordinates,
        incident_location: props.complaint_item.incident_location,
        day_time: props.complaint_item.day_time.value,
        complaint_channel_id: props.complaint_item.complaint_channel_id.id,
        inspector_id: props.complaint_item.inspector_id,
        bureau_id: props.complaint_item.bureau_id,
        division_id: props.complaint_item.division_id,
        agency_id: props.complaint_item.agency_id,

        topic_type_id: props.complaint_item.complaint_topic.topic_type_id,

        topic_category_id:
          props.complaint_item.complaint_topic.topic_category_id,

        house_number: "",
        building: "",
        moo: "",
        soi: "",
        road: "",
        postal_code: props.item.postal_code,
        sub_district_id: props.complaint_item.sub_district_id,
        district_id: props.complaint_item.district_id,
        province_id: props.complaint_item.province_id,
        state_id: 1,
        secret_key: props.r,
        created_by: props.item.firstname + " " + props.item.lastname,
      };

      let api = {
        type: "post",
        url: "complaint/",
        textToast: "เพิ่มข้อมูลเสร็จสิ้น",
      };

      await ApiService[api.type](api.url, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          result_complaint.value.complaint_id = data.id;
          result_complaint.value.jcoms_no = data.jcoms_no;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onSaveAccused = async () => {
      for (let i = 0; i < props.accused.length; i++) {
        let data_accused_item = {
          prefix_name_id: props.accused[i].prefix_name_id
            ? props.accused[i].prefix_name_id.id
            : null,
          firstname: props.accused[i].firstname,
          lastname: props.accused[i].lastname,

          position_id: props.accused[i].position_id,
          section_id: props.accused[i].section_id,

          inspector_id: props.accused[i].inspector_id,
          bureau_id: props.accused[i].bureau_id,
          division_id: props.accused[i].division_id,
          agency_id: props.accused[i].agency_id,
          complaint_id: result_complaint.value.complaint_id,
          type: 2, //ประเภทผ้ถูกกล่าวหา props.accused[i],
          detail: "",
          created_by: props.item.firstname,
        };

        let api = {
          type: "post",
          url: "accused/",
          textToast: "เพิ่มข้อมูลเสร็จสิ้น",
        };

        await ApiService[api.type](api.url, data_accused_item)
          .then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
          });
        // fetch
      }
    };

    const onFetchComplaint = async () => {
      let api = {
        type: "get",
        url: "complaint/",
      };

      await ApiService[api.type](api.url + result_complaint.value.complaint_id)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          result_complaint.value.jcoms_no = data.jcoms_no;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // const onSaveComplaintChannel = async () => {
    //   for (
    //     let i = 0;
    //     i < props.complaint_item.complaint_channel_all.length;
    //     i++
    //   ) {
    //     let data_complaint_channel_history_item = {
    //       complaint_id: result_complaint.value.complaint_id,
    //       complaint_channel_id: props.complaint_item.complaint_channel_all[i],
    //       description: "",
    //       can_input: "",
    //       created_at: props.item.firstname,
    //     };

    //     // fetch
    //     console.log(data_complaint_channel_history_item);

    //     let api = {
    //       type: "post",
    //       url: "complaint-channel-history/",
    //       textToast: "เพิ่มข้อมูลเสร็จสิ้น",
    //     };

    //     await ApiService[api.type](api.url, data_complaint_channel_history_item)
    //       .then(({ data }) => {
    //         if (data.msg != "success") {
    //           throw new Error("ERROR");
    //         }
    //       })
    //       .catch(({ response }) => {
    //         console.log(response);
    //       });
    //   }
    // };

    const onCancel = () => {
      otpConfirmModalObj.value.hide();
      otpWrong.value = "d-none";
      emit("close-otp-modal");
    };

    const onEvalModal = () => {
      evalModalObj.value.show();
    };

    const onEvalConfirm = async () => {
      // save Eval
      let eval_data = {
        complaint_satisfaction: rating.value,
        complaint_satisfaction_at: dayjs().format("YYYY-MM-DD HH:mm:ss"),
      };
      //   fetch
      let api = {
        type: "post",
        url: "complaint/",
        textToast: "แก้ไขข้อมูลเสร็จสิ้น",
      };

      await ApiService[api.type](
        api.url + result_complaint.value.complaint_id,
        eval_data
      )
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          otpConfirmModalObj.value.hide();
          evalModalObj.value.hide();
          useToast("ร้องเรียนเสร็จสิ้น", "success");
          emit("close-otp-modal");

          let api_sms = {
            type: "post",
            url: "sms/send-sms/",
          };

          await ApiService[api_sms.type](api_sms.url, {
            msisdn: otpData.value.phone,
            message: `สำนักงานจเรตำรวจได้รับคำร้องของท่านรียบร้อยแล้ว เลขคำร้องของท่าน (JCOM No.) : ${
              result_complaint.jcoms_no
            } ท่านสามารถตรวจสอบสถานะคำร้องได้ที่ : ${
              import.meta.env.VITE_APP_BASE_URL
            }/jcoms/tracking`,
          })
            .then(({ data }) => {
              if (data.msg != "success") {
                throw new Error("ERROR");
              }

              setTimeout(() => {
                router.push({ name: "home" });
              }, 1000);
            })
            .catch(({ response }) => {
              console.log(response);
            });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Mounted
    onMounted(() => {
      otpConfirmModalObj.value = new Modal(otpConfirmModalRef.value, {});
      onOTPModal();
      evalModalObj.value = new Modal(evalModalRef.value, {});
    });

    onUnmounted(() => {
      otpConfirmModalObj.value.hide();
      evalModalObj.value.hide();
    });

    // Watch
    watch(
      otpCountdown,
      (value: any) => {
        if (value > 0) {
          setTimeout(() => {
            otpCountdown.value = otpCountdown.value - 1;
          }, 1000);
        } else {
          btnConfirmOtpDisabled.value = true;
        }

        if (value < 60 && btnSendOtpDisabled.value == true) {
          btnSendOtpDisabled.value = false;
        }
      },
      { immediate: true }
    );

    // watch(rating.value, (value: any) => {});

    const setRating = (rate: number) => {
      rating.value = rate;
    };

    // Return
    return {
      loadingTimeout,
      otpConfirmModalRef,
      otpConfirmModalObj,
      otpData,
      otpDataCheck,
      btnSendOtpDisabled,
      btnConfirmOtpDisabled,
      otpCountdown,
      otpWrong,
      evalModalRef,
      evalModalObj,
      rating,
      setRating,
      APP_BASE_URL: import.meta.env.VITE_APP_BASE_URL,
      otp_secret_key,
      onOTPModal,
      onSendOTP,
      onConfirmOTP,
      onCancel,
      onEvalModal,
      onEvalConfirm,
      result_complaint,
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
</style>
