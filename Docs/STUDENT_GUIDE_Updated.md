# Dodge Rain: คู่มือทำตามทีละขั้น

เป้าหมาย: สร้างเกมหลบสิ่งกีดขวาง เก็บคะแนนตามเวลาที่รอด ชนแล้ว Game Over และเริ่มใหม่ได้ ใช้ Godot 4.7.2 Standard กับ GDScript 2D เรียนตามลำดับและพิมพ์ logic เอง โค้ด Main ฉบับครบอยู่ช่วงท้ายหลังผ่าน spawn แล้ว

## 1. เปิดโปรแกรมและสร้าง Project

1. ดาวน์โหลด Windows Standard จาก https://godotengine.org/download/archive/4.7.2-stable/ หรือรับ ZIP จากวิทยากร
2. File Explorer > เลือก ZIP > Extract all > เลือกโฟลเดอร์ของคุณ > Extract แล้วเปิด Godot_v4.7.2-stable_win64.exe
3. Project Manager > Create ตั้งชื่อ DodgeRain เลือก Project Path ในเครื่องคุณเอง เลือก Compatibility และ Version Control Metadata เป็น None แล้ว Create
4. Project > Project Settings > Display > Window ตั้ง Viewport Width 960, Height 540, Stretch Mode canvas_items และ Aspect keep

ภาพที่ใช้ไดรฟ์ U: เป็นเพียงตัวอย่างของเครื่องสาธิต คุณใช้ไดรฟ์หรือชื่อโฟลเดอร์อื่นได้ แต่ชื่อไฟล์และ Node ภายในโปรเจกต์ต้องตรงคู่มือนี้

ทดสอบ: เปิด Editor และเห็นแท็บ 2D

## 2. โฟลเดอร์และ Assets

ใน FileSystem คลิกขวา res:// > Create New > Folder สร้าง assets, scenes และ scripts คัดลอก player.png, obstacle.png, background.png และ hit.wav จาก Asset Pack เข้า assets แล้วรอ Godot import

FileSystem ใช้เปิดและจัดไฟล์ res:// หมายถึงโฟลเดอร์ที่มี project.godot ส่วน Inspector ใช้ปรับค่าของไฟล์หรือ Node ที่เลือก

ทดสอบ: ขยาย assets แล้วเห็นครบ 4 ไฟล์ ภาพ player/obstacle มีขนาด 64×64

## 3. Player Scene

1. Scene > New Scene หรือ Ctrl+N > Other Node ค้นหา CharacterBody2D > Create เปลี่ยนชื่อ root เป็น Player
2. เลือก Player > ปุ่ม + > Sprite2D จากนั้นลาก assets/player.png ลง Texture ของ Sprite2D ใน Inspector
3. เลือก Player > + > CollisionShape2D ใน Inspector ช่อง Shape เลือก New RectangleShape2D แล้วคลิก resource ตั้ง Size X=44, Y=44
4. เลือก Player ตั้ง Motion Mode เป็น Floating และ Collision > Layer 1 / Mask 1
5. Ctrl+S บันทึก scenes/player.tscn

Scene Tree ต้องเป็น Player > Sprite2D และ Player > CollisionShape2D ทั้งสองเป็นลูกของ Player ไม่ใช่ลูกซ้อนกัน Sprite2D แสดงภาพ ส่วน Shape ใช้ตรวจชน

## 4. Input Map

Project > Project Settings > Input Map เพิ่ม move_left, move_right, restart แล้วกด + ของแต่ละ action เพื่อเพิ่มปุ่ม

| Action | ปุ่ม |
|---|---|
| move_left | A และ Left Arrow |
| move_right | D และ Right Arrow |
| restart | R และ Enter |

ใช้ Keycode (Latin Equivalent) และตรวจการพิมพ์ชื่อให้ตรง โค้ดจะเรียก action แทนการผูกติดกับปุ่มเพียงปุ่มเดียว

## 5. โค้ด Player

เลือก root Player > ปุ่ม Attach Script ตั้ง Path res://scripts/player.gd เอา Template ออก แล้ว Create แทนโค้ดด้วย:

```gdscript
extends CharacterBody2D

@export var speed: float = 500.0

var screen_size: Vector2


func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	velocity.y = 0.0
	move_and_slide()
	position.x = clamp(position.x, 32.0, screen_size.x - 32.0)
```

speed คือความเร็ว px/s, Vector2 เก็บ x,y, _ready ทำครั้งเดียวเมื่อเข้า tree, _physics_process ทำทุก physics tick Input.get_axis คืนค่าทิศทาง -1/0/1 ให้ move_and_slide ใช้ velocity โดยไม่คูณ delta ซ้ำ clamp จำกัดจุดศูนย์กลางห่างขอบ 32 px เพราะภาพกว้าง 64 px

## 6. ทดสอบ Player

Ctrl+N > 2D Scene ตั้งชื่อ Main บันทึก scenes/main.tscn ลาก scenes/player.tscn จาก FileSystem ลง Main เพื่อ instantiate เลือก Player ใน Main > Inspector > Transform > Position X=480, Y=476

