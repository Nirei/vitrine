module vitrine

import term.ui as tui

pub interface Component {
	grow bool
	natural_size() Vector2
mut:
	resolved Resolved
	draw(mut context tui.Context, transform Vector2)
}
