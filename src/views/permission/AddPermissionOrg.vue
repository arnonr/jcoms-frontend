<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">เพิ่มสิทธิการแสดงหน่วยงาน</h3>
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
            <div class="row">
              <div class="col-md-12">
                <div class="row">
                  <div class="col-md-12 mb-5">
                    <h4 class="color-primary">สถานะผู้ใช้งาน</h4>
                  </div>

                  <div class="col-12 col-md-12 my-2">
                    <label for="">ระดับหน่วยงานต้นทาง</label>
                    <v-select
                      id="slt-search-role-id"
                      name="slt-search-role-id"
                      label="name_th"
                      placeholder="ระดับหน่วยงาน"
                      :options="selectOptions.roles"
                      v-model="item.role_id"
                      class="form-control"
                      :clearable="true"
                    ></v-select>
                  </div>
                  <div class="col-12 col-md-6 my-2">
                    <label for="">หน่วยงานต้นทาง</label>
                    <v-select
                      id="slt-search-source-org"
                      name="slt-search-source-org"
                      label="name_th"
                      :options="selectOptions.source_orgs"
                      v-model="item.source_org"
                      class="form-control"
                      :clearable="true"
                    ></v-select>
                  </div>
                  <div class="col-12 col-md-6 my-2">
                    <label for="">หน่วยงานปลายทาง</label>
                    <v-select
                      id="slt-search-destination-org"
                      name="slt-search-destination-org"
                      label="name_th"
                      :options="selectOptions.resp_orgs"
                      v-model="item.resp_org"
                      class="form-control"
                      :clearable="true"
                    ></v-select>
                  </div>

                  <!-- <div class="col-md-12 mb-7">
                    <label class="form-label required">สถานะ</label>
                    <v-select
                      label="name"
                      name="status"
                      placeholder="สถานะ"
                      :options="selectOptions.user_statuses"
                      class="form-control form-control-lg"
                      :clearable="false"
                      v-model="item.status"
                    >
                    </v-select>
                    <div class="fv-plugins-message-container">
                      <div class="fv-help-block">
                        <ErrorMessage name="status" />
                      </div>
                    </div>
                  </div>

                  <div class="col-md-12 mb-5 mt-5">
                    <h4 class="color-primary">ข้อมูลผู้ใช้งาน</h4>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label class="form-label required">คำนำหน้า</label>
                    <v-select
                      label="name_th"
                      name="prefix_name"
                      placeholder="คำนำหน้า (ยศ)"
                      :options="selectOptions.prefix_names"
                      class="form-control form-control-lg"
                      :clearable="false"
                      v-model="item.prefix_name_id"
                    >
                    </v-select>
                    <div class="fv-plugins-message-container">
                      <div class="fv-help-block">
                        <ErrorMessage name="prefix_name" />
                      </div>
                    </div>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label for="firstname" class="required form-label"
                      >ชื่อ</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="ชื่อ"
                      aria-label="ชื่อ/Firstname"
                      v-model="item.firstname"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.firstname.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.firstname.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-4 mb-7">
                    <label for="lastname" class="required form-label"
                      >นามสกุล</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="นามสกุล"
                      aria-label="นามสกุล/Lastname"
                      v-model="item.lastname"
                    />
                    <div class="d-block mt-1" v-if="errors.lastname.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.lastname.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="line_id" class="form-label"
                      >รหัสเจ้าหน้าที่</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="รหัสเจ้าหน้าที่"
                      aria-label="รหัสเจ้าหน้าที่"
                      v-model="item.officer_code"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.officer_code.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.officer_code.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="line_id" class="form-label required"
                      >เลขบัตรประจำตัวประชาชน</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="เลขบัตรประจำตัวประชาชน"
                      aria-label="เลขบัตรประจำตัวประชาชน"
                      v-model="item.id_card"
                    />
                    <div class="d-block mt-1" v-if="errors.id_card.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.id_card.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="birthday" class="form-label"
                      >วันเดือนปีเกิด</label
                    >
                    <VueDatePicker
                      v-model="item.birthday"
                      :max-date="new Date()"
                      :enable-time-picker="false"
                      placeholder="วันเดือนปีเกิด(พ.ศ.)"
                      :locale="'th'"
                      auto-apply
                      class="form-control"
                      :format="format"
                    >
                      <template #year-overlay-value="{ text }">
                        {{ parseInt(text) + 543 }}
                      </template>

                      <template #year="{ value }">
                        {{ value + 543 }}
                      </template>
                    </VueDatePicker>
                    <div class="d-block mt-1" v-if="errors.birthday.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.birthday.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="phone_number" class="form-label required"
                      >เบอร์โทรศัพท์</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      placeholder="โทรศัพท์"
                      aria-label="โทรศัพท์"
                      v-model="item.phone_number"
                    />
                    <div
                      class="d-block mt-1"
                      v-if="errors.phone_number.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.phone_number.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="email" class="form-label required">อีเมล</label>
                    <input
                      type="text"
                      class="form-control"
                      placeholder="อีเมล"
                      aria-label="อีเมล/Email"
                      v-model="item.email"
                    />
                    <div class="d-block mt-1" v-if="errors.email.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.email.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="line_id" class="form-label">Line ID</label>
                    <input
                      type="text"
                      class="form-control"
                      placeholder="Line ID"
                      aria-label="Line ID"
                      v-model="item.line_id"
                    />
                    <div class="d-block mt-1" v-if="errors.line_id.error == 1">
                      <span role="alert" class="text-danger">{{
                        errors.line_id.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-12 mb-7">
                    <label for="organization_all" class="form-label required"
                      >หน่วยงาน</label
                    >
                    <v-select
                      name="organization_all"
                      placeholder="หน่วยงาน/Organization"
                      :options="selectOptions.organizations"
                      class="form-control"
                      :clearable="false"
                      v-model="item.organization_all"
                    >
                    </v-select>
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.position_id.text
                      }}</span>
                    </div>
                  </div>

                  <div class="col-md-6 mb-7">
                    <label for="position_id" class="form-label required"
                      >ตำแหน่ง</label
                    >
                    <v-select
                      label="name_th"
                      name="position_id"
                      placeholder="ตำแหน่ง"
                      :options="selectOptions.positions"
                      class="form-control form-control-lg"
                      :clearable="false"
                      v-model="item.position_id"
                    >
                    </v-select>
                    <div
                      class="d-block mt-1"
                      v-if="errors.position_id.error == 1"
                    >
                      <span role="alert" class="text-danger">{{
                        errors.position_id.text
                      }}</span>
                    </div>
                  </div> -->

                  <div class="col-md-12 mb-7">
                    <button
                      class="finish-button btn text-white btn-success"
                      @click="onSavePermissionOrg()"
                    >
                      บันทึก
                    </button>
                    <button
                      class="btn text-white btn-danger ms-2"
                      @click="onClose"
                      data-bs-dismiss="modal"
                      aria-label="Close"
                    >
                      ยกเลิก
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  ref,
  reactive,
  onMounted,
  onUnmounted,
  watch,
} from "vue";
// Import Modal Bootstrap
import { Modal } from "bootstrap";
import ApiService from "@/core/services/ApiService";

// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";

// Import route
import { useRoute, useRouter } from "vue-router";

// Import Yup Validate
import * as Yup from "yup";
// Use Toast Composables
import useToast from "@/composables/useToast";

// Use Composables
import useBasicData from "@/composables/useBasicData";
import useOrganizationData from "@/composables/useOrganizationData";

export default defineComponent({
  name: "add-permission-org",
  components: {
    vSelect,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;
    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);

    const selectOptions = ref({
      roles: [],
      source_orgs: [],
      resp_orgs: [],
      inspectors: [],
      bureaus: [],
      divisions: [],
      agencys: [],
      division_organizations: useOrganizationData().division_organizations,
    });

    const item = reactive<any>({});
    const errors = ref<any>({
      prefix_name_id: { error: 0, text: "" },
      firstname: { error: 0, text: "" },
      lastname: { error: 0, text: "" },
    });

    // Fetch
    const fetchInspector = async () => {
      const { data } = await ApiService.query("inspector", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.inspectors = data.data;
    };
    const fetchBureau = async () => {
      const { data } = await ApiService.query("bureau", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.bureaus = data.data;
    };
    const fetchDivision = async () => {
      const { data } = await ApiService.query("division", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
        },
      });
      selectOptions.value.divisions = data.data;
    };

    const fetchAgency = async () => {
      const { data } = await ApiService.query("agency", {
        params: {
          perPage: 100000,
          orderBy: "name_th",
          order: "asc",
          //   division_id: search.value.division_id?.id,
        },
      });
      selectOptions.value.agencys = data.data.map((x: any) => {
        let division = selectOptions.value.division_organizations.find(
          (e: any) => {
            return e.division_id == x.division_id;
          }
        );

        x.name_th = x.name_th + " > " + (division ? division.division_th : "");

        return x;
      });
    };

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
            return x.id != 6 && x.id != 7 && x.id != 1 && x.id != 2;
          });
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    //Event
    const onClose = () => {
      mainModalObj.value.hide();
      emit("close-modal");
    };

    const onSavePermissionOrg = async () => {
      //
      console.log(item);
      let data_item = {
        role_id: item.role_id?.id ?? undefined,
        inspector_id: item.inspector_id?.id ?? undefined,
        bureau_id: item.bureau_id?.id ?? undefined,
        division_id: item.division_id?.id ?? undefined,
        // resp
        resp_bureau_id: item.resp_bureau_id?.id ?? undefined,
        resp_division_id: item.resp_division_id?.id ?? undefined,
        resp_agency_id: item.resp_agency_id?.id ?? undefined,
        is_active: 1
      };
      console.log(data_item);

      await ApiService.post("/organization-permission", { ...data_item })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          // Swal
          useToast("เพิ่มข้อมูลเสร็จสิ้น", "success");
          emit("reload");
          emit("close-modal");
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    // Mounted
    onMounted(async () => {
      fetchRole();
      fetchInspector();
      fetchBureau();
      fetchDivision();
      fetchAgency();
      mainModalObj.value = new Modal(mainModalRef.value, {});
      mainModalObj.value.show();
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Watch

    watch(
      () => item.role_id,
      (value: any) => {
        if (value) {
          if (value.id == 5) {
            selectOptions.value.source_orgs = [
              ...selectOptions.value.inspectors,
            ];
            selectOptions.value.resp_orgs = [...selectOptions.value.bureaus];
          }

          if (value.id == 3) {
            selectOptions.value.source_orgs = [...selectOptions.value.bureaus];
            selectOptions.value.resp_orgs = [...selectOptions.value.divisions];
          }

          if (value.id == 4) {
            selectOptions.value.source_orgs = [
              ...selectOptions.value.divisions,
            ];
            selectOptions.value.resp_orgs = [...selectOptions.value.agencys];
          }
        }
      }
    );

    watch(
      () => item.source_org,
      () => {
        if (Object.keys(item).length !== 0) {
          if (item.role_id.id == 5) {
            item.inspector_id = item.source_org;
            item.bureau_id = null;
            item.division_id = null;
          }

          if (item.role_id.id == 3) {
            item.bureau_id = item.source_org;
            item.inspector_id = null;
            item.division_id = null;
          }

          if (item.role_id.id == 4) {
            item.division_id = item.source_org;
            item.bureau_id = null;
            item.inspector_id = null;
          }
        }
      }
    );

    watch(
      () => item.resp_org,
      () => {
        if (Object.keys(item).length !== 0) {
          if (item.role_id.id == 5) {
            item.resp_bureau_id = item.resp_org;
            item.resp_division_id = null;
            item.resp_agency_id = null;
          }

          if (item.role_id.id == 3) {
            item.resp_bureau_id = null;
            item.resp_division_id = item.resp_org;
            item.resp_agency_id = null;
          }

          if (item.role_id.id == 4) {
            item.resp_division_id = null;
            item.resp_bureau_id = null;
            item.resp_agency_id = item.resp_org;
          }
        }
      }
    );

    // Return
    return {
      item,
      errors,
      selectOptions,
      onClose,
      mainModalRef,
      onSavePermissionOrg,
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

.color-primary {
  color: #800001;
}
</style>
