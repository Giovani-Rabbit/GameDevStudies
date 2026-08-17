package prototypes
import rl "vendor:raylib"

Lerp_Mode :: enum {
	BASICS,
	FOLLOW_MOUSE,
}

toggle_mode :: proc(mode: ^Lerp_Mode) {
	next := int(mode^) + 1
	if next >= len(Lerp_Mode) do next = 0
	mode^ = Lerp_Mode(next)
}

run_lerp :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "Lerp")
	rl.SetTargetFPS(144)

	mode := Lerp_Mode.BASICS

	basics := init_basics_state()
	follow_mouse := init_follow_mouse_state()

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.SPACE) do toggle_mode(&mode)

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		switch mode {
		case .BASICS:
			update_basics(&basics)
			draw_basics(&basics)
		case .FOLLOW_MOUSE:
			update_follow_mouse(&follow_mouse)
			draw_follow_mouse(&follow_mouse)
		}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

Basics_State :: struct {
	pc1, pc2, pv1, pv2: rl.Vector2,
	tc, tv:             f32,
	distance:           f32,
	debug_mode:         bool,
}

init_basics_state :: proc() -> Basics_State {
	pc1 := rl.Vector2{0, WINDOW_H / 3}
	pc2 := rl.Vector2{WINDOW_W, WINDOW_H / 3}
	pv1 := rl.Vector2{0, WINDOW_H / 2}
	pv2 := rl.Vector2{WINDOW_W, WINDOW_H / 2}

	tc: f32 = 0.0 // tempo constante, velocidade variavel
	tv: f32 = 0.0 // tempo variavel, velocidade constante

	distance := rl.Vector2Distance(pc1, pc2)
	debug_mode := false

	return Basics_State{pc1, pc2, pv1, pv2, tc, tv, distance, debug_mode}
}

update_basics :: proc(s: ^Basics_State) {
	update_tc(&s.tc, s.debug_mode)
	update_tv(&s.tv, s.debug_mode, s.distance)
	if rl.IsKeyPressed(.D) do s.debug_mode = !s.debug_mode
}

draw_basics :: proc(s: ^Basics_State) {
	draw_lerp_point(&s.pc1, &s.pc2, s.tc)
	draw_lerp_point(&s.pv1, &s.pv2, s.tv)
}

// tempo constante / velocidade variavel
update_tc :: proc(tc: ^f32, debug_mode: bool) {
	time_delta := rl.GetFrameTime() * 0.5

	if debug_mode {
		if rl.IsMouseButtonPressed(.LEFT) do tc^ += time_delta
	} else do tc^ += time_delta

	if tc^ > 1.0 do tc^ = 0.0
}

// tempo variavel / velocidade constante
update_tv :: proc(tv: ^f32, debug_mode: bool, distance: f32) {
	speed: f32 = 200.0
	total_time := distance / speed
	time_delta := rl.GetFrameTime() / total_time

	if debug_mode {
		if rl.IsMouseButtonPressed(.RIGHT) do tv^ += time_delta
	} else do tv^ += time_delta

	if tv^ > 1.0 do tv^ = 0.0
}

Follow_Mouse_state :: struct {
	position:  rl.Vector2,
	smoothing: f32,
}

init_follow_mouse_state :: proc() -> Follow_Mouse_state {
	return Follow_Mouse_state{position = rl.Vector2{WINDOW_W / 2, WINDOW_H / 2}, smoothing = 5}
}

update_follow_mouse :: proc(s: ^Follow_Mouse_state) {
	target := rl.GetMousePosition()
	smoothing_delta := rl.GetFrameTime() * s.smoothing

	if rl.Vector2Distance(s.position, target) < 0.5 do s.position = target

	s.position = lerp_vec2(s.position, target, smoothing_delta)
}

draw_follow_mouse :: proc(s: ^Follow_Mouse_state) {
	mouse := rl.GetMousePosition()
	rl.DrawCircleV(mouse, 6, rl.BLUE)
	rl.DrawCircleV(s.position, 6, rl.RED)
	rl.DrawLineV(s.position, mouse, rl.LIGHTGRAY)
}

draw_lerp_point :: proc(p1, p2: ^rl.Vector2, t: f32) {
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
