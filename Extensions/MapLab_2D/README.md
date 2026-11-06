# MapLab 2D และตัวอย่างโจทย์ต่อยอด

เปิด `project.godot` ด้วย Godot 4.7.2 Standard แล้วเลือกแท็บ 2D

## ฝึกวางวัตถุในแมพ

เปิด `scenes/map_lab.tscn` แล้วกด F6 เพื่อรันฉากนี้ หรือกด F5 เพื่อรันแมพที่เป็น Main Scene ของโปรเจกต์ฝึก

- `Map` เป็น Node2D root
- `Background` แสดงภาพพื้นหลัง
- `Decoration` และ `Decoration2` เป็น instance ของ `scenes/decoration.tscn` ที่ตำแหน่ง (240,180) และ (720,180)
- `Player` เป็น instance ของ `scenes/player.tscn` ที่ตำแหน่ง (480,476) พร้อม script และขอบเขตชน ขยับด้วย A/D หรือลูกศรได้
- `Decoration` เป็นภาพตกแต่ง ไม่มีระบบชนหรือการตกลงมา จึงไม่ทำให้ Game Over

สร้างวัตถุใหม่ด้วย Scene > New Scene > 2D Scene ตั้งชื่อ root แล้วลาก PNG จาก FileSystem ลงจุดกำเนิด Godot จะเพิ่ม Sprite2D และ Texture ให้ บันทึกเป็นไฟล์ .tscn ใน scenes

กลับแท็บแมพ เลือก Map แล้วลาก .tscn จาก FileSystem ลง viewport เลือก instance และแก้ Inspector > Transform > Position หากต้องการกำหนดพิกัดแน่นอน เลือก instance ใน Scene Tree แล้วกด Ctrl+D เพื่อทำสำเนา ก่อนย้ายสำเนาออกจากจุดเดิม

## ตัวอย่างพาทำเพิ่ม: ระดับความยาก

เปิด `scenes/challenge_difficulty.tscn` แล้วกด F6 เพื่อรันเกมตัวอย่างที่เพิ่มความยาก เปิด `scripts/main_difficulty.gd` เพื่อดูโค้ด

ฉากนี้สืบทอดโครงสร้างจาก Main และใช้ script ที่สืบทอด main.gd โดยเปลี่ยนเฉพาะ `_spawn_obstacle()` ตัวอย่างยังใช้ Input, Score, Game Over และ Restart ของเกมเดิม

- ทุก 15 วินาทีของคะแนน เพิ่ม level หนึ่งระดับ
- ช่วง spawn ลดจาก 0.8 วินาทีครั้งละ 0.08 และไม่ต่ำกว่า 0.25
- ความเร็ววัตถุใหม่เพิ่มจาก 300 ครั้งละ 30 และไม่เกิน 600
- หลัง Game Over หยุดทุกระบบ และเมื่อ R/Enter เริ่มใหม่ ระดับกลับไปเริ่มต้น

ผู้เรียนที่แก้เกมของตนเอง ให้สำรองโปรเจกต์ แล้วเพิ่มสามบรรทัด level / wait_time / obstacle.fall_speed ใน `_spawn_obstacle()` ตามคู่มือ `Docs/EXTENSION_EXERCISES.md` ไม่จำเป็นต้องสร้าง inherited scene เหมือนตัวอย่างนี้

ตัวเกมหลักอยู่ในโฟลเดอร์ `Final_Project` ของ repository นี้