กด F5 และเลือก main.tscn เป็น Main Scene เมื่อโปรแกรมถาม ทดสอบ A/D และลูกศรซ้ายขวา กดค้างจนสุดทั้งสองข้าง ต้องไม่หลุดจอ กด F8 หยุด

F6 จะรันเฉพาะฉากปัจจุบัน ฉาก Player เดี่ยวอยู่จุดกำเนิด จึงใช้ F5 ผ่าน Main สำหรับทดสอบ movement

## 7. Obstacle Scene

1. Ctrl+N > Other Node > Area2D ตั้งชื่อ Obstacle
2. เพิ่ม Sprite2D ลูกของ Obstacle ตั้ง Texture เป็น obstacle.png
3. เพิ่ม CollisionShape2D ลูกของ Obstacle ตั้ง Shape เป็น New CircleShape2D รัศมี 25
4. เลือก Obstacle ตั้ง Collision Layer 2 และ Mask 1 (ปิด layer 1 ของ Obstacle)
5. บันทึก scenes/obstacle.tscn Attach Script ไป scripts/obstacle.gd

Area2D ใช้ตรวจ body ที่เข้ามาซ้อนทับผ่าน body_entered ไม่ได้ทำให้ก้อนหินเด้งออกเอง

## 8. โค้ด Obstacle

```gdscript
extends Area2D

@export var fall_speed: float = 300.0


func _process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport_rect().size.y + 80.0:
		queue_free()
```

delta คือวินาทีที่ผ่านไปของ frame นี้ ระยะทาง = ความเร็ว × delta ถ้าเพิ่ม y ทีละ 5 โดยไม่คูณ delta ความเร็วจะเปลี่ยนตาม frame rate queue_free ลบ Node เมื่อสิ้น frame เพื่อไม่สะสมสิ่งกีดขวางนอกจอ

## 9. Main Scene และ Timer

กลับ main.tscn เพิ่ม Node2D ลูกของ Main ชื่อ ObstacleLayer เพิ่ม Timer ลูกของ Main ชื่อ SpawnTimer ตั้ง Wait Time 0.8, One Shot ปิด และ Autostart ปิด (เริ่มด้วยโค้ด)

Attach Script ให้ Main ไป scripts/main.gd พิมพ์โค้ด spawn ช่วงแรกด้านล่าง จากนั้นเลือก Main แล้วลาก scenes/obstacle.tscn ลงช่อง Obstacle Scene ใน Inspector

```gdscript
extends Node2D

@export var obstacle_scene: PackedScene
var rng = RandomNumberGenerator.new()
@onready var obstacle_layer = $ObstacleLayer
@onready var spawn_timer = $SpawnTimer


func _ready():
	rng.randomize()
	spawn_timer.wait_time = 0.8
	spawn_timer.timeout.connect(_spawn_obstacle)
	spawn_timer.start()


func _spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = Vector2(rng.randf_range(40.0, get_viewport_rect().size.x - 40.0), -60.0)
	obstacle_layer.add_child(obstacle)
```

Timer ส่ง timeout ทุก 0.8 วินาที PackedScene คือแม่แบบที่บันทึกไว้ instantiate() สร้างสำเนา และ add_child() ใส่สำเนาในเกม Vector2(x,-60) วางเหนือจอ rng.randf_range สุ่ม X โดยเว้นขอบด้านละ 40 px

ทดสอบระบบเกิดสิ่งกีดขวาง: F5 ต้องเห็นสิ่งกีดขวางตกหลายตำแหน่งและหายเมื่อหลุดจอ ตอนนี้ยังไม่มี Game Over ชนแล้วผ่านกันได้เป็นเรื่องปกติ

## 10. UI และโครง Main ฉบับครบ

เพิ่ม AudioStreamPlayer ชื่อ HitSound เป็นลูก Main (ยังไม่ต้องใส่เสียงก็ได้) เพิ่ม CanvasLayer ชื่อ UI และเพิ่ม Label สองตัวเป็นลูก UI ชื่อ ScoreLabel และ MessageLabel

ScoreLabel: Layout > Transform ตั้ง Position (24,18), Size (280,48), Text "Score: 0", Theme Overrides > Font Sizes > Font Size 30

MessageLabel: Position (200,186), Size (560,168), Horizontal Alignment Center, Vertical Alignment Center, Font Size 28 และ Text ว่าง

Scene Tree ต้องเป็น:

```text
Main (Node2D)
├── ObstacleLayer (Node2D)
├── Player (instance)
├── SpawnTimer (Timer)
├── HitSound (AudioStreamPlayer)
└── UI (CanvasLayer)
    ├── ScoreLabel (Label)
    └── MessageLabel (Label)
```

## 11. Signals, Game Over, Score และ Restart

แทน main.gd ช่วง spawn ด้วยโค้ด core ด้านล่าง พิมพ์ทีละ function และทำความเข้าใจหน้าที่ก่อนทดสอบ โค้ดเชื่อม timeout และ body_entered ให้เองแล้ว จึงไม่เชื่อมซ้ำผ่านแท็บ Signals

