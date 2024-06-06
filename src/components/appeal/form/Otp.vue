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
                  v-model="complainant_item.phone_number"
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
import {
  defineComponent,
  ref,
  onMounted,
  onUnmounted,
  watch,
  toRefs,
} from "vue";
import ApiService from "@/core/services/ApiService";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Import Dayjs
import dayjs from "dayjs";
// Import Rating
import StarRating from "vue-star-rating";
// Use Toast Composables
import useToast from "@/composables/useToast";

import { useRouter } from "vue-router";

export default defineComponent({
  name: "otp",
  props: {
    complainant_item: {
      type: Object,
      required: true,
    },
    complaint_item: {
      type: Object,
      required: true,
    },
    complaint_type: {
      type: Object,
      required: true,
    },
    accused: {
      type: Array as () => any[],
      required: true,
    },
    r: {
      type: String,
      required: true,
    },
  },
  components: { StarRating },
  setup(props, { emit }) {
    // Variable
    const router = useRouter();
    const { complaint_type, complaint_item, accused, complainant_item } =
      toRefs(props);

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
      otpWrong.value = "d-none";
      otp_secret_key.value = generateRandomEnglishString(4);

      let api_1 = {
        type: "post",
        url: "sms/send-otp",
      };

      await ApiService[api_1.type](api_1.url, {
        phone_number: props.complainant_item.phone_number,
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
    };

    const onConfirmOTP = async () => {
      let api_2 = {
        type: "post",
        url: "sms/verify-otp",
      };

      await ApiService[api_2.type](api_2.url, {
        otp: otpDataCheck.value.code,
        otp_secret: otp_secret_key.value,
        phone_number: props.complainant_item.phone_number,
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
      let data_complainant_item: any = {
        card_photo:
          complainant_item.value.card_photo != null
            ? complainant_item.value.card_photo
            : undefined,
        card_type: complainant_item.value.card_type
          ? complainant_item.value.card_type.value
          : undefined,
        id_card: complainant_item.value.id_card
          ? complainant_item.value.id_card
          : undefined,
        prefix_name_id: complainant_item.value.prefix_name_id
          ? complainant_item.value.prefix_name_id.id
          : undefined,
        firstname: complainant_item.value.firstname
          ? complainant_item.value.firstname
          : undefined,
        lastname: complainant_item.value.lastname
          ? complainant_item.value.lastname
          : undefined,
        birthday: complainant_item.value.birthday
          ? dayjs(complainant_item.value.birthday).format("YYYY-MM-DD")
          : undefined,
        occupation_id: undefined,
        occupation_text: complainant_item.value.occupation_text
          ? complainant_item.value.occupation_text
          : undefined
          ? complainant_item.value.occupation_text
          : undefined,
        phone_number: complainant_item.value.phone_number,
        email: complainant_item.value.email
          ? complainant_item.value.email
          : undefined,
        line_id: complainant_item.value.line_id
          ? complainant_item.value.line_id
          : undefined,
        house_number: complainant_item.value.house_number
          ? complainant_item.value.house_number
          : undefined,
        building: complainant_item.value.building
          ? complainant_item.value.building
          : undefined,
        moo: complainant_item.value.moo
          ? complainant_item.value.moo
          : undefined,
        soi: complainant_item.value.soi
          ? complainant_item.value.soi
          : undefined,
        road: complainant_item.value.road
          ? complainant_item.value.road
          : undefined,
        postal_code: complainant_item.value.postal_code
          ? complainant_item.value.postal_code
          : undefined,
        sub_district_id: complainant_item.value.sub_district_id
          ? complainant_item.value.sub_district_id
          : undefined,
        district_id: complainant_item.value.district_id
          ? complainant_item.value.district_id
          : undefined,
        province_id: complainant_item.value.province_id
          ? complainant_item.value.province_id
          : undefined,
        complainant_type: complaint_type.value.id == 4 ? 2 : 1,
        position_id: complaint_type.value.id == 4 ? null : null,
        section_id: complaint_type.value.id == 4 ? null : null,
        inspection_id: complaint_type.value.id == 4 ? null : null,
        bureau_id: complaint_type.value.id == 4 ? null : null,
        division_id: complaint_type.value.id == 4 ? null : null,
        agency_id: complaint_type.value.id == 4 ? null : null,
        created_by: complainant_item.value.firstname
          ? complainant_item.value.firstname +
            " " +
            complainant_item.value.lastname
          : complainant_item.value.phone_number,
        updated_by: complainant_item.value.firstname
          ? complainant_item.value.firstname +
            " " +
            complainant_item.value.lastname
          : complainant_item.value.phone_number,
      };

      if (complaint_item.value?.is_anonymous == 2) {
        data_complainant_item = {
          phone_number: complainant_item.value.phone_number,
          created_by: complainant_item.value.firstname
            ? complainant_item.value.firstname +
              " " +
              complainant_item.value.lastname
            : complainant_item.value.phone_number,
          updated_by: complainant_item.value.phone_number,
          complainant_type: complaint_type.value.id == 4 ? 2 : 1,
        };
      }

      let api = {
        type: "postFormData",
        url: "complainant/",
      };

      let check_duplicate_complainant = await ApiService.query(api.url, {
        params: { phone_number: complainant_item.value.phone_number },
      }).then(({ data }) => {
        if (data.msg != "success") {
          throw new Error("ERROR");
        }
        return data.data;
      });

      if (check_duplicate_complainant) {
        api.type = "putFormData";
        api.url = "complainant/" + check_duplicate_complainant[0].id;
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
      let d1 = <any>null;
      if (complaint_item.value.incident_date) {
        if (complaint_item.value.incident_time) {
          d1 = dayjs(complaint_item.value.incident_date)
            .set("hour", complaint_item.value.incident_time.hours)
            .set("minute", complaint_item.value.incident_time.minutes)
            .format("YYYY-MM-DDTHH:mm:ss.SSS[Z]");
        }
      }
      //   console.log(complaint_item.value.complaint_channel_all.join(","));

      let data_item = {
        complaint_type_id:
          complaint_item.value.complaint_topic.complaint_type_id,
        complainant_id: result_complaint.value.complainant_id,
        is_anonymous: complaint_item.value.is_anonymous,
        complaint_title: complaint_item.value.complaint_title,
        complaint_detail: complaint_item.value.complaint_detail,
        complaint_channel_ids:
          complaint_item.value.complaint_channel_all.length != 0
            ? complaint_item.value.complaint_channel_all.join(",")
            : undefined,
        channel_history_text: complaint_item.value.channel_history_text,
        incident_date: complaint_item.value.incident_date
          ? dayjs(complaint_item.value.incident_date).format("YYYY-MM-DD")
          : null,
        incident_datetime: d1,
        location_coordinates: complaint_item.value.location_coordinates,
        incident_location: complaint_item.value.incident_location,
        day_time: complaint_item.value.day_time.value,
        complaint_channel_id: complaint_item.value.complaint_channel_id.id,
        inspector_id: complaint_item.value.inspector_id,
        bureau_id: complaint_item.value.bureau_id,
        division_id: complaint_item.value.division_id,
        agency_id: complaint_item.value.agency_id,
        topic_type_id: complaint_item.value.complaint_topic.topic_type_id,
        topic_category_id:
          complaint_item.value.complaint_topic.topic_category_id,
        house_number: "",
        building: "",
        moo: "",
        soi: "",
        road: "",
        postal_code: complaint_item.value.postal_code,
        sub_district_id: complaint_item.value.sub_district_id,
        district_id: complaint_item.value.district_id,
        province_id: complaint_item.value.province_id,
        state_id: 1,
        secret_key: props.r,
        evidence_url: complaint_item.value.evidence_url,
        created_by:
          complaint_item.value.firstname + " " + complaint_item.value.lastname,
      };

      console.log(data_item);

      await ApiService.postFormData("complaint/", { ...data_item })
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
      for (let i = 0; i < accused.value.length; i++) {
        let data_accused_item = {
          prefix_name_id: accused.value[i].prefix_name_id
            ? accused.value[i].prefix_name_id.id
            : null,
          firstname: accused.value[i].firstname,
          lastname: accused.value[i].lastname,

          position_id: accused.value[i].position_id?.value,
          section_id: accused.value[i].section_id?.value,

          inspector_id: accused.value[i].inspector_id,
          bureau_id: accused.value[i].bureau_id,
          division_id: accused.value[i].division_id,
          agency_id: accused.value[i].agency_id,
          complaint_id: result_complaint.value.complaint_id,
          type: 2, //ประเภทผ้ถูกกล่าวหา props.accused[i],
          detail: "",
          created_by: complainant_item.value.firstname,
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
