import term.ui as tui

pub struct Text implements Component {
  Box
  mut:
    resolved Resolved
  pub mut:
    value string
}

pub fn (text Text) draw(mut context tui.Context, transform Vector2) {
  if !text.visible { return }

  text.set_colors(mut context)
  x, y := (transform + text.offset).value()
  context.draw_text(x, y, text.value)
}

pub fn (text Text) natural_size() Vector2 {
  return Vector2 { text.value.len, 1 }
}
