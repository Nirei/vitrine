module vitrine

import term.ui as tui

pub enum Align as u8 {
	stretch
	start
	end
	center
}

pub struct Flex implements Element {
	Box
mut:
	resolved Resolved
	children []&Element
pub mut:
	horizontal bool
	gap        int
	align      Align
}

@[params]
pub struct FlexInit {
	Box
pub:
	children   []&Element
	horizontal bool
	gap        int
	align      Align = .stretch
}

pub fn Flex.new(init FlexInit) &Flex {
	mut flex := &Flex{
		Box:        init.Box
		children:   init.children
		horizontal: init.horizontal
		gap:        init.gap
		align:      init.align
	}

	return flex
}

pub fn (mut flex Flex) draw(mut context tui.Context) {
	if !flex.visible {
		return
	}

	transform := flex.resolved.position

	flex.set_colors(mut context)
	main_axis := if flex.horizontal { right } else { down }
	cross_axis := if flex.horizontal { down } else { right }
	mut child_transform := transform + flex.offset

	mut growers := 0
	for index in 0 .. flex.children.len {
		child := flex.children[index]
		if child.grow {
			growers += 1
		}
	}
	// Space taken by children before growth
	size := flex.natural_size()
	// Space available for children to grow
	available := flex.resolved.size
	// Space to share among growers
	leftover := available - size
	// Space initially assigned to each grower
	assigned := if growers > 0 { leftover.divide(growers) } else { Vector2{} }
	// Remainder space, shared among the first growers until none left
	mut remainder := if growers > 0 {
		(leftover.x % growers) * main_axis.x + (leftover.y % growers) * main_axis.y
	} else {
		0
	}

	for index in 0 .. flex.children.len {
		mut child := flex.children[index]
		mut resolved_size := child.natural_size()
		if child.grow {
			resolved_size.add(assigned * main_axis)
			if remainder > 0 {
				resolved_size.add(main_axis)
				remainder -= 1
			}
		}

		mut align_offset := Vector2{}
		if flex.align == .center {
			align_offset = (size - resolved_size).divide(2) * cross_axis
		} else if flex.align == .end {
			align_offset = (size - resolved_size) * cross_axis
		} else if flex.align == .stretch {
			// When .stretch, every child fills the complete cross-axis
			resolved_size = resolved_size * main_axis + available * cross_axis
		}

		child.resolved.size = resolved_size
		child.resolved.position = child_transform + align_offset

		child.draw(mut context)
		child_transform.add(resolved_size * main_axis + main_axis.scale(flex.gap))
	}
}

pub fn (flex Flex) natural_size() Vector2 {
	if !flex.visible {
		return Vector2{}
	}

	main_axis := if flex.horizontal { right } else { down }
	cross_axis := if flex.horizontal { down } else { right }
	mut sum := Vector2{}
	mut max := Vector2{}

	for child in flex.children {
		child_size := child.natural_size()
		sum.add(child_size + main_axis.scale(flex.gap))
		max.max(child_size)
	}

	return sum * main_axis + max * cross_axis
}

pub fn (mut flex Flex) add(mut child Element) {
	flex.children << child
}

pub fn (flex Flex) children() []&Element {
	return flex.children
}
