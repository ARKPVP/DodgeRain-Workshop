# บทพาทำและโจทย์ต่อยอด Dodge Rain

เก็บสำเนาโปรเจกต์ที่เล่นได้ก่อนเลือกทำโจทย์ ไม่จำเป็นต้องทำครบทุกโจทย์ โฟลเดอร์บนไดรฟ์ U ในภาพเป็นตัวอย่างของเครื่องสาธิต ผู้เรียนเลือกตำแหน่งบันทึกของตนเอง

## พาทำ: นำภาพและ Scene มาวางในแมพ 2D

โปรเจกต์ตัวอย่างอยู่ใน `Extensions/MapLab_2D` เปิด `project.godot` ด้วย Godot 4.7.2 Standard แล้วเลือก 2D ฉาก `Map` ใช้ฝึกวางวัตถุ ส่วนเกมหลักอยู่ใน `Final_Project/DodgeRain` ขั้นตอนเดียวกันนำไปใช้ใน Main ของผู้เรียนได้

1. คัดลอก PNG จาก Asset Pack ลงโฟลเดอร์ `assets` ของโปรเจกต์ รอ Godot นำเข้าและเห็นชื่อไฟล์ใน FileSystem คลิกภาพแล้วแท็บ Import จะแสดงชนิด Texture2D
2. Scene > New Scene หรือ Ctrl+N แล้วเลือก 2D Scene ได้ root ชนิด Node2D ตั้งชื่อ `Decoration` ด้วย F2
3. ลาก `obstacle.png` จาก FileSystem ลงจุดกำเนิด (0,0) ของฉาก Godot จะสร้าง Sprite2D ลูกและกำหนด Texture ให้ ภาพนี้ใช้ตกแต่งจึงไม่มี collision
4. Ctrl+S บันทึกเป็น `res://scenes/decoration.tscn`
5. เปิดฉากแมพ เลือก root `Map` แล้วลาก `decoration.tscn` ลง viewport ได้ Scene instance เป็นลูกของ Map
6. เลือก instance แล้วเปิด Inspector > Transform > Position ตั้ง (240,180) หากต้องการย้ายด้วยเมาส์ ใช้ Move (W)
7. เลือก Decoration ใน Scene Tree แล้ว Ctrl+D ได้ Decoration2 ตั้ง (720,180) ตัวแรกต้องอยู่ตำแหน่งเดิม
8. เลือก Map แล้วลาก `player.tscn` ลงฉาก ตั้ง (480,476) ผู้เล่น instance นี้มี Sprite2D, CollisionShape2D และ script เดิม
9. เปิด `map_lab.tscn` กด F6 ทดลอง A/D และปุ่มลูกศร ตรวจว่าวัตถุอยู่ตรงตำแหน่งที่ตั้ง แล้ว F8 หยุด

ฉากฝึก Map ไม่มีระบบเกิดสิ่งกีดขวางหรือ Game Over ใช้ฝึกจัดวางเท่านั้น ในเกมหลักให้ใช้ Main และระบบของเกมเดิม วัตถุตกแต่งไม่มีผลต่อการชนจนกว่าจะเพิ่ม Area2D หรือ PhysicsBody2D พร้อม CollisionShape2D ตามกติกาที่ออกแบบ

เครื่องมือที่ใช้: FileSystem จัดไฟล์, Import ตั้งค่าการนำเข้า, Node2D เป็นตำแหน่งอ้างอิงของลูก, Sprite2D แสดงภาพ, Scene เก็บชุด Node ใช้ซ้ำ, Scene Tree เลือก parent/child, Inspector ปรับคุณสมบัติ, Transform ปรับตำแหน่ง/หมุน/ขนาด, Ctrl+D ทำสำเนา, F6 รันฉากปัจจุบัน, F8 หยุด

## พาทำ: ความยากตามเวลารอดในเกม

เปิดสำเนาเกมของตัวเอง จาก FileSystem เปิด `scripts/main.gd` แล้วไปที่ `_spawn_obstacle()` เพิ่ม level กับ wait_time ก่อน `instantiate()` และตั้ง fall_speed หลังสร้าง obstacle โดยเก็บ guard, ตำแหน่งสุ่ม, Signal และ add_child ของเดิมไว้

```gdscript
func _spawn_obstacle():
	if not game_running:
		return
	var level = int(score / 15.0)
	spawn_timer.wait_time = maxf(0.25, 0.8 - float(level) * 0.08)
	var obstacle = obstacle_scene.instantiate()
	obstacle.fall_speed = minf(600.0, 300.0 + float(level) * 30.0)
	var screen_width = get_viewport_rect().size.x
	obstacle.position = Vector2(rng.randf_range(40.0, screen_width - 40.0), -60.0)
	obstacle.body_entered.connect(_on_obstacle_body_entered)
	obstacle_layer.add_child(obstacle)
```

