<template>
  <div>
    <!--begin::Wrapper-->
    <div class="container p-lg-10 mt-5" id="container">
      <h2 class="mt-10 mb-5 text-black">
        แบบฟอร์ม{{ complaint_type.name_th }}
      </h2>
      <div class="card">
        <div class="card-body" style="background-color: #d9f4fe">
          <form-wizard
            color="#800001"
            ref="formStep"
            finishButtonText="ส่งข้อมูล"
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
              @change-policy="
                (e: any ) => {
                  policy_checkbox = e;
                }
              "
            />

            <template v-slot:footer="props">
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
                  :class="[policy_checkbox == false ? 'disabled' : '']"
                  style="background-color: #800001"
                >
                  {{ props.isLastStep ? "ส่งข้อมูล" : "Next" }}
                </button>
              </div>
              <Preloader :isLoading="isLoading" :position="'absolute'" />
            </template>
          </form-wizard>
        </div>
      </div>
    </div>

    <!-- <div id="captcha">
      <Captcha
        :item="complainant_item"
        v-if="captcha_modal"
        :complaint_item="item"
        :change_phone_number="change_phone_number"
        :errors="complainant_item_errors"
        :first_action="first_action"
        @update-phone-number-data="
          (new_phone) => {
            complainant_item.phone_number = new_phone;
            change_phone_number = false;
            fetchComplainant();
          }
        "
        @close-captcha-modal="
          () => {
            captcha_modal = false;
          }
        "
      />
    </div> -->

    <div id="otp-before-confirm">
      <Otp
        :complaint_item="item"
        :complainant_item="complainant_item"
        :accused="accused"
        :complaint_type="complaint_type"
        :r="r"
        v-if="otp_modal"
        @close-otp-modal="
          () => {
            otp_modal = false;
          }
        "
      />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";
import ApiService from "@/core/services/ApiService";

// Import FormWizard
import { FormWizard } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
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
// Import route
import { useRoute } from "vue-router";

// Import Component
import Tab1 from "@/components/appeal/form/Tab1.vue";
import Tab2 from "@/components/appeal/form/Tab2.vue";
import Tab3 from "@/components/appeal/form/Tab3.vue";
// import Captcha from "@/components/appeal//form/TCaptcha.vue";
import Otp from "@/components/appeal/form/Otp.vue";
import Preloader from "@/components/Preloader.vue";

export default defineComponent({
  name: "appeal",
  components: {
    FormWizard,
    Tab1,
    Tab2,
    Tab3,
    // Captcha,
    Otp,
    Preloader,
  },
  setup() {
    // UI
    const isLoading = ref<Boolean>(false);
    const tab_index = ref(0);
    const onTabChange = (prevIndex: number, nextIndex: number) => {
      tab_index.value = nextIndex;
    };
    const otp_modal = ref(false);
    const captcha_modal = ref(true);
    const first_action = ref(true);

    // Variable
    const route = useRoute();
    const r = (Math.random() + 1).toString(36).substring(7);
    const complaint_type = useComplaintTypeData().complaint_types.find(
      (x: any) => x.id == Number(route.query.type_id)
    );
    const policy_checkbox = ref<boolean>(false);

    const item = ref<any>({
      complaint_type_id: Number(route.params.type_id),
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
    });

    const complainant_item = ref<any>({
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
      complaint_type_id: null,
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

    //Fetch

    // Event
    const onComplete = () => {
      otp_modal.value = true;
      return false;
    };

    // Mounted
    onMounted(() => {});

    // Watch

    // Return
    return {
      isLoading,
      item,
      complainant_item,
      accused,
      complaint_type,
      r,
      tab_index,
      policy_checkbox,
      otp_modal,
      captcha_modal,
      first_action,
      onTabChange,
      onComplete,
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

.wizard-icon-circle {
  color: #800001;
}

.vue-form-wizard.xs .wizard-nav-pills > li.active > a .wizard-icon {
  color: #800001;
}
.form-check-label {
  color: #444;
}

.stepTitle {
  color: #800001;
}

.vs__dropdown-toggle {
  border: none;
}

.dp__pointer {
  border: none;
}
</style>
