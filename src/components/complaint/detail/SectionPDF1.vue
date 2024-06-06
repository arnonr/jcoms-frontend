<template>
  <div class="accordion-item bg-sky">
    <h2 class="accordion-header">
      <button
        class="accordion-button rounded"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#item1"
      >
        <h4 class="color-primary">สถานะการดำเนินการ</h4>
      </button>
    </h2>
    <div id="item1" class="accordion-collapse collapse show">
      <div class="accordion-body">
        <span class="fw-bold"> สถานะปัจจุบัน : </span>
        <span
          class="badge p-2 text-black fw-bold"
          :style="`background-color: ${complaint_item.state?.bg_color};`"
          >{{ complaint_item.state?.name_th }}</span
        >
        <div class="separator separator-dotted my-2"></div>

        <table class="table table-bordered table-striped" style="width: 100%">
          <thead class="bg-color-police">
            <th style="max-width: 100px" class="p-3 text-white">วันที่</th>
            <th class="p-3 text-white">สถานะ</th>
            <th class="p-3 text-white">รายละเอียด</th>
          </thead>
          <tbody>
            <tr>
              <td class="p-3">
                {{ showDate(complaint_item.created_at) }}
              </td>
              <td class="fw-bold p-3">ร้องเรียน/แจ้งเบาะแส</td>
              <td class="p-3"></td>
            </tr>
            <!-- ฝรท. รับเรื่อง-->
            <tr v-if="complaint_item.receive_status == 1">
              <td class="p-3">
                {{ showDate(complaint_item.receive_at) }}
              </td>
              <td class="fw-bold p-3">
                ฝรท.
                {{
                  complaint_item.receive_status == 1
                    ? "รับเรื่อง"
                    : "ไม่รับเรื่อง"
                }}
              </td>
              <td class="p-3">
                <div
                  v-if="
                    complaint_item.receive_status == 2 ||
                    complaint_item.receive_status == 3
                  "
                >
                  <span class="fw-bold">เหตุผล : </span>
                  <span class="fst-italic">{{
                    complaint_item.receive_status == 2
                      ? "ข้อมูลไม่ครบถ้วน"
                      : "เป็นการร้องทุกข์ กล่าวโทษคดีอาญา"
                  }}</span>
                </div>
                <div
                  class="mb-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_date"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div class="fst-italic">
                    {{ showDate(complaint_item.receive_doc_date) }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_no"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div class="fst-italic">
                    {{ complaint_item.receive_doc_no }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_comment"
                >
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div class="fst-italic">
                    {{ complaint_item.receive_comment }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_filename"
                >
                  <div class="fw-bold" style="min-width: 100px">ไฟล์แนบ :</div>
                  <div class="fst-italic">
                    <a
                      :href="complaint_item.receive_doc_filename"
                      target="_blank"
                    >
                      ดาวน์โหลด
                    </a>
                  </div>
                </div>
              </td>
            </tr>

            <!-- ฝรท. ปฏิเสธ -->
            <tr v-if="complaint_item.receive_status == 2 || complaint_item.receive_status == 3">
              <td class="p-3">
                {{ showDate(complaint_item.receive_at) }}
              </td>
              <td class="fw-bold p-3">
                ฝรท.
                {{
                  complaint_item.receive_status == 1
                    ? "รับเรื่อง"
                    : "ไม่รับเรื่อง"
                }}
              </td>
              <td class="p-3">
                <div
                  v-if="
                    complaint_item.receive_status == 2 ||
                    complaint_item.receive_status == 3
                  "
                >
                  <span class="fw-bold" style="min-width: 100px">เหตุผล : </span>
                  <span class="fst-italic">{{
                    complaint_item.receive_status == 2
                      ? "ข้อมูลไม่ครบถ้วน"
                      : "เป็นการร้องทุกข์ กล่าวโทษคดีอาญา"
                  }}</span>
                </div>
                <div
                  class="mb-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_date"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div class="fst-italic">
                    {{ showDate(complaint_item.receive_doc_date) }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_no"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div class="fst-italic">
                    {{ complaint_item.receive_doc_no }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_comment"
                >
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div class="fst-italic">
                    {{ complaint_item.receive_comment }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_item.receive_doc_filename"
                >
                  <div class="fw-bold" style="min-width: 100px">ไฟล์แนบ :</div>
                  <div class="fst-italic">
                    <a
                      :href="complaint_item.receive_doc_filename"
                      target="_blank"
                    >
                      ดาวน์โหลด
                    </a>
                  </div>
                </div>
              </td>
            </tr>

            <!-- ฝรท. ส่งต่อเรื่อง ไป บช/ภ.-->
            <tr v-if="complaint_forward_state.state10 != null">
              <td class="p-3">
                {{ showDate(complaint_forward_state.state10.created_at) }}
              </td>
              <td class="fw-bold p-3">
                {{ complaint_forward_state.state10.state.name_th }}
                ({{ complaint_forward_state.state10.to_bureau?.name_th }})
              </td>
              <td class="p-3">
                <div
                  class="mb-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state10.forward_doc_date"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div>
                    {{
                      showDate(complaint_forward_state.state10.forward_doc_date)
                    }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state10.forward_doc_no"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div>
                    {{ complaint_forward_state.state10.forward_doc_no }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state10.order.name_th"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    คำสั่งการ :
                  </div>
                  <div>
                    {{ complaint_forward_state.state10.order.name_th }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state10.order_detail"
                >
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_forward_state.state10.order_detail }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state10.forward_doc_filename"
                >
                  <div class="fw-bold" style="min-width: 100px">ไฟล์แนบ :</div>
                  <div>
                    <a
                      :href="
                        complaint_forward_state.state10.forward_doc_filename
                      "
                      target="_blank"
                    >
                      ดาวน์โหลด
                    </a>
                  </div>
                </div>
              </td>
            </tr>

            <!-- บช/ภ. รับเรื่อง -->
            <tr
              v-if="
                complaint_forward_state.state10 != null &&
                complaint_forward_state.state10.receive_status == 1
              "
            >
              <td class="p-3">
                {{ showDate(complaint_forward_state.state10.receive_at) }}
              </td>
              <td class="fw-bold p-3">
                บช./ภ. รับเรื่อง ({{
                  complaint_forward_state.state10.to_bureau?.name_th
                }})
              </td>
              <td class="p-3">
                <div class="mb-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div>
                    {{
                      showDate(complaint_forward_state.state10.forward_doc_date)
                    }}
                  </div>
                </div>
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div>
                    {{ complaint_forward_state.state10.receive_doc_no }}
                  </div>
                </div>
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_forward_state.state10.receive_comment }}
                  </div>
                </div>
              </td>
            </tr>

            <!-- ส่งต่อเรื่อง ไป บก./จ. -->
            <tr v-if="complaint_forward_state.state11 != null">
              <td class="p-3">
                {{ showDate(complaint_forward_state.state11.created_at) }}
              </td>
              <td class="fw-bold p-3">
                {{ complaint_forward_state.state11.state.name_th }}
                ({{ complaint_forward_state.state11.to_division?.name_th }})
              </td>
              <td class="p-3">
                <div
                  class="mb-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.forward_doc_date"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div>
                    {{
                      showDate(complaint_forward_state.state11.forward_doc_date)
                    }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.forward_doc_no"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div>
                    {{ complaint_forward_state.state11.forward_doc_no }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.order.name_th"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    คำสั่งการ :
                  </div>
                  <div>
                    {{ complaint_forward_state.state11.order.name_th }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.order_detail"
                >
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_forward_state.state11.order_detail }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.forward_doc_filename"
                >
                  <div class="fw-bold" style="min-width: 100px">ไฟล์แนบ :</div>
                  <div>
                    <a
                      :href="
                        complaint_forward_state.state11.forward_doc_filename
                      "
                      target="_blank"
                    >
                      ดาวน์โหลด
                    </a>
                  </div>
                </div>
              </td>
            </tr>

            <!-- บก/ภจ.ว. รับเรื่อง -->
            <tr
              v-if="
                complaint_forward_state.state11 != null &&
                complaint_forward_state.state11.receive_status == 1
              "
            >
              <td class="p-3">
                {{ showDate(complaint_forward_state.state11.receive_at) }}
              </td>
              <td class="fw-bold p-3">
                บก./จ. รับเรื่อง ({{
                  complaint_forward_state.state11.to_division?.name_th
                }})
              </td>
              <td class="p-3">
                <div
                  class="mb-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.forward_doc_date"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    วันที่เอกสาร :
                  </div>
                  <div>
                    {{
                      showDate(complaint_forward_state.state11.forward_doc_date)
                    }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.receive_doc_no"
                >
                  <div class="fw-bold" style="min-width: 100px">
                    เลขที่เอกสาร :
                  </div>
                  <div>
                    {{ complaint_forward_state.state11.receive_doc_no }}
                  </div>
                </div>
                <div
                  class="mt-0 pt-0 pb-0 d-flex"
                  v-if="complaint_forward_state.state11.receive_comment"
                >
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_forward_state.state11.receive_comment }}
                  </div>
                </div>
              </td>
            </tr>

            <!-- บก/ภจ.ว. ส่งรายงาน -->
            <template
              v-for="(cr, idx) in complaint_report_state.state15"
              :key="idx"
            >
              <tr v-if="cr != null">
                <td class="p-3 text-green">
                  {{ showDate(cr.created_at) }}
                </td>
                <td class="fw-bold p-3 text-green">
                  {{ cr.state.name_th }}
                </td>
                <td class="p-3 text-green">
                  <div class="mb-0 pt-0 pb-0 d-flex" v-if="cr.report_doc_date">
                    <div class="fw-bold" style="min-width: 100px">
                      วันที่เอกสาร :
                    </div>
                    <div>
                      {{ showDate(cr.report_doc_date) }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.report_doc_no">
                    <div class="fw-bold" style="min-width: 100px">
                      เลขที่เอกสาร :
                    </div>
                    <div>
                      {{ cr.report_doc_no }}
                    </div>
                  </div>
                  <div
                    class="mt-0 pt-0 pb-0 d-flex"
                    v-if="cr.proceed_status.name_th"
                  >
                    <div class="fw-bold" style="min-width: 100px">
                      ผลดำเนินการ :
                    </div>
                    <div>
                      {{ cr.proceed_status.name_th }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.report_detail">
                    <div class="fw-bold" style="min-width: 100px">
                      หมายเหตุ :
                    </div>
                    <div>
                      {{ cr.report_detail }}
                    </div>
                  </div>
                  <div
                    class="mt-0 pt-0 pb-0 d-flex"
                    v-if="cr.report_doc_filename"
                  >
                    <div class="fw-bold" style="min-width: 100px">
                      ไฟล์แนบ :
                    </div>
                    <div>
                      <a :href="cr.report_doc_filename" target="_blank">
                        ดาวน์โหลด
                      </a>
                    </div>
                  </div>

                  <!-- Return -->
                  <div v-if="cr.status == 3">
                    <hr />
                    <h6 class="text-danger">ส่งกลับให้แก้ไขเอกสาร</h6>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        วันที่เอกสารส่งกลับ :
                      </div>
                      <div>
                        {{ showDate(cr.return_doc_date) }}
                      </div>
                    </div>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        เลขที่เอกสารส่งกลับ :
                      </div>
                      <div>
                        {{ cr.return_doc_no }}
                      </div>
                    </div>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        เหตุผลการส่งกลับ :
                      </div>
                      <div>
                        {{ cr.return_detail }}
                      </div>
                    </div>
                    <div
                      class="mt-0 pt-0 pb-0 d-flex text-danger"
                      v-if="cr.return_doc_filename"
                    >
                      <div class="fw-bold" style="min-width: 150px">
                        ไฟล์แนบ :
                      </div>
                      <div>
                        <a
                          :href="cr.return_doc_filename"
                          target="_blank"
                          class="text-danger"
                        >
                          ดาวน์โหลด
                        </a>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>

              <!-- บช./ภ. รับรายงาน -->
              <tr v-if="cr != null && cr.receive_at != null">
                <td class="p-3 text-green">
                  {{ showDate(cr.receive_at) }}
                </td>
                <td class="fw-bold p-3 text-green">บช./ภ. รับรายงาน</td>
                <td class="p-3 text-green">
                  <div class="mb-0 pt-0 pb-0 d-flex" v-if="cr.receive_doc_date">
                    <div class="fw-bold" style="min-width: 100px">
                      วันที่เอกสาร :
                    </div>
                    <div>
                      {{ showDate(cr.receive_doc_date) }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.receive_doc_no">
                    <div class="fw-bold" style="min-width: 100px">
                      เลขที่เอกสาร :
                    </div>
                    <div>
                      {{ cr.receive_doc_no }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.receive_comment">
                    <div class="fw-bold" style="min-width: 100px">
                      หมายเหตุ :
                    </div>
                    <div>
                      {{ cr.receive_comment }}
                    </div>
                  </div>
                </td>
              </tr>
            </template>

            <!-- หน่วย บช./ภ. รายงานถึง จต. -->
            <template
              v-for="(cr, idx) in complaint_report_state.state16"
              :key="idx"
            >
              <tr v-if="cr != null">
                <td class="p-3 text-green">
                  {{ showDate(cr.created_at) }}
                </td>
                <td class="fw-bold p-3 text-green">
                  {{ cr.state.name_th }}
                </td>
                <td class="p-3 text-green">
                  <div class="mb-0 pt-0 pb-0 d-flex" v-if="cr.report_doc_date">
                    <div class="fw-bold" style="min-width: 100px">
                      วันที่เอกสาร :
                    </div>
                    <div>
                      {{ showDate(cr.report_doc_date) }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.report_doc_no">
                    <div class="fw-bold" style="min-width: 100px">
                      เลขที่เอกสาร :
                    </div>
                    <div>
                      {{ cr.report_doc_no }}
                    </div>
                  </div>
                  <div
                    class="mt-0 pt-0 pb-0 d-flex"
                    v-if="cr.proceed_status.name_th"
                  >
                    <div class="fw-bold" style="min-width: 100px">
                      ผลดำเนินการ :
                    </div>
                    <div>
                      {{ cr.proceed_status.name_th }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex" v-if="cr.report_detail">
                    <div class="fw-bold" style="min-width: 100px">
                      หมายเหตุ :
                    </div>
                    <div>
                      {{ cr.report_detail }}
                    </div>
                  </div>
                  <div
                    class="mt-0 pt-0 pb-0 d-flex"
                    v-if="complaint_report_state.state16.report_doc_filename"
                  >
                    <div class="fw-bold" style="min-width: 100px">
                      ไฟล์แนบ :
                    </div>
                    <div>
                      <a
                        :href="
                          complaint_report_state.state16.report_doc_filename
                        "
                        target="_blank"
                      >
                        ดาวน์โหลด
                      </a>
                    </div>
                  </div>

                  <!-- Return -->
                  <div v-if="cr.status == 3">
                    <hr />
                    <h6 class="text-danger">ส่งกลับให้แก้ไขเอกสาร</h6>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        วันที่เอกสารส่งกลับ :
                      </div>
                      <div>
                        {{ showDate(cr.return_doc_date) }}
                      </div>
                    </div>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        เลขที่เอกสารส่งกลับ :
                      </div>
                      <div>
                        {{ cr.return_doc_no }}
                      </div>
                    </div>
                    <div class="mt-0 pt-0 pb-0 d-flex text-danger">
                      <div class="fw-bold" style="min-width: 150px">
                        เหตุผลการส่งกลับ :
                      </div>
                      <div>
                        {{ cr.return_detail }}
                      </div>
                    </div>
                    <div
                      class="mt-0 pt-0 pb-0 d-flex text-danger"
                      v-if="cr.return_doc_filename"
                    >
                      <div class="fw-bold" style="min-width: 150px">
                        ไฟล์แนบ :
                      </div>
                      <div>
                        <a
                          :href="cr.return_doc_filename"
                          target="_blank"
                          class="text-danger"
                        >
                          ดาวน์โหลด
                        </a>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>

              <!-- จต. รับรายงาน -->
              <tr v-if="cr != null && cr.receive_at != null">
                <td class="p-3 text-green">
                  {{ showDate(cr.receive_at) }}
                </td>
                <td class="fw-bold p-3 text-green">จต. รับรายงาน</td>
                <td class="p-3 text-green">
                  <div class="mb-0 pt-0 pb-0 d-flex">
                    <div class="fw-bold" style="min-width: 100px">
                      วันที่เอกสาร :
                    </div>
                    <div>
                      {{ showDate(cr.receive_doc_date) }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex">
                    <div class="fw-bold" style="min-width: 100px">
                      เลขที่เอกสาร :
                    </div>
                    <div>
                      {{ cr.receive_doc_no }}
                    </div>
                  </div>
                  <div class="mt-0 pt-0 pb-0 d-flex">
                    <div class="fw-bold" style="min-width: 100px">
                      หมายเหตุ :
                    </div>
                    <div>
                      {{ cr.receive_comment }}
                    </div>
                  </div>
                </td>
              </tr>
            </template>

            <!-- จต. ปิดเรื่อง -->
            <tr v-if="complaint_item.closed_at != null">
              <td class="p-3 text-green">
                {{ showDate(complaint_item.closed_at) }}
              </td>
              <td class="fw-bold p-3 text-green">จต. ปิดเรื่อง</td>
              <td class="p-3 text-green">
                <div class="mt-0 pt-0 pb-0 d-flex">
                  <div class="fw-bold" style="min-width: 100px">หมายเหตุ :</div>
                  <div>
                    {{ complaint_item.closed_comment }}
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { getAssetPath } from "@/core/helpers/assets";
import { defineComponent, onMounted, reactive, toRefs } from "vue";
import ApiService from "@/core/services/ApiService";
// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);

export default defineComponent({
  name: "complaint-detail-section1",
  props: {
    complaint_item: {
      type: Object,
      required: true,
    },
  },

  components: {
    dayjs,
  },
  setup(props) {
    // Variable
    const { complaint_item } = toRefs(props);

    const complaint_forward = reactive<any>([]);
    const complaint_report = reactive<any>([]);

    const complaint_forward_state = reactive<any>({
      state10: null,
      state11: null,
    });

    const complaint_report_state = reactive<any>({
      state15: null,
      state16: null,
    });

    // Fetch
    const fetchForward = async () => {
      try {
        const { data } = await ApiService.query("complaint-forward/", {
          params: { complaint_id: complaint_item.value.id },
        });

        complaint_forward.length = 0;
        Object.assign(complaint_forward, data.data);

        complaint_forward_state.state10 = complaint_forward.find((x: any) => {
          return x.state_id == 10;
        });

        complaint_forward_state.state11 = complaint_forward.find((x: any) => {
          return x.state_id == 11;
        });
      } catch (error) {
        console.log(error);
      }
    };

    const fetchReport = async () => {
      try {
        const { data } = await ApiService.query("complaint-report/", {
          params: { complaint_id: complaint_item.value.id },
        });

        complaint_report.length = 0;
        Object.assign(complaint_report, data.data);

        // complaint_report_state.state15 = complaint_report.find((x: any) => {
        //   return x.state_id == 15;
        // });

        complaint_report_state.state15 = complaint_report.filter((x: any) => {
          return x.state_id == 15;
        });

        // complaint_report_state.state16 = complaint_report.find((x: any) => {
        //   return x.state_id == 16;
        // });

        complaint_report_state.state16 = complaint_report.filter((x: any) => {
          return x.state_id == 16;
        });
      } catch (error) {
        console.log(error);
      }
    };

    // Event
    const showDate = (date: any) => {
      if (date == null) {
        return "";
      }
      return dayjs(date).locale("th").format("DD MMM BBBB");
    };

    // Mounted
    onMounted(async () => {
      await fetchForward();
      await fetchReport();
    });

    // Watch
    // Return
    return {
      getAssetPath,
      showDate,
      complaint_forward_state,
      complaint_report_state,
    };
  },
});
</script>

<style scoped>
/* .bg-sky {
  background-color: #d9f4fe;
} */

.bg-header-grey {
  background-color: #ddd;
}

.separator.separator-dotted {
  border-bottom-color: #aaa;
}

.accordion-item {
  border-color: #d9f4fe;
}
.color-primary {
  color: #800001;
}

.text-green {
  color: green;
}
</style>
