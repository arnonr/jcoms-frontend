<template>
  <!--begin::Wrapper-->
  <div class="container mt-5">
    <div class="card shadow-sm my-6">
      <div class="card-header bg-white d-flex">
        <h4 class="card-title">กรองสถิติ</h4>
      </div>
      <div class="card-body">
        <div class="row ps-5 pe-5 ps-md-0 pe-md-0">
          <div class="col-12 col-md-3 my-2">
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

          <div class="col-12 col-md-3 my-2">
            <label for="">เดือน</label>
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

          <div class="col-md-3 mb-7">
            <label for="">ช่วงวันที่ร้องเรียน (จากวันที่)</label>
            <VueDatePicker
              id="dp-search-startdate-2"
              name="dp-search-startdate-2"
              class="form-control"
              v-model="search.start_date"
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
          <div class="col-md-3 mb-7">
            <label for="">ช่วงวันที่ร้องเรียน (ถึงวันที่)</label>
            <VueDatePicker
              id="dp-search-enddate-2"
              name="dp-search-enddate-2"
              class="form-control"
              v-model="search.end_date"
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

          <div class="col-12 col-md-4 my-2">
            <label for="">บช./ภ.</label>
            <v-select
              id="slt-search-bureau-id"
              name="slt-search-bureau-id"
              label="name"
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
              label="name"
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
              label="name"
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
          กรองสถิติ
        </button>
        <button class="btn btn-danger ms-2 fw-bold" @click="onClear()">
          ล้าง
        </button>
        <!-- data-bs-toggle="modal" data-bs-target="#modal-search" -->
        <!-- <button
          id="kt_search_toggle"
          class="btn btn-primary fw-bold float-end"
          data-bs-toggle="tooltip"
          data-bs-placement="left"
          data-bs-dismiss="click"
          data-bs-trigger="hover"
        >
          ค้นหาเพิ่มเติม
        </button> -->
      </div>
    </div>

    <div class="row">
      <div class="col-12 mb-3">
        <h4>เรื่องร้องเรียนทั้งหมด {{ 1200 }} เรื่อง</h4>
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

    <div class="row mt-20">
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องแบ่งตามประเภทเรื่องร้องเรียน</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 400px; height: 400px" class="mx-auto">
              <Doughnut
                :data="chartComplaintTypeData"
                :options="chartOptions"
              />
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องแบ่งตามหน่วยงานที่ถูกร้องเรียน</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 600px; height: 400px" class="mx-auto">
              <Bar
                :data="chartOrganizationData"
                :options="chartOrganizationOptions"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row mt-20">
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องแบ่งตามประเภทการแจ้งเบาะแส</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 400px; height: 400px" class="mx-auto">
              <Doughnut
                :data="chartComplaintTypeData"
                :options="chartOptions"
              />
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องแบ่งตามหน่วยงานที่ถูกแจ้งเบาะแส</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 600px; height: 400px" class="mx-auto">
              <Bar
                :data="chartOrganizationData"
                :options="chartOrganizationOptions"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row mt-20">
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องแจ้งเบาะแสสารเสพติด</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 600px; height: 400px" class="mx-auto">
              <Bar
                :data="chartOrganizationData"
                :options="chartOrganizationOptions"
              />
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 mb-3">
        <h4>จำนวนเรื่องร้องเรียนเจ้าหน้าที่ตำรวจด้วยกัน</h4>
        <div class="card">
          <div class="card-body overflow-scroll">
            <div style="width: 600px; height: 400px" class="mx-auto">
              <Bar
                :data="chartOrganizationData"
                :options="chartOrganizationOptions"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm my-5 mt-20">
      <div class="card-header bg-white">
        <h4 class="card-title">
          สรุปจำนวนเรื่องร้องเรียน/แจ้งเบาะแสแยกตามหน่วยงาน
        </h4>
        <div class="card-toolbar">
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
              <th
                v-for="(hd, idx) in tableHeader"
                :key="idx"
                class="text-center text-white"
              >
                {{ hd.columnName }}
              </th>
            </tr>
          </thead>
          <tbody v-if="items.length != 0">
            <tr v-for="(it, idx) in items" :key="idx">
              <td class="text-center">{{ it.oragnization }}</td>
              <td class="text-center">{{ it.complian_code }}</td>
              <td class="text-center">
                <a @click="onAccusedDetailModal()" class="cursor-pointer">{{
                  it.name
                }}</a>
              </td>
              <td class="text-center">{{ it.status1 }}</td>
              <td class="text-center">{{ it.status3 }}</td>
              <td class="text-center">{{ it.status4 }}</td>
              <td class="text-center">{{ it.percentage }}</td>

              <!-- <td class="text-center">
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
                        @click="onDetailModal()"
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
                        >รับเรื่อง</a
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
              </td> -->
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
        <h5 class="card-title fw-semibold text-gray-600">กรองสถิติเพิ่มเติม</h5>

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
                v-model="search.start_date"
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
                v-model="search.end_date"
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
              v-model="search.complain_title"
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
                label="name"
                placeholder="สถานะเรื่องร้องเรียน"
                :options="selectOptions.proceed_states"
                v-model="search.proceed_state_id"
                class="form-control"
                :clearable="true"
              ></v-select>
            </div>
          </div>

          <h4>ค้นหาจากข้อมูลหน่วยงาน</h4>
          <hr />
          <div class="mb-7">
            <label for="">ฝ่ายรับเรื่องร้องเรียน : </label>
            <input
              id="slt-search-proceed-state-2"
              name="slt-search-procees-state-2"
              type="text"
              class="form-control"
              v-model="search.complain_code"
            />
          </div>

          <div class="mb-7">
            <label for="">บช./ภ.</label>
            <v-select
              id="slt-search-bureau-id-2"
              name="slt-search-bureau-id-2"
              label="name"
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
              label="name"
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
              label="name"
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
              label="name"
              placeholder="จังหวัด"
              :options="selectOptions.complain_statuses"
              v-model="search.complain_status"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">อำเภอ : </label>
            <v-select
              id="slt-search-district-id-2"
              name="slt-search-district-id-2"
              label="name"
              placeholder="อำเภอ"
              :options="selectOptions.complain_statuses"
              v-model="search.complain_status"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">ตำบล : </label>
            <v-select
              id="slt-search-sub-district-id-2"
              name="slt-search-sub-district-id-2"
              label="name"
              placeholder="ตำบล"
              :options="selectOptions.complain_statuses"
              v-model="search.complain_status"
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
              label="name"
              placeholder="หมวดหมู่เรื่อง"
              :options="selectOptions.complain_types"
              v-model="search.complain_type_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <div class="mb-7">
            <label for="">ประเภทเรื่อง : </label>
            <v-select
              id="slt-search-topic-type-id-2"
              name="slt-search-topic-type-id-2"
              label="name"
              placeholder="ประเภทเรื่อง"
              :options="selectOptions.topic_types"
              v-model="search.topic_type_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>
          <div class="mb-7">
            <label for="">ลักษณะเรื่อง : </label>
            <v-select
              id="slt-search-topic-category-id-2"
              name="slt-search-topic-category-id-2"
              label="name"
              placeholder="ลักษณะเรื่อง"
              :options="selectOptions.topic_categories"
              v-model="search.topic_category_id"
              class="form-control"
              :clearable="true"
            ></v-select>
          </div>

          <h4>ค้นหาจากเลขเอกสาร</h4>
          <hr />

          <div class="row">
            <div class="col-md-6 mb-7">
              <label for="">เลขที่คำร้องเรียน : </label>
              <input
                id="slt-search-complain-code-2"
                name="slt-search-complain-code-2"
                type="text"
                class="form-control"
                v-model="search.complain_code"
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
              label="name"
              placeholder="ช่องทางการรับเรื่อง"
              :options="selectOptions.complain_channels"
              v-model="search.complain_channel_id"
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

  <!-- Modal Detail -->
  <div
    class="modal fade"
    tabindex="-1"
    ref="accusedDetailModalRef"
    id="detail-model"
  >
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">รายการเจ้าหน้าที่ถูกร้องเรียน</h3>

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
          <div>
            <!-- <AccusedDetail /> -->
            <h2>หน่วยงาน : xxxxx</h2>
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th class="text-center">ชื่อ</th>
                  <th class="text-center">จำนวนครั้ง</th>
                  <th class="text-center">หัวข้อร้องเรียน</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                 <td class="text-center">พันเอกอานนท์ รักจักร์</td>
                 <td class="text-center">5</td>
                 <td>1. ......</td>
                </tr>
                <tr>
                 <td class="text-center">พันเอกอานนท์ รักจักร์</td>
                 <td class="text-center">5</td>
                 <td>1. ......</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--end::Wrapper-->
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  onBeforeMount,
  ref,
  watch,
  computed,
} from "vue";
// import { getAssetPath } from "@/core/helpers/assets";
import { useRouter } from "vue-router";
import useAddressData from "@/composables/useAddressData";
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

