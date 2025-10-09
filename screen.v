module vitrine

import term.ui as tui

pub struct Screen implements Component, Container {
	Box
mut:
	resolved Resolved
	child    &Component
}

@[params]
pub struct ScreenInit {
	Box
pub:
	child &Component
}

pub fn Screen.new(init ScreenInit) &Screen {
	mut screen := &Screen{
		Box:   init.Box
		child: init.child
	}

	screen.child.parent = screen

	return screen
}

pub fn (mut screen Screen) render(mut context tui.Context) {
	// NOTE: The origin of coordinates for TUI is 1,1 not 0,0
	screen.draw(mut context, Vector2{1, 1})
}

pub fn (mut screen Screen) draw(mut context tui.Context, transform Vector2) {
	mut child := screen.child
	child.resolved.size = if child.grow {
		Vector2{context.window_width, context.window_height}
	} else {
		screen.child.natural_size()
	}

	screen.child.draw(mut context, transform)
}

pub fn (screen Screen) natural_size() Vector2 {
	return Vector2{}
}

pub fn (mut screen Screen) add(mut child Component) {
	child.parent = screen
	screen.child = child
}

pub fn (screen Screen) children() []&Component {
	return [screen.child]
}
