export default () => {
  const types = [
    {
      id: 1,
      value: 1,
      name: "Report",
    },
    {
      id: 2,
      value: 2,
      name: "Certificate",
    },
  ];

  const publishes = [
    {
      id: 0,
      value: 0,
      name: "none",
      color: "warning",
    },
    {
      id: 1,
      value: 1,
      name: "publish",
      color: "success",
    },
  ];
  const actives = [
    {
      id: 0,
      value: 0,
      name: "none",
      color: "warning",
    },
    {
      id: 1,
      value: 1,
      name: "active",
      color: "success",
    },
  ];

  const user_statuses = [
    {
      id: 0,
      value: 0,
      name: "ปิดการใช้งาน",
      color: "danger",
    },
    {
      id: 1,
      value: 1,
      name: "ใช้งาน",
      color: "success",
    },
  ];

  const day_times = [
    {
      name: "กลางวัน",
      value: 1,
    },
    { name: "กลางคืน", value: 2 },
  ];

  const is_anonymouses = [
    { name: "ระบุตัวตน", value: 1 },
    { name: "ไม่ระบุตัวตน", value: 2 },
  ];

  const card_types = [
    {
      name: "หมายเลขบัตรประชาชน",
      value: 1,
    },
    {
      name: "หนังสือเดินทาง",
      value: 2,
    },
  ];

  const receive_statuses = [
    {
      name: "รับเรื่อง",
      value: 1,
      state_id: 3,
    },
    {
      name: "ข้อมูลไม่ครบถ้วน",
      value: 2,
      state_id: 18,
    },
    {
      name: "เป็นการร้องทุกข์ กล่าวโทษคดีอาญา",
      value: 3,
      state_id: 18,
    },
  ];
  const orders = [
    {
      value: 1,
      name: "พิจารณาดำเนินการตามอำนาจหน้าที่",
    },
    {
      value: 2,
      name: "เป็นข้อมูลในการปฏิบัติราชการ",
    },
    {
      value: 3,
      name: "เร่งรัดติตตามผล",
    },
  ];

  return {
    publishes,
    actives,
    user_statuses,
    types,
    day_times,
    is_anonymouses,
    card_types,
    receive_statuses,
    orders,
  };
};
