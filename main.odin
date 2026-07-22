package main

import "core:fmt"
import rl "vendor:raylib"

WINDOW_H :: 800
WINDOW_W :: 1200
CELL_SIZE :: 40

COLS :: WINDOW_W / CELL_SIZE
ROWS :: WINDOW_H / CELL_SIZE

main :: proc() {
	rl.InitWindow(WINDOW_W, WINDOW_H, "GRID")
	rl.SetTargetFPS(60)

	grid := grid_schema()

	for !rl.WindowShouldClose() {
		paint_element(&grid)

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		draw_solid_grid(&grid)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

draw_outline_grid :: proc() {
	for y in 1 ..< COLS {
		rl.DrawLine(i32(y * CELL_SIZE), 0, i32(y * CELL_SIZE), WINDOW_H, rl.WHITE)
	}
	for x in 1 ..< ROWS {
		rl.DrawLine(0, i32(x * CELL_SIZE), WINDOW_W, i32(x * CELL_SIZE), rl.WHITE)
	}
}

draw_solid_grid :: proc(grid: ^[ROWS][COLS]rl.Color) {
	for y in 0 ..< ROWS {
		for x in 0 ..< COLS {
			cell := rl.Rectangle{f32(x * CELL_SIZE), f32(y * CELL_SIZE), CELL_SIZE, CELL_SIZE}
			rl.DrawRectangleRec(cell, grid[y][x])
			rl.DrawRectangleLinesEx(cell, 1, rl.BLACK)
		}
	}
}

grid_schema :: proc() -> [ROWS][COLS]rl.Color {
	grid: [ROWS][COLS]rl.Color

	for y in 0 ..< ROWS {
		for x in 0 ..< COLS {
			grid[y][x] = rl.RAYWHITE
		}
	}

	return grid
}

paint_element :: proc(grid: ^[ROWS][COLS]rl.Color) {
	if rl.IsMouseButtonPressed(.LEFT) {
		mouse := rl.GetMousePosition()
		fmt.println("current mouse: ", mouse, "Cell: ", int(mouse.x) / CELL_SIZE)

		cx := int(mouse.x) / CELL_SIZE
		cy := int(mouse.y) / CELL_SIZE

		if cx >= 0 && cx < COLS && cy >= 0 && cy < ROWS {
			grid^[cy][cx] = rl.RED
		}
	}
}
