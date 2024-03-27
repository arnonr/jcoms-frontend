-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tbl_prefix_name`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_prefix_name` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_position` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(45) NULL,
  `name_en_abbr` VARCHAR(45) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `description` VARCHAR(200) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_inspector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_inspector` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `sort_order` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'กองตรวจราชการ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_bureau`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_bureau` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `sort_order` INT NULL,
  `inspector_id` INT NULL,
  `is_master` CHAR(1) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `bureau_ibfk_inspector_idx` (`inspector_id` ASC) VISIBLE,
  CONSTRAINT `bureau_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'กองบัญชาการ/ตำรวจภูธรภาค';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_division`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_division` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `bureau_id` INT NULL COMMENT 'กองบัญชาการ/ตำรวจภูธรภาค',
  `sort_order` VARCHAR(45) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `division_ibfk_bureau_idx` (`bureau_id` ASC) VISIBLE,
  CONSTRAINT `division_ibfk_bureau`
    FOREIGN KEY (`bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'กองบังคับการ/ตำรวจภูธรจังหวัด';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_section` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'สายงานตำรวจ เช่น ปราบปราม, สืบสวน ,ธุรการ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_agency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_agency` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_th_abbr` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `name_en_abbr` VARCHAR(100) NULL,
  `division_id` INT NULL,
  `sort_order` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `agency_ibfk_division_idx` (`division_id` ASC) VISIBLE,
  CONSTRAINT `agency_ibfk_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'สถานีตำรวจ/สน./หน่วยงานในกองบังคับการ/หน่วยงานในตำรวจภูธรจังหวัด';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(100) NULL,
  `username` VARCHAR(32) NULL,
  `prefix_name_id` INT NULL COMMENT 'คำนำหน้าชื่อ',
  `firstname` VARCHAR(100) NULL COMMENT 'ชื่อ',
  `lastname` VARCHAR(100) NULL COMMENT 'นามสกุล',
  `officer_code` VARCHAR(45) NULL COMMENT 'รหัสเจ้าหน้าที่',
  `id_card` VARCHAR(45) NULL COMMENT 'เลขประจำตัวประชาชน',
  `position_id` INT NULL COMMENT 'ตำแหน่ง',
  `section_id` INT NULL COMMENT 'สายงานตำรวจ เช่น ปราบปราม, สืบสวน ,ธุรการ',
  `role_id` INT NULL,
  `inspector_id` INT NULL COMMENT 'กองตรวจราชการ',
  `bureau_id` INT NULL COMMENT 'กองบัญชาการ',
  `division_id` INT NULL COMMENT 'กองบังคับการ/ภูธรจังหวัด',
  `agency_id` INT NULL COMMENT 'สถานีตำรวจ/สน./หน่วยงานในกองบังคับการ/หน่วยงานในตำรวจภูธรจังหวัด',
  `phone_number` VARCHAR(100) NULL COMMENT 'หมายเลขโทรศัพท์',
  `status` TINYINT(1) NULL COMMENT 'สถานะ 1=ใช้งาน,0=ปิดใช้งาน,2=รออนุมัติ',
  `email` VARCHAR(45) NULL COMMENT 'อีเมล',
  `line_id` VARCHAR(45) NULL COMMENT 'ID Line',
  `birthday` DATE NULL COMMENT 'วันเกิด',
  `file_attach` VARCHAR(200) NULL COMMENT 'ไฟล์หลักฐานแนบ',
  `password` VARCHAR(100) NULL COMMENT 'รหัสผ่าน',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `user_ibfk_1_idx` (`prefix_name_id` ASC) VISIBLE,
  INDEX `user_ibfk_position_id_idx` (`position_id` ASC) INVISIBLE,
  INDEX `user_ibfk_role_idx` (`role_id` ASC) VISIBLE,
  INDEX `user_ibfk_inspection_idx` (`inspector_id` ASC) VISIBLE,
  INDEX `user_ibfk_bureau_idx` (`bureau_id` ASC) VISIBLE,
  INDEX `user_ibfk_division_idx1` (`division_id` ASC) VISIBLE,
  INDEX `user_ibfk_section_idx` (`section_id` ASC) VISIBLE,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  CONSTRAINT `user_ibfk_1`
    FOREIGN KEY (`prefix_name_id`)
    REFERENCES `mydb`.`tbl_prefix_name` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_position_id`
    FOREIGN KEY (`position_id`)
    REFERENCES `mydb`.`tbl_position` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `mydb`.`tbl_role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_bureau`
    FOREIGN KEY (`bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_section`
    FOREIGN KEY (`section_id`)
    REFERENCES `mydb`.`tbl_section` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_ibfk_agency`
    FOREIGN KEY (`agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ผู้ใช้งานระบบ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `due_date` INT NOT NULL COMMENT 'ต้องดำเนินการแล้วเสร็จภายในกี่วัน',
  `extend_time` INT NOT NULL COMMENT 'ขยายเวลาดำเนินการได้กี่ครั้ง',
  `extend_date` INT NOT NULL COMMENT 'ขยายเวลาดำเนินการได้ครั้งละกี่วัน',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'ประเภทการร้องเรียน ร้องเรียน เบาะแส ประชาชนร้องเรียนเจ้าหน้าที่ ตำรวจร้องเรียนตำรวจ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_occupation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_occupation` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(45) NULL,
  `name_en` VARCHAR(45) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_province`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_province` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_district`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_district` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `province_id` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `district_ibfk_province_idx` (`province_id` ASC) VISIBLE,
  CONSTRAINT `district_ibfk_province`
    FOREIGN KEY (`province_id`)
    REFERENCES `mydb`.`tbl_province` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_sub_district`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_sub_district` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `district_id` INT NULL,
  `post_code` VARCHAR(10) NULL,
  `province_id` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `sub_district_ibfk_district_idx` (`district_id` ASC) VISIBLE,
  INDEX `sub_district_ibfk_province_idx` (`province_id` ASC) VISIBLE,
  CONSTRAINT `sub_district_ibfk_district`
    FOREIGN KEY (`district_id`)
    REFERENCES `mydb`.`tbl_district` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sub_district_ibfk_province`
    FOREIGN KEY (`province_id`)
    REFERENCES `mydb`.`tbl_province` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complainant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complainant` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(45) NULL COMMENT 'รหัสอ้างอิง UUID',
  `card_type` TINYINT(1) NULL COMMENT 'ประเภทบัตร 1=บัตรประชาชน, 2=หนังสือเดินทาง',
  `id_card` VARCHAR(45) NULL,
  `card_photo` VARCHAR(200) NULL,
  `prefix_name_id` INT NULL COMMENT 'คำนำหน้าชื่อ',
  `firstname` VARCHAR(100) NULL COMMENT 'ชื่อ',
  `lastname` VARCHAR(100) NULL COMMENT 'สกุล',
  `birthday` DATE NULL COMMENT 'วันเกิด',
  `occupation_id` INT NULL COMMENT 'อาชีพ กรณีใช้ตัวเลือก',
  `occupation_text` VARCHAR(100) NULL COMMENT 'ระบุอาชีพ',
  `phone_number` VARCHAR(45) NULL COMMENT 'หมายเลโทรศัพท์',
  `email` VARCHAR(45) NULL COMMENT 'อีเมล',
  `house_number` VARCHAR(45) NULL COMMENT 'บ้านเลขที่',
  `building` VARCHAR(100) NULL COMMENT 'หมู่บ้าน/อาคาร',
  `moo` VARCHAR(45) NULL COMMENT 'หมู่ที่',
  `soi` VARCHAR(100) NULL COMMENT 'ซอย',
  `road` VARCHAR(100) NULL COMMENT 'ถนน',
  `postal_code` VARCHAR(45) NULL COMMENT 'รหัสไปรษณีย์',
  `sub_district_id` INT NULL COMMENT 'ตำบล',
  `district_id` INT NULL COMMENT 'อำเภอ',
  `province_id` INT NULL COMMENT 'จังหวัด',
  `line_id` VARCHAR(45) NULL COMMENT 'ID line',
  `position_id` INT NULL COMMENT 'ตำแหน่ง',
  `section_id` INT NULL COMMENT 'สายงานตำรวจ เช่น ปราบปราม, สืบสวน ,ธุรการ',
  `inspector_id` INT NULL COMMENT 'กองตรวจราชการ',
  `bureau_id` INT NULL COMMENT 'กองบัญชาการ',
  `division_id` INT NULL COMMENT 'กองบังคับการ/ภูธรจังหวัด',
  `agency_id` INT NULL COMMENT 'สถานีตำรวจ/สน./หน่วยงานในกองบังคับการ/หน่วยงานในตำรวจภูธรจังหวัด',
  `complainant_type` TINYINT(1) NULL COMMENT 'ประเภทผู้ร้องเรียน 1=ประชาชน, 2=เจ้าหน้าที่ตำรวจ',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `complainant_ibfk_prefix_name_idx` (`prefix_name_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_occupation_idx` (`occupation_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_postion_idx` (`position_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_section_idx` (`section_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_inspector_idx` (`inspector_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_bureau_idx` (`bureau_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_division_idx` (`division_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_agency_idx` (`agency_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_province_idx` (`province_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_district_idx` (`district_id` ASC) VISIBLE,
  INDEX `complainant_ibfk_sub_district_idx` (`sub_district_id` ASC) VISIBLE,
  CONSTRAINT `complainant_ibfk_prefix_name`
    FOREIGN KEY (`prefix_name_id`)
    REFERENCES `mydb`.`tbl_prefix_name` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_occupation`
    FOREIGN KEY (`occupation_id`)
    REFERENCES `mydb`.`tbl_occupation` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_postion`
    FOREIGN KEY (`position_id`)
    REFERENCES `mydb`.`tbl_position` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_section`
    FOREIGN KEY (`section_id`)
    REFERENCES `mydb`.`tbl_section` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_bureau`
    FOREIGN KEY (`bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_agency`
    FOREIGN KEY (`agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_province`
    FOREIGN KEY (`province_id`)
    REFERENCES `mydb`.`tbl_province` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_district`
    FOREIGN KEY (`district_id`)
    REFERENCES `mydb`.`tbl_district` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complainant_ibfk_sub_district`
    FOREIGN KEY (`sub_district_id`)
    REFERENCES `mydb`.`tbl_sub_district` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_channel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_channel` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_tn` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `can_input` TINYINT(1) NULL COMMENT '1=สามารถระบุเพิ่มเติมได้',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tbl_topic_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_topic_category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `complaint_type_id` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `topic_category_ibfk_complaint_type_idx` (`complaint_type_id` ASC) VISIBLE,
  CONSTRAINT `topic_category_ibfk_complaint_type`
    FOREIGN KEY (`complaint_type_id`)
    REFERENCES `mydb`.`tbl_complaint_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ประเภทเรื่องร้องเรียน ทุจริตต่อหน้าที่ ปฎิบัติหน้าที่มิชอบ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_topic_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_topic_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `topic_category_id` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `topic_ibfk_category_idx` (`topic_category_id` ASC) VISIBLE,
  CONSTRAINT `topic_ibfk_category`
    FOREIGN KEY (`topic_category_id`)
    REFERENCES `mydb`.`tbl_topic_category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ลักษณะเรื่องร้องเรียน เช่น เบียดบังทรัพย์สิน(โกง), ละเว้นการปฏิบัติหน้าที่';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_state` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'ลำดับการดำเนินเรื่อง 1. ร้องเรียนใหม่ 2.รับเรื่อง 3.ส่งกองตรวจรายการ .. ส่งกองบังคับการจังหวัก';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(45) NULL,
  `complaint_code` VARCHAR(45) NULL COMMENT 'หมายเลขเรื่องร้องเรียน',
  `tracking_satisfaction` TINYINT(1) NULL COMMENT 'ความพึงพอใจการติดตามเรื่อง',
  `tracking_satisfaction_at` DATETIME NULL COMMENT 'ประเมินความพึงพอใจการติดตามเรื่องเมื่อเวลา',
  `complaint_satisfaction` TINYINT(1) NULL COMMENT 'ความพึงพอใจการร้องเรียน',
  `complaint_satisfaction_at` DATETIME NULL COMMENT 'ประเมินความพึงพอใจการร้องเรียนเมื่อเวลา',
  `receive_at` DATETIME NULL COMMENT 'เวลารับเรื่่อง',
  `receive_user_id` INT NULL,
  `complaint_type_id` INT NULL COMMENT 'ประเภทการร้องเรียน ร้องเรียน เบาะแส ประชาชนร้องเรียนเจ้าหน้าที่ ตำรวจร้องเรียนตำรวจ',
  `complainant_id` INT NULL COMMENT 'ผู้ร้องเรียน',
  `is_anonymous` TINYINT(1) NULL COMMENT 'ร้องเรียนแบบไม่ระบุตัวตน 1 ระบุ 2 ไม่ระบุ',
  `complaint_title` VARCHAR(200) NULL COMMENT 'เรื่องร้องเรียน',
  `complaint_detail` TEXT(1000) NULL COMMENT 'รายละเอียดการร้องเรียน',
  `incident_date` DATE NULL COMMENT 'วันที่เกิดเหตุ',
  `location_coordinates` VARCHAR(100) NULL COMMENT 'พิกัดสถานที่เกิดเหตุ (Google map)',
  `incident_location` VARCHAR(200) NULL COMMENT 'สถานที่เกิดเหตุโดยละเอียด',
  `incident_time` TIME NULL,
  `day_time` TINYINT(1) NULL COMMENT 'ห้วงเวลาเกิดเหตุ 1=กลางวัน,2=กลางคืน',
  `file_attach_1` VARCHAR(200) NULL COMMENT 'ไฟล์',
  `file_attach_2` VARCHAR(200) NULL,
  `file_attach_3` VARCHAR(200) NULL,
  `file_attach_4` VARCHAR(200) NULL,
  `file_attach_5` VARCHAR(200) NULL,
  `complaint_channel_id` INT NULL COMMENT 'ช่องทางการร้องเรียน',
  `inspector_id` INT NULL COMMENT 'กองตรวจราชการ',
  `bureau_id` INT NULL COMMENT 'กองบัญชาการ/ตำรวจภูธรภาค',
  `division_id` INT NULL COMMENT 'กองบังคับการ/ภูธรจังหวัด',
  `agency_id` INT NULL,
  `topic_type_id` INT NULL,
  `house_number` VARCHAR(45) NULL,
  `building` VARCHAR(100) NULL COMMENT 'หมู่บ้าน/อาคาร',
  `moo` VARCHAR(45) NULL COMMENT 'หมู่ที่',
  `soi` VARCHAR(100) NULL,
  `road` VARCHAR(100) NULL COMMENT 'ถนน',
  `postal_code` VARCHAR(45) NULL COMMENT 'รหัสไปรษณีย์',
  `sub_district_id` INT NULL,
  `district_id` INT NULL,
  `province_id` INT NULL,
  `state_id` INT NULL COMMENT 'ลำดับการดำเนินเรื่อง 1. ร้องเรียนใหม่ 2.รับเรื่อง 3.ส่งกองตรวจรายการ .. ส่งกองบังคับการจังหวัก',
  `notice_type` TINYINT(1) NULL COMMENT 'ช่องทางการแจ้งเตือนที่ต้องการได้ 1=SMS,2=Email,3=Line',
  `jcoms_no` VARCHAR(45) NULL COMMENT 'เลขที่ JCOMS',
  `pol_no` VARCHAR(45) NULL COMMENT 'เลขที่ POL',
  `receive_doc_no` VARCHAR(45) NULL COMMENT 'เลขรับ ฝรท',
  `receive_doc_date` DATE NULL COMMENT 'วันที่หนังสือรับ ฝรท',
  `forward_doc_no` VARCHAR(45) NULL COMMENT 'เลขที่หนังสือส่ง จต/ตร',
  `forward_doc_date` DATE NULL COMMENT 'วันที่หนังสือส่ง จต/ตร',
  `receive_status` TINYINT(1) NULL COMMENT '1=รับเรื่อง,2=ไม่รับเรื่อง (ข้อมูลไม่ครบถ้วน),3=ไม่รับเรื่อง (เป็นการร้องทุกข์กล่าวโทษคดีอาญา)',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `complaint_ibfk_type_idx` (`complaint_type_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_complainant_idx` (`complainant_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_district_idx` (`district_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_sub_district_idx` (`sub_district_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_province_idx` (`province_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_channel_idx` (`complaint_channel_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_bureau_idx` (`bureau_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_inspector_idx` (`inspector_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_division_idx` (`division_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_topic_type_idx` (`topic_type_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_proceed_state_idx` (`state_id` ASC) VISIBLE,
  INDEX `complaint_ibfk_user_receive_idx` (`receive_user_id` ASC) VISIBLE,
  CONSTRAINT `complaint_ibfk_type`
    FOREIGN KEY (`complaint_type_id`)
    REFERENCES `mydb`.`tbl_complaint_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_complainant`
    FOREIGN KEY (`complainant_id`)
    REFERENCES `mydb`.`tbl_complainant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_province`
    FOREIGN KEY (`province_id`)
    REFERENCES `mydb`.`tbl_province` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_district`
    FOREIGN KEY (`district_id`)
    REFERENCES `mydb`.`tbl_district` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_sub_district`
    FOREIGN KEY (`sub_district_id`)
    REFERENCES `mydb`.`tbl_sub_district` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_channel`
    FOREIGN KEY (`complaint_channel_id`)
    REFERENCES `mydb`.`tbl_complaint_channel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_bureau`
    FOREIGN KEY (`bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_topic_type`
    FOREIGN KEY (`topic_type_id`)
    REFERENCES `mydb`.`tbl_topic_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_proceed_state`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`tbl_state` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_ibfk_user_receive`
    FOREIGN KEY (`receive_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ตารางข้อมูลการร้องเรียน';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_accused`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_accused` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prefix_name_id` INT NULL,
  `firstname` VARCHAR(100) NULL,
  `lastname` VARCHAR(100) NULL,
  `position_id` INT NULL,
  `section_id` INT NULL COMMENT 'สายงานตำรวจ เช่น ปราบปราม, สืบสวน ,ธุรการ',
  `agency_id` INT NULL COMMENT 'สถานีตำรวจ/สน./หน่วยงานในกองบังคับการ/หน่วยงานในตำรวจภูธรจังหวัด',
  `inspector_id` INT NULL COMMENT 'กองตรวจราชการ',
  `bureau_id` INT NULL COMMENT 'กองบัญชาการ',
  `division_id` INT NULL COMMENT 'กองบังคับการ/ภูธรจังหวัด',
  `complaint_id` INT NULL,
  `type` TINYINT(1) NULL COMMENT 'ประเภทผู้ถูกกล่าวหา 1=ประชาชน,2=ตำรวจ',
  `detail` VARCHAR(200) NULL COMMENT 'รายละเอียด',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `accused_ibfk_complaint_idx` (`complaint_id` ASC) VISIBLE,
  INDEX `accused_ibfk_prefixname_idx` (`prefix_name_id` ASC) VISIBLE,
  INDEX `accused_ibfk_position_idx` (`position_id` ASC) VISIBLE,
  INDEX `accused_ibfk_section_idx` (`section_id` ASC) VISIBLE,
  INDEX `accused_ibfk_agency_idx` (`agency_id` ASC) VISIBLE,
  INDEX `accused_ibfk_inspector_idx` (`inspector_id` ASC) VISIBLE,
  INDEX `accused_ibfk_bureau_idx` (`bureau_id` ASC) VISIBLE,
  INDEX `accused_ibfk_division_idx` (`division_id` ASC) VISIBLE,
  CONSTRAINT `accused_ibfk_complaint`
    FOREIGN KEY (`complaint_id`)
    REFERENCES `mydb`.`tbl_complaint` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_prefixname`
    FOREIGN KEY (`prefix_name_id`)
    REFERENCES `mydb`.`tbl_prefix_name` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_position`
    FOREIGN KEY (`position_id`)
    REFERENCES `mydb`.`tbl_position` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_section`
    FOREIGN KEY (`section_id`)
    REFERENCES `mydb`.`tbl_section` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_agency`
    FOREIGN KEY (`agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_bureau`
    FOREIGN KEY (`bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `accused_ibfk_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ผู้ถูกกล่าวหา';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_order` (
  `id` INT NOT NULL,
  `name_th` VARCHAR(45) NULL,
  `name_en` VARCHAR(45) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'ข้อสั่งการ 1=พิจารณาดำเนินการตามอำนาจหน้าที่ 2=เป็นข้อมูลในการปฏิบัติราชการ 3=เร่งรัดติตตามผล';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_forward`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_forward` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `complaint_id` INT NULL COMMENT 'วันที่หนังสือส่งต่อ',
  `foward_doc_no` VARCHAR(100) NULL,
  `foward_doc_date` DATE NULL,
  `foward_doc_filename` VARCHAR(200) NULL,
  `forward_at` DATETIME NULL COMMENT 'ส่งต่อเรื่องเมื่อ',
  `forward_user_id` INT NULL COMMENT 'ผู้ส่งต่อเรื่อง',
  `from_inspector_id` INT NULL,
  `from_bureau_id` INT NULL,
  `from_agency_id` INT NULL COMMENT 'จากหน่วยงาน',
  `from_division_id` INT NULL,
  `to_inspector_id` INT NULL,
  `to_bureau_id` INT NULL,
  `to_division_id` INT NULL,
  `to_agency_id` INT NULL COMMENT 'ถึงหน่วยงาน (สน.)',
  `receive_doc_no` VARCHAR(100) NULL COMMENT 'เลขที่ลงรับเรื่อง',
  `receive_doc_date` DATETIME NULL COMMENT 'วันที่ลงรับเรื่อง',
  `receive_doc_filename` VARCHAR(200) NULL,
  `receive_user_id` INT NULL COMMENT 'ผู้รับเรื่อง',
  `receive_at` DATETIME NULL COMMENT 'รับเรื่องเมื่อ',
  `order_id` INT NULL COMMENT 'ข้อสั่งการ ให้หน่วยงานรับเรื่องปฏิบัติ',
  `receive_status` INT NULL COMMENT '1=รับ,2=ไม่รับ',
  `order_id` INT NULL,
  `order_detail` VARCHAR(200) NULL COMMENT 'รายละเอียดข้อสั่งการ',
  `receive_status` TINYINT(1) NULL COMMENT 'สถานะการรับ 1=รับเรื่อง',
  `state_id` INT NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  PRIMARY KEY (`id`),
  INDEX `forward_ibfk_complaint_idx` (`complaint_id` ASC) VISIBLE,
  INDEX `forward_ibfk_from_inspector_idx` (`from_inspector_id` ASC) VISIBLE,
  INDEX `forward_ibfk_from_bureau_idx` (`from_bureau_id` ASC) VISIBLE,
  INDEX `forward_ibfk_from_division_idx` (`from_division_id` ASC) VISIBLE,
  INDEX `forward_ibfk_from_agency_idx` (`from_agency_id` ASC) VISIBLE,
  INDEX `forward_ibfk_to_inspector_idx` (`to_inspector_id` ASC) VISIBLE,
  INDEX `forward_ibfk_to_bureau_idx` (`to_bureau_id` ASC) VISIBLE,
  INDEX `forward_ibfk_to_division_idx` (`to_division_id` ASC) VISIBLE,
  INDEX `forward_ibfk_to_agency_idx` (`to_agency_id` ASC) VISIBLE,
  INDEX `forward_ibfk_order_idx` (`order_id` ASC) VISIBLE,
  INDEX `forward_ibfk_state_idx` (`state_id` ASC) INVISIBLE,
  INDEX `forward_ibfk_forward_user_idx` (`forward_user_id` ASC) VISIBLE,
  INDEX `forward_ibfk_receive_user_idx` (`receive_user_id` ASC) VISIBLE,
  CONSTRAINT `forward_ibfk_complaint`
    FOREIGN KEY (`complaint_id`)
    REFERENCES `mydb`.`tbl_complaint` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_from_inspector`
    FOREIGN KEY (`from_inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_from_bureau`
    FOREIGN KEY (`from_bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_from_division`
    FOREIGN KEY (`from_division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_from_agency`
    FOREIGN KEY (`from_agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_to_inspector`
    FOREIGN KEY (`to_inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_to_bureau`
    FOREIGN KEY (`to_bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_to_division`
    FOREIGN KEY (`to_division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_to_agency`
    FOREIGN KEY (`to_agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`tbl_order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_state`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`tbl_state` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_forward_user`
    FOREIGN KEY (`forward_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `forward_ibfk_receive_user`
    FOREIGN KEY (`receive_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'การส่งต่อเรื่องร้องเรียน';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_proceed_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_proceed_status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `namt_th` VARCHAR(100) NULL,
  `name_en` VARCHAR(100) NULL,
  `state_id` INT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `status_ibfk_state_idx` (`state_id` ASC) VISIBLE,
  CONSTRAINT `status_ibfk_state`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`tbl_state` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'สถานะการดำเนินเรื่อง';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_report` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `complaint_id` INT NULL,
  `proceed_status_id` INT NULL,
  `report_doc_no` VARCHAR(100) NULL,
  `report_doc_date` DATE NULL,
  `report_doc_filename` VARCHAR(200) NULL,
  `report_user_id` INT NULL,
  `report_at` DATETIME NULL,
  `from_inspector_id` INT NULL,
  `from_bureau_id` INT NULL,
  `from_division_id` INT NULL,
  `from_agency_id` INT NULL,
  `to_inspector_id` INT NULL,
  `to_bureau_id` INT NULL,
  `to_division_id` INT NULL,
  `to_agency_id` INT NULL,
  `receive_doc_no` VARCHAR(100) NULL COMMENT 'เลขที่ลงรับเรื่อง',
  `receive_doc_date` DATETIME NULL COMMENT 'วันที่ลงรับเรื่อง',
  `receive_doc_filename` VARCHAR(200) NULL,
  `receive_user_id` INT NULL COMMENT 'ผู้รับเรื่อง',
  `receive_at` DATETIME NULL COMMENT 'รับเรื่องเมื่อ',
  `state_id` INT NULL COMMENT 'ลำดับการดำเนินเรื่อง 1. ร้องเรียนใหม่ 2.รับเรื่อง 3.ส่งกองตรวจรายการ .. ส่งกองบังคับการจังหวัด',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `report_ibfk_complaint_idx` (`complaint_id` ASC) VISIBLE,
  INDEX `report_ibfk_proceed_idx` (`proceed_status_id` ASC) VISIBLE,
  INDEX `report_ibfk_proceed_state_idx` (`state_id` ASC) VISIBLE,
  INDEX `report_ibfk_report_user_idx` (`report_user_id` ASC) VISIBLE,
  INDEX `from_inspector_id_idx` (`from_inspector_id` ASC) VISIBLE,
  INDEX `from_bureau_id_idx` (`from_bureau_id` ASC) VISIBLE,
  INDEX `from_division_id_idx` (`from_division_id` ASC) VISIBLE,
  INDEX `from_agency_id_idx` (`from_agency_id` ASC) VISIBLE,
  INDEX `to_inspector_id_idx` (`to_inspector_id` ASC) VISIBLE,
  INDEX `to_bureau_id_idx` (`to_bureau_id` ASC) VISIBLE,
  INDEX `to_division_id_idx` (`to_division_id` ASC) VISIBLE,
  INDEX `to_agency_id_idx` (`to_agency_id` ASC) VISIBLE,
  INDEX `receive_user_id_idx` (`receive_user_id` ASC) VISIBLE,
  CONSTRAINT `report_ibfk_complaint`
    FOREIGN KEY (`complaint_id`)
    REFERENCES `mydb`.`tbl_complaint` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `report_ibfk_proceed_status`
    FOREIGN KEY (`proceed_status_id`)
    REFERENCES `mydb`.`tbl_proceed_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `report_ibfk_state`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`tbl_state` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `report_ibfk_report_user`
    FOREIGN KEY (`report_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `from_inspector_id`
    FOREIGN KEY (`from_inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `from_bureau_id`
    FOREIGN KEY (`from_bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `from_division_id`
    FOREIGN KEY (`from_division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `from_agency_id`
    FOREIGN KEY (`from_agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `to_inspector_id`
    FOREIGN KEY (`to_inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `to_bureau_id`
    FOREIGN KEY (`to_bureau_id`)
    REFERENCES `mydb`.`tbl_bureau` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `to_division_id`
    FOREIGN KEY (`to_division_id`)
    REFERENCES `mydb`.`tbl_division` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `to_agency_id`
    FOREIGN KEY (`to_agency_id`)
    REFERENCES `mydb`.`tbl_agency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `receive_user_id`
    FOREIGN KEY (`receive_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'การรายงานผลการดำเนินการ';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_follow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_follow` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `inspector_id` INT NULL,
  `complaint_id` INT NULL,
  `detail` VARCHAR(200) NULL,
  `follow_doc_no` VARCHAR(100) NULL COMMENT 'เลขที่ลงรับเรื่อง',
  `follow_doc_date` DATETIME NULL COMMENT 'วันที่ลงรับเรื่อง',
  `follow_doc_filename` VARCHAR(200) NULL,
  `follow_user_id` INT NULL COMMENT 'ผู้รับเรื่อง',
  `follow_at` DATETIME NULL COMMENT 'รับเรื่องเมื่อ',
  `receive_doc_no` VARCHAR(100) NULL COMMENT 'เลขที่ลงรับเรื่อง',
  `receive_doc_date` DATETIME NULL COMMENT 'วันที่ลงรับเรื่อง',
  `receive_doc_filename` VARCHAR(200) NULL,
  `receive_user_id` INT NULL COMMENT 'ผู้รับเรื่อง',
  `receive_at` DATETIME NULL COMMENT 'รับเรื่องเมื่อ',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `complaint_follow_ibfk_complaint_idx` (`complaint_id` ASC) VISIBLE,
  INDEX `complaint_follow_ibfk_inspector_idx` (`inspector_id` ASC) VISIBLE,
  INDEX `complaint_follow_ibfk_follow_user_id_idx` (`follow_user_id` ASC) VISIBLE,
  INDEX `complaint_follow_ibfk_receive_user_id_idx` (`receive_user_id` ASC) VISIBLE,
  CONSTRAINT `complaint_follow_ibfk_complaint`
    FOREIGN KEY (`complaint_id`)
    REFERENCES `mydb`.`tbl_complainant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_follow_ibfk_inspector`
    FOREIGN KEY (`inspector_id`)
    REFERENCES `mydb`.`tbl_inspector` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_follow_ibfk_follow_user_id`
    FOREIGN KEY (`follow_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `complaint_follow_ibfk_receive_user_id`
    FOREIGN KEY (`receive_user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'การติดตามเรื่องร้องเรียน';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_login_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_login_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `logined_at` DATETIME NULL,
  `ip_address` VARCHAR(100) NULL,
  `user_agent` VARCHAR(200) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  INDEX `loginlog_ibfk_user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `loginlog_ibfk_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`tbl_user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Log ยืนยันตัวตนเข้าใช้งาน';


-- -----------------------------------------------------
-- Table `mydb`.`tbl_complaint_channel_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tbl_complaint_channel_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `complaint_id` INT NULL,
  `complaint_channel_id` INT NULL,
  `description` VARCHAR(100) NULL COMMENT 'ระบุช่องทางร้องเรียน กรณีช่องทางอื่นๆ',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` VARCHAR(32) NULL,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(32) NULL,
  `deleted_at` DATETIME NULL,
  `deleted_by` VARCHAR(32) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `channel_history_ibfk_complaint_idx` (`complaint_id` ASC) VISIBLE,
  INDEX `channel_history_ibfk_channel_idx` (`complaint_channel_id` ASC) VISIBLE,
  CONSTRAINT `channel_history_ibfk_complaint`
    FOREIGN KEY (`complaint_id`)
    REFERENCES `mydb`.`tbl_complaint` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `channel_history_ibfk_channel`
    FOREIGN KEY (`complaint_channel_id`)
    REFERENCES `mydb`.`tbl_complaint_channel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'ช่องทางร้องเรียนอื่น ที่เคยร้องเรียนมาแล้ว';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
