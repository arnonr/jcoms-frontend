<template>
  <!--begin::Wrapper-->
  <div class="container">
    <!-- color="#ffcb05" -->
    <!-- disable-back -->
    <!-- hide-buttons -->
    <form-wizard
      ref="formStep"
      finishButtonText="บันทึก"
      backButtonText="ย้อนกลับ"
      nextButtonText="ถัดไป"
    >
      <tab-content title="ระบุข้อมูล">
        <div class="row">
          <!--begin::Input group-->
          <div class="mb-5"><h4>1. ข้อมูลส่วนตัว</h4></div>

          <div class="input-group input-group mb-7">
            <span class="me-5 fs-5 mb-2">ประเภทการระบุตัวตน</span>
            <div
              class="form-check form-check-custom form-check-solid me-5 mb-2"
            >
              <input
                class="form-check-input"
                name="ty    pe_of_identity"
                type="radio"
                value="1"
                checked
                v-model="item.type_of_identity"
                id="flexCheckboxLg"
              />
              <label class="form-check-label fs-5" for="flexCheckboxLg">
                แบบระบุตัวตน
              </label>
            </div>
            <div class="form-check form-check-custom form-check-solid">
              <input
                class="form-check-input"
                name="type_of_identity"
                type="radio"
                value="2"
                v-model="item.type_of_identity"
                id="flexCheckboxLg"
              />
              <label class="form-check-label fs-5" for="flexCheckboxLg">
                แบบไม่ระบุตัวตน
              </label>
            </div>
          </div>

          <div class="mb-7 col-12 col-lg-4" v-if="item.type_of_identity == 1">
            <label for="exampleFormControlInput1" class="required form-label"
              >ประเภทเอกสาร</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="ประเภทเอกสาร"
              :options="selectOptions.type_of_document"
              class="form-control"
              :clearable="false"
              v-model="item.type_of_document_id"
            >
            </v-select>
          </div>

          <div class="mb-7 col-12 col-lg-8" v-if="item.type_of_identity == 1">
            <label for="exampleFormControlInput1" class="required form-label"
              >หมายเลขบัตรประชาชน/หนังสือเดินทาง</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
              aria-label="หมายเลขบัตรประชาชน/หนังสือเดินทาง"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-7 col-12 col-lg-2" v-if="item.type_of_identity == 1">
            <label for="prefix_name" class="required form-label"
              >คำนำหน้า</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="คำนำหน้า"
              :options="selectOptions.prefix_name"
              class="form-control"
              :clearable="false"
              v-model="item.prefix_name"
            >
            </v-select>
          </div>

          <div class="mb-7 col-12 col-lg-5" v-if="item.type_of_identity == 1">
            <label for="firstanme" class="required form-label">ชื่อ</label>
            <input
              type="text"
              class="form-control"
              placeholder="ชื่อ"
              aria-label="ชื่อ"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-7 col-12 col-lg-5" v-if="item.type_of_identity == 1">
            <label for="surname" class="required form-label">นามสกุล</label>
            <input
              type="text"
              class="form-control"
              placeholder="นามสกุล"
              aria-label="นามสกุล"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-7 col-12 col-lg-4" v-if="item.type_of_identity == 1">
            <label for="surname" class="form-label">วัน/เดือน/ปีเกิด</label>
            <VueDatePicker
              :max-date="new Date()"
              v-model="item.inspection_date"
              :enable-time-picker="false"
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
          </div>

          <div class="mb-7 col-12 col-lg-4" v-if="item.type_of_identity == 1">
            <label for="surname" class="form-label">อาชีพ</label>
            <input
              type="text"
              class="form-control"
              placeholder="อาชีพ"
              aria-label="อาชีพ"
              aria-describedby="basic-addon2"
            />
          </div>

          <div
            class="mb-7 col-12 col-lg-4"
            :class="[item.type_of_identity == 1 ? 'col-lg-4' : 'col-lg-12']"
          >
            <label for="surname" class="required form-label"
              >หมายเลขโทรศัพท์มือถือ</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="หมายเลขโทรศัพท์มือถือ"
              aria-label="นามสกุล"
              aria-describedby="basic-addon2"
            />
          </div>

          <!-- <div class="separator my-10"></div> -->

          <div class="mb-7 col-12 col-lg-6" v-if="item.type_of_identity == 1">
            <label for="surname" class="required form-label"
              >ที่อยู่ติดต่อได้</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="ที่อยู่"
              aria-label="ที่อยู่"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-5 col-12 col-lg-6" v-if="item.type_of_identity == 1">
            <label for="surname" class="required form-label"
              >ตำบล/อำเภอ/จังหวัด :</label
            >

            <v-select
              :label="'label'"
              placeholder="จังหวัด/อำเภอ/ตำบล"
              :options="selectOptions.address_all"
              item-value="id"
              id="slt-province-amphur-tumbol"
              v-model="item.address_all"
              class="form-control v-select-no-border"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7 col-12 col-lg-12" v-if="item.type_of_identity == 1">
            <label for="formFile" class="form-label"
              >ถ่ายรูปตนเองพร้อมบัตร</label
            >
            <input class="form-control" type="file" id="formFile" />
          </div>

          <div class="separator my-10"></div>
          <div class="mb-5"><h4>2. ข้อมูลร้องเรียน/แจ้งเบาะแส</h4></div>

          <div class="mb-7 col-12 col-lg-12">
            <label for="surname" class="required form-label"
              >เรื่องร้องเรียน/แจ้งเบาะแส</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="เรื่องร้องเรียน/แจ้งเบาะแส"
              aria-label="เรื่องร้องเรียน/แจ้งเบาะแส"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-7 col-12 col-lg-6">
            <label for="surname" class="required form-label"
              >สถานที่เกิดเหตุ</label
            >
            <v-select
              :label="'label'"
              placeholder="จังหวัด/อำเภอ/ตำบล"
              :options="selectOptions.address_all"
              item-value="id"
              id="slt-province-amphur-tumbol"
              v-model="item.address_all"
              class="form-control v-select-no-border"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7 col-12 col-lg-6">
            <label for="surname" class="required form-label"
              >บันทึกข้อมูลสถานที่เกิดเหตุโดยละเอียด</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="บันทึกข้อมูลสถานที่เกิดเหตุ"
              aria-label="บันทึกข้อมูลสถานที่เกิดเหตุ"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >วันที่เกิดเหตุ</label
            >
            <VueDatePicker
              :max-date="new Date()"
              v-model="item.inspection_date"
              :enable-time-picker="false"
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
          </div>
          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >เวลาเกิดเหตุ</label
            >
            <input
              type="text"
              class="form-control"
              placeholder="เวลาเกิดเหตุ"
              aria-label="เวลาเกิดเหตุ"
              aria-describedby="basic-addon2"
            />
          </div>
          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >ห้วงเวลาเกิดเหตุ</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="ห้วงเวลาเกิดเหตุ"
              :options="selectOptions.dayornight"
              class="form-control"
              :clearable="false"
              v-model="item.day_or_night"
            >
            </v-select>
          </div>

          <div class="col-12">
            <div class="row mb-7">
              <div class="mb-3 col-12 col-lg-2">
                <label for="surname" class="required form-label"
                  >ผู้ถูกร้อง</label
                >
                <v-select
                  label="name"
                  name="id"
                  placeholder="คำนำหน้า(ยศ)"
                  :options="selectOptions.prefix_name_1"
                  class="form-control"
                  :clearable="false"
                  v-model="item.prefix_name_1"
                >
                </v-select>
              </div>
              <div class="mb-3 col-12 col-lg-5">
                <label for="surname" class="required form-label">ชื่อ</label>
                <input
                  type="text"
                  class="form-control"
                  placeholder="ชื่อ"
                  aria-label="ชื่อ"
                  aria-describedby="basic-addon2"
                />
              </div>
              <div class="mb-3 col-12 col-lg-5">
                <label for="surname" class="required form-label">นามสกุล</label>
                <input
                  type="text"
                  class="form-control"
                  placeholder="นามสกุล"
                  aria-label="นามสกุล"
                  aria-describedby="basic-addon2"
                />
              </div>
              <div class="mb-1 col-12 col-lg-12">
                <label for="surname" class="required form-label"
                  >หน่วยงาน</label
                >
                <v-select
                  label="name"
                  name="id"
                  placeholder="หน่วยงาน"
                  :options="selectOptions.organizations"
                  class="form-control"
                  :clearable="false"
                  v-model="item.organization"
                >
                </v-select>
              </div>
              <a href="#" class="mt-2"><span>+ เพิ่มผู้ถูกร้องเรียน</span></a>
            </div>
          </div>

          <div class="mb-7 col-12 col-lg-12">
            <label for="surname" class="required form-label"
              >บรรยายพฤติกรรมการกระทำความผิด</label
            >
            <textarea
              style="height: 150px"
              type="text"
              class="form-control"
              placeholder="บรรยายพฤติกรรมการกระทำความผิด"
              aria-label="บรรยายพฤติกรรมการกระทำความผิด"
              aria-describedby="basic-addon2"
            />
          </div>

          <div class="col-12">
            <div class="mb-7 row">
              <div class="col-12 col-lg-12">
                <label for="formFile" class="form-label"
                  >แนบไฟล์หลักฐานเพิ่มเติม</label
                >
                <input class="form-control" type="file" id="formFile" />
              </div>
              <a href="#" class="mt-5"><span>+ เพิ่มไฟล์หลักฐาน</span></a>
            </div>
          </div>

          <div class="mb-7 col-12 col-lg-12">
            <label for="surname" class="form-label"
              >เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด</label
            >
            <div class="d-flex">
              <div class="form-check">
                <input
                  class="form-check-input"
                  type="checkbox"
                  value=""
                  id="flexCheckDefault"
                />
                <label class="form-check-label" for="flexCheckDefault">
                  ศูนย์ดำรงธรรม
                </label>
              </div>
              <div class="form-check ms-5">
                <input
                  class="form-check-input"
                  type="checkbox"
                  value=""
                  id="flexCheckDefault"
                />
                <label class="form-check-label" for="flexCheckDefault">
                  สายด่วน 1599
                </label>
              </div>
              <div class="form-check ms-5">
                <input
                  class="form-check-input"
                  type="checkbox"
                  value=""
                  id="flexCheckDefault"
                />
                <label class="form-check-label" for="flexCheckDefault">
                  ศูนย์รับเรื่องราวร้องทุกข์ของรัฐบาล 1111
                </label>
              </div>
            </div>
          </div>

          <div class="separator my-10"></div>
          <div class="mb-5 mt-5">
            <h4>3. เจ้าหน้าที่ระบุข้อมูลเพิ่มเติม</h4>
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >วันที่รับเรื่อง</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="ห้วงเวลาเกิดเหตุ"
              :options="selectOptions.dayornight"
              class="form-control"
              :clearable="false"
              v-model="item.day_or_night"
            >
            </v-select>
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >เลขรับหนังสือ ฝรท.</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="ห้วงเวลาเกิดเหตุ"
              :options="selectOptions.dayornight"
              class="form-control"
              :clearable="false"
              v-model="item.day_or_night"
            >
            </v-select>
          </div>
          <div class="mb-7 col-12 col-lg-4">
            <label for="surname" class="required form-label"
              >ช่องทางการรับเรื่อง</label
            >
            <v-select
              label="name"
              name="id"
              placeholder="ห้วงเวลาเกิดเหตุ"
              :options="selectOptions.dayornight"
              class="form-control"
              :clearable="false"
              v-model="item.day_or_night"
            >
            </v-select>
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="">หมวดหมู่เรื่อง : </label>
            <v-select
              id="slt-search-complain-type-id-2"
              name="slt-search-complain-type-id-2"
              label="name"
              placeholder="หมวดหมู่เรื่อง"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="">ประเภทเรื่อง : </label>
            <v-select
              id="slt-search-topic-type-id-2"
              name="slt-search-topic-type-id-2"
              label="name"
              placeholder="ประเภทเรื่อง"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7 col-12 col-lg-4">
            <label for="">ลักษณะเรื่อง : </label>
            <v-select
              id="slt-search-topic-category-id-2"
              name="slt-search-topic-category-id-2"
              label="name"
              placeholder="ลักษณะเรื่อง"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>
        </div>
      </tab-content>
      <tab-content title="ยืนยันข้อมูล">
        <div class="row">
          <div class="mb-5"><h4>1. ข้อมูลส่วนตัว</h4></div>
          <div v-if="item.type_of_identity == 1">
            <span>หมายเลขบัตรประชาชน/หนังสือเดินทาง : </span>
            <span class="fst-italic">1100200629414</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>ชื่อ-นามกุล ผู้ร้อง : </span>
            <span class="fst-italic">นายอานนท์ รักจักร์</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>วัน/เดือน/ปีเกิด : </span>
            <span class="fst-italic">19 มีนาคม 2534</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>อาชีพ : </span>
            <span class="fst-italic">พนักงานบริษัท</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>หมายเลขโทรศัพท์มือถือ : </span>
            <span class="fst-italic">0802112900</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>ที่อยู่ที่สามารถติดต่อได้ : </span>
            <span class="fst-italic">705 ซ.จรัญสนิทวงศ์ 89</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>ตำบล/อำเภอ/จังหวัด : </span>
            <span class="fst-italic">แขวงบางอ้อ เขตบางพลัด กทม. 10700</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div v-if="item.type_of_identity == 1">
            <span>รูปถ่ายพร้อมบัตร : </span>
            <span class="fst-italic">IMG</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="mb-5 mt-5">
            <h4>2. ข้อมูลร้องเรียน/แจ้งเบาะแส</h4>
          </div>
          <div>
            <span>เรื่องร้องเรียน/แจ้งเบาะแส : </span>
            <span class="fst-italic">โดนเจ้าหน้าที่ทำร้ายร่างกาย</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>สถานที่เกิดเหตุ : </span>
            <span class="fst-italic">แขวงบางอ้อ เขตบางพลัด กทม. 10700</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>ข้อมูลสถานที่เกิดเหตุ : </span>
            <span class="fst-italic">..........</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>วันที่เกิดเหตุ : </span>
            <span class="fst-italic"
              >15 กุมภาพันธ์ 2567 เวลา 16.00 น. (กลางวัน)</span
            >
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>ผู้ถูกร้อง : </span>
            <span class="fst-italic">พล.ต.ท สมชาย รักดี</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div>
            <span>หน่วยงานผู้ถูกร้อง : </span>
            <span class="fst-italic"
              >สถานีตำรวจภูธรเจาะไอ้ร้อง > บก... > บช.. > สังกัด ...</span
            >
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div>
            <span>พฤติกรรมการกระทำความผิด : </span>
            <span class="fst-italic">............</span>
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div>
            <span>ไฟล์หลักฐานเพิ่มเติม : </span>
            <span class="fst-italic">PDF</span>
            <div class="separator separator-dotted my-2"></div>
          </div>

          <div>
            <span>ไฟล์หลักฐานเพิ่มเติม : </span>
            <span class="fst-italic">PDF</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>
      </tab-content>
    </form-wizard>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, ref } from "vue";
