<template>
  <div
    class="modal fade"
    tabindex="-1"
    ref="mainModalRef"
    id="main-modal"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">เพิ่มข้อมูล</h3>
          <button
            @click="onClose({ reload: false })"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <form-wizard
            color="#800001"
            ref="formStep"
            finishButtonText="บันทึก"
            backButtonText="ย้อนกลับ"
            nextButtonText="ถัดไป"
            step-size="xs"
            id="form"
            @on-change="onTabChange"
            @on-complete="onComplete"
          >
            <Tab1
              :complaint_item="item"
              :complainant_item="complainant_item"
              :complaint_type="complaint_type"
            />

            <Tab2
              :complaint_item="item"
              :complaint_type="complaint_type"
              :accused="accused"
              :r="r"
            />

            <Tab3
              :tab_index="tab_index"
              :complaint_item="item"
              :complainant_item="complainant_item"
              :accused="accused"
              :complaint_type="complaint_type"
              :r="r"
            />

            <template #footer="props">
              <div class="wizard-footer-left">
                <button
                  v-if="props.activeTabIndex > 0"
                  @click.native="props.prevTab()"
                  class="btn text-white float-left"
                  style="background-color: #800001"
                >
                  ย้อนกลับ
                </button>
              </div>

              <div class="wizard-footer-right">
                <button
                  v-if="!props.isLastStep"
                  @click.native="props.nextTab()"
                  class="btn text-white"
                  style="background-color: #800001"
                >
                  ถัดไป
                </button>

                <button
                  v-else
                  @click.native="onComplete"
                  class="finish-button btn text-white"
                  style="background-color: #800001"
                >
                  {{ props.isLastStep ? "บันทึก" : "Next" }}
                </button>
              </div>
            </template>
          </form-wizard>
        </div>
        <Preloader
          :isLoading="isLoading != undefined ? isLoading : false"
          :position="'absolute'"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
import ApiService from "@/core/services/ApiService";

// Import FormWizard
import { FormWizard } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Use Toast Composables
import useToast from "@/composables/useToast";
// Use Address Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import customParseFormat from "dayjs/plugin/customParseFormat";
dayjs.extend(buddhistEra);
dayjs.extend(customParseFormat);

// Import Component
import Tab1 from "@/components/complaint/form/Tab1.vue";
import Tab2 from "@/components/complaint/form/Tab2Add.vue";
import Tab3 from "@/components/complaint/form/Tab3.vue";
import Preloader from "@/components/preloader/Preloader.vue";

