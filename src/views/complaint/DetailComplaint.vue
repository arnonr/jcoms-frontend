<template>
  <div class="modal fade" tabindex="-1" ref="mainModalRef" id="main-modal">
    <div class="modal-dialog modal-dialog-centered modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รายละเอียด</h3>
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
              <Detail :complaint_id="prop.complaint_id" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, onUnmounted } from "vue";

// Import Modal Bootstrap
import { Modal } from "bootstrap";

// Import Component
import Detail from "./Detail.vue";

export default defineComponent({
  name: "detail-complaint",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    Detail,
  },
  setup(props, context) {
    // Variable
    const emit = context.emit;

    const mainModalRef = ref<any>(null);
    const mainModalObj = ref<any>(null);
    const mounted_success = ref<boolean>(false);

    const complaint_type = useComplaintTypeData().complaint_types.find(
      (x: any) => x.id == 1 //Number(route.query.type_id)
    );

    // Validate Schema
    const validationItemSchema = Yup.object().shape({
      receive_doc_no: Yup.string().nullable().label("ประเภทระบุตัวตน"),
      receive_doc_date: Yup.date().nullable().label("วันที่รับหนังสือ"),
    });

    // Item Variable
    const item = reactive<any>({
      id: null,
      receive_doc_no: null,
      receive_doc_date: null,
    });

    // Item Errors
    const item_errors = reactive<any>({
      receive_doc_no: { error: 0, text: "" },
      receive_doc_date: { error: 0, text: "" },
    });

    //Fetch
    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );
        item.id = data.data.id;
        item.receive_doc_no = data.data.receive_doc_no;
        item.receive_doc_date = data.data.receive_doc_date;
        // Object.assign(item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    // Event
    const onValidate = async (type: number) => {
      Object.assign(item_errors, {
        receive_doc_no: { error: 0, text: "" },
        receive_doc_date: { error: 0, text: "" },
      });

      try {
        await validationItemSchema.validate(item, {
          abortEarly: false,
        });
      } catch (err: any) {
        err.inner.forEach((error: any) => {
          const fieldName = error.path;
          const errorMessage = error.message;
          item_errors[fieldName].error = 1;
          item_errors[fieldName].text = errorMessage;
        });
        console.log(item_errors);
        useToast("ระบุข้อมูลไม่ครบถ้วน", "error");
        return false;
      }

      if (type == 1) {
        // 1 == รับเรื่อง
        onSaveComplaint(type);
      } else {
        // type == 0 คือ ไม่รับเรื่อง
        Swal.fire({
          title: "โปรดระบุเหตุผล",
          input: "select",
          inputOptions: {
            1: "ข้อมูลไม่ครบถ้วน1",
            2: "ข้อมูลไม่ครบถ้วน2",
          },
          inputPlaceholder: "เลือกเหตุผล",
          showCancelButton: true,
          confirmButtonText: "ยืนยัน",
          cancelButtonText: `ยกเลิก`,
          customClass: {
            confirmButton: "btn fw-semibold btn-light-success",
            cancelButton: "btn fw-semibold btn-light-danger",
          },
        }).then(async (result: any) => {
          if (result.isConfirmed) {
            let comment = Number(result.value);
            await onSaveComplaint(type);
          } else if (result.isDenied) {
          }
        });
      }

      return true;
    };

    const onSaveComplaint = async (type: number) => {
      let data_item = {
        receive_doc_no: item.receive_doc_no,
        receive_doc_date: item.receive_doc_date,
        // state
        // comment
        // comment ถ้า error
        // เหตุผลไม่รับเรื่อง
      };

      await ApiService.put("complaint/" + item.id, data_item)
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          useToast("บันทึกข้อมูลเสร็จสิ้น", "success");
          onClose();
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const onClose = () => {
      mainModalObj.value.hide();
      emit("reload");
      emit("close-modal");
    };

    onMounted(async () => {
      try {
        mainModalObj.value = new Modal(mainModalRef.value, {});
        mainModalObj.value.show();
        await fetchComplaint();
        mounted_success.value = true;
      } catch (error) {
        console.error("Error:", error);
      }
    });

    onUnmounted(() => {
      mainModalObj.value.hide();
      emit("close-modal");
    });

    // Watch

    // Return
    return {
      // items
      item,
      //   errors
      item_errors,
      complaint_type,
      // event
      onValidate,
      onClose,
      mainModalRef,
      mounted_success,
      format,
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
</style>
