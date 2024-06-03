<template>
  <div class="accordion-item bg-sky">
    <h2 class="accordion-header">
      <button
        class="accordion-button bg-header-grey rounded"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#item1"
      >
        <h4 class="color-primary">สถานะการดำเนินการ</h4>
      </button>
    </h2>
    <div id="item1" class="accordion-collapse collapse show">
      <div class="accordion-body">
        <span class="fw-bold"> สถานะปัจจุบัน : </span>
        <span
          class="badge p-2 text-white fw-bold"
          :style="`background-color: ${complaint_item.state?.bg_color};`"
          >{{ complaint_item.state?.name_th }}</span
        >
        <div class="separator separator-dotted my-2"></div>

        <table class="table table-bordered table-striped" style="width: 100%">
          <thead class="bg-color-police">
            <th style="max-width: 100px" class="p-3 text-white">วันที่</th>
            <th class="p-3 text-white">สถานะ</th>
            <th class="p-3 text-white">รายละเอียด</th>
          </thead>
          <tbody>
            <tr>
              <td class="p-3">
                {{ showDate(complaint_item.created_at) }}
              </td>
              <td class="fw-bold p-3">ร้องเรียน/แจ้งเบาะแส</td>
              <td class="p-3"></td>
            </tr>
            <!-- ฝรท. รับเรื่อง/ปฏิเสธ -->
            <tr v-if="complaint_item.receive_doc_date">
              <td class="p-3">
                {{ showDate(complaint_item.receive_at) }}
              </td>
              <td class="fw-bold p-3">
                ฝรท.
                {{
                  complaint_item.receive_status == 1
                    ? "รับเรื่อง"
                    : "ไม่รับเรื่อง"
                }}
              </td>
              <td class="p-3">
                <div class="mb-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div>
                    {{ showDate(complaint_item.receive_doc_date) }}
                  </div>
                </div>
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div>{{ complaint_item.receive_doc_no }}</div>
                </div>
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_item.receive_comment }}
                  </div>
                </div>
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">ไฟล์แนบ :</div>
                  <div>
                    <a
                      :href="complaint_item.receive_doc_filename"
                      target="_blank"
                    >
                      เอกสาร
                    </a>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
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

export default defineComponent({
  name: "complaint-detail-section1",
  props: {
    complaint_item: {
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
      return dayjs(date).locale("th").format("DD MMM BBBB");
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
