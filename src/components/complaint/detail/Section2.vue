<template>
  <div class="accordion-item bg-sky">
    <h2 class="accordion-header">
      <button
        class="accordion-button bg-header-grey rounded"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#item3"
      >
        <h4 class="color-primary">ข้อมูลผู้{{ complaint_type.name_th }}</h4>
      </button>
    </h2>
    <div id="item3" class="accordion-collapse collapse show">
      <div class="accordion-body row">
        <div class="col-md-6">
          <span class="fw-bold">ประเภทการระบุตัวตน : </span>
          <span class="fst-italic">{{ new_item.is_anonymous?.name }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-6">
          <span class="fw-bold">หมายเลขโทรศัพท์มือถือ : </span>
          <span class="fst-italic">
            {{ complainant_item.phone_number }}
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12" v-if="complaint_item.is_anonymous == 1">
          <div class="row">
            <div class="col-md-6">
              <span class="fw-bold">ประเภทบัตร : </span>
              <span class="fst-italic">
                {{ new_item.card_type?.name }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">หมายเลขบัตรประชาชน/Passport : </span>
              <span class="fst-italic">{{
                complainant_item.id_card?.slice(0, -7) + "xxxxxxx"
              }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">ชื่อ-นามสกุล : </span>
              <span class="fst-italic"
                >{{ complainant_item.prefix_name?.name_th
                }}{{ complainant_item.firstname }}
                {{ complainant_item.lastname }}</span
              >
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">วัน/เดือน/ปีเกิด : </span>
              <span class="fst-italic">
                {{ new_item.birthday }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span class="fw-bold">อาชีพ : </span>
              <span class="fst-italic">
                {{ complainant_item.occupation_text }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span class="fw-bold">ที่อยู่ : </span>
              <span class="fst-italic">
                {{
                  complainant_item.house_number
                    ? "บ้านเลขที่ " + complainant_item.house_number
                    : ""
                }}{{
                  complainant_item.building
                    ? " หมู่บ้าน " + complainant_item.building
                    : ""
                }}{{
                  complainant_item.moo
                    ? " หมู่ที่ " + complainant_item.moo
                    : ""
                }}{{
                  complainant_item.soi
                    ? " ตรอก/ซอย " + complainant_item.soi
                    : ""
                }}{{
                  complainant_item.road ? " ถนน " + complainant_item.road : ""
                }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span class="fw-bold">ตำบล/อำเภอ/จังหวัด : </span>
              <span class="fst-italic">
                {{ complainant_item.address_all }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">อีเมล : </span>
              <span class="fst-italic">
                {{ complainant_item.email }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span class="fw-bold">Line ID : </span>
              <span class="fst-italic">
                {{ complainant_item.line_id }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span class="fw-bold">รูปถ่ายตนเองพร้อมบัตร : </span>
              <br />
              <span class="fst-italic">
                <img
                  :src="complainant_item.card_photo"
                  class="mt-5 w-100 w-md-50"
                />
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, onMounted } from "vue";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);

export default defineComponent({
  name: "complaint-detail-section2",
  props: {
    complaint_type: {
      type: Object,
      required: true,
    },
    complaint_item: {
      type: Object,
      required: true,
    },
    complainant_item: {
      type: Object,
      required: true,
    },
    new_item: {
      type: Object,
      required: true,
    },
  },

  components: {
    dayjs,
  },
  setup(props) {
    // Variable

    // Event
    const showDate = (date: any) => {
      if (date == null) {
        return "";
      }
      return dayjs(date).utc().locale("th").format("DD MMM BBBB");
    };

    // Mounted
    onMounted(() => {});

    // Watch
    // Return
    return {
      getAssetPath,
      showDate,
    };
  },
});
</script>

<style scoped>
.bg-sky {
  background-color: #d9f4fe;
}

.bg-header-grey {
  background-color: #ddd;
}

.separator.separator-dotted {
  border-bottom-color: #aaa;
}

.accordion-item {
  border-color: #d9f4fe;
}
.color-primary {
  color: #800001;
}
</style>
