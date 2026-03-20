
  พีรพงศ์ ปัญญาสัน


# 🛍️ Barrel Store - API Data Management & Shopping Cart (Lab 10)

โปรเจกต์นี้เป็นส่วนหนึ่งของรายวิชา **การพัฒนาแอปพลิเคชันมือถือ** โดยเน้นการจัดการข้อมูลผ่าน Web API (CRUD), การจัดการสถานะ (State Management) ด้วย Provider และการทำระบบสิทธิ์ผู้ใช้งาน (RBAC)

---

## 🎯 วัตถุประสงค์ (Objectives)
* เชื่อมต่อและจัดการข้อมูลจาก **FakeStoreAPI** แบบ Asynchronous
* จัดการสถานะตระกร้าสินค้าและระบบ Login ด้วย **Provider**
* ออกแบบระบบแยกสิทธิ์ระหว่าง **Admin** และ **User** (Role-based Access Control)
* พัฒนา UI แบบแยกส่วน (Clean Architecture) เพื่อความง่ายในการบำรุงรักษา

---

## ✨ คุณสมบัติของระบบ (Features)

### 1. ระบบ Authentication & RBAC
* ตรวจสอบสิทธิ์การเข้าใช้งานผ่านข้อมูลจาก API
* **Admin (johnd):** สามารถเข้าถึงหน้า **Admin Panel** เพื่อจัดการข้อมูลผู้ใช้งาน (User Management)
* **User ทั่วไป:** เข้าสู่หน้ารายการสินค้าเพื่อเลือกซื้อสินค้าได้ตามปกติ

### 2. ระบบรายการสินค้า (Product Catalog)
* ดึงข้อมูลสินค้าทั้งหมดจาก `/products` มาแสดงผลในรูปแบบ Grid View
* มีระบบ Badge แสดงจำนวนชนิดสินค้าในตระกร้าบน Icon รถเข็นแบบ Real-time
* กดที่สินค้าเพื่อดูรายละเอียด (Description) แบบเต็มได้

### 3. ระบบตระกร้าสินค้า (Shopping Cart System)
* **Create/Read:** เพิ่มสินค้าลงตระกร้าได้จากหน้าหลักและหน้าละเอียด
* **Update/Delete:** สามารถเพิ่ม-ลดจำนวนสินค้า หรือลบสินค้าออกจากตระกร้าได้
* **Calculation:** คำนวณราคารวมของแต่ละชนิดสินค้า และราคาสุทธิรวม (Total Price) อัตโนมัติ


### 4. ระบบจัดการผู้ใช้ (Admin Management)
* เฉพาะ Admin เท่านั้นที่เข้าหน้านี้ได้
* ดึงรายชื่อผู้ใช้ทั้งหมดจาก `/users` มาแสดงผลในรูปแบบ List Card
* **แก้ไข (Edit):** แก้ไขข้อมูลผู้ใช้ เช่น ชื่อ, email, username, เบอร์โทร, ที่อยู่
* **ลบ (Delete):** ลบผู้ใช้ออกจากระบบ พร้อม dialog ยืนยัน


---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)
มีการแบ่งโฟลเดอร์ตามหลักการแยกส่วน (Separation of Concerns):
```text
lib/
├── models/
│   ├── product_model.dart   # โครงสร้างข้อมูลสินค้า
│   └── user_model.dart      # โครงสร้างข้อมูลผู้ใช้
├── providers/
│   ├── cart_provider.dart   # State จัดการตระกร้าสินค้า
│   ├── product_provider.dart # State ดึงข้อมูลสินค้า
│   └── user_provider.dart   # State ดึง/แก้ไข/ลบข้อมูลผู้ใช้
├── screens/
│   ├── login_screen.dart
│   ├── admin_screen.dart
│   ├── user_edit_screen.dart
│   ├── product_list_screen.dart
│   ├── product_detail_screen.dart
│   └── cart_screen.dart
└── main.dart
```

---

## 🌐 API Endpoints ที่ใช้งาน

| Method | Endpoint | การใช้งาน |
|--------|----------|-----------|
| GET | `/users` | ตรวจสอบ Login และดึงรายชื่อผู้ใช้สำหรับ Admin |
| PUT | `/users/{id}` | แก้ไขข้อมูลผู้ใช้ |
| DELETE | `/users/{id}` | ลบผู้ใช้ |
| GET | `/products` | ดึงรายการสินค้าทั้งหมดมาแสดงผล |

---

## 🚀 วิธีการรันโปรเจกต์

ติดตั้ง Dependencies:
```bash
flutter pub get
```

รันแอปพลิเคชัน:
```bash
flutter run
```

---

## 🔑 ข้อมูลสำหรับทดสอบ

| Role | Username | Password |
|------|----------|----------|
| Admin | johnd | m38rmn= |
| User | mor_2314 | 83r5^_ |
