<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <div class="card-header bg-white d-flex">
        <h4 class="card-title">ค้นหาเรื่องร้องเรียน</h4>
      </div>
      <div class="card-body">
        <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
          <div class="col-12 col-md-4 my-2">
            <label for="">ปีที่ร้องเรียน</label>
            <v-select
              id="slt-search-year"
              name="slt-search-year"
              label="name"
              placeholder="ปีที่ร้องเรียน"
              :options="selectOptions.years"
              v-model="search.year"
              :reduce="(year) => year.value"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">เรื่องร้องเรียน</label>
            <input
              type="text"
              id="txt-search-complain-title"
              name="txt-search-complain-title"
              class="form-control"
              v-model="search.complaint_title"
            />
          </div>
          <div class="col-12 col-md-4 my-2">
            <label for="">เลขคำร้องเรียน (Jcom No)</label>
            <input
              type="text"
              id="txt-search-complain-code"
              name="txt-search-complain-code"
              class="form-control"
              v-model="search.jcoms_no"
            />
          </div>
          <div class="col-12 col-md-4 my-2">
            <label for="">ชื่อผู้ร้อง</label>
            <input
              type="text"
              id="txt-search-complain-fullname"
              name="txt-search-complain-fullname"
              class="form-control"
              v-model="search.complainant_fullname"
            />
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">ชื่อผู้ถูกร้อง</label>
            <input
              type="text"
              id="txt-search-accused-fullname"
              name="txt-search-accused-fullname"
              class="form-control"
              v-model="search.accused_fullname"
            />
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">สถานะเรื่องร้องเรียน</label>
            <v-select
              id="slt-search-state-id"
              name="slt-search-state-id"
              label="name_th"
              placeholder="สถานะเรื่องร้องเรียน"
              :options="selectOptions.states"
              v-model="search.state_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">บช./ภ.</label>
            <v-select
              id="slt-search-bureau-id"
              name="slt-search-bureau-id"
              label="name_th"
              placeholder="บช./ภ."
              :options="selectOptions.bureaus"
              v-model="search.bureau_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">บก./ภ.จว.</label>
            <v-select
              id="slt-search-division-id"
              name="slt-search-division-id"
              label="name_th"
              placeholder="บก./ภ.จว."
              :options="selectOptions.divisions"
              v-model="search.division_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="col-12 col-md-4 my-2">
            <label for="">หน่วยงาน(สถานีตำรวจ)</label>
            <v-select
              id="slt-search-agency-id"
              name="slt-search-agency-id"
              label="name_th"
              placeholder="หน่วยงาน(สถานีตำรวจ)"
              :options="selectOptions.agencies"
              v-model="search.agency_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>
        </div>

        <!-- FORM -->
      </div>
      <div class="card-footer">
        <button class="btn btn-success fw-bold" @click="onSearch()">
          ค้นหา
        </button>
        <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
          ล้าง
        </button>
        <!-- data-bs-toggle="modal" data-bs-target="#modal-search" -->
        <button
          id="kt_search_toggle"
          class="btn btn-primary fw-bold float-end"
          data-bs-toggle="tooltip"
          data-bs-placement="left"
          data-bs-dismiss="click"
          data-bs-trigger="hover"
        >
          ค้นหาเพิ่มเติม
        </button>
      </div>
    </div>

    <div class="row">
      <div class="col-12 mb-3 mt-5">
        <h4>เรื่องร้องเรียนทั้งหมด {{ totalItems }} เรื่อง</h4>
      </div>
      <div
        class="col-md-6 col-lg-6 col-xl-6 col-xxl-3 mb-4"
        v-for="(it, idx) in cardStatus"
        :key="idx"
      >
        <a
          class="cursor-pointer"
          @click="
            () => {
              search.status = it.status_id;
              onSearch();
            }
          "
        >
          <Widget1Custom
            className=""
            :description="it.description"
            :bgColor="it.bgColor"
            :total="it.total"
            :percentage="it.percentage"
          />
        </a>
      </div>
    </div>

    <div class="card shadow-sm my-5">
      <div class="card-header bg-white">
        <h4 class="card-title">รายการเรื่องร้องเรียน</h4>
        <div class="card-toolbar">
          <button
            class="btn btn-outline btn-outline-primary me-2 pe-sm-3 ps-sm-5"
            @click="onAddModal()"
          >
            <i class="bi bi-file-earmark-plus-fill fs-4"></i>
            <span class="d-none d-lg-inline-block ms-2"
              >เพิ่มเรื่องร้องเรียน</span
            >
          </button>

          <div class="dropdown">
            <button
              class="btn btn-outline btn-outline-success pe-sm-3 ps-sm-5 dropdown-toggle"
              type="button"
              id="dropdownMenuButton"
              data-bs-toggle="dropdown"
              aria-expanded="false"
            >
              <i class="bi bi-file-earmark-arrow-down-fill fs-4"></i>
              <span class="d-none d-lg-inline-block ms-2">ส่งออกข้อมูล</span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
              <!-- <li><a class="dropdown-item" href="#">PDF</a></li> -->
              <li><a class="dropdown-item" @click="onExport()">Excel</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="card-body" style="overflow: visible">
        <!-- <div class="overflow-visible"> -->
        <table class="table table-bordered table-striped" style="width: 100%">
          <thead class="bg-color-police">
            <tr>
              <th class="text-center text-white">วันที่ร้องเรียน</th>
              <th class="text-center text-white">รหัสคำร้อง</th>
              <th class="text-center text-white">ลักษณะความผิด</th>
              <th class="text-center text-white">เรื่องร้องเรียน</th>
              <th class="text-center text-white">ผู้ถูกร้อง</th>
              <th class="text-center text-white">หน่วยงานถูกร้อง</th>
              <th class="text-center text-white">สถานะ</th>
              <th class="text-center text-white">จัดการข้อมูล</th>
            </tr>
          </thead>
          <tbody v-if="items.length != 0">
            <tr v-for="(it, idx) in items" :key="idx">
              <td class="text-center">
                {{ convert_date(it.created_at) }}
              </td>
              <td class="text-center">{{ it.jcoms_no }}</td>

              <td class="text-center">{{ it.topic_type?.name_th }}</td>
              <td>{{ it.complaint_title }}</td>
              <td>{{ showAccused(it.accused) }}</td>
              <td>
                <span v-if="it.agency_id">{{ it.agency.name_th }}</span>
                <span v-else-if="it.division_id">{{
                  it.division.name_th
                }}</span>
                <span v-else-if="it.bureau_id">{{ it.bureau.name_th }}</span>
                <span v-else-if="it.inspector_id">{{
                  it.inspector.name_th
                }}</span>
                <span v-else></span>
              </td>
              <td class="text-center">
                <span
                  class="badge p-2 text-white"
                  :style="`background-color: ${
                    showState(it.state_id).bg_color
                  };`"
                  >{{ showState(it.state_id).name_th }}</span
                >
              </td>

              <td class="text-center">
                <div class="dropdown">
                  <button
                    class="btn btn-primary btn-sm dropdown-toggle"
                    type="button"
                    id="dropdownMenuButton"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    <i
                      class="bi bi-pencil-square fs-4 d-sm-inline-block d-lg-none"
                    ></i>
                    <span class="d-none d-lg-inline-block">จัดการ</span>
                  </button>
                  <ul
                    class="dropdown-menu"
                    aria-labelledby="dropdownMenuButton"
                  >
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onDetailModal(it)"
                        >รายละเอียด</a
                      >
                    </li>

                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onEditModal()"
                        >แก้ไขข้อมูล</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onReceiveModal()"
                        >ฝรท. รับเรื่อง</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onReceive2Modal()"
                        >รับเรื่อง2</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onSendModal()"
                        >ส่งต่อเรื่อง</a
                      >
                    </li>

                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onTrackModal()"
                        >ติดตาม</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onReceiveReportModal()"
                        >รับรายงานผล</a
                      >
                    </li>
                    <li>
                      <a
                        class="dropdown-item cursor-pointer"
                        @click="onSendReportModal()"
                        >ส่งต่อรายงานผล</a
                      >
                    </li>
                  </ul>
                </div>
              </td>
            </tr>
          </tbody>

          <tbody v-else>
            <tr>
              <td colspan="10">
                <div class="text-center"><span>ไม่พบข้อมูล</span></div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="col-xxl-12">
          <div class="tp-pagination mt-30">
            <BlogPagination
              :totalItems="totalItems"
              :totalPage="totalPage"
              :currentPage="currentPage"
              @update:currentPage="currentPage = $event"
            />
          </div>
        </div>
        <!-- </div> -->
      </div>
    </div>
  </div>

  <!-- Modal Advanced Search -->
  <div
    id="kt_search"
    class="bg-body"
    data-kt-drawer="true"
    data-kt-drawer-name="search"
    data-kt-drawer-activate="true"
    data-kt-drawer-overlay="true"
    data-kt-drawer-width="{default:'350px', 'md': '525px'}"
    data-kt-drawer-direction="end"
    data-kt-drawer-toggle="#kt_search_toggle"
    data-kt-drawer-close="#kt_search_close"
  >
    <!--begin::Card-->
    <div class="card shadow-none rounded-0 w-100">
      <!--begin::Header-->
      <div class="card-header" id="kt_search_header">
        <h5 class="card-title fw-semibold text-gray-600">ค้นหาเพิ่มเติม</h5>

        <div class="card-toolbar">
          <button
            type="button"
            class="btn btn-sm btn-icon explore-btn-dismiss me-n5"
            id="kt_search_close"
          >
            <KTIcon icon-name="cross" icon-class="fs-2" />
          </button>
        </div>
      </div>
      <!--end::Header-->

      <!--begin::Body-->
      <div class="card-body" id="kt_search_body">
        <!--begin::Content-->
        <div
          id="kt_search_scroll"
          class="hover-scroll-overlay-y ps-5 pe-5 pt-5 ps-md-0 pe-md-0 pt-md-0"
          data-kt-scroll="true"
          data-kt-scroll-height="auto"
          data-kt-scroll-wrappers="#kt_search_body"
          data-kt-scroll-dependencies="#kt_search_header"
          data-kt-scroll-offset="5px"
        >
          <!--end::Support-->
          <!--begin::Link-->

          <h4>ค้นหาจากข้อมูลร้องเรียน</h4>
          <hr />
          <div class="mb-7">
            <label for="">ปีที่ร้องเรียน</label>
            <v-select
              id="slt-search-year-2"
              name="slt-search-year-2"
              label="name"
              placeholder="ปีที่ร้องเรียน"
              :options="selectOptions.years"
              v-model="search.year"
              :reduce="(year) => year.value"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="row">
            <div class="col-md-6 mb-7">
              <label for="">ช่วงวันที่ร้องเรียน (จากวันที่)</label>
              <VueDatePicker
                id="dp-search-startdate-2"
                name="dp-search-startdate-2"
                class="form-control"
                v-model="search.create_from"
                :enable-time-picker="false"
                locale="th"
                auto-apply
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
            <div class="col-md-6 mb-7">
              <label for="">ช่วงวันที่ร้องเรียน (ถึงวันที่)</label>
              <VueDatePicker
                id="dp-search-enddate-2"
                name="dp-search-enddate-2"
                class="form-control"
                v-model="search.create_to"
                :enable-time-picker="false"
                locale="th"
                auto-apply
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
          </div>

          <div class="mb-7">
            <label for="">เรื่องร้องเรียน : </label>
            <input
              id="txt-search-complain-title-2"
              name="txt-search-complain-title-2"
              type="text"
              class="form-control"
              v-model="search.complaint_title"
            />
          </div>

          <div class="mb-7">
            <label for="">ชื่อผู้ร้อง</label>
            <input
              id="txt-search-complain-fullname-2"
              name="txt-search-complain-fullname-2"
              type="text"
              class="form-control"
              v-model="search.complainant_fullname"
            />
          </div>

          <div class="mb-7">
            <label for="">ชื่อผู้ถูกร้อง</label>
            <input
              id="txt-search-accused-fullname-2"
              name="txt-search-accused-fullname-2"
              type="text"
              class="form-control"
              v-model="search.accused_fullname"
            />
          </div>

          <div class="row">
            <div class="col-md-6 mb-7">
              <label for="">ประเภทการระบุตัวตน</label>
              <v-select
                id="slt-search-is-anonymous-2"
                name="slt-search-is-anonymous-2"
                label="name"
                placeholder="ประเภทการระบุตัวตน"
                :options="selectOptions.is_anonymouses"
                v-model="search.is_anonymous"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>
            <div class="col-md-6 mb-7">
              <label for="">สถานะเรื่องร้องเรียน</label>
              <v-select
                id="slt-search-proceed-state-2"
                name="slt-search-procees-state-2"
                label="name_th"
                placeholder="สถานะเรื่องร้องเรียน"
                :options="selectOptions.states"
                v-model="search.state_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>
          </div>

          <h4>ค้นหาจากข้อมูลหน่วยงาน</h4>
          <hr />
          <div class="mb-7">
            <label for="">กต</label>
            <v-select
              id="slt-search-inspector-id-2"
              name="slt-search-inspector-id-2"
              label="name_th"
              placeholder="กต."
              :options="selectOptions.inspectors"
              v-model="search.inspector_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">บช./ภ.</label>
            <v-select
              id="slt-search-bureau-id-2"
              name="slt-search-bureau-id-2"
              label="name_th"
              placeholder="บช./ภ."
              :options="selectOptions.bureaus"
              v-model="search.bureau_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">บก./ภ.จว.</label>
            <v-select
              id="slt-search-division-id-2"
              name="slt-search-division-id-2"
              label="name_th"
              placeholder="บก./ภ.จว."
              :options="selectOptions.divisions"
              v-model="search.division_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">หน่วยงาน(สถานีตำรวจ)</label>
            <v-select
              id="slt-search-agency-id-2"
              name="slt-search-agency-id-2"
              label="name_th"
              placeholder="หน่วยงาน(สถานีตำรวจ)"
              :options="selectOptions.agencies"
              v-model="search.agency"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <h4>ค้นหาจากข้อมูลที่เกิดเหตุ</h4>
          <hr />

          <div class="mb-7">
            <label for="">วันที่เกิดเหตุ : </label>
            <VueDatePicker
              id="dp-search-incident-date-2"
              name="dp-search-incident-date-2"
              class="form-control"
              v-model="search.incident_date"
              :enable-time-picker="false"
              locale="th"
              auto-apply
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

          <div class="mb-7">
            <label for="">จังหวัด : </label>
            <v-select
              id="slt-search-province-id-2"
              name="slt-search-province-id-2"
              label="name_th"
              placeholder="จังหวัด"
              :options="selectOptions.provinces"
              v-model="search.province_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">อำเภอ : </label>
            <v-select
              id="slt-search-district-id-2"
              name="slt-search-district-id-2"
              label="name_th"
              placeholder="อำเภอ"
              :options="selectOptions.districts"
              v-model="search.district_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">ตำบล : </label>
            <v-select
              id="slt-search-sub-district-id-2"
              name="slt-search-sub-district-id-2"
              label="name_th"
              placeholder="ตำบล"
              :options="selectOptions.subdistricts"
              v-model="search.sub_district_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <h4>ค้นหาจากหมวดหมู่เรื่อง</h4>
          <hr />
          <div class="mb-7">
            <label for="">หมวดหมู่เรื่อง : </label>
            <v-select
              id="slt-search-complain-type-id-2"
              name="slt-search-complain-type-id-2"
              label="name_th"
              placeholder="หมวดหมู่เรื่อง"
              :options="selectOptions.complaint_types"
              v-model="search.complaint_type_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">ประเภทเรื่อง : </label>
            <v-select
              id="slt-search-topic-type-id-2"
              name="slt-search-topic-type-id-2"
              label="name_th"
              placeholder="ประเภทเรื่อง"
              :options="selectOptions.topic_categories"
              v-model="search.topic_category_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>
          <div class="mb-7">
            <label for="">ลักษณะเรื่อง : </label>
            <v-select
              id="slt-search-topic-category-id-2"
              name="slt-search-topic-category-id-2"
              label="name_th"
              :options="selectOptions.topic_types"
              v-model="search.topic_type_id"
              placeholder="ลักษณะเรื่อง"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <h4>ค้นหาจากเลขเอกสาร</h4>
          <hr />

          <div class="row">
            <div class="col-md-6 mb-7">
              <label for="">เลขที่คำร้องเรียน (Jcom No): </label>
              <input
                id="slt-search-complain-code-2"
                name="slt-search-complain-code-2"
                type="text"
                class="form-control"
                v-model="search.jcoms_no"
              />
            </div>
            <div class="col-md-6 mb-7">
              <label for="">เลขที่ POL : </label>
              <input
                id="slt-search-pol-no-2"
                name="slt-search-pol-no-2"
                type="text"
                class="form-control"
                v-model="search.pol_no"
              />
            </div>

            <div class="col-md-6 mb-7">
              <label for="">เลขรับ ฝรท. : </label>
              <input
                id="slt-search-reveice-no-2"
                name="slt-search-receive-no-2"
                type="text"
                class="form-control"
                v-model="search.receive_no"
              />
            </div>

            <div class="col-md-6 mb-7">
              <label for="">เลขที่หนังสือส่ง จต./ตร. : </label>
              <input
                id="slt-search-forward-no-2"
                name="slt-search-forward-no-2"
                type="text"
                class="form-control"
                v-model="search.forward_no"
              />
            </div>
          </div>

          <h4>ค้นหาจากข้อมูลอื่น ๆ</h4>
          <hr />
          <div class="mb-7">
            <label for="">ช่องทางการรับเรื่อง : </label>
            <v-select
              id="slt-search-complain-channel-id"
              name="slt-search-complain-channel-id"
              label="name_th"
              placeholder="ช่องทางการรับเรื่อง"
              :options="selectOptions.complaint_channels"
              v-model="search.complaint_channel_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <button class="btn btn-success fw-bold" @click="onSearch()">
              ค้นหา
            </button>
            <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
              ล้าง
            </button>
          </div>

          <!--end::Link-->
        </div>
        <!--end::Content-->
      </div>
      <!--end::Body-->
    </div>
    <!--end::Card-->
  </div>

  <!-- Modal Add -->
  <div class="modal fade" tabindex="-1" ref="addModalRef" id="add-modal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">บันทึกเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <AddComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Edit -->
  <div class="modal fade" tabindex="-1" ref="editModalRef" id="edit-modal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">แก้ไขเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <EditComplaint complaint_id="1" />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Receive -->
  <div
    class="modal fade"
    tabindex="-1"
    ref="receiveModalRef"
    id="receive-modal"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รับเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <ReceiveComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Receive2 -->
  <div class="modal fade" tabindex="-1" ref="receive2ModalRef" id="send-modal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รับเรื่องเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <Receive2Complaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Send -->
  <div class="modal fade" tabindex="-1" ref="sendModalRef" id="send-modal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">ส่งต่อเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <SendComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Track -->
  <div class="modal fade" tabindex="-1" ref="trackModalRef" id="track-modal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">ติดตามเรื่องร้องเรียน/แจ้งเบาะแส</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <TrackComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Receive Report -->
  <div
    class="modal fade"
    tabindex="-1"
    ref="receiveReportModalRef"
    id="receive-report-modal"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รับรายงานผล</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <ReceiveReportComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Send Report -->
  <div
    class="modal fade"
    tabindex="-1"
    ref="sendReportModalRef"
    id="send-report-modal"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">ส่งต่อรายงานผล</h3>
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
        </div>

        <div class="modal-body">
          <SendReportComplaint />
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Detail -->
  <div class="modal fade" tabindex="-1" ref="detailModalRef" id="detail-modal">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รายละเอียดเรื่องร้องเรียน</h3>

          <!--begin::Close-->
          <div
            class="btn btn-icon btn-sm btn-active-light-primary ms-2"
            data-bs-dismiss="modal"
            aria-label="Close"
          >
            <i class="ki-duotone ki-cross fs-1"
              ><span class="path1"></span><span class="path2"></span
            ></i>
          </div>
          <!--end::Close-->
        </div>

        <div class="modal-body">
          <DetailComplaint :item="item" v-if="Object.keys(item).length !== 0" />
        </div>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import { defineComponent, onMounted, onUnmounted, ref, watch } from "vue";
// import { getAssetPath } from "@/core/helpers/assets";
import { useRouter } from "vue-router";
import useAddressData from "@/composables/useAddressData";
import useStateData from "@/composables/useStateData";
// import useStatusData from "@/composables/useStatusData";
// import useOrganizationData from "@/composables/useOrganizationData";
// Import Validate
import { ErrorMessage, Field, Form as VForm } from "vee-validate";
import * as Yup from "yup";
// Import SweetAlert2
import Swal from "sweetalert2/dist/sweetalert2.js";
// Import Form Wizard
import { FormWizard, TabContent } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
// Import Vue-select
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";
// Import Datepicker
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
// Import Custom Widget Dashboard
import Widget1Custom from "@/components/dashboard-default-widgets/Widget1Custom.vue";
// Import Pagination
import BlogPagination from "@/components/common/pagination/BlogPagination.vue";
// Import Bootstrap
import { Modal } from "bootstrap";
// Import ExcelJS
import ExcelJS from "exceljs";

import AddComplaint from "@/views/complaint/Add.vue";
import EditComplaint from "@/views/complaint/Edit.vue";
import ReceiveComplaint from "@/views/complaint/Receive.vue";
import Receive2Complaint from "@/views/complaint/Receive2.vue";
import SendComplaint from "@/views/complaint/Send.vue";
import TrackComplaint from "@/views/complaint/Track.vue";
import ReceiveReportComplaint from "@/views/complaint/ReceiveReport.vue";
import SendReportComplaint from "@/views/complaint/SendReport.vue";
import DetailComplaint from "@/views/complaint/Detail.vue";
import ApiService from "@/core/services/ApiService";

import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

import { useAbility } from "@casl/vue";

export default defineComponent({
  name: "complaint",
  components: {
    Field,
    VForm,
    ErrorMessage,
    FormWizard,
    TabContent,
    VueDatePicker,
    dayjs,
    Widget1Custom,
    vSelect,
    BlogPagination,
    AddComplaint,
    EditComplaint,
    ReceiveComplaint,
    Receive2Complaint,
    SendComplaint,
    ReceiveReportComplaint,
    SendReportComplaint,
    TrackComplaint,
    DetailComplaint,
  },
  setup() {
    // Variable
    const ability = useAbility();
    // console.log(ability);

    const router = useRouter();
    let addModalRef = ref<any>(null);
    let addModalObj = ref<any>(null);
    let editModalRef = ref<any>(null);
    let editModalObj = ref<any>(null);
    let detailModalRef = ref<any>(null);
    let detailModalObj = ref<any>(null);
    let receiveModalRef = ref<any>(null);
    let receiveModalObj = ref<any>(null);
    let receive2ModalRef = ref<any>(null);
    let receive2ModalObj = ref<any>(null);
    let sendModalRef = ref<any>(null);
    let sendModalObj = ref<any>(null);
    let trackModalRef = ref<any>(null);
    let trackModalObj = ref<any>(null);
    let receiveReportModalRef = ref<any>(null);
    let receiveReportModalObj = ref<any>(null);
    let sendReportModalRef = ref<any>(null);
    let sendReportModalObj = ref<any>(null);

    const cardStatus = ref([
      {
        status_id: 1,
        description: "รอตรวจสอบ/รับเรื่อง",
        bgColor: "#F8285A",
        total: "400",
        percentage: "30%",
      },
      {
        status_id: 2,
        description: "อยู่ระหว่างดำเนินการ",
        bgColor: "#FFC107",
        total: "300",
        percentage: "25%",
      },

      {
        status_id: 4,
        description: "รอรายงานผล",
        bgColor: "#1B84FF",
        total: "300",
        percentage: "25%",
      },

      {
        status_id: 3,
        description: "เสร็จสิ้น",
        bgColor: "#17c653",
        total: "200",
        percentage: "20%",
      },
    ]);

    const tableHeader = ref([
      {
        columnName: "วันที่ร้องเรียน",
        columnLabel: "created_at",
      },
      {
        columnName: "รหัสคำร้อง",
        columnLabel: "complian_code",
      },
      {
        columnName: "ลักษณะความผิด",
        columnLabel: "complian_type",
      },
      {
        columnName: "ผู้ถูกร้อง",
        columnLabel: "complian_name",
      },
      {
        columnName: "หน่วยงานถูกร้อง",
        columnLabel: "complain_organization",
      },
      {
        columnName: "สถานะ",
        columnLabel: "status",
      },
      {
        columnName: "จัดการข้อมูล",
        columnLabel: "manage",
      },
    ]);

    let states = useStateData().states;

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
    const selectOptions = ref<any>({
      years: [],
      address_all: address_all.value,
      complain_statuses: [
        { name: "รอตรวจสอบ/รับเรื่อง", value: 1 },
        { name: "อยู่ระหว่างดำเนินการ", value: 2 },
        { name: "รอรายงานผล", value: 3 },
        { name: "เสร็จสิ้น", value: 4 },
      ],
      is_anonymouses: [
        { name: "ระบุตัวตน", value: 1 },
        { name: "ไม่ระบุตัวตน", value: 2 },
      ],
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
      states: [],
      perPage: [
        { title: "20", value: 20 },
        { title: "40", value: 40 },
        { title: "60", value: 60 },
      ],
      inspectors: [],
      bureaus: [],
      divisions: [],
      agency: [],
      provinces: [],
      districts: [],
      subdistricts: [],
      complaint_types: [],
      topic_categories: [],
      topic_types: [],
      prefix_names: [],
    });
    const item = ref<any>({});
    const search = ref<any>({
      year: null,
      complaint_title: "",
      jcoms_no: "",
      complainant_fullname: "",
      accused_fullname: "",
      state_id: null,
      inspector_id: null,
      bureau_id: null,
      division_id: null,
      agency_id: null,
      create_from: null,
      create_to: null,
      is_anonymous: null,
      incident_date: null,
      province_id: null,
      district_id: null,
      sub_district_id: null,
      complaint_type_id: null,
      topic_category_id: null,
      topic_type_id: null,
      pol_no: "",
      receive_no: "",
      forward_no: "",
      complaint_channel_id: null,
    });
    const items = ref<any>([]);
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const perPage = ref(20);
    const currentPage = ref(1);
    const totalPage = ref(1);
    const totalItems = ref(0);
    const json_data = ref([]);
    const submitButton = ref<HTMLButtonElement | null>(null);

    //Create form validation object
    const login = Yup.object().shape({
      email: Yup.string().email().required().label("Email"),
      password: Yup.string().min(4).required().label("Password"),
    });

    const calYear = () => {
      let year = new Date().getFullYear();
      for (let i = 0; i <= 10; i++) {
        selectOptions.value.years.push({
          name: year - i + 543,
          value: Number(year - i),
        });
      }
      selectOptions.value.years.push({
        name: "ทั้งหมด",
        value: null,
      });
    };
    calYear();
    // console.log(selectOptions.value.years);

    // Fetch Data
    const fetchPrefixName = async () => {
      let api = {
        type: "query",
        url: "prefix-name",
      };

      // ส่งไรไป ID phone เก็บ tracking_state ไว้  มี ID หรือเบอร์โทร
      await ApiService[api.type](api.url, {
        params: { is_active: 1, perPage: 500 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.prefix_names = data.data;
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchState = () => {
      const params = {
        perPage: 100,
      };
      ApiService.query("state", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.states = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchInspector = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
      };
      ApiService.query("inspector", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.inspectors = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchBureau = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
        inspector_id: search.value.inspector_id?.id ?? undefined,
      };
      ApiService.query("bureau", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.bureaus = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchDivision = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
        bureau_id: search.value.bureau_id?.id ?? undefined,
      };
      ApiService.query("division", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.divisions = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchAgency = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
        division_id: search.value.division_id?.id ?? undefined,
      };
      ApiService.query("agency", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.agencies = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchProvince = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
      };
      ApiService.query("province", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.provinces = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchDistrict = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
        province_id: search.value.province_id?.id ?? undefined,
      };
      ApiService.query("district", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.districts = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchSubdistrict = () => {
      const params = {
        perPage: 100000,
        orderBy: "name_th",
        order: "asc",
        district_id: search.value.district_id?.id ?? undefined,
      };
      ApiService.query("sub-district", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.subdistricts = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchComplaintType = () => {
      const params = {
        perPage: 100000,
      };
      ApiService.query("complaint-type", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.complaint_types = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchTopicCategory = () => {
      const params = {
        perPage: 100000,
        complaint_type_id: search.value.complaint_type_id?.id ?? undefined,
      };
      ApiService.query("topic-category", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.topic_categories = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchTopicType = () => {
      const params = {
        perPage: 100000,
        topic_category_id: search.value.topic_category_id?.id ?? undefined,
      };
      ApiService.query("topic-type", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.topic_types = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchComplaintChannel = () => {
      const params = {
        perPage: 100000,
      };
      ApiService.query("complaint-channel", { params: params })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          selectOptions.value.complaint_channels = data.data;
        })
        .catch(({ response }) => {
          console.log(response.data.errors);
        });
    };

    const fetchItems = async () => {
      const params = {
        perPage: perPage.value,
        currentPage: currentPage.value,
        orderBy: "created_at",
        order: "desc",
        ...search.value,
        year: search.value.year?.value ?? undefined,
        state_id: search.value.state_id?.id ?? undefined,
        inspector_id: search.value.inspector_id?.id ?? undefined,
        bureau_id: search.value.bureau_id?.id ?? undefined,
        division_id: search.value.division_id?.id ?? undefined,
        agency_id: search.value.agency_id?.id ?? undefined,
        is_anonymous: search.value.is_anonymous?.value ?? undefined,
        province_id: search.value.province_id?.id ?? undefined,
        district_id: search.value.district_id?.id ?? undefined,
        sub_district_id: search.value.sub_district_id?.id ?? undefined,
        complaint_type_id: search.value.complaint_type_id?.id ?? undefined,
        topic_category_id: search.value.topic_category_id?.id ?? undefined,
        topic_type_id: search.value.topic_type_id?.id ?? undefined,
        complaint_channel_id:
          search.value.complaint_channel_id?.id ?? undefined,
        incident_date: search.value.incident_date
          ? dayjs(search.value.incident_date).format("YYYY-MM-DD")
          : undefined,
        create_from: search.value.create_from
          ? dayjs(search.value.create_from).format("YYYY-MM-DD")
          : undefined,
        create_to: search.value.create_to
          ? dayjs(search.value.create_to).format("YYYY-MM-DD")
          : undefined,
      };

      let api = {
        type: "query",
        url: "complaint/",
      };

      await ApiService[api.type](api.url, {
        params: params,
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          items.value = data.data;
          totalPage.value = data.totalPage;
          totalItems.value = data.totalData;
          currentPage.value = data.currentPage;
        })
        .catch(({ response }) => {
          console.log(response);
        });

      await ApiService[api.type](api.url + "count", {
        params: { ...params, state_id: 1 },
      })
        .then(({ data }) => {
          if (data.msg != "success") {
            throw new Error("ERROR");
          }
          cardStatus.value[0].total = data.totalCount.toString();
        })
        .catch(({ response }) => {
          console.log(response);
        });
    };

    const fetchItemsExport = async () => {
      let params = {
        ...search.value,
        asset_type_id:
          search.value.asset_type_id == null
            ? undefined
            : search.value.asset_type_id.value,
        budget_type_id:
          search.value.budget_type_id == null
            ? undefined
            : search.value.budget_type_id.value,
        department_id:
          search.value.department_id == null
            ? undefined
            : search.value.department_id.value,
        input_year:
          search.value.input_year == null
            ? undefined
            : search.value.input_year.id,
        created_at_from:
          search.value.created_at_from == null
            ? undefined
            : dayjs(search.value.created_at_from).format("YYYY-MM-DD"),
        created_at_to:
          search.value.created_at_to == null
            ? undefined
            : dayjs(search.value.created_at_to).format("YYYY-MM-DD"),
        status:
          search.value.status != null ? search.value.status.id : undefined,
        perPage: 100000,
        currentPage: currentPage.value,
        lang: "th",
        orderBy: "created_at",
        order: "desc",
      };
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };
    const onClear = async () => {
      search.value = {
        year: selectOptions.value.years[0],
        complaint_title: "",
        jcoms_no: "",
        complainant_fullname: "",
        accused_fullname: "",
        state_id: null,
        inspector_id: null,
        bureau_id: null,
        division_id: null,
        agency_id: null,
        create_from: null,
        create_to: null,
        is_anonymous: null,
        incident_date: null,
        province_id: null,
        district_id: null,
        sub_district_id: null,
        complaint_type_id: null,
        topic_category_id: null,
        topic_type_id: null,
        pol_no: "",
        receive_no: "",
        forward_no: "",
        complaint_channel_id: null,
      };
    };
    const onExport = async () => {
      //   setTimeout(async () => {
      //     const workbook = new ExcelJS.Workbook();
      //     const worksheet = workbook.addWorksheet("รายการเรื่องร้องเรียน", {
      //       pageSetup: { orientation: "landscape" },
      //       headerFooter: {
      //         firstHeader: "Hello Exceljs",
      //         firstFooter: "Hello World",
      //       },
      //     });
      //     worksheet.columns = [
      //       {
      //         header: "หมายเลขคำร้อง",
      //         key: "หมายเลขครุภัณฑ์",
      //         width: 25,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "วันที่ขอเปลี่ยน",
      //         key: "วันที่ขอเปลี่ยน",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "ผู้แจ้ง",
      //         key: "ผู้แจ้ง",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //       {
      //         header: "สถานะ",
      //         key: "สถานะ",
      //         width: 20,
      //         outlineLevel: 1,
      //       },
      //     ];
      //     worksheet.properties.defaultRowHeight = 45;
      //     worksheet.addRows(json_data.value);
      //     worksheet.eachRow((row) => {
      //       row.height = 45;
      //       row.eachCell(function (cell) {
      //         cell.alignment = {
      //           vertical: "middle",
      //           horizontal: "center",
      //           wrapText: true,
      //         };
      //       });
      //     });
      //     const row = worksheet.getRow(1);
      //     row.height = 20;
      //     worksheet.insertRow(1, "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์");
      //     worksheet.mergeCells("A1:K1");
      //     worksheet.getCell("A1").value =
      //       "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์";
      //     worksheet.getCell("A1").alignment = {
      //       vertical: "middle",
      //       horizontal: "center",
      //     };
      //     const font = { name: "Arial", size: 18, bold: true };
      //     worksheet.getCell("A1").font = font;
      //     let start_date =
      //       search.created_at_from != null
      //         ? dayjs(search.created_at_from).locale("th").format("DD MMM BBBB")
      //         : "-";
      //     let end_date =
      //       search.created_at_to != null
      //         ? dayjs(search.created_at_to).locale("th").format("DD MMM BBBB")
      //         : "-";
      //     worksheet.insertRow(2);
      //     worksheet.mergeCells("A2:K2");
      //     worksheet.getCell("A2").value =
      //       "ระหว่างวันที่ " + start_date + " ถึง " + end_date;
      //     worksheet.getCell("A2").alignment = {
      //       vertical: "middle",
      //       horizontal: "center",
      //     };
      //     const font1 = { name: "Arial", size: 18, bold: true };
      //     worksheet.getCell("A1").font = font1;
      //     const buffer = await workbook.xlsx.writeBuffer();
      //     const blob = new Blob([buffer], { type: "application/octet-stream" });
      //     const href = URL.createObjectURL(blob);
      //     const link = document.createElement("a");
      //     link.href = href;
      //     link.download = "รายการทะเบียนแจ้งขอเปลี่ยนผู้ใช้งานครุภัณฑ์.xlsx";
      //     document.body.appendChild(link);
      //     link.click();
      //     document.body.removeChild(link);
      //   }, 3000);
    };
    const onAddModal = () => {
      addModalObj.value.show();
    };
    const onEditModal = () => {
      editModalObj.value.show();
    };
    const onDetailModal = (it: any) => {
      item.value = it;
      detailModalObj.value.show();
    };
    const onReceiveModal = () => {
      receiveModalObj.value.show();
    };

    const onReceive2Modal = () => {
      receive2ModalObj.value.show();
    };
    const onSendModal = () => {
      sendModalObj.value.show();
    };

    const onReceiveReportModal = () => {
      receiveReportModalObj.value.show();
    };
    const onSendReportModal = () => {
      sendReportModalObj.value.show();
    };

    const onTrackModal = () => {
      trackModalObj.value.show();
    };

    const showState = (state: number) => {
      let find_state = states.find((x: any) => {
        return state == x.id;
      });

      return {
        name_th: find_state.name_th,
        bg_color: find_state.bg_color,
      };
    };

    // Watch
    watch(
      [currentPage],
      () => {
        fetchItems();
      },
      { deep: true }
    );

    // watch(
    //   [search.value],
    //   () => {
    //     console.log(search.value.year);
    //   },
    //   { deep: true }
    // );

    const convert_date = (date: any) => {
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    const showAccused = (accused: any) => {
      let text = "";

      if (accused != null && accused.length != 0) {
        accused.forEach((x: any, idx: number) => {
          if (x.firstname == null) {
            return;
          }
          if (idx != 0) {
            text = text + ", ";
          }

          let fn = x.firstname;
          let ln = x.lastname != null ? x.lastname : "";
          text = text + showPrefix(x.prefix_name_id) + fn + " " + ln;
        });
      }
      return text;
    };

    const showPrefix = (prefix_name_id: any) => {
      let text = "";

      if (prefix_name_id != null) {
        let prefix_name: any;
        prefix_name = selectOptions.value.prefix_names.find((x: any) => {
          return prefix_name_id == x.id;
        });
        if (prefix_name) {
          return prefix_name.name_th;
        }
      }
      return text;
    };

    fetchPrefixName();
    fetchState();
    fetchInspector();
    fetchBureau();
    // fetchDivision();
    // fetchAgency();
    fetchProvince();
    // fetchDistrict();
    // fetchSubdistrict();
    fetchComplaintType();
    // fetchTopicCategory();
    // fetchTopicType();
    fetchComplaintChannel();
    fetchItems();

    // Mounted
    onMounted(() => {
      addModalObj.value = new Modal(addModalRef.value, {});
      editModalObj.value = new Modal(editModalRef.value, {});
      detailModalObj.value = new Modal(detailModalRef.value, {});
      receiveModalObj.value = new Modal(receiveModalRef.value, {});
      receive2ModalObj.value = new Modal(receive2ModalRef.value, {});
      sendModalObj.value = new Modal(sendModalRef.value, {});
      trackModalObj.value = new Modal(trackModalRef.value, {});
      receiveReportModalObj.value = new Modal(receiveReportModalRef.value, {});
      sendReportModalObj.value = new Modal(sendReportModalRef.value, {});

      search.value.year = selectOptions.value.years[0];
    });

    onUnmounted(() => {
      addModalObj.value.hide();
      editModalObj.value.hide();
      detailModalObj.value.hide();
      receiveModalObj.value.hide();
      receive2ModalObj.value.hide();
      sendModalObj.value.hide();
      trackModalObj.value.hide();
      receiveReportModalObj.value.hide();
      sendReportModalObj.value.hide();
    });

    // watch

    watch(
      () => search.value.inspector_id,
      () => {
        search.value.bureau_id = null;
        search.value.division_id = null;
        search.value.agency_id = null;
        fetchBureau();
      },
      { deep: true }
    );

    watch(
      () => search.value.bureau_id,
      () => {
        search.value.division_id = null;
        search.value.agency_id = null;
        search.value.bureau_id == null
          ? (selectOptions.value.divisions = [])
          : fetchDivision();
      },
      { deep: true }
    );

    watch(
      () => search.value.division_id,
      () => {
        search.value.agency_id = null;
        search.value.division_id == null
          ? (selectOptions.value.agencies = [])
          : fetchAgency();
      },
      { deep: true }
    );

    watch(
      () => search.value.province_id,
      () => {
        search.value.district_id = null;
        search.value.sub_district_id = null;
        search.value.province_id == null
          ? (selectOptions.value.districts = [])
          : fetchDistrict();
      },
      { deep: true }
    );

    watch(
      () => search.value.district_id,
      () => {
        search.value.sub_district_id = null;
        search.value.district_id == null
          ? (selectOptions.value.subdistricts = [])
          : fetchSubdistrict();
      },
      { deep: true }
    );

    watch(
      () => search.value.complaint_type_id,
      () => {
        search.value.topic_category_id = null;
        search.value.topic_type_id = null;

        search.value.complaint_type_id == null
          ? (selectOptions.value.topic_categories = [])
          : fetchTopicCategory();
      },
      { deep: true }
    );

    watch(
      () => search.value.topic_category_id,
      () => {
        search.value.topic_type_id = null;

        search.value.topic_category_id == null
          ? (selectOptions.value.topic_types = [])
          : fetchTopicType();
      },
      { deep: true }
    );

    return {
      cardStatus,
      tableHeader,
      totalPage,
      totalItems,
      search,
      items,
      perPage,
      currentPage,
      login,
      submitButton,
      selectOptions,
      item,
      router,
      format,
      addModalRef,
      editModalRef,
      detailModalRef,
      receiveModalRef,
      receive2ModalRef,
      sendModalRef,
      trackModalRef,
      receiveReportModalRef,
      sendReportModalRef,
      showState,

      onSearch,
      onClear,
      onExport,
      onAddModal,
      onEditModal,
      onDetailModal,
      onReceiveModal,
      onReceive2Modal,
      onSendModal,
      onTrackModal,
      onReceiveReportModal,
      onSendReportModal,
      ability,
      showAccused,
      convert_date,
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

.bg-color-police {
  background-color: #800001;
}
</style>

<!-- Get ข้อมูล count -->
<!-- สิทธิ์การมองเห็น เมนูย่อย และข้อมูลกับ Filter -->
