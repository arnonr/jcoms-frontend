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
        <div class="modal-header" v-if="!isLoading">
          <h3 class="modal-title">รายละเอียด {{ complaint_item.jcoms_no }}</h3>
          <button
            @click="onClose({ reload: false })"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body" v-if="!isLoading">
          <div class="row">
            <div class="col-md-12">
              <div class="row">
                <!--  -->
                <div class="accordion" id="myAccordion">
                  <Section1 :complaint_item="complaint_item" />

                  <Section2
                    :complaint_type="complaint_type"
                    :complaint_item="complaint_item"
                    :complainant_item="complainant_item"
                    :new_item="new_item"
                  />

                  <Section3
                    :complaint_type="complaint_type"
                    :complaint_item="complaint_item"
                    :complainant_item="complainant_item"
                    :new_item="new_item"
                    :accused_item="accused_item"
                    :complaint_file_attach="complaint_file_attach"
                  />

                  <div class="mx-auto text-center">
                    <button
                      @click="generatePDF"
                      type="button"
                      class="btn btn-success"
                    >
                      พิมพ์ข้อมูลส่วนบุคคล
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <Preloader :isLoading="isLoading" :position="'absolute'" />
      </div>
    </div>

    <!-- PDF -->
    <vue3-html2pdf
      :show-layout="false"
      :float-layout="true"
      :enable-download="true"
      :preview-modal="true"
      :paginate-elements-by-height="1400"
      filename="jcoms_data"
      :pdf-quality="2"
      :manual-pagination="false"
      pdf-format="a4"
      pdf-orientation="portrait"
      pdf-content-width="800px"
      ref="html2Pdf"
    >
      <template v-slot:pdf-content>
        <div
          style="
            margin-top: 50px;
            margin-right: 50px;
            margin-bottom: 50px;
            margin-left: 50px;
          "
          class="generate-pdf"
        >
          <!-- <SectionPDF1 :complaint_item="complaint_item" /> -->

          <SectionPDF2
            :complaint_type="complaint_type"
            :complaint_item="complaint_item"
            :complainant_item="complainant_item"
            :new_item="new_item"
          />

          <SectionPDF3
            :complaint_type="complaint_type"
            :complaint_item="complaint_item"
            :complainant_item="complainant_item"
            :new_item="new_item"
            :accused_item="accused_item"
            :complaint_file_attach="complaint_file_attach"
          />
        </div>
      </template>
    </vue3-html2pdf>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
// PDF
import { jsPDF } from "jspdf";
import Vue3Html2pdf from "vue3-html2pdf";

// Use Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useBasicData from "@/composables/useBasicData";
import useStateData from "@/composables/useStateData";
import Preloader from "@/components/preloader/Preloader.vue";
import Section1 from "@/components/complaint/detail/Section1.vue";
import Section2 from "@/components/complaint/detail/Section2.vue";
import Section3 from "@/components/complaint/detail/Section3.vue";
import SectionPDF1 from "@/components/complaint/detail/SectionPDF1.vue";
import SectionPDF2 from "@/components/complaint/detail/SectionPDF2.vue";
import SectionPDF3 from "@/components/complaint/detail/SectionPDF3.vue";

