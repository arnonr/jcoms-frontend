export default () => {
  const complaint_types = [
    {
      id: 1,
      name_th: "ร้องเรียน",
      name_en: null,
      is_active: 1,
      due_date: 30,
      extend_time: 10,
      extend_date: 15,
    },
    {
      id: 2,
      name_th: "ร้องทุกข์ขอความช่วยเหลือ/แจ้งเบาะแส",
      name_en: null,
      is_active: 1,
      due_date: 15,
      extend_time: 10,
      extend_date: 7,
    },
    {
      id: 3,
      name_th: "ร้องเรียน/แจ้งเบาะแสเกี่ยวกับยาเสพติด",
      name_en: null,
      is_active: 1,
      due_date: 15,
      extend_time: 10,
      extend_date: 7,
    },
    {
      id: 4,
      name_th: "เจ้าหน้าที่ตำรวจร้องเรียนเจ้าหน้าที่ตำรวจ",
      name_en: null,
      is_active: 1,
      due_date: 30,
      extend_time: 10,
      extend_date: 15,
    },
  ];

  return {
    complaint_types,
  };
};
