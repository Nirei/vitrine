module vitrine

import term.ui as tui

pub interface Element {
	grow bool
	natural_size() Vector2
mut:
	resolved Resolved
	draw(mut context tui.Context)
	handle(event &tui.Event)
}
