module vitrine

import term.ui as tui

pub struct Screen implements Element {
	Flex
mut:
	resolved Resolved
}

@[params]
pub struct ScreenInit {
	FlexInit
}

pub fn Screen.new(init ScreenInit) &Screen {
	mut screen := &Screen{
		Box:        init.FlexInit.Box
		children:   init.children
		horizontal: init.horizontal
		gap:        init.gap
		align:      init.align
	}

	return screen
}

pub fn (mut screen Screen) draw(mut context tui.Context) {
	mut child := screen.Flex
	child.resolved.position = Vector2{1, 1}
	child.resolved.size = if child.grow {
		Vector2{context.window_width, context.window_height}
	} else {
		child.natural_size()
	}

	child.draw(mut context)
}

pub fn (screen Screen) natural_size() Vector2 {
	return Vector2{}
}
