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
	value    string
	on_click ?fn ()
}

pub fn Text.new(init TextInit) &Text {
	mut text := &Text{
		Box:   init.Box
		value: init.value
	}
	text.resolved.on_click = init.on_click
	return text
}

pub fn (text Text) draw(mut context tui.Context) {
	if !text.visible {
		return
	}

	text.set_colors(mut context)
	x, y := (text.resolved.position + text.offset).value()
	width, height := (text.resolved.size - Vector2{1, 1}).value()
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

pub fn (mut element Text) handle(event &tui.Event) {
	element.resolved.handle(event)
}
