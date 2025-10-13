module vitrine

import math

pub struct Vector2 {
pub mut:
	x int
	y int
}

pub const up = Vector2{0, -1}
pub const down = Vector2{0, 1}
pub const left = Vector2{-1, 0}
pub const right = Vector2{1, 0}

pub fn Vector2.max(a Vector2, b Vector2) Vector2 {
	return Vector2{math.max(a.x, b.x), math.max(a.y, b.y)}
}

pub fn (a Vector2) + (b Vector2) Vector2 {
	return Vector2{a.x + b.x, a.y + b.y}
}

pub fn (a Vector2) - (b Vector2) Vector2 {
	return Vector2{a.x - b.x, a.y - b.y}
}

pub fn (a Vector2) * (b Vector2) Vector2 {
	return Vector2{a.x * b.x, a.y * b.y}
}

pub fn (a Vector2) / (b Vector2) Vector2 {
	return Vector2{a.x / b.x, a.y / b.y}
}

pub fn (a Vector2) % (b Vector2) Vector2 {
	return Vector2{a.x % b.x, a.y % b.y}
}

pub fn (vector Vector2) scale(scalar int) Vector2 {
	return Vector2{vector.x * scalar, vector.y * scalar}
}

pub fn (vector Vector2) divide(scalar int) Vector2 {
	return Vector2{vector.x / scalar, vector.y / scalar}
}

pub fn (vector Vector2) value() (int, int) {
	return vector.x, vector.y
}

pub fn (mut vector Vector2) add(operand Vector2) Vector2 {
	vector.x += operand.x
	vector.y += operand.y
	return vector
}

pub fn (mut vector Vector2) max(operand Vector2) Vector2 {
	vector.x = math.max(vector.x, operand.x)
	vector.y = math.max(vector.y, operand.y)
	return vector
}

pub fn (vector Vector2) inside(start Vector2, size Vector2) bool {
	end := start + size
	return vector.x >= start.x && vector.x < end.x && vector.y >= start.y && vector.y < end.y
}