import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement,
} from "chart.js";
import { Pie, Bar, Doughnut } from "vue-chartjs";
ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement
);

import ApiService from "@/core/services/ApiService";

import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

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
    Doughnut,
    Bar,
  },
  setup() {
    // Variable
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
    let accusedDetailModalRef = ref<any>(null);
    let accusedDetailModalObj = ref<any>(null);

    const chartComplaintTypeData = ref({
      labels: [
        "ขอความเป็นธรรม",
        "ทุจริตต่อหน้าที่",
        "ไม่บริการประชาชน",
        "ปฎิบัติหน้าที่มิชอบ",
        "ประพฤติตนไม่สมควร",
      ],
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: [40, 20, 12, 50, 60],
          backgroundColor: [
            "rgb(255, 99, 132)",
            "rgb(54, 162, 235)",
            "rgb(255, 205, 86)",
            "rgb(255, 205, 86)",
            "rgb(255, 205, 86)",
          ],
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });
    const chartOptions = <any>{
      plugins: {
        legend: {
          display: true,
          position: "right",
          labels: {
            boxWidth: 15, // ความกว้างของลูกศร
            boxHeight: 15, // ความสูงของลูกศร
            padding: 15, // ระยะห่างระหว่างลูกศรกับข้อความ
            generateLabels: (chart) => {
              const sortedData = [...chart.data.datasets[0].data].sort(
                (a, b) => b - a
              );

              return sortedData.map((data, i) => ({
                text: `${chart.data.labels[i]} (${data} เรื่อง)`,
                fillStyle: chart.data.datasets[0].backgroundColor[i],
              }));
            },
          },
        },
      },
      layout: {
        width: 400,
      },
      responsive: true,
    };

    const chartOrganizationData = ref({
      labels: [
        "ภูธรภาค 1",
        "ภูธรภาค 2",
        "ภูธรภาค 3",
        "ภูธรภาค 4",
        "ภูธรภาค 5",
        "ภูธรภาค 6",
        "ภูธรภาค 7",
        "ภูธรภาค 8",
        "ภูธรภาค 9",
        "อื่น ๆ",
      ],
      datasets: [
        {
          label: "จำนวนเรื่อง",
          data: [40, 20, 12, 50, 60, 50, 80, 54, 89, 120],
          backgroundColor: [
            "rgb(255, 99, 132)",
            "rgb(54, 162, 235)",
            "rgb(255, 205, 86)",
            "rgb(54, 162, 235)",
            "rgb(255, 205, 86)",
            "rgb(255, 99, 132)",
            "rgb(255, 205, 86)",
            "rgb(255, 99, 132)",
            "rgb(255, 205, 86)",
            "rgb(54, 162, 235)",
          ],
          hoverOffset: 10,
          borderRadius: 3,
          //   cutout: 80,
        },
      ],
    });
    const chartOrganizationOptions = <any>{
      plugins: {
        legend: {
          display: true,
          position: "right",
          labels: {
            boxWidth: 15, // ความกว้างของลูกศร
            boxHeight: 15, // ความสูงของลูกศร
            padding: 15, // ระยะห่างระหว่างลูกศรกับข้อความ
            generateLabels: (chart) => {
              const sortedData = [...chart.data.datasets[0].data].sort(
                (a, b) => b - a
              );

              return sortedData.map((data, i) => ({
                text: `${chart.data.labels[i]} (${data} เรื่อง)`,
                fillStyle: chart.data.datasets[0].backgroundColor[i],
              }));
            },
          },
        },
      },
      layout: {
        width: 600,
      },
      responsive: true,
    };

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
        columnName: "ชื่อหน่วยงานที่ถูกร้อง",
        columnLabel: "oragnization",
      },
      {
        columnName: "ภ.จว.",
        columnLabel: "complian_code",
      },
      {
        columnName: "เจ้าหน้าที่ถูกร้อง",
        columnLabel: "name",
      },
      //   {
      //     columnName: "รอรับเรื่อง",
      //     columnLabel: "status1",
      //   },
      {
        columnName: "อยู่ระหว่างดำเนินการ",
        columnLabel: "status2",
      },
      {
        columnName: "เสร็จสิ้น",
        columnLabel: "status4",
      },
      {
        columnName: "รวม",
        columnLabel: "status3",
      },
      {
        columnName: "Percentage",
        columnLabel: "percentage",
      },
    ]);

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
      identity_types: [
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
      perPage: [
        { title: "20", value: 20 },
        { title: "40", value: 40 },
        { title: "60", value: 60 },
      ],
    });
    const item = ref({
      organization: "",
      type_of_document_id: "",
      type_of_identity: 1,
      name: "",
      id_number: "",
      id_file: "",
      address_all: "",
      prefix_name_1: "",
    });
    const search = ref<any>({
      year: "",
      day: "",
      title: "",
      code: "",
      organization: "",
      name: "",
      complain_type: "",
      complain_code: "",
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
    console.log(selectOptions.value.years);

    // Fetch Data
    const fetchItems = () => {
      const params = {
        perPage: perPage.value,
        currentPage: currentPage.value,
        ...search.value,
        // group_id: search.value.group_id ? search.value.group_id.id : undefined,
      };

      items.value = [
        {
          oragnization: "สน. ตลิ่งชัน",
          complian_code: "สำนักงานตำรวจนครบาล",
          name: 5,
          complain_organization: "สถานีตำรวจภูธรเจาะไอ้ร้อง",
          status1: 20,
          status2: 20,
          status3: 20,
          status4: 20,
          percentage: 70,
        },
        {
          oragnization: "สน. ตลิ่งชัน",
          complian_code: "สำนักงานตำรวจนครบาล",
          name: 5,
          complain_organization: "สถานีตำรวจภูธรเจาะไอ้ร้อง",
          status1: 20,
          status2: 20,
          status3: 20,
          status4: 20,
          percentage: 70,
        },
        {
          oragnization: "สน. ตลิ่งชัน",
          complian_code: "สำนักงานตำรวจนครบาล",
          name: 5,
          complain_organization: "สถานีตำรวจภูธรเจาะไอ้ร้อง",
          status1: 20,
          status2: 20,
          status3: 20,
          status4: 20,
          percentage: 70,
        },
      ];

      //   ApiService.query("complain", { params: params })
      //     .then(async (response) => {
      //       // .then(({ data }) => {
      //       //   if (data.msg != "success") {
      //       //     throw new Error("ERROR");
      //       //   }
      //       // items.value = data.data;
      //       //   items.value = response;
      //       //   totalPage.value = data.totalPage;
      //       //   totalItems.value = data.totalData;
      //       //   json_data.value = await fetchItemsExport();
      //       //   items.value = [
      //       //     {
      //       //       created_at: dayjs('2023-01-01').locale("th").format("DD"),
      //       //       complain_code: "123456",
      //       //     },
      //       //     {
      //       //       created_at: dayjs('2023-01-01').locale("th").format("DD")
      //       //     },
      //       //   ];
      //     })
      //     .catch(({ response }) => {
      //       console.log(response.data.errors);
      //     });
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

      //   if (useCookie("user").value.level == 3) {
      //     params["department_id"] = useCookie("user").value.department_id;
      //   }

      //   let data = await $fetch(
      //     `${runtimeConfig.public.apiBase}/holder-history`,
      //     {
      //       params: params,
      //     }
      //   ).catch((error) => error.data);

      //   return data.data.map((e) => {
      //     return {
      //       หมายเลขครุภัณฑ์: e.asset.asset_code,
      //       ชื่อครุภัณฑ์: e.asset.asset_name,
      //       รายละเอียด: e.asset.asset_detail,
      //       ประเภทครุภัณฑ์: e.asset.asset_type_id
      //         ? selectOptions.value.asset_types_array[e.asset.asset_type_id]
      //         : "",
      //       ผู้ใช้งานเดิม: e.previous_holder_name,
      //       ผู้ใช้งานใหม่: e.holder_name,
      //       วันที่ขอเปลี่ยน:
      //         e.created_at != null
      //           ? dayjs(e.created_at).locale("th").format("DD MMM BBBB")
      //           : "-",
      //       ผู้แจ้ง: e.created_user?.name,
      //       สถานะ: selectOptions.value.holder_statuses[e.status].name,
      //     };
      //   });
    };

    // Event
    const onSearch = async () => {
      fetchItems();
    };
    const onClear = async () => {
      search.value = {};
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
    const onAccusedDetailModal = () => {
      accusedDetailModalObj.value.show();
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

    // Watch
    watch(
      [currentPage],
      () => {
        fetchItems();
      },
      { deep: true }
    );

    watch(
      [search.value],
      () => {
        console.log(search.value.year);
      },
      { deep: true }
    );

    // Mounted
    onMounted(() => {
      accusedDetailModalObj.value = new Modal(accusedDetailModalRef.value, {});
      search.value.year = selectOptions.value.years[0];
      fetchItems();
    });

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
      accusedDetailModalRef,
      sendReportModalRef,
      chartComplaintTypeData,
      chartOptions,
      chartOrganizationData,
      chartOrganizationOptions,

      onSearch,
      onClear,
      onExport,
      onAccusedDetailModal,
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
