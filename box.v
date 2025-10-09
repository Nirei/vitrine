module vitrine

import term.ui as tui

struct Box {
pub mut:
	parent     ?&Container
	visible    bool = true
	z_index    int
	offset     Vector2
	bold       bool
	color      ?Color
	background ?Color
	grow       bool
}

fn (box Box) set_colors(mut context tui.Context) {
	context.reset()

	if box.bold {
		context.bold()
	}

	if color := box.color {
		fr, fg, fb := color.value()
		context.set_color(r: fr, g: fg, b: fb)
	}

	if background := box.background {
		br, bg, bb := background.value()
		context.set_bg_color(r: br, g: bg, b: bb)
	}
}
