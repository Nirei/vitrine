module vitrine

import math { max }

pub struct Vector2 {
  pub:
    x int
    y int
}

pub fn Vector2.max(a Vector2, b Vector2) Vector2 {
  return Vector2{ max(a.x, b.x), max(a.y, b.y) }
}

pub fn (a Vector2) + (b Vector2) Vector2 {
  return Vector2 { a.x + b.x, a.y + b.y }
}

pub fn (a Vector2) - (b Vector2) Vector2 {
  return Vector2 { a.x - b.x, a.y - b.y }
}

pub fn (a Vector2) * (b Vector2) Vector2 {
  return Vector2 { a.x * b.x, a.y * b.y }
}

pub fn (a Vector2) / (b Vector2) Vector2 {
  return Vector2 { a.x / b.x, a.y / b.y }
}

pub fn (a Vector2) % (b Vector2) Vector2 {
  return Vector2 { a.x % b.x, a.y % b.y }
}

pub fn (vector Vector2) scale(scalar int) Vector2 {
  return Vector2 { vector.x * scalar, vector.y * scalar }
}

pub fn (vector Vector2) value() (int, int) {
  return vector.x, vector.y
}
