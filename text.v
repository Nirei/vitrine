module vitrine

import term.ui as tui

pub struct Text implements Element {
	Box
mut:
	resolved Resolved
pub mut:
	value string
	bold  bool
}

@[params]
pub struct TextInit {
	Box
pub:
	value string
}

pub fn Text.new(init TextInit) &Text {
	return &Text{
		Box:   init.Box
		value: init.value
	}
}

pub fn (text Text) draw(mut context tui.Context, transform Vector2) {
	if !text.visible {
		return
	}

	text.set_colors(mut context)
	x, y := (transform + text.offset).value()
	width, height := text.resolved.size.value()
	// Ensure background fills complete text area even if text shorter
	context.draw_rect(x, y, x + width, y + height)
	context.draw_text(x, y, text.value)
}

pub fn (text Text) natural_size() Vector2 {
	if !text.visible {
		return Vector2{}
	}
	return Vector2{text.value.len, 1}
}