import { ErrorMessage, Field, Form as VForm } from "vee-validate";
import { useAuthStore, type User } from "@/stores/auth";
import { useRouter } from "vue-router";
import Swal from "sweetalert2/dist/sweetalert2.js";
import * as Yup from "yup";
import { FormWizard, TabContent } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
import useAddressData from "@/composables/useAddressData";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

export default defineComponent({
  name: "add-complaint",
  components: {
    Field,
    VForm,
    ErrorMessage,
    FormWizard,
    TabContent,
    vSelect,
    VueDatePicker,
    dayjs,
  },
  setup() {
    const store = useAuthStore();
    const router = useRouter();

    const address_all = ref([]);
    address_all.value = useAddressData().addresses.map((el) => {
      el.label =
        el.district +
        " > " +
        el.amphoe +
        " > " +
        el.province +
        " > " +
        el.zipcode;
      return el;
    });

    const format = (date: any) => {
      const day = dayjs(date).locale("th").format("DD");
      const month = dayjs(date).locale("th").format("MMM");
      const year = date.getFullYear() + 543;
      return `${day} ${month} ${year}`;
    };

    const selectOptions = {
      type_of_document: [
        {
          name: "หมายเลขบัตรประชาชน",
          value: 1,
        },
        {
          name: "หนังสือเดินทาง",
          value: 2,
        },
      ],
      prefix_name: [
        { name: "นาย", value: 1 },
        { name: "นาง", value: 1 },
        { name: "นางสาว", value: 1 },
      ],
      prefix_name_1: [
        { name: "พล.ต.อ.", value: 1 },
        { name: "พล.ต.ท.", value: 2 },
        { name: "พล.ต.ต.", value: 3 },
      ],
      address_all: address_all.value,
      dayornight: [
        {
          name: "กลางวัน",
          value: 1,
        },
        { name: "กลางคืน", value: 2 },
      ],
      organizations: [
        {
          name: "สถานีตำรวจภูธรเจาะไอ้ร้อง > บก... > บช.. > สังกัด ...",
          value: 1,
        },
        {
          name: "สถานีตำรวจภูธรจักราช > บก... > บช.. > สังกัด ...",
          value: 2,
        },
      ],
    };
    const item = ref<any>({
      organization: "",
      type_of_document_id: "",
      type_of_identity: 1,
      name: "",
      id_number: "",
      id_file: "",
      address_all: "",
      prefix_name_1: "",
      prefix_name: "",
      inspection_date: "",
      day_or_night: "",
    });

    const submitButton = ref<HTMLButtonElement | null>(null);

    //Create form validation object
    const login = Yup.object().shape({
      email: Yup.string().email().required().label("Email"),
      password: Yup.string().min(4).required().label("Password"),
    });

    //Form submit function
    return {
      login,
      submitButton,
      getAssetPath,
      selectOptions,
      item,
      format,
    };
  },
});
</script>

<style>
.vs__dropdown-toggle {
  border: none;
}

.v-select {
  padding: 0.4em 0.5em;
}

.dp__main {
  padding: 0.35em 0em;
}

.dp__input {
  border: none !important;
}
@media only screen and (max-width: 768px) {
  .card > .card-body {
    padding: 0px;
  }
}
</style>
