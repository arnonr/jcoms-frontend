<template>
  <div
    class="modal fade"
    id="subOrganizationModal"
    tabindex="-1"
    aria-labelledby="exampleModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">รายการหน่วยงานย่อย</h5>
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>
        <div class="modal-body">
          <table
            class="table table-bordered table-striped bg-sky"
            style="width: 100%"
          >
            <thead class="bg-color-police">
              <tr>
                <th class="text-center text-white">ชื่อหน่วยงานย่อย</th>
                <th class="text-center text-white">รับเรื่อง</th>
                <th class="text-center text-white">ค้าง</th>
                <th class="text-center text-white">เสร็จ</th>
              </tr>
            </thead>
            <tbody v-if="subOrganizations.length">
              <tr v-for="(org, idx) in subOrganizations" :key="idx">
                <!-- <td class="text-center fw-bold">
                  {{ org.name }}
                </td>
                <td class="text-center">{{ org.count_receive }}</td>
                <td class="text-center">{{ org.count_send }}</td>
                <td class="text-center">{{ org.count_success }}</td> -->
              </tr>
            </tbody>
            <tbody v-else>
              <tr>
                <td colspan="4">
                  <div class="text-center"><span>ไม่พบข้อมูล</span></div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="modal-footer">
          <button
            type="button"
            class="btn btn-secondary"
            data-bs-dismiss="modal"
          >
            ปิด
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, toRefs } from "vue";

export default defineComponent({
  name: "SubOrganizationModal",
  props: {
    subOrganizations: {
      type: Array as () => any[],
      //   type: Array as PropType<SubOrganization[]>,
      required: true,
    },
  },
  setup(props, { emit }) {
    const { subOrganizations } = toRefs(props);
    return {
      subOrganizations,
    };
  },
});
</script>

<style scoped>
.modal-dialog {
  max-width: 800px;
}
</style>
