<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">จัดการสิทธิการใช้งาน</h3>
          <button
            @click="onClose"
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Close"
          ></button>
        </div>

        <div class="modal-body">
          <div class="container">
            <form @submit.prevent="updatePermissions">
              <div class="mb-3">
                <label for="role" class="form-label"
                  >ประเภทการกำหนดสิทธิ์</label
                >
                <select id="role" v-model="is_custom_role" class="form-select">
                  <option value="0">สิทธิตามกลุ่มผู้ใช้งาน</option>
                  <option value="1">สิทธิแบบกำหนดเอง</option>
                </select>
              </div>

              <table class="table table-bordered" v-if="is_custom_role == 1">
                <thead>
                  <tr>
                    <th>Menu</th>
                    <th v-for="permission in permissions" :key="permission">
                      {{ permission }}
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="menu in menus" :key="menu">
                    <td>{{ menu.name_th }}</td>
                    <td v-for="permission in permissions" :key="permission">
                      <input
                        type="checkbox"
                        v-model="menuPermissions[menu.name_th][permission]"
                      />
                    </td>
                  </tr>
                </tbody>
              </table>

              <button type="submit" class="btn btn-primary">
                Update Permissions
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  ref,
  toRefs,
  onMounted,
  onUnmounted,
} from "vue";
import { defineAbilitiesFor, ability } from "@/services/ability1";
// Import Modal Bootstrap
import { Modal } from "bootstrap";

import useMenuData from "@/composables/useMenuData";

export default defineComponent({
  name: "permission-user",
  props: {
    id: {
      type: Number,
      required: true,
    },
  },
  components: {},
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    const is_custom_role = ref<any>(null);

    // สร้างสถานะของ component โดยใช้ reactive
    const state = reactive({
      user: {
        role: "guest",
      },
      selectedMenu: "",
      //   menus: ["Dashboard", "Articles", "Settings"],
      menus: useMenuData().menus,
      permissions: ["view", "create", "update", "delete"],
      menuPermissions: {},
    });

    state.menus.forEach((menu: any) => {
      state.menuPermissions[menu.name_th] = {
        view: false,
        create: false,
        update: false,
        delete: false,
      };
    });

    const updatePermissions = () => {
      // อัปเดตสิทธิ์การเข้าถึงโดยอ้างอิงจากบทบาทของผู้ใช้
      const newAbilities = defineAbilitiesFor(state.user);
      ability.update(newAbilities.rules);

      // แสดงข้อความยืนยันหรือดำเนินการเพิ่มเติม
      alert("Permissions updated successfully!");
    };

    // ส่งออกสถานะและฟังก์ชันเพื่อให้สามารถใช้งานใน template ได้
    const { user, selectedMenu, menus, permissions, menuPermissions } =
      toRefs(state);

    //Event
    const onClose = () => {
      mainModalObj.value.hide();
      emit("close-modal");
    };

    // Mounted
    onMounted(async () => {
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    return {
      user,
      menus,
      selectedMenu,
      permissions,
      updatePermissions,
      menuPermissions,
      onClose,
      mainModalRef,
      is_custom_role,
    };
  },
});
</script>

<style scoped>
/* Add your styles here */
</style>
