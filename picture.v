import term.ui as tui

import nirei.vrawille { Canvas }

pub struct Picture implements Component {
  Box
  mut:
    resolved Resolved
  pub mut:
    canvas &Canvas
}

pub fn (picture Picture) draw(mut context tui.Context, transform Vector2) {
  if !picture.visible { return }

  picture.set_colors(mut context)
  x, y := (transform + picture.offset).value()

  rows := picture.canvas.rows()
  for index in 0..rows.len {
    text := rows[index].map(
        fn (r rune) string {
          return r.str()
        }
      ).join('')
    context.draw_text(x, y+index, text)
  }
}

pub fn (picture Picture) natural_size() Vector2 {
  x, y := picture.canvas.size()
  return Vector2 { x/2, y/4 }
}
