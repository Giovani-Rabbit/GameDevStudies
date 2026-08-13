package prototypes
import rl "vendor:raylib"

run_lerp :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "GRID")
	rl.SetTargetFPS(60)

	p1 := rl.Vector2{100, 200}
	p2 := rl.Vector2{300, 400}
	t: f32 = 0.0

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		t += rl.GetFrameTime() * 0.5
		if t > 1.0 do t = 0.0

		draw_lerp(&p1, &p2, t)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

draw_lerp :: proc(p1, p2: ^rl.Vector2, t: f32) {
	draw_line_simple(p1^, p2^)
	rl.DrawCircle(i32(p2.x), i32(p2.y), 10, rl.RED)
	rl.DrawCircle(i32(p1.x), i32(p1.y), 10, rl.RED)

	pl := lerp_vec2(p1^, p2^, t)
	rl.DrawCircleV(pl, 10, rl.BLUE)
}

draw_line_simple :: proc(ip, ep: rl.Vector2) {
	rl.DrawLine(i32(ip.x), i32(ip.y), i32(ep.x), i32(ep.y), rl.BLACK)
}

lerp_vec2 :: proc(a, b: rl.Vector2, t: f32) -> rl.Vector2 {
	result: rl.Vector2 = {}
	result.x = lerp(a.x, b.x, t)
	result.y = lerp(a.y, b.y, t)
	return result
}

lerp :: proc(a: f32, b: f32, t: f32) -> f32 {
	return a + (b - a) * t
}
