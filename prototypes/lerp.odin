package prototypes
import "core:fmt"
import rl "vendor:raylib"

run_lerp :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "GRID")
	rl.SetTargetFPS(144)

	FIXED_DT :: 60
	p1 := rl.Vector2{0, WINDOW_H / 3}
	p2 := rl.Vector2{WINDOW_W, WINDOW_H / 3}
	p3 := rl.Vector2{0, WINDOW_H / 2}
	p4 := rl.Vector2{WINDOW_W, WINDOW_H / 2}

	tc: f32 = 0.0 // tempo constante, velocidade variavel
	tv: f32 = 0.0 // tempo variavel, velocidade constante

	distance := rl.Vector2Distance(p1, p2)

	debug_mode := false
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if rl.IsKeyPressed(.D) do debug_mode = !debug_mode

		update_tc(&tc, debug_mode)
		update_tv(&tv, debug_mode, distance)

		draw_lerp(&p1, &p2, tc)
		draw_lerp(&p3, &p4, tv)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

// tempo constante / velocidade variavel
update_tc :: proc(tc: ^f32, debug_mode: bool) {
	if debug_mode {
		if rl.IsMouseButtonPressed(.LEFT) {
			tc^ += rl.GetFrameTime() * 0.5
		}
	} else do tc^ += rl.GetFrameTime() * 0.5

	if tc^ > 1.0 do tc^ = 0.0
}

// tempo variavel / velocidade constante
update_tv :: proc(tv: ^f32, debug_mode: bool, distance: f32) {
	speed: f32 = 200.0
	total_time := distance / speed

	if debug_mode {
		if rl.IsMouseButtonPressed(.RIGHT) {
			tv^ += rl.GetFrameTime() / total_time
		}
	} else do tv^ += rl.GetFrameTime() / total_time

	if tv^ > 1.0 do tv^ = 0.0
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
	fmt.println("lerp x: ", a.x, b.x, t)
	return result
}

lerp :: proc(a: f32, b: f32, t: f32) -> f32 {
	return a + (b - a) * t
}
