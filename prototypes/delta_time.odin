package prototypes

import "core:fmt"
import rl "vendor:raylib"

execDeltaTime :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "Test window")
	current_fps: i32 = 60
	speed: f32 : 10.0

	deltaCircle: rl.Vector2 = {0, WINDOW_H / 3.0}
	frameCircle: rl.Vector2 = {0, WINDOW_H * (2.0 / 3.0)}
	circle_radius: f32 = 32.0

	rl.SetTargetFPS(current_fps)

	frameCount := 0
	deltaStart := deltaCircle[0]
	frameStart := frameCircle[0]

	for !rl.WindowShouldClose() {
		delta_mov := rl.GetFrameTime()

		deltaCircle[0] += delta_mov * speed
		if deltaCircle[0] > WINDOW_W do deltaCircle[0] = 0

		frameCircle[0] += speed
		if frameCircle[0] > WINDOW_W do frameCircle[0] = 0

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		rl.DrawCircleV(deltaCircle, circle_radius, rl.RED)
		rl.DrawCircleV(frameCircle, circle_radius, rl.BLUE)
		rl.EndDrawing()

		frameCount += 1
	}

	deltaTraveled := deltaCircle[0] - deltaStart
	frameTraveled := frameCircle[0] - frameStart

	// deltaTime = 0.0166
	// speed = 10
	// frame por segundo = 60
	// 0.0166 * 10 = 0.16 -> Ou seja em um frame ele vai percorrer 0.16 pixels
	// 0.16 * 60 = 10 -> Em um segundo ele ira percorrer 10 pixels, o equivalente a speed definida
	fmt.println("deltaCircle percorreu:", deltaTraveled, "pixels")
	fmt.println("frameCircle percorreu:", frameTraveled, "pixels")

	rl.CloseWindow()
}
