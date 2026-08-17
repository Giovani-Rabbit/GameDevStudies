package prototypes
import "core:fmt"
import math "core:math"
import rl "vendor:raylib"

Ball :: struct {
	position: rl.Vector2,
	size:     f32,
	color:    rl.Color,
}

follow_leader :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "Follow Leader")
	rl.SetTargetFPS(60)

	be: [4]Ball = init_lerp_exponential()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		exponential_ball(&be)

		rl.EndDrawing()
	}
}

exponential_ball :: proc(b: ^[4]Ball) {
	speed: f32 = 5.0
	mouse := rl.GetMousePosition()
	dt := rl.GetFrameTime()
	factor := 1 - math.exp(-speed * dt)

	for i in 0 ..< len(b) {
		target: rl.Vector2 = mouse if i == 0 else b[i - 1].position
		b[i].position = b[i].position + (target - b[i].position) * factor

		draw_line_simple(target, b[i].position)
		rl.DrawCircleV(b[i].position, b[i].size, b[i].color)
	}
}

// Estou usando um numero de bolas fixas para trabalhar os dados na stack.
init_lerp_exponential :: proc() -> [4]Ball {
	ball := Ball{window_center_Vec2(), 5, rl.RED}
	return [4]Ball{ball, ball, ball, ball}
}

window_center_Vec2 :: proc() -> rl.Vector2 {
	return rl.Vector2{WINDOW_W / 2, WINDOW_H / 2}
}
