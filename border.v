module vitrine

import term.ui as tui
import strings { repeat_string }

pub struct BorderStyle {
	nw rune
	ne rune
	sw rune
	se rune
	h  rune
	v  rune
}

const border_style_curved = &BorderStyle{`╭`, `╮`, `╰`, `╯`, `─`, `│`}
const border_style_single = &BorderStyle{`┌`, `┐`, `└`, `┘`, `─`, `│`}
const border_style_dashed = &BorderStyle{`┌`, `┐`, `└`, `┘`, `╌`, `╎`}
const border_style_bolder = &BorderStyle{`┏`, `┓`, `┗`, `┛`, `━`, `┃`}
const border_style_dashbo = &BorderStyle{`┏`, `┓`, `┗`, `┛`, `╍`, `╏`}
const border_style_double = &BorderStyle{`╔`, `╗`, `╚`, `╝`, `═`, `║`}

pub struct Border implements Component, Container {
	Box
mut:
	resolved Resolved
	child    &Component
pub mut:
	style &BorderStyle
}

@[params]
pub struct BorderInit {
	Box
pub:
	child &Component
	style &BorderStyle = border_style_curved
}

pub fn Border.new(init BorderInit) &Border {
	mut border := &Border{
		Box:   init.Box
		child: init.child
		style: init.style
	}

	border.child.parent = border

	return border
}

pub fn (mut border Border) draw(mut context tui.Context, transform Vector2) {
	if !border.visible {
		return
	}

	child_transform := transform + Vector2{1, 1}
	border.child.resolved.size = border.resolved.size - Vector2{2, 2}
	border.child.draw(mut context, child_transform)

	border.set_colors(mut context)
	x, y := (border.offset + transform).value()
	size := border.resolved.size
	style := border.style
	horizontal := repeat_string(style.h.str(), size.x - 2)

	context.draw_text(x, y, '${style.nw}${horizontal}${style.ne}')

	for row in 1 .. size.y - 1 {
		context.draw_text(x, y + row, style.v.str())
		context.draw_text(x + size.x - 1, y + row, style.v.str())
	}

	context.draw_text(x, y + size.y - 1, '${style.sw}${horizontal}${style.se}')
}

pub fn (border Border) natural_size() Vector2 {
	return border.child.natural_size() + Vector2{2, 2}
}

pub fn (mut border Border) add(mut child Component) {
	child.parent = border
	border.child = child
}

pub fn (border Border) children() []&Component {
	return [border.child]
}
