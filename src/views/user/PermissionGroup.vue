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
                  >กลุ่มผู้ใช้งาน</label
                >
                <v-select
                  label="name_th"
                  name="role_id"
                  placeholder="กลุ่มผู้ใช้งาน"
                  :options="selectOptions.roles"
                  class="form-control form-control-lg"
                  :clearable="false"
                  v-model="item.role_id"
                >
                </v-select>
              </div>

              <table class="table table-bordered table-striped bg-sky" v-if="item.role_id">
                <thead class="bg-color-police">
                  <tr>
                    <th class="text-white">Menu</th>
                    <th
                      v-for="permission in permissions"
                      :key="permission"
                      class="text-center text-white"
                    >
                      {{ permission }}
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="menu in menus" :key="menu">
                    <td>{{ menu.name_th }}</td>
                    <td
                      v-for="permission in permissions"
                      :key="permission"
                      class="text-center"
                    >
                      <input
                        type="checkbox"
                        class="form-check-input"
                        v-model="menuPermissions[menu.name_th][permission]"
                      />
                    </td>
                  </tr>
                </tbody>
              </table>

              <button
                type="submit"
                class="btn btn-primary"
                :disabled="isLoading"
              >
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
  watch,
} from "vue";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
import ApiService from "@/core/services/ApiService";
import useMenuData from "@/composables/useMenuData";
import useToast from "@/composables/useToast";
// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";

interface Permissions {
  view: boolean;
  create: boolean;
  update: boolean;
  delete: boolean;
  export: boolean;
}

export default defineComponent({
  name: "permission-group",
  components: { vSelect },
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const isLoading = ref<any>(null);
    const group_permission_items = reactive<any>([]);
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
      menus: useMenuData().menus,
      permissions: ["view", "create", "update", "delete"],
      menuPermissions: {} as Record<string, Permissions>,
    });

    state.menus.forEach((menu: any) => {
      state.menuPermissions[menu.name_th] = {
        view: false,
        create: false,
        update: false,
        delete: false,
        export: false,
      };
    });

    const fetchRole = async () => {
      await ApiService.query("role", {
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

    // fetch User Permission
    const fetchPermissions = async () => {
      state.menus.forEach((menu: any) => {
        state.menuPermissions[menu.name_th] = {
          view: false,
          create: false,
          update: false,
          delete: false,
          export: false,
        };
      });
      if (item.role_id != null) {
        const params = {
          perPage: 100,
          currentPage: 1,
          role_id: item.role_id.id,
          is_active: 1,
        };

        const { data } = await ApiService.query("permission", {
          params: params,
        });

        group_permission_items.length = 0;
        Object.assign(group_permission_items, data.data);

        group_permission_items.forEach((el: any) => {
          menuPermissions.value[el.menu] = {
            view: el.action_view == 1 ? true : false,
            create: el.action_create == 1 ? true : false,
            update: el.action_update == 1 ? true : false,
            delete: el.action_delete == 1 ? true : false,
            export: el.action_export == 1 ? true : false,
          };
        });
      }
    };
    const updatePermissions = async () => {
      if (item.role_id != null) {
        isLoading.value = true;
        await ApiService.delete("permission/with-role-id/" + item.role_id.id)
          .then(async ({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
          });

        for (const [menu, permissions] of Object.entries(
          menuPermissions.value
        )) {
          let permission_data = <any>{
            role_id: item.role_id.id,
            menu: menu,
            action_view: 0,
            action_create: 0,
            action_update: 0,
            action_delete: 0,
            action_export: 0,
            is_active: 1,
          };
          for (const [permission, value] of Object.entries(permissions)) {
            permission_data["action_" + permission] = value == true ? 1 : 0;
          }
          await ApiService.post("permission/", {
            ...permission_data,
          })
            .then(async ({ data }) => {
              if (data.msg != "success") {
                throw new Error("ERROR");
              }
            })
            .catch(({ response }) => {
              console.log(response);
            });
        }

        isLoading.value = false;
        useToast("อัพเดทสิทธิเสร็จสิ้น", "success");
      }
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
      fetchPermissions();
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    watch(
      () => item.role_id,
      async () => {
        fetchPermissions();
      }
    );

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
      isLoading,
    };
  },
});
</script>

<style scoped>
.bg-sky {
  background-color: #d9f4fe;
}

.form-check-input[type="checkbox"] {
  border-color: #800002;
}
/* Add your styles here */
</style>
