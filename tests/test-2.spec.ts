import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://localhost:5173/jcoms/appeal');
  await page.goto('http://localhost:5173/jcoms/');
  await page.goto('http://localhost:5173/jcoms/home');
  await page.getByText('ร้องเรียน (ประชาชนร้องเรียนตำรวจ)').click();
  await page.locator('#otp-modal').getByPlaceholder('หมายเลขโทรศัพท์มือถือ').click();
  await page.locator('#otp-modal').getByPlaceholder('หมายเลขโทรศัพท์มือถือ').fill('0802112900');
  await page.getByRole('button', { name: 'ส่ง OTP' }).click();
  await page.getByPlaceholder('รหัส OTP').click();
  await page.getByPlaceholder('รหัส OTP').fill('137623');
  await page.getByRole('button', { name: 'ยืนยัน' }).click();
  await page.getByRole('button', { name: 'ตกลง' }).click();
  await page.getByRole('button', { name: 'ถัดไป' }).click();
  await page.getByPlaceholder('คำนำหน้า (ยศ)/prefix').click();
  await page.getByRole('option', { name: 'พลตำรวจโท', exact: true }).click();
  await page.getByRole('textbox', { name: 'ชื่อ/Firstname' }).fill('dqwd');
  await page.getByRole('textbox', { name: 'ชื่อ/Firstname' }).click();
  await page.getByRole('textbox', { name: 'ชื่อ/Firstname' }).fill('dqwdwqd');
  await page.getByRole('textbox', { name: 'นามสกุล/Surname' }).fill('qwdqwd');
  await page.getByRole('textbox', { name: 'นามสกุล/Surname' }).click();
});