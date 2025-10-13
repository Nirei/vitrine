module vitrine

import term.ui as tui

struct Resolved {
pub mut:
	size     Vector2
	position Vector2
	pressed  bool
	on_click ?fn ()
}

pub fn (mut resolved Resolved) handle(event &tui.Event) {
	position := Vector2{event.x, event.y}

	if event.typ == .mouse_down {
		if !position.inside(resolved.position, resolved.size) {
			return
		}
		resolved.pressed = true
	}

	if event.typ == .mouse_up {
		resolved.pressed = false

		if !position.inside(resolved.position, resolved.size) {
			return
		}
		if resolved.on_click != none {
			resolved.on_click()
		}
	}
}
