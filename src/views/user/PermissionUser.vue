<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content bg-sky">
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

              <table
                class="table table-bordered table-striped bg-sky"
                v-if="is_custom_role == 1"
              >
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
} from "vue";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
import ApiService from "@/core/services/ApiService";
import useMenuData from "@/composables/useMenuData";
import useToast from "@/composables/useToast";

interface Permissions {
  view: boolean;
  create: boolean;
  update: boolean;
  delete: boolean;
  export: boolean;
}

export default defineComponent({
  name: "permission-user",
  props: {
    user_id: {
      type: Number,
      required: true,
    },
    is_custom_role: {
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
    const isLoading = ref<any>(null);
    const user_permission_items = reactive<any>([]);
    const is_custom_role = ref<any>(props.is_custom_role);

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

    // fetch User Permission
    const fetchUserPermissions = async () => {
      if (is_custom_role.value == 1) {
        const params = {
          perPage: 100,
          currentPage: 1,
          user_id: props.user_id,
          is_active: 1,
        };

        const { data } = await ApiService.query("user-permission", {
          params: params,
        });

        user_permission_items.length = 0;
        Object.assign(user_permission_items, data.data);

        user_permission_items.forEach((el: any) => {
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
      isLoading.value = true;
      await ApiService.delete("user-permission/with-user-id/" + props.user_id)
        .then(async ({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
        })
        .catch(({ response }) => {
          console.log(response);
        });

      if (is_custom_role.value == 1) {
        for (const [menu, permissions] of Object.entries(
          menuPermissions.value
        )) {
          let permission_data = <any>{
            user_id: props.user_id,
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

          await ApiService.post("user-permission/", {
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

        await ApiService.post("user/" + props.user_id, {
          is_custom_role: 1,
        })
          .then(async ({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
          });

        isLoading.value = false;
        useToast("อัพเดทสิทธิเสร็จสิ้น", "success");
      } else {
        await ApiService.post("user/" + props.user_id, {
          is_custom_role: 0,
        })
          .then(async ({ data }) => {
            if (data.msg != "success") {
              throw new Error("ERROR");
            }
          })
          .catch(({ response }) => {
            console.log(response);
          });

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
      fetchUserPermissions();
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
