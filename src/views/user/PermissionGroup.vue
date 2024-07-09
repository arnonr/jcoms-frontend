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
                <label for="line_id" class="form-label required"
                  >สิทธิผู้ใช้งาน</label
                >
                <v-select
                  label="name_th"
                  name="role_id"
                  placeholder="สิทธิผู้ใช้งาน"
                  :options="selectOptions.roles"
                  class="form-control form-control-lg"
                  :clearable="false"
                  v-model="item.role_id"
                >
                </v-select>
              </div>

              <table class="table table-bordered">
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
import ApiService from "@/core/services/ApiService";

import useMenuData from "@/composables/useMenuData";

// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";

export default defineComponent({
  name: "permission-user",
  props: {
  },
  components: { vSelect },
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    const item = reactive<any>({});

    const selectOptions = ref({
      // complaint_channels: <any>[],
      roles: <any>[],
    });

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

    const fetchRole = async () => {
      let api = {
        type: "query",
        url: "role",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.roles = data.data.filter((x: any) => {
            return x.id != 7;
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

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
      fetchRole();  
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
      selectOptions,
      item,
    };
  },
});
</script>

<style scoped>
/* Add your styles here */
</style>
