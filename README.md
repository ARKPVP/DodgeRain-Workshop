# Dodge Rain Workshop

โปรเจกต์ Godot 2D สำหรับผู้เรียนที่ต้องการดูตัวอย่างโค้ดหรือกลับมาทำต่อเมื่อทำตามในห้องไม่ทัน

## เริ่มใช้งาน

1. ดาวน์โหลด [Godot 4.7.2 Standard](https://godotengine.org/download/archive/4.7.2-stable/) ตามระบบปฏิบัติการของคุณ
2. กดปุ่ม **Code > Download ZIP** บน GitHub แล้วแตกไฟล์ ZIP ลงในโฟลเดอร์ของคุณ
3. เปิด Godot เลือก **Import** แล้วเลือกไฟล์ `project.godot` ในโฟลเดอร์ที่ต้องการจากรายการด้านล่าง
4. รอให้ Godot นำเข้า assets แล้วกด **F5** เพื่อทดลองรัน

เก็บงานเดิมของตัวเองไว้ก่อน และเปิด checkpoint ในโฟลเดอร์แยก เพื่อกลับไปแก้ไขงานเดิมได้

## เลือกจุดเริ่มต้น

| โฟลเดอร์ | เนื้อหา |
| --- | --- |
| [Starter_Project](Starter_Project) | โปรเจกต์ตั้งต้นสำหรับฝึก |
| [Checkpoint 1](Checkpoints/checkpoint_1_player) | นาที 75: ตัวละครเคลื่อนที่และจำกัดขอบจอ |
| [Checkpoint 2](Checkpoints/checkpoint_2_spawn) | นาที 115: สุ่มสร้างสิ่งกีดขวาง |
| [Checkpoint 3](Checkpoints/checkpoint_3_core_game) | นาที 148: ระบบชน คะแนน Game Over และเริ่มใหม่ |
| [Final_Project](Final_Project) | เกมฉบับสมบูรณ์ พร้อมภาพพื้นหลังและเสียง |
| [MapLab_2D](Extensions/MapLab_2D) | ตัวอย่างฝึกวางวัตถุและต่อยอดความยาก |

อ่าน [คู่มือผู้เรียน](Docs/STUDENT_GUIDE_Updated.md) และ [โจทย์ต่อยอด](Docs/EXTENSION_EXERCISES.md) พร้อมใช้ภาพและเสียงจาก [Assets](Assets) ได้

## การควบคุม

ใช้ **A/D** หรือ **ลูกศรซ้าย/ขวา** เพื่อเคลื่อนที่ ใน checkpoint 3 และเกมฉบับสมบูรณ์ กด **R** หรือ **Enter** หลัง Game Over เพื่อเริ่มใหม่

แต่ละโฟลเดอร์เป็นโปรเจกต์แยกกัน จึงต้องเลือก `project.godot` ของโฟลเดอร์นั้นเมื่อ Import ดูโค้ด GDScript ได้ในโฟลเดอร์ `scripts` ของแต่ละโปรเจกต์
