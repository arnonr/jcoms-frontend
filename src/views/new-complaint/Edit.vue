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
        <div class="modal-header" v-if="item.id != null">
          <h3 class="modal-title">แก้ไขข้อมูล</h3>
          <button
            @click="onClose({ reload: false })"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body" v-if="item.id != null">
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
            />

            <Tab3
              :tab_index="tab_index"
              :complaint_item="item"
              :complainant_item="complainant_item"
              :accused="accused"
              :complaint_type="complaint_type"
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
        <Preloader :isLoading="isLoading" :position="'absolute'" />
      </div>
    </div>
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
import Tab2 from "@/components/complaint/form/Tab2.vue";
import Tab3 from "@/components/complaint/form/Tab3.vue";
import Preloader from "@/components/Preloader.vue";

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
    const isLoading = ref<Boolean>(false);
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const tab_index = ref(0);
    const onTabChange = (prevIndex: number, nextIndex: number) => {
      tab_index.value = nextIndex;
    };

    // Variable
    const complaint_type = ref({ id: null, name_th: "" });

    // Item Variable
    const item = reactive<any>({
      complaint_type_id: 1,
      is_anonymous: null,
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
    const fetchComplainant = async () => {
      try {
        isLoading.value = true;
        const params = { id: props.complainant_id };
        const { data } = await ApiService.query("complainant", { params });

        if (data.data.length > 0) {
          Object.assign(complainant_item, {
            id: data.data[0].id,
            phone_number: data.data[0].phone_number,
            card_type:
              data.data[0].card_type != null
                ? {
                    name:
                      data.data[0].card_type == 2
                        ? "หนังสือเดินทาง"
                        : "หมายเลขบัตรประชาชน",
                    value: data.data[0].card_type,
                  }
                : "-",

            id_card: data.data[0].id_card,
            prefix_name_id:
              data.data[0].prefix_name_id != null
                ? {
                    name_th: data.data[0].prefix_name.name_th,
                    id: data.data[0].prefix_name_id,
                  }
                : null,
            firstname: data.data[0].firstname,
            lastname: data.data[0].lastname,
            birthday: data.data[0].birthday
              ? dayjs(data.data[0].birthday).format("YYYY-MM-DD")
              : null,
            occupation_text: data.data[0].occupation_text,
            house_number: data.data[0].house_number,
            building: data.data[0].building,
            moo: data.data[0].moo,
            soi: data.data[0].soi,
            road: data.data[0].road,
            address_all:
              data.data[0].sub_district_id != null
                ? {
                    label:
                      data.data[0].sub_district?.name_th +
                      " > " +
                      data.data[0].district?.name_th +
                      " > " +
                      data.data[0].province?.name_th +
                      " > " +
                      data.data[0].postal_code,
                    province_th: data.data[0].province?.name_th,
                    district_th: data.data[0].district?.name_th,
                    sub_district_th: data.data[0].sub_district?.name_th,
                    post_code: data.data[0].postal_code,
                    sub_district_id: data.data[0].sub_district_id,
                    district_id: data.data[0].district_id,
                    province_id: data.data[0].province_id,
                  }
                : null,
            province_id: data.data[0].province_id,
            district_id: data.data[0].district_id,
            sub_district_id: data.data[0].sub_district_id,
            postal_code: data.data[0].postal_code,
            card_photo_old: data.data[0].card_photo,
            email: data.data[0].email,
            line_id: data.data[0].line_id,
          });
          //   is_complainant_old.value = true;
        } else {
          //   is_complainant_old.value = false;
        }

        fetchComplaint();
      } catch (error) {
        // is_complainant_old.value = false;
        console.log(error);
        isLoading.value = false;
      }
    };
    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        complaint_type.value = useComplaintTypeData().complaint_types.find(
          (x: any) => x.id == data.data.complaint_type_id
        );

        Object.assign(item, data.data);
        accused.length = 0;
        accused_old.length = 0;
        Object.assign(accused, data.data.accused);
        Object.assign(accused_old, data.data.accused);

        isLoading.value = false;
      } catch (error) {
        console.log(error);
        isLoading.value = false;
      }
    };

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

      await ApiService.putFormData(
        "complainant/" + complainant_item.id,
        data_complainant_item
      )
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
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
        complainant_id: complainant_item.complainant_id,
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
        // updated_by: item.firstname + " " + item.lastname,
      };

      await ApiService.putFormData("complaint/" + item.id, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
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
        await fetchComplainant();
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
