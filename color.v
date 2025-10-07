module vitrine

pub struct Color {
  pub:
    r u8
    g u8
    b u8
}

pub fn (color Color) value() (u8, u8, u8) {
  return color.r, color.g, color.b
}
