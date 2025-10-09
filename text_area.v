module vitrine

import term.ui as tui

pub struct TextArea implements Component {
	Box
mut:
	resolved Resolved
pub mut:
	width int
	value string
}

@[params]
pub struct TextAreaInit {
	Box
pub:
	width int
	value string
}

pub fn TextArea.new(init TextAreaInit) &TextArea {
	return &TextArea{
		Box:   init.Box
		value: init.value
		width: init.width
	}
}

pub fn (text_area TextArea) draw(mut context tui.Context, transform Vector2) {
	if !text_area.visible {
		return
	}

	text_area.set_colors(mut context)
	x, y := (transform + text_area.offset).value()
	width, height := text_area.resolved.size.value()
	mut words := text_area.value.split(' ')

	mut line := 0
	mut length := 0
	mut buffer := []string{}
	for word in words {
		if length + word.len > width {
			context.draw_text(x, y + line, buffer.join(' '))
			buffer.clear()
			length = 0
			line += 1

			if line == height {
				break
			}
		}
		buffer << word
		length += word.len + 1
	}
	if line < height {
		context.draw_text(x, y + line, buffer.join(' '))
	}

	// context.draw_text(transform.x, transform.y, '${width} ${height}')
}

pub fn (text_area TextArea) natural_size() Vector2 {
	return Vector2{text_area.width, 1}
}
