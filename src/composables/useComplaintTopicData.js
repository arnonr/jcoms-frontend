export default () => {
  const complaint_topics = [
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "เบียดบังทรัพย์สิน(โกง)",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 1,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "ละเว้นการปฏิบัติหน้าที่เพื่อผลประโยชน์(รับส่วย)",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 2,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "เอื้อประโยชน์ให้ผู้อื่นได้ประโยชน์ (ฮั๊ว)",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 3,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "เรียกรับผลประโยชน์ ข่มขู่ คุกคาม (รีดไถ)",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 4,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "รับสินบน (ช่วยผู้กระทำผิดให้ไม่ต้องรับโทษ)",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 5,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "เบียดบังทรัพย์สิน(โกง) Update",
      complaint_type_id: 1,
      topic_category_id: 1,
      topic_type_id: 41,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "ทำร้ายผู้ต้องหา",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 6,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "ไม่รับคดี",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 7,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "บิดเบือนคดี",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 8,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "กลั่นแกล้ง จับกุม ข่มขู่ คุกคาม",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 9,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "ค้นข้อมูลทะเบียนราษฎร์โดยมิชอบ",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 10,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "ละเว้นการปฏิบัติหน้าที่",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 11,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ปฎิบัติหน้าที่มิชอบ",
      topic_type_th: "เกี่ยวกับการตั้งด่าน",
      complaint_type_id: 1,
      topic_category_id: 2,
      topic_type_id: 12,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "ปัญหาครอบครัว/ชู้สาว",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 13,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "ปัญหาหนี้สิน",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 14,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "เกี่ยวข้องกับอบายมุข",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 15,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "กระทำผิดอาญา",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 16,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "ละทิ้งหน้าที่ เกียจคร้าน",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 17,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ประพฤติตนไม่สมควร",
      topic_type_th: "ก่อให้เกิดความแตกสามัคคีในหน่วย",
      complaint_type_id: 1,
      topic_category_id: 3,
      topic_type_id: 18,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่บริการประชาชน",
      topic_type_th: "ใช้กริยา วาจาไม่สุภาพ",
      complaint_type_id: 1,
      topic_category_id: 4,
      topic_type_id: 19,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่บริการประชาชน",
      topic_type_th: "เลือกปฏิบัติ",
      complaint_type_id: 1,
      topic_category_id: 4,
      topic_type_id: 20,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ขอความเป็นธรรม",
      topic_type_th: "ขอความเป็นธรรมในคดี",
      complaint_type_id: 1,
      topic_category_id: 5,
      topic_type_id: 21,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ขอความเป็นธรรม",
      topic_type_th: "เร่งรัดผลคดี",
      complaint_type_id: 1,
      topic_category_id: 5,
      topic_type_id: 22,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ขอความเป็นธรรม",
      topic_type_th: "เร่งรัด ติดตาม จับกุม",
      complaint_type_id: 1,
      topic_category_id: 5,
      topic_type_id: 23,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ขอความเป็นธรรม",
      topic_type_th: "ขอเปลี่ยนตัวพนักงานสอบสวน",
      complaint_type_id: 1,
      topic_category_id: 5,
      topic_type_id: 24,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th:
        "บัตรสนเท่ห์ร้องเรียนการปฏิบัติหน้าที่ของเจ้าหน้าที่ตำรวจ",
      topic_type_th: "บัตรสนเท่ห์ร้องเรียนการปฏิบัติหน้าที่ของเจ้าหน้าที่ตำรวจ",
      complaint_type_id: 1,
      topic_category_id: 6,
      topic_type_id: 25,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "ขอความช่วยเหลือ",
      topic_type_th: "ขอให้ตรวจพื้นที่",
      complaint_type_id: 2,
      topic_category_id: 7,
      topic_type_id: 26,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "ขอความช่วยเหลือ",
      topic_type_th: "ขอความคุ้มครอง/ปลอดภัย",
      complaint_type_id: 2,
      topic_category_id: 7,
      topic_type_id: 27,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "ขอความช่วยเหลือ",
      topic_type_th: "ผู้มีอิทธิพล ข่มขู่",
      complaint_type_id: 2,
      topic_category_id: 7,
      topic_type_id: 28,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "ยาเสพติด",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 29,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "การพนัน",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 30,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "สถานบริการ",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 31,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "เงินกู้นอกระบบ",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 32,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "แข่งรถ/จราจร",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 33,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "มั่วสุมเสียงดัง",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 34,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "แรงงานต่างด้าว",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 35,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "ค้ามนุษย์/ค้าประเวณี",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 36,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "ทรัพย์สินทางปัญญา",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 37,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "ป่าไม้ ทรัพยากรธรรมชาติ",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 38,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "ความผิดต่อชีวิต ร่างกาย ทรัพย์สิน",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 39,
    },
    {
      complaint_type_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "แนะนำแนวทางการปฏิบัติงาน",
      complaint_type_id: 2,
      topic_category_id: 8,
      topic_type_id: 40,
    },
    {
      complaint_type_th: "แจ้งเบาะแสยาเสพติด",
      topic_category_th: "แจ้งเบาะแส/แนะนำ",
      topic_type_th: "แจ้งเบาะแสยาเสพติด",
      complaint_type_id: 3,
      topic_category_id: 10,
      topic_type_id: 42,
    },
    {
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ทุจริตต่อหน้าที่",
      topic_type_th: "เบียดบังทรัพย์สิน(โกง)",
      complaint_type_id: 4,
      topic_category_id: 11,
      topic_type_id: 43,
    },

    {
      id: 43,
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่ระบุ",
      topic_type_th: "ไม่ระบุ",
      topic_category_id: 13,
      complaint_type_id: 1,
      is_active: 1,
    },
    {
      id: 44,
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่ระบุ",
      topic_type_th: "ไม่ระบุ",
      topic_category_id: 14,
      complaint_type_id: 2,
      is_active: 1,
    },
    {
      id: 45,
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่ระบุ",
      topic_type_th: "ไม่ระบุ",
      topic_category_id: 15,
      complaint_type_id: 3,
      is_active: 1,
    },
    {
      id: 46,
      complaint_type_th: "ร้องเรียน",
      topic_category_th: "ไม่ระบุ",
      topic_type_th: "ไม่ระบุ",
      topic_category_id: 16,
      complaint_type_id: 4,
      is_active: 1,
    },
  ];

  const complaint_topic_mapping = (complaint_type_id) => {
    return complaint_topics
      .filter((x) => {
        return x.complaint_type_id == complaint_type_id;
      })
      .map((el) => {
        el.label = el.topic_category_th + " > " + el.topic_type_th;
        return el;
      });
  };

  return {
    complaint_topics,
    complaint_topic_mapping,
  };
};
