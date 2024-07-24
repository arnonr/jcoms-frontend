<template>
  <div class="" v-if="!isLoading">
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
          </div>
        </div>
      </div>
    </div>
    <Preloader :isLoading="isLoading" :position="'absolute'" />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);

// Use Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useBasicData from "@/composables/useBasicData";
import useStateData from "@/composables/useStateData";
import Preloader from "@/components/preloader/Preloader.vue";
import Section1 from "@/components/complaint/detail/Section1.vue";
import Section2 from "@/components/complaint/detail/Section2.vue";
import Section3 from "@/components/complaint/detail/Section3.vue";

export default defineComponent({
  name: "complaint-detail",
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
  },
  setup(props, { emit }) {
    // UI
    const isLoading = ref<any>(true);

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
      if (reload === true) {
        emit("reload");
      }
      emit("close-modal");
    };

    const beforeShow = () => {
      new_item.complaint_channel_all = "";
      if (complaint_item.channel_history?.length > 0) {
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

        complainant_item.address_all = `${complainant_item.sub_district?.name_th} > ${complainant_item.district?.name_th} > ${complainant_item.province?.name_th} > ${complainant_item.postal_code}`;
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
      isLoading.value = true;

      await fetchComplaint();
      await fetchComplainant();
      await fetchAccused();
      await fetchComplaintFileAttach();

      beforeShow();
      isLoading.value = false;
    });

    onUnmounted(() => {});

    // Return
    return {
      isLoading,
      complaint_item,
      complainant_item,
      accused_item,
      complaint_file_attach,
      complaint_type,
      new_item,
      onClose,
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

.color-primary {
  color: #800001;
}

.modal-content {
  background-color: #d9f4fe;
}
</style>
