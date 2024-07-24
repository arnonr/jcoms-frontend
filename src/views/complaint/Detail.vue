<template>
  <div class="row">
    <div class="col-md-12">
      <div class="row">
        <div class="col-md-12 mb-5">
          <h4 class="color-primary">ข้อมูลการดำเนินการ</h4>
        </div>

        <div class="col-md-12">
          <span> สถานะปัจจุบัน : </span>
          <span
            class="badge p-2 text-white fw-bold"
            :style="`background-color: ${complaint_item.state?.bg_color};`"
            >{{ complaint_item.state?.name_th }}</span
          >
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12 mb-2">
          <button
            class="accordion-button pb-2"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#collapseOne"
            aria-expanded="true"
            aria-controls="collapseOne"
          >
            <span class="me-2">รายละเอียดการดำเนินการ : </span>
            <span class="badge p-2 text-white fw-bold bg-success">คลิก</span>
          </button>
          <div class="accordion col-md-12" id="accordionExample">
            <div class="accordion-item">
              <div
                id="collapseOne"
                class="accordion-collapse collapse"
                data-bs-parent="#accordionExample"
              >
                <div class="accordion-body">
                  <table class="table table-bordered">
                    <tr class="bg-secondary">
                      <th style="max-width: 100px" class="p-3">วันที่</th>
                      <th class="p-3">สถานะ</th>
                      <th class="p-3">รายละเอียด</th>
                    </tr>

                    <tr>
                      <td class="p-3">
                        {{ showDate(complaint_item.created_at) }}
                      </td>
                      <td class="fw-bold p-3">ร้องเรียน/แจ้งเบาะแส</td>
                      <td class="p-3"></td>
                    </tr>

                    <!-- ฝรท. รับเรื่อง -->
                    <tr v-if="complaint_item.receive_status == 1">
                      <td class="p-3">
                        {{ showDate(complaint_item.receive_at) }}
                      </td>
                      <td class="fw-bold p-3">
                        ฝรท.
                        {{
                          complaint_item.receive_status == 1
                            ? "รับเรื่อง/ดำเนินการ"
                            : "ไม่รับเรื่อง"
                        }}
                      </td>
                      <td class="p-3">
                        <div
                          v-if="
                            userData.role_id == 1 ||
                            userData.role_id == 2 ||
                            userData.role_id == 6
                          "
                        >
                          <div class="mb-0 pt-0 pb-0 d-flex">
                            <div class="fw-bold" style="min-width: 100px">
                              วันที่หนังสือ :
                            </div>
                            <div>
                              {{ showDate(complaint_item.receive_doc_date) }}
                            </div>
                          </div>
                          <div class="mt-0 pt-0 pb-0 d-flex">
                            <div class="fw-bold" style="min-width: 100px">
                              เลขทะเบียนหนังสือรับ :
                            </div>
                            <div>{{ complaint_item.receive_doc_no }}</div>
                          </div>
                          <div class="mt-0 pt-0 pb-0 d-flex">
                            <div class="fw-bold" style="min-width: 100px">
                              หมายเหตุ :
                            </div>
                            <div>{{ complaint_item.receive_comment }}</div>
                          </div>
                          <div class="mt-0 pt-0 pb-0 d-flex">
                            <div class="fw-bold" style="min-width: 100px">
                              ไฟล์แนบ :
                            </div>
                            <div>
                              <a
                                :href="complaint_item.receive_doc_filename"
                                target="_blank"
                              >
                                เอกสาร
                              </a>
                            </div>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- ส่งต่อเรื่อง ไป บช/ภ.-->
                    <tr v-if="complaint_forward_state.state10 != null">
                      <td class="p-3">
                        {{
                          showDate(complaint_forward_state.state10.created_at)
                        }}
                      </td>
                      <td class="fw-bold p-3">
                        {{ complaint_forward_state.state10.state.name_th }}
                        ({{
                          complaint_forward_state.state10.to_bureau?.name_th
                        }})
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_forward_state.state10.forward_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือส่ง :
                          </div>
                          <div>
                            {{ complaint_forward_state.state10.forward_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            คำสั่งการ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state10.order.name_th }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state10.order_detail }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_forward_state.state10
                                  .forward_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
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
                        {{
                          showDate(complaint_forward_state.state10.receive_at)
                        }}
                      </td>
                      <td class="fw-bold p-3">
                        บช./ภ. รับเรื่อง ({{
                          complaint_forward_state.state10.to_bureau?.name_th
                        }})
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_forward_state.state10.forward_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือรับ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state10.receive_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{
                              complaint_forward_state.state10.receive_comment
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_forward_state.state10
                                  .receive_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- ส่งต่อเรื่อง ไป บก./จ. -->
                    <tr v-if="complaint_forward_state.state11 != null">
                      <td class="p-3">
                        {{
                          showDate(complaint_forward_state.state11.created_at)
                        }}
                      </td>
                      <td class="fw-bold p-3">
                        {{ complaint_forward_state.state11.state.name_th }}
                        ({{
                          complaint_forward_state.state11.to_division?.name_th
                        }})
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_forward_state.state11.forward_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือส่ง :
                          </div>
                          <div>
                            {{ complaint_forward_state.state11.forward_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            คำสั่งการ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state11.order.name_th }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state11.order_detail }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_forward_state.state11
                                  .forward_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- บก./จ. รับเรื่อง -->
                    <tr
                      v-if="
                        complaint_forward_state.state11 != null &&
                        complaint_forward_state.state11.receive_status == 1
                      "
                    >
                      <td class="p-3">
                        {{
                          showDate(complaint_forward_state.state11.receive_at)
                        }}
                      </td>
                      <td class="fw-bold p-3">
                        บก./จ. รับเรื่อง ({{
                          complaint_forward_state.state11.to_division?.name_th
                        }})
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_forward_state.state11.forward_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือรับ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state11.receive_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{
                              complaint_forward_state.state11.receive_comment
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              v-if="
                                complaint_forward_state.state11
                                  .receive_doc_filename
                              "
                              :href="
                                complaint_forward_state.state11
                                  .receive_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                            <span v-else>-</span>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- ส่งต่อเรื่อง ไป บก./จ. -->
                    <tr v-if="complaint_forward_state.state12 != null">
                      <td class="p-3">
                        {{
                          showDate(complaint_forward_state.state12.created_at)
                        }}
                      </td>
                      <td class="fw-bold p-3">
                        {{ complaint_forward_state.state12.state.name_th }}
                        ({{
                          complaint_forward_state.state12.to_agency?.name_th
                        }})
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_forward_state.state12.forward_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือส่ง :
                          </div>
                          <div>
                            {{ complaint_forward_state.state12.forward_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            คำสั่งการ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state12.order.name_th }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_forward_state.state12.order_detail }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_forward_state.state12
                                  .forward_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- ส่งรายงานกลับ -->
                    <tr v-if="complaint_report_state.state15 != null">
                      <td class="p-3">
                        {{
                          showDate(complaint_report_state.state15.created_at)
                        }}
                      </td>
                      <td class="fw-bold p-3 text-success">
                        {{ complaint_report_state.state15.state.name_th }}
                        <!-- ({{
                          complaint_report_state.state15.to_division?.name_th
                        }}) -->
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_report_state.state15.report_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือส่ง :
                          </div>
                          <div>
                            {{ complaint_report_state.state15.report_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ผลดำเนินการ :
                          </div>
                          <div>
                            {{
                              complaint_report_state.state15.proceed_status
                                .name_th
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_report_state.state15.report_detail }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_report_state.state15
                                  .report_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- บช./ภ. รับรายงาน-->
                    <tr
                      v-if="
                        complaint_report_state.state15 != null &&
                        complaint_report_state.state15.receive_at != null
                      "
                    >
                      <td class="p-3">
                        {{
                          showDate(complaint_report_state.state15.receive_at)
                        }}
                      </td>
                      <td class="fw-bold p-3 text-success">บช./ภ. รับรายงาน</td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_report_state.state15.receive_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือรับ :
                          </div>
                          <div>
                            {{ complaint_report_state.state15.receive_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_report_state.state15.receive_comment }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              v-if="
                                complaint_report_state.state15
                                  .receive_doc_filename
                              "
                              :href="
                                complaint_report_state.state15
                                  .receive_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                            <span v-else>-</span>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- ส่งรายงานกลับ -->
                    <tr v-if="complaint_report_state.state16 != null">
                      <td class="p-3">
                        {{
                          showDate(complaint_report_state.state16.created_at)
                        }}
                      </td>
                      <td class="fw-bold p-3 text-success">
                        {{ complaint_report_state.state16.state.name_th }}
                        <!-- ({{
                          complaint_report_state.state15.to_division?.name_th
                        }}) -->
                      </td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_report_state.state16.report_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือส่ง :
                          </div>
                          <div>
                            {{ complaint_report_state.state16.report_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ผลดำเนินการ :
                          </div>
                          <div>
                            {{
                              complaint_report_state.state16.proceed_status
                                .name_th
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_report_state.state16.report_detail }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              :href="
                                complaint_report_state.state16
                                  .report_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                          </div>
                        </div>
                      </td>
                    </tr>

                    <!-- จต. รับเรื่อง -->
                    <tr
                      v-if="
                        complaint_report_state.state16 != null &&
                        complaint_report_state.state16.receive_at != null
                      "
                    >
                      <td class="p-3">
                        {{
                          showDate(complaint_report_state.state16.receive_at)
                        }}
                      </td>
                      <td class="fw-bold p-3 text-success">จต. รับรายงาน</td>
                      <td class="p-3">
                        <div class="mb-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            วันที่หนังสือ :
                          </div>
                          <div>
                            {{
                              showDate(
                                complaint_report_state.state16.receive_doc_date
                              )
                            }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            เลขทะเบียนหนังสือรับ :
                          </div>
                          <div>
                            {{ complaint_report_state.state16.receive_doc_no }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            หมายเหตุ :
                          </div>
                          <div>
                            {{ complaint_report_state.state16.receive_comment }}
                          </div>
                        </div>
                        <div class="mt-0 pt-0 pb-0 d-flex">
                          <div class="fw-bold" style="min-width: 100px">
                            ไฟล์แนบ :
                          </div>
                          <div>
                            <a
                              v-if="
                                complaint_report_state.state16
                                  .receive_doc_filename
                              "
                              :href="
                                complaint_report_state.state16
                                  .receive_doc_filename
                              "
                              target="_blank"
                            >
                              เอกสาร
                            </a>
                            <span v-else>-</span>
                          </div>
                        </div>
                      </td>
                    </tr>
                    <!--  -->
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!--  -->

        <!-- <div class="col-md-12" v-if="complaint_item.receive_doc_date">
          <span> {{ showDate(complaint_item.receive_doc_date) }} : </span>
          <span class="fw-bold me-10"
            >ฝรท
            {{
              complaint_item.receive_status == 1 ? "รับเรื่อง" : "ไม่รับเรื่อง"
            }}
          </span>
          <span> เลขทะเบียนหนังสือ : {{ complaint_item.receive_doc_no }}, </span
          ><span>หมายเหตุ : {{ complaint_item.receive_comment }}, </span
          ><span v-if="complaint_item.receive_doc_filename"
            >ไฟล์แนบ :
            <a :href="complaint_item.receive_doc_filename" target="_blank"
              >คลิก</a
            >
          </span>

          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12" v-if="complaint_item.receive_doc_date">
          <span> {{ showDate(complaint_item.receive_doc_date) }} : </span>
          <span class="fw-bold me-10">ฝรท. ส่งเรื่องต่อ </span>
          <span> เลขทะเบียนหนังสือ : {{ complaint_item.receive_doc_no }}, </span
          ><span>หมายเหตุ : {{ complaint_item.receive_comment }}, </span
          ><span v-if="complaint_item.receive_doc_filename"
            >ไฟล์แนบ :
            <a :href="complaint_item.receive_doc_filename" target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12" v-if="complaint_forward_state.state10 != null">
          <span>
            {{ showDate(complaint_forward_state.state10.forward_doc_date) }} :
          </span>
          <span class="fw-bold me-10">
            {{ complaint_forward_state.state10.state.name_th }}
          </span>
          <span
            >({{ complaint_forward_state.state10.to_bureau?.name_th }})</span
          >
          <span>
            เลขทะเบียนหนังสือ :
            {{ complaint_forward_state.state10.forward_doc_no }}, </span
          ><span
            >หมายเหตุ :
            {{ complaint_forward_state.state10.order_detail }}, </span
          ><span
            >คำสั่งการ :
            {{ complaint_forward_state.state10.order.name_th }}, </span
          ><span v-if="complaint_forward_state.state10.forward_doc_filename"
            >ไฟล์แนบ :
            <a
              :href="complaint_forward_state.state10.forward_doc_filename"
              target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div> -->

        <!-- <div
          class="col-md-12"
          v-if="
            complaint_forward_state.state10 != null &&
            complaint_forward_state.state10.receive_status == 1
          "
        >
          <span>
            {{ showDate(complaint_forward_state.state10.receive_doc_date) }} :
          </span>
          <span class="fw-bold me-10"
            >บช./ภ. รับเรื่อง
            {{ complaint_forward_state.state10.to_bureau.name_th }}
          </span>
          <span>
            เลขทะเบียนหนังสือ :
            {{ complaint_forward_state.state10.receive_doc_no }}, </span
          ><span
            >หมายเหตุ :
            {{ complaint_forward_state.state10.receive_comment }}, </span
          ><span v-if="complaint_forward_state.state10.receive_doc_filename"
            >ไฟล์แนบ :
            <a
              :href="complaint_forward_state.state10.receive_doc_filename"
              target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12" v-if="complaint_forward_state.state11 != null">
          <span>
            {{ showDate(complaint_forward_state.state11.forward_doc_date) }} :
          </span>
          <span class="fw-bold me-10">
            {{ complaint_forward_state.state11.state.name_th }}
          </span>
          <span
            >({{ complaint_forward_state.state11.from_bureau?.name_th }})</span
          >
          <span
            >({{ complaint_forward_state.state11.to_division?.name_th }})</span
          >
          <span>
            เลขทะเบียนหนังสือ :
            {{ complaint_forward_state.state11.forward_doc_no }}, </span
          ><span
            >หมายเหตุ :
            {{ complaint_forward_state.state11.order_detail }}, </span
          ><span
            >คำสั่งการ :
            {{ complaint_forward_state.state11.order.name_th }}, </span
          ><span v-if="complaint_forward_state.state10.forward_doc_filename"
            >ไฟล์แนบ :
            <a
              :href="complaint_forward_state.state11.forward_doc_filename"
              target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div
          class="col-md-12"
          v-if="
            complaint_forward_state.state11 != null &&
            complaint_forward_state.state11.receive_status == 1
          "
        >
          <span>
            {{ showDate(complaint_forward_state.state11.receive_doc_date) }} :
          </span>
          <span class="fw-bold me-10"
            >บก./จ. รับเรื่อง
            {{ complaint_forward_state.state11.from_bureau?.name_th }}
            {{ complaint_forward_state.state11.to_division.name_th }}
          </span>
          <span>
            เลขทะเบียนหนังสือ :
            {{ complaint_forward_state.state11.receive_doc_no }}, </span
          ><span
            >หมายเหตุ :
            {{ complaint_forward_state.state11.receive_comment }}, </span
          ><span v-if="complaint_forward_state.state11.receive_doc_filename"
            >ไฟล์แนบ :
            <a
              :href="complaint_forward_state.state11.receive_doc_filename"
              target="_blank"
              >คลิก</a
            >
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div> -->

        <div class="col-md-12 mb-5 mt-5">
          <h4 class="color-primary">ข้อมูลผู้{{ complaint_type.name_th }}</h4>
        </div>
        <div class="col-md-6">
          <span>ประเภทการระบุตัวตน : </span>
          <span class="fst-italic">{{ new_item.is_anonymous?.name }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-6">
          <span>หมายเลขโทรศัพท์มือถือ : </span>
          <span class="fst-italic">{{ complainant_item.phone_number }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12" v-if="complaint_item.is_anonymous == 1">
          <div class="row">
            <div class="col-md-6">
              <span>ประเภทบัตร : </span>
              <span class="fst-italic">
                {{ new_item.card_type?.name }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>หมายเลขบัตรประชาชน/Passport : </span>
              <span class="fst-italic">{{ complainant_item.id_card }}</span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>ชื่อ-นามสกุล : </span>
              <span class="fst-italic"
                >{{ complainant_item.prefix_name_id?.name_th
                }}{{ complainant_item.firstname }}
                {{ complainant_item.lastname }}</span
              >
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>วัน/เดือน/ปีเกิด : </span>
              <span class="fst-italic">
                {{ new_item.birthday }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>อาชีพ : </span>
              <span class="fst-italic">
                {{ complainant_item.occupation_text }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>ที่อยู่ : </span>
              <span class="fst-italic">
                {{
                  complainant_item.house_number
                    ? "บ้านเลขที่ " + complainant_item.house_number
                    : ""
                }}{{
                  complainant_item.building
                    ? " หมู่บ้าน " + complainant_item.building
                    : ""
                }}{{
                  complainant_item.moo
                    ? " หมู่ที่ " + complainant_item.moo
                    : ""
                }}{{
                  complainant_item.soi
                    ? " ตรอก/ซอย " + complainant_item.soi
                    : ""
                }}{{
                  complainant_item.road ? " ถนน " + complainant_item.road : ""
                }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>ตำบล/อำเภอ/จังหวัด : </span>
              <span class="fst-italic">
                {{ complainant_item.address_all }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>อีเมล : </span>
              <span class="fst-italic">
                {{ complainant_item.email }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-6">
              <span>Line ID : </span>
              <span class="fst-italic">
                {{ complainant_item.line_id }}
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
            <div class="col-md-12">
              <span>รูปถ่ายตนเองพร้อมบัตร : </span>
              <br />
              <span class="fst-italic">
                <img
                  :src="complainant_item.card_photo"
                  class="mt-5 w-100 w-md-50"
                />
              </span>
              <div class="separator separator-dotted my-2"></div>
            </div>
          </div>
        </div>

        <div class="col-md-12 mb-5 mt-5">
          <h4 class="color-primary">
            ข้อมูลเรื่อง{{ complaint_type.name_th }}
          </h4>
        </div>

        <div class="col-md-12">
          <span>เลข Jcom : </span>
          <span class="fst-italic">{{ complaint_item.jcoms_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>เลขรับ ฝรท. : </span>
          <span class="fst-italic">{{ complaint_item.receive_doc_no }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>หัวข้อเรื่อง{{ complaint_type.name_th }} : </span>
          <span class="fst-italic">{{ complaint_item.complaint_title }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ประเภท/ลักษณะเรื่อง : </span>
          <span class="fst-italic">{{
            complaint_item.topic_type?.topic_category.name_th +
            " > " +
            complaint_item.topic_type?.name_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>สถานที่เกิดเหตุ : </span>
          <span class="fst-italic"> {{ complaint_item.address_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>ข้อมูลสถานที่เกิดเหตุ : </span>
          <span class="fst-italic">{{ complaint_item.incident_location }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>วันที่เกิดเหตุ : </span>
          <span class="fst-italic">
            {{ new_item.incident_date }}
            {{ new_item.incident_time }}
            {{ "(" + new_item.day_time?.name + ")" }}
          </span>
          <div class="separator separator-dotted my-2"></div>
        </div>
        <div class="col-md-12">
          <span>Google Map : </span>
          <br />
          <GMapMap
            v-if="
              complaint_item.location_coordinates != null &&
              complaint_item.location_coordinates != ''
            "
            :center="new_item.markerDetails.position"
            :click="false"
            :zoom="16"
            map-type-id="terrain"
            style="width: 100%; height: 400px"
          >
            <GMapMarker
              :key="1"
              :position="new_item.markerDetails.position"
              :clickable="false"
              :draggable="false"
            >
            </GMapMarker>
          </GMapMap>
          <!-- <span class="fst-italic"> </span> -->
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div v-for="(ac, idx) in accused_item" :key="idx">
          <div class="col-md-12">
            <span>ผู้ถูกร้องคนที่ {{ Number(idx) + 1 }} : </span>
            <span class="fst-italic">
              {{
                ac.prefix_name_id
                  ? ac.prefix_name?.name_th +
                    "" +
                    ac.firstname +
                    " " +
                    ac.lastname
                  : ""
              }}
            </span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span>ตำแหน่งงาน : </span>
            <span class="fst-italic">{{ ac.position?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-6">
            <span>สายงาน : </span>
            <span class="fst-italic">{{ ac.section?.name_th }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
          <div class="col-md-12">
            <span>หน่วยงานผู้ถูกร้อง : </span>
            <span class="fst-italic">{{ showAccusedOrganization(ac) }}</span>
            <div class="separator separator-dotted my-2"></div>
          </div>
        </div>

        <div class="col-md-12">
          <span>พฤติกรรมการกระทำความผิด : </span>
          <span class="fst-italic">{{ complaint_item.complaint_detail }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div v-for="(cf, idx) in complaint_file_attach" :key="idx">
          <span>ไฟล์หลักฐานเพิ่มเติม {{ idx + 1 }} : </span>
          <a :href="cf.filename" target="_blank"
            ><span class="fst-italic">คลิก</span></a
          >
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>ช่องทางการร้องเรียน : </span>
          <span class="fst-italic">{{
            complaint_item.complaint_channel?.name_th
          }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>

        <div class="col-md-12">
          <span>เคยร้องเรียนเรื่องนี้ผ่านช่องทางใด : </span>
          <span class="fst-italic">{{ new_item.complaint_channel_all }}</span>
          <div class="separator separator-dotted my-2"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive, onMounted, watch } from "vue";
import ApiService from "@/core/services/ApiService";

// Import route
import { useRoute } from "vue-router";

// Import Dayjs
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
dayjs.extend(buddhistEra);
import utc from "dayjs/plugin/utc";
dayjs.extend(utc);

// Use Composables
import useComplaintTypeData from "@/composables/useComplaintTypeData";
import useComplaintChannelData from "@/composables/useComplaintChannelData";
import useBasicData from "@/composables/useBasicData";
import useStateData from "@/composables/useStateData";

export default defineComponent({
  name: "complaint-receive-tab3",
  props: {
    complaint_id: {
      type: Number,
      required: true,
    },
  },
  components: {
    dayjs,
  },
  setup(props) {
    const selectOptions = ref({
      complaint_channels: <any>[],
      card_types: useBasicData().card_types,
      is_anonymouses: useBasicData().is_anonymouses,
      day_times: useBasicData().day_times,
      states: useStateData().states,
    });
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");

    const complaint_item = reactive<any>({});
    const complainant_item = reactive<any>({});
    const accused_item = reactive<any>({});
    const complaint_file_attach = reactive<any>([]);
    const complaint_type = reactive<any>({
      name_th: "",
    });
    const complaint_forward = reactive<any>([]);
    const complaint_report = reactive<any>([]);

    const complaint_forward_state = reactive<any>({
      state10: null,
      state11: null,
      state12: null,
    });

    const complaint_report_state = reactive<any>({
      state15: null,
      state16: null,
    });

    // Fetch
    const fetchComplaint = async () => {
      try {
        const { data } = await ApiService.query(
          "complaint/" + props.complaint_id,
          {}
        );

        Object.assign(complaint_item, data.data);

        Object.assign(
          complaint_type,
          useComplaintTypeData().complaint_types.find(
            (x: any) => x.id == complaint_item.complaint_type_id
          )
        );
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplainant = async () => {
      try {
        const { data } = await ApiService.query(
          "complainant/" + complaint_item.complainant_id,
          {}
        );

        Object.assign(complainant_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchAccused = async () => {
      try {
        const { data } = await ApiService.query("accused/", {
          params: {
            complaint_id: complaint_item.id,
          },
        });

        accused_item.length = 0;
        Object.assign(accused_item, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchComplaintFileAttach = async () => {
      try {
        const { data } = await ApiService.query("complaint-file-attach/", {
          params: { complaint_id: complaint_item.id },
        });
        complaint_file_attach.length = 0;
        Object.assign(complaint_file_attach, data.data);
      } catch (error) {
        console.log(error);
      }
    };

    const fetchForward = async () => {
      try {
        const { data } = await ApiService.query("complaint-forward/", {
          params: { complaint_id: complaint_item.id },
        });

        complaint_forward.length = 0;
        Object.assign(complaint_forward, data.data);

        complaint_forward_state.state10 = complaint_forward.find((x: any) => {
          return x.state_id == 10;
        });

        complaint_forward_state.state11 = complaint_forward.find((x: any) => {
          return x.state_id == 11;
        });

        complaint_forward_state.state12 = complaint_forward.find((x: any) => {
          return x.state_id == 12;
        });
      } catch (error) {
        console.log(error);
      }
    };

    const fetchReport = async () => {
      try {
        const { data } = await ApiService.query("complaint-report/", {
          params: { complaint_id: complaint_item.id },
        });

        complaint_report.length = 0;
        Object.assign(complaint_report, data.data);

        complaint_report_state.state15 = complaint_report.find((x: any) => {
          return x.state_id == 15;
        });

        complaint_report_state.state16 = complaint_report.find((x: any) => {
          return x.state_id == 16;
        });
      } catch (error) {
        console.log(error);
      }
    };

    // สถานะ ตั้งแต่ receive ใน complaint เมื่อไหร่ เอกสาร เลขทะเบียนหนังสือ หมายเหตุ

    // Forward
    // สถานะ ตั้งแต่ send ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขทะเบียนหนังสือ หมายเหตุ
    // สถานะ receive ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขทะเบียนหนังสือ หมายเหตุ

    // Report
    // สถานะ ตั้งแต่ send ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขทะเบียนหนังสือ หมายเหตุ
    // สถานะ receive ใน complaint เวลา ส่งไปที่หน่วยงานไหน เอกสาร เลขทะเบียนหนังสือ หมายเหตุ

    const previewImage = ref<any>(null);
    const new_item = reactive<any>({
      is_anonymous: null,
      card_type: null,
      birthday: null,
      organization_all: [],
      markerDetails: { id: 1, position: { lat: null, lng: null } },
      complaint_channel_all: "",
      incident_date: "",
    });

    // Mounted
    onMounted(async () => {
      await fetchComplaint();
      await fetchComplainant();
      await fetchAccused();
      await fetchComplaintFileAttach();
      await fetchForward();
      await fetchReport();

      new_item.is_anonymous = selectOptions.value.is_anonymouses.find(
        (x: any) => {
          return x.value == complaint_item.is_anonymous;
        }
      );

      if (complaint_item.is_anonymous == 1) {
        new_item.card_type = selectOptions.value.card_types.find((x: any) => {
          return x.value == complainant_item.card_type;
        });

        new_item.birthday = complainant_item.birthday
          ? dayjs(complainant_item.birthday).locale("th").format("DD MMMM BBBB")
          : "";

        complainant_item.address_all = `${complainant_item.sub_district.name_th} > ${complainant_item.district.name_th} > ${complainant_item.province.name_th} > ${complainant_item.postal_code}`;
      }

      complaint_item.address_all = "";
      if (Object.keys(complaint_item.sub_district).length != 0) {
        complaint_item.address_all = `${complaint_item.sub_district?.name_th} > ${complaint_item.district?.name_th} > ${complaint_item.province?.name_th} > ${complaint_item.postal_code}`;
      }

      if (complaint_item.incident_datetime) {
        new_item.incident_date = dayjs(complaint_item.incident_datetime)
          .utc()
          .locale("th")
          .format("DD MMM BBBB HH:mm");

        new_item.day_time = selectOptions.value.day_times.find((x: any) => {
          return x.value == complaint_item.day_time;
        });
      }

      if (
        complaint_item.location_coordinates != "" &&
        complaint_item.location_coordinates != null
      ) {
        const [lat, lng] = complaint_item.location_coordinates.split(",");
        new_item.markerDetails = {
          id: 1,
          position: { lat: Number(lat), lng: Number(lng) },
        };
      }

      complaint_item.state = selectOptions.value.states.find(
        (x: any) => x.id === complaint_item.state_id
      );

      //   complaint_item.state = selectOptions.value.states.find(
      //     (x: any) => x.id === complaint_item.state_id
      //   );
    });

    // Watch

    const showAccusedOrganization = (ac: any) => {
      let item = "";

      if (ac.agency != null) {
        item = item + ac.agency.name_th + " > ";
      }

      if (ac.division != null) {
        item = item + ac.division.name_th + " > ";
      }

      if (ac.bureau != null) {
        item = item + ac.bureau.name_th;
      }

      return item;
    };

    const showDate = (date: any) => {
      if (date == null) {
        return "";
      }
      return dayjs(date).utc().locale("th").format("DD MMM BBBB");
    };

    // Return
    return {
      complaint_item,
      complainant_item,
      accused_item,
      complaint_file_attach,
      complaint_type,
      new_item,
      previewImage,
      selectOptions,
      showAccusedOrganization,
      showDate,
      complaint_forward_state,
      complaint_forward,
      complaint_report_state,
      complaint_report,
      userData,
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