export default defineComponent({
  name: "edit-complaint",
  props: {
    complaint_id: Number,
    complainant_id: Number,
  },
  components: {
    FormWizard,
    Tab1,
    Tab2,
    Tab3,
    Preloader,
  },
  setup(props, { emit }) {
    // UI Variable
    const isLoading = ref<any>(false);
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const tab_index = ref(0);
    const onTabChange = (prevIndex: number, nextIndex: number) => {
      tab_index.value = nextIndex;
    };

    // Variable
    const complaint_type = ref({ id: 1, name_th: "ร้องเรียน" });
    const r = (Math.random() + 1).toString(36).substring(7);

    // Item Variable
    const item = reactive<any>({
      is_anonymous: 1,
      complaint_title: "",
      house_number: "",
      building: "",
      moo: "",
      soi: "",
      road: "",
      address_all: null,
      incident_location: "",
      incident_date: null,
      incident_time: null,
      day_time: null,
      location_coordinates: "",
      complaint_detail: "",
      complaint_channel_id: {
        id: 8,
        name_th: "JCOM ร้องเรียน/แจ้งเบาะแส",
      },
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      topic_type_id: null,
      notice_type: null,
      complaint_topic: null,
      complaint_channel_all: [],
      evidence_url: "",
      channel_history_text: "",
      complaint_type_id: { id: 1, name_th: "ร้องเรียน" },
      //   state_id
    });

    const complainant_item = reactive<any>({
      phone_number: "",
      card_type: null,
      id_card: "",
      prefix_name_id: null,
      firstname: "",
      lastname: "",
      birthday: "",
      occupation_text: "",
      house_number: "",
      building: "",
      moo: "",
      soi: "",
      road: "",
      address_all: null,
      card_photo: [],
      email: "",
      line_id: "",
      card_photo_old: null,
    });

    const accused = reactive<any[]>([
      {
        id: null,
        prefix_name_id: null,
        firstname: "",
        lastname: "",
        position_id: null,
        section_id: null,
        agency_id: null,
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        complaint_id: null,
        type: null,
        detail: null,
        organization_all: null,
      },
    ] as any[]);

    const accused_old = reactive([
      {
        id: null,
        prefix_name_id: null,
        firstname: "",
        lastname: "",
        position_id: null,
        section_id: null,
        agency_id: null,
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        complaint_id: null,
        type: null,
        detail: null,
        organization_all: null,
      },
    ] as any[]);

    //Fetch

    // Event
    const onClose = ({ reload = false }: { reload?: boolean }) => {
      mainModalObj.value.hide();
      if (reload === true) {
        emit("reload");
      }
      emit("close-modal");
    };

    const onComplete = async () => {
      try {
        isLoading.value = true;
        await onSaveComplainant();
        await onSaveComplaint();
        await onSaveAccused();
        isLoading.value = false;
        useToast("บันทึกข้อมูลเสร็จสิ้น");
        // useToast("บันทึกข้อมูลเสร็จสิ้น", "success","top","right");
        onClose({ reload: true });
      } catch (error) {
        isLoading.value = false;
        useToast("เกิดข้อผิดพลาดในการบันทึกข้อมูล", "error");
        console.error("Error saving data:", error);
      }
    };
    // Save Event
    const onSaveComplainant = async () => {
      //
      let data_complainant_item = {
        card_photo:
          complainant_item.card_photo.length != 0
            ? complainant_item.card_photo
            : undefined,
        card_type: complainant_item.card_type
          ? complainant_item.card_type?.value
          : undefined,
        id_card: complainant_item.id_card,
        prefix_name_id: complainant_item.prefix_name_id
          ? complainant_item.prefix_name_id?.id
          : undefined,
        firstname: complainant_item.firstname,
        lastname: complainant_item.lastname,
        birthday: complainant_item.birthday
          ? dayjs(complainant_item.birthday).format("YYYY-MM-DD")
          : undefined,
        occupation_id: undefined,
        occupation_text: complainant_item.occupation_text,
        phone_number: complainant_item.phone_number,
        email: complainant_item.email,
        line_id: complainant_item.line_id,
        house_number: complainant_item.house_number,
        building: complainant_item.building,
        moo: complainant_item.moo,
        soi: complainant_item.soi,
        road: complainant_item.road,
        postal_code: complainant_item.postal_code,
        sub_district_id: complainant_item.sub_district_id,
        district_id: complainant_item.district_id,
        province_id: complainant_item.province_id,
        id: complainant_item.id,
        complainant_type: item.id == 4 ? 2 : 1,
        position_id: complaint_type.value.id == 4 ? null : null,
        section_id: complaint_type.value.id == 4 ? null : null,
        inspection_id: complaint_type.value.id == 4 ? null : null,
        bureau_id: complaint_type.value.id == 4 ? null : null,
        division_id: complaint_type.value.id == 4 ? null : null,
        agency_id: complaint_type.value.id == 4 ? null : null,
        // updated_by: item.firstname + " " + props.item.lastname,
      };

      if (complaint_item.is_anonymous == 2) {
        data_complainant_item = {
          phone_number: complainant_item.phone_number,
          updated_by: complainant_item.firstname
            ? complainant_item.firstname + " " + complainant_item.lastname
            : complainant_item.phone_number,
          complainant_type: complaint_type.id == 4 ? 2 : 1,
        };
      }

      let api = {
        type: "postFormData",
        url: "complainant/",
      };

      let check_duplicate_complainant = await ApiService.query("complainant/", {
        params: { phone_number: complainant_item.phone_number },
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

          complainant_item.id = data.id;
        })
        .catch(({ response }) => {
          console.log(response);
          isLoading.value = false;
        });
    };
    const onSaveComplaint = async () => {
      let d1 = <any>null;
      if (item.incident_date) {
        if (item.incident_time) {
          d1 = dayjs(item.incident_date)
            .set("hour", item.incident_time.hours)
            .set("minute", item.incident_time.minutes)
            .format("YYYY-MM-DDTHH:mm:ss.SSS[Z]");
        }
      }

      let data_item = {
        complaint_type_id: item.complaint_topic.complaint_type_id,
        complainant_id: complainant_item.id,
        is_anonymous: item.is_anonymous,
        complaint_title: item.complaint_title,
        complaint_detail: item.complaint_detail,
        complaint_channel_ids:
          item.complaint_channel_all != null
            ? item.complaint_channel_all.join(",")
            : "",
        incident_date: item.incident_date
          ? dayjs(item.incident_date).format("YYYY-MM-DD")
          : null,
        incident_datetime: d1,
        location_coordinates: item.location_coordinates,
        incident_location: item.incident_location,
        day_time: item.day_time.value,
        complaint_channel_id: item.complaint_channel_id.id,
        inspector_id: item.inspector_id,
        bureau_id: item.bureau_id,
        division_id: item.division_id,
        agency_id: item.agency_id,
        topic_type_id: item.complaint_topic.topic_type_id,
        topic_category_id: item.complaint_topic.topic_category_id,
        house_number: "",
        building: "",
        moo: "",
        soi: "",
        road: "",
        postal_code: item.postal_code,
        sub_district_id: item.sub_district_id,
        district_id: item.district_id,
        province_id: item.province_id,
        evidence_url: item.evidence_url,
        channel_history_text: item.channel_history_text,
        state_id: 1,
        // updated_by: item.firstname + " " + item.lastname,
      };

      await ApiService.postFormData("complaint/", data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }

          item.id = data.id;
        })
        .catch(({ response }) => {
          console.log(response);
          isLoading.value = false;
        });
    };
    const onSaveAccused = async () => {
      for (let i = 0; i < accused.length; i++) {
        let data_accused_item = {
          id: accused[i].id,
          prefix_name_id: accused[i].prefix_name_id
            ? accused[i].prefix_name_id.id
            : null,
          firstname: accused[i].firstname,
          lastname: accused[i].lastname,

          position_id: accused[i].position_id?.value,
          section_id: accused[i].section_id?.value,

          inspector_id: accused[i].inspector_id,
          bureau_id: accused[i].bureau_id,
          division_id: accused[i].division_id,
          agency_id: accused[i].agency_id,
          complaint_id: item.id,
          type: 2,
          detail: "",
        };

        let api = {
          type: "post",
          url: "accused/",
        };

        if (data_accused_item.id != null) {
          api.type = "put";
          api.url = "accused/" + data_accused_item.id;
        }

        await ApiService[api.type](api.url, data_accused_item)
          .then(({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
            isLoading.value = false;
          });
      }

      //   accused_old
      for (let i = 0; i < accused_old.length; i++) {
        let check = accused.find((x: any) => {
          return x.id == accused_old[i].id;
        });

        if (!check) {
          await ApiService.delete("accused/" + accused_old[i].id)
            .then(({ data }) => {
              if (data.msg != "success") {
                throw new Error("ERROR");
              }
            })
            .catch(({ response }) => {
              console.log(response);
            });
        }
      }
    };

    onMounted(async () => {
      try {
        mainModalObj.value = new Modal(mainModalRef.value, {});
        mainModalObj.value.show();
        mainModalRef.value.addEventListener("hidden.bs.modal", () =>
          onClose({ reload: false })
        );
      } catch (error) {
        console.error("Error:", error);
      }
    });

    onUnmounted(() => {
      if (mainModalRef.value) {
        mainModalRef.value.addEventListener("hidden.bs.modal", () =>
          onClose({ reload: false })
        );
      }
      mainModalObj.value.hide();

      emit("close-modal");
    });

    // Watch

    // Return
    return {
      isLoading,
      item,
      complainant_item,
      accused,
      complaint_type,
      tab_index,
      // event
      onTabChange,
      onComplete,
      onClose,
      mainModalRef,
      r,
    };
  },
});
</script>

<style scoped>
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}
.modal-content {
  background-color: #d9f4fe;
}
</style>

<style>
.wizard-icon-container {
  background-color: #800001 !important;
}

.form-check-label {
  color: #444;
}
.pac-container {
  z-index: 9999 !important;
}

.stepTitle {
  color: #800001;
  font-weight: bold;
}
</style>
