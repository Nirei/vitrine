module vitrine

import term.ui as tui
import nirei.vrawille { Canvas }

pub struct Picture implements Element {
	Box
mut:
	resolved Resolved
pub mut:
	canvas &Canvas
}

@[params]
pub struct PictureInit {
	Box
pub:
	canvas &Canvas
}

pub fn Picture.new(init PictureInit) &Picture {
	return &Picture{
		Box:    init.Box
		canvas: init.canvas
	}
}

pub fn (picture Picture) draw(mut context tui.Context) {
	if !picture.visible {
		return
	}

	transform := picture.resolved.position
	picture.set_colors(mut context)
	x, y := (transform + picture.offset).value()

	rows := picture.canvas.rows()
	for index in 0 .. rows.len {
		text := rows[index].map(fn (r rune) string {
			return r.str()
		}).join('')
		context.draw_text(x, y + index, text)
	}
}

pub fn (picture Picture) natural_size() Vector2 {
	x, y := picture.canvas.size()
	return Vector2{x / 2, y / 4}
}

pub fn (mut element Picture) handle(event &tui.Event) {
	element.resolved.handle(event)
}
