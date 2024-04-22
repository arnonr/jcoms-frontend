export default () => {
  const states = [
    {
      id: 1,
      name_th: "เรื่องร้องเรียนใหม่",
      name_en: null,
      bg_color: "#f8285a",
    },
    {
      id: 3,
      name_th: "ฝรท.บก.อก.จต. ลงรับเรื่อง",
      name_en: null,
      bg_color: "#ffc107",
    },
    {
      id: 4,
      name_th:
        "ส่งต่อไปยังหน่วยราชการหรือส่วนราชการอื่นที่มีอำนาจ (ไม่อยู่ในอำนาจ ตร.)",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 5,
      name_th: "ส่งคืนเรื่องให้หน่วยงานที่ส่งเรื่องมา",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 6,
      name_th: "เรื่องร้องเรียนซ้ำ",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 7,
      name_th: "ส่งเอกสารเพิ่มเติม",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 8,
      name_th: "ขอถอนเรื่อง",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 9,
      name_th: "ติดตามเรื่อง",
      name_en: null,
      bg_color: "#ffc107",
    },
    {
      id: 10,
      name_th: "ฝรท.บก.อก.จต. ส่งถึง หน่วย บช./ภ. ดำเนินการ",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#f8285a",
    },
    {
      id: 11,
      name_th: "หน่วย บช./ภ. ส่งถึง หน่วย ภ.จว./บก. ดำเนินการ",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#ffc107",
      bg_division_color: "#f8285a",
    },
    {
      id: 12,
      name_th: "หน่วย ภ.จว./บก. ส่งถึง กก./สถานี ดำเนินการ",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#ffc107",
      bg_division_color: "#ffc107",
    },
    {
      id: 13,
      name_th: "กต. เร่งรัดติดตามผล (กต.1 - 10 จต.)",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#ffc107",
      bg_division_color: "#ffc107",
    },
    {
      id: 14,
      name_th: "กก./สถานี รายงานถึง ภ.จว./บก.",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#ffc107",
      bg_division_color: "#ffc107",
    },
    {
      id: 15,
      name_th: "หน่วย หน่วย ภ.จว./บก.รายงานถึง บช./ภ.",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#ffc107",
      bg_division_color: "#17c653",
    },
    {
      id: 16,
      name_th: "หน่วย บช./ภ. รายงานถึง จต.",
      name_en: null,
      bg_color: "#ffc107",
      bg_bureau_color: "#17c653",
      bg_division_color: "#17c653",
    },
    {
      id: 17,
      name_th: "ปิดเรื่อง (ดำเนินการแล้วเสร็จ)",
      name_en: null,
      bg_color: "#17c653",
    },
    {
      id: 18,
      name_th: "ไม่รับเรื่อง",
      name_en: null,
      bg_color: "#17c653",
    },
  ];

  return {
    states,
  };
};