`level` เพิ่มทุก 15 วินาทีของเวลารอดในเกม `maxf` จำกัดช่วงเกิดไม่ให้ต่ำกว่า 0.25 วินาที ส่วน `minf` จำกัดความเร็วไม่ให้เกิน 600 พิกเซลต่อวินาที ค่าความเร็วนี้ตั้งให้วัตถุที่เกิดใหม่ วัตถุที่อยู่ในเกมก่อนหน้านั้นยังใช้ความเร็วเดิม

ตัวอย่างที่รันได้อยู่ใน MapLab: เปิด `scenes/challenge_difficulty.tscn` แล้ว F6 ตัวอย่างใช้ inherited Main scene และ script ลูก `main_difficulty.gd` เพื่อแยกบทต่อยอดจากเกมหลัก ผู้เรียนแก้ฟังก์ชันในสำเนา main.gd ได้โดยตรง

ตรวจค่า: เริ่มเกม interval 0.8 / speed 300; รอด 30 วินาที interval 0.64 / speed 360; ระดับสูง interval ไม่ต่ำกว่า 0.25 / speed ไม่เกิน 600 ตรวจ Game Over หยุดทุกระบบ และ R/Enter เริ่มใหม่กลับค่าเริ่มต้น

## โจทย์ลองเอง: หน้าตาเกมและแมพ

เป้าหมาย: เปลี่ยนภาพ Player กับ Background และวาง Scene ตกแต่งอย่างน้อย 3 ชิ้น ใช้ภาพของตนเองหรือภาพที่มีสิทธิ์ใช้

คำใบ้: Sprite2D > Texture, Ctrl+D, Inspector > Transform และลำดับการวาดหรือ Z Index หากปรับขนาดภาพ ต้องตรวจขอบชนให้เหมาะสมด้วย

ผ่านเมื่อ: ภาพไม่บังคะแนนหรือ Game Over ผู้เล่นไม่หลุดขอบ และ Restart ได้ตามเดิม

## โจทย์ลองเอง: ชีวิต 3 ครั้ง

เป้าหมาย: เริ่มด้วย lives = 3 แสดง LivesLabel ชนครั้งแรกกับครั้งที่สองยังเล่นต่อ ครั้งที่สามจึง Game Over

คำใบ้: แยกฟังก์ชันรับดาเมจจาก game_over() ใช้ body_entered อัปเดตชีวิตและข้อความ ต้องกำหนดว่าลบสิ่งกีดขวางที่ชน หรือให้ช่วงป้องกันการโดนซ้ำ เพื่อไม่ให้การชนครั้งเดียวลดชีวิตหมด

ผ่านเมื่อ: หนึ่งการชนลดหนึ่งชีวิต การชนหลังจบเกมไม่ลดเพิ่ม และ Restart คืน lives = 3 กับคะแนน 0

## โจทย์ลองเอง: ไอเทมโบนัส

เป้าหมาย: สร้าง Scene ไอเทมจาก Area2D + Sprite2D + CollisionShape2D เก็บแล้วได้โบนัส 10 คะแนนหนึ่งครั้งและไอเทมหาย

คำใบ้: ใช้ body_entered และ layer/mask ให้ตรวจ Player แยก `bonus_score` จากเวลารอด แสดงผลรวมบน Label แต่ใช้เวลารอดคำนวณความยากต่อไป ตรวจสถานะเกมก่อนให้โบนัส

ผ่านเมื่อ: ไอเทมไม่ทำให้ Game Over เก็บหนึ่งชิ้นได้โบนัสครั้งเดียว หลังจบเกมไม่มีโบนัสเพิ่ม และ Restart ล้างโบนัส

โจทย์หน้าตา ชีวิต และไอเทมเป็นแบบฝึกออกแบบเอง ยังไม่ได้เปิดใช้เป็นฟีเจอร์ในเกมตัวอย่างเดิม

## ก่อนส่งงานต่อยอด

ให้เพื่อนลองเล่น อธิบายกติกาและ Node/Signal/function ที่แก้ ทดสอบกรณีปกติกับกรณีขอบ ทดสอบ Game Over/Restart หลังเพิ่มทุกระบบ แล้วบันทึกและเปิดโปรเจกต์ใหม่อีกครั้ง

แหล่งอ้างอิง: [Scene instances](https://docs.godotengine.org/en/stable/getting_started/step_by_step/instancing.html), [Sprite2D](https://docs.godotengine.org/en/stable/classes/class_sprite2d.html), [Importing images](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html)