```gdscript
extends Node2D

@export var obstacle_scene: PackedScene

var score: float = 0.0
var game_running: bool = true
var rng = RandomNumberGenerator.new()

@onready var player = $Player
@onready var obstacle_layer = $ObstacleLayer
@onready var spawn_timer = $SpawnTimer
@onready var score_label = $UI/ScoreLabel
@onready var message_label = $UI/MessageLabel
@onready var hit_sound = $HitSound


func _ready():
	rng.randomize()
	score_label.text = "Score: 0"
	message_label.text = ""
	spawn_timer.wait_time = 0.8
	spawn_timer.timeout.connect(_spawn_obstacle)
	spawn_timer.start()


func _process(delta):
	if game_running:
		score += delta
		score_label.text = "Score: %d" % int(score)
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _spawn_obstacle():
	if not game_running:
		return
	var obstacle = obstacle_scene.instantiate()
	var screen_width = get_viewport_rect().size.x
	obstacle.position = Vector2(rng.randf_range(40.0, screen_width - 40.0), -60.0)
	obstacle.body_entered.connect(_on_obstacle_body_entered)
	obstacle_layer.add_child(obstacle)


func _on_obstacle_body_entered(body):
	if game_running and body == player:
		game_over()


func game_over():
	if not game_running:
		return
	game_running = false
	spawn_timer.stop()
	player.set_physics_process(false)
	for obstacle in obstacle_layer.get_children():
		obstacle.set_process(false)
	message_label.text = (
		"GAME OVER\n"
		+ "Score: %d\n" % int(score)
		+ "Press R / Enter to Restart"
	)
	if hit_sound.stream:
		hit_sound.play()
```

1. อ่านตัวแปรและ @onready: score เก็บเวลา game_running เก็บสถานะ ส่วน $NodePath ต้องตรง Scene Tree
2. _ready ตั้งค่าเริ่มและเริ่ม Timer
3. _spawn_obstacle สร้างก้อนหิน สุ่มตำแหน่ง และเชื่อม body_entered ก่อน add_child
4. _on_obstacle_body_entered รับ body แล้วตรวจว่าเป็น Player จึงเรียก game_over
5. game_over หยุด score ด้วย state, หยุด Timer, ปิด physics ของ Player และปิด process ของทุก obstacle
6. _process เพิ่ม score เฉพาะตอนเล่น ส่วน elif รับ restart เฉพาะหลังจบ reload_current_scene เริ่มฉากและตัวแปรใหม่

ทดสอบระบบเกมหลัก: อยู่รอดแล้วคะแนนขึ้น ชนแล้ว Game Over คะแนนและวัตถุหยุด กด R และ Enter เริ่มใหม่ได้ ทดสอบอย่างน้อย 3 รอบ

## 12. Background และเสียง (ทำเมื่อ core ผ่าน)

เพิ่ม Sprite2D ชื่อ Background เป็นลูกตัวแรกของ Main ตั้ง Texture background.png และ Position (480,270) เพื่อวางภาพ 960×540 พอดีจอ ให้ Background อยู่เหนือ ObstacleLayer ในรายการ Tree เพื่อวาดด้านหลัง

เลือก HitSound ลาก hit.wav ลง Stream ตั้ง Volume dB=-8 โค้ดจะ play ตอน Game Over ถ้าไม่มี stream จะข้ามเสียงได้ ทดสอบระดับเสียงที่ลำโพงจริงก่อนสอน

เกมหลักใช้ความยากคงที่ หลังทดสอบระบบหลักผ่านแล้วเลือกทำบทพาทำหรือโจทย์ใน EXTENSION_EXERCISES.md ได้ ตัวอย่างความยากที่รันได้อยู่ใน Extensions/MapLab_2D

## 13. Debug และตรวจงาน

F5 รันโปรเจกต์ F6 รันเฉพาะฉาก F8 หยุด Output อ่านข้อความ Debugger อ่าน errors และ stack trace Inspector ดูค่าของ Node ที่เลือก แก้ error แรกก่อนแล้วรันใหม่

- A/D และลูกศรใช้งานได้ ไม่หลุดขอบซ้าย/ขวา
- สิ่งกีดขวางสุ่ม X ตกและลบเมื่อหลุดจอ
- ชนซ้าย กลาง และขวาแล้วจบ คะแนนไม่เพิ่ม spawn และทุกวัตถุหยุด
- R/Enter เริ่มใหม่ 3 รอบ score เริ่มใหม่และ Player กลับจุดเริ่ม
- Ctrl+S ทุกฉาก เปิด project ใหม่แล้ว F5 ได้

ก่อนทำต่อยอดให้ตรวจเกมและแก้บั๊ก ถ้าติดให้บอกวิทยากรว่าทดสอบล่าสุดผ่านข้อไหน ไม่ต้องเริ่มทำใหม่ทั้งหมด