export default defineComponent({
  name: "complaint-detail-modal",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
    complainant_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    dayjs,
    Preloader,
    Section1,
    Section2,
    Section3,
    Vue3Html2pdf,
    jsPDF,
    SectionPDF1,
    SectionPDF2,
    SectionPDF3,
  },
  setup(props, { emit }) {
    // UI
    const isLoading = ref<any>(true);
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const html2Pdf = ref<any>(null);

    // Variable
    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: useBasicData().card_types,
      is_anonymouses: useBasicData().is_anonymouses,
      day_times: useBasicData().day_times,
      states: useStateData().states,
    });

    const complaint_item = reactive<any>({});
    const complainant_item = reactive<any>({});
    const accused_item = reactive<any>([]);
    const complaint_file_attach = reactive<any>([]);
    const complaint_type = reactive<any>({
      name_th: "",
      id: null,
    });

    const new_item = reactive<any>({
      is_anonymous: null,
      card_type: null,
      birthday: null,
      organization_all: [],
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
      incident_date: "",
      evidence_url: [],
    });

    const generatePDF = () => {
      html2Pdf.value.generatePdf();
    };

    // Fetch
    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        Object.assign(complaint_item, data.data);
        Object.assign(
          complaint_type,
          useComplaintTypeData().complaint_types.find(
            (x: any) => x.id == complaint_item.complaint_type_id
          )
        );
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplainant = async () => {
      try {
        const { data } = await ApiService.query(
          "complainant/" + props.complainant_id,
          {}
        );

        Object.assign(complainant_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchAccused = async () => {
      try {
        const { data } = await ApiService.query("accused/", {
          params: {
            complaint_id: complaint_item.id,
          },
        });

        accused_item.length = 0;
        Object.assign(accused_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplaintFileAttach = async () => {
      try {
        const { data } = await ApiService.query("complaint-file-attach/", {
          params: { complaint_id: complaint_item.id },
        });
        complaint_file_attach.length = 0;
        Object.assign(complaint_file_attach, data.data);
      } catch (error) {
        console.log(error);
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

    const beforeShow = () => {
      new_item.complaint_channel_all = "";
      if (complaint_item.channel_history.length > 0) {
        complaint_item.channel_history.forEach((el: any) => {
          let comma_text = "";
          if (new_item.complaint_channel_all.length != 0) {
            comma_text = " , ";
          }
          new_item.complaint_channel_all =
            new_item.complaint_channel_all + comma_text + el.channel?.name_th;
        });
      }

      new_item.is_anonymous = selectOptions.value.is_anonymouses.find(
        (x: any) => {
          return x.value == complaint_item.is_anonymous;
        }
      );

      if (complaint_item.is_anonymous == 1) {
        new_item.card_type = selectOptions.value.card_types.find((x: any) => {
          return x.value == complainant_item.card_type;
        });

        new_item.birthday = complainant_item.birthday
          ? dayjs(complainant_item.birthday).locale("th").format("DD MMMM BBBB")
          : "";

        complainant_item.address_all = `${complainant_item.sub_district.name_th} > ${complainant_item.district.name_th} > ${complainant_item.province.name_th} > ${complainant_item.postal_code}`;
      }

      complaint_item.address_all = "";
      if (Object.keys(complaint_item.sub_district).length != 0) {
        complaint_item.address_all = `${complaint_item.sub_district?.name_th} > ${complaint_item.district?.name_th} > ${complaint_item.province?.name_th} > ${complaint_item.postal_code}`;
      }

      if (complaint_item.incident_datetime) {
        new_item.incident_date = dayjs(complaint_item.incident_datetime)
          .utc()
          .locale("th")
          .format("DD MMM BBBB HH:mm");

        new_item.day_time = selectOptions.value.day_times.find((x: any) => {
          return x.value == complaint_item.day_time;
        });
      }

      if (
        complaint_item.location_coordinates != "" &&
        complaint_item.location_coordinates != null
      ) {
        const [lat, lng] = complaint_item.location_coordinates.split(",");
        new_item.markerDetails = {
          id: 1,
          position: { lat: Number(lat), lng: Number(lng) },
        };
      }

      complaint_item.state = selectOptions.value.states.find(
        (x: any) => x.id === complaint_item.state_id
      );

      new_item.evidence_url =
        complaint_item.evidence_url != "" && complaint_item.evidence_url != null
          ? complaint_item.evidence_url
              .split(",")
              .map((it: any) => it.replace(/(^'|'$)/g, ""))
          : [];
    };

    // Mounted
    onMounted(async () => {
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
      mainModalRef.value.addEventListener("hidden.bs.modal", () =>
        onClose({ reload: false })
      );

      await fetchComplaint();
      await fetchComplainant();
      await fetchAccused();
      await fetchComplaintFileAttach();

      isLoading.value = false;

      beforeShow();
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

    // Return
    return {
      isLoading,
      mainModalRef,
      complaint_item,
      complainant_item,
      accused_item,
      complaint_file_attach,
      complaint_type,
      new_item,
      onClose,
      generatePDF,
      html2Pdf,
    };
  },
});
</script>

<style scoped>
/* @import "https://fonts.googleapis.com/css2?family=Sarabun&display=swap"; */
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}

.generate-pdf {
  font-family: Sarabun, sans-serif;
}

.color-primary {
  color: #800001;
}

.modal-content {
  background-color: #d9f4fe;
}
</style>
