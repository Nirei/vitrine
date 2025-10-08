module vitrine

import term.ui as tui

enum Align as u8 {
  stretch
  start
  end
  center
}

pub struct Flex implements Component, Container {
  Box
  mut:
    resolved Resolved
    children []&Component
  pub mut:
    horizontal bool
    gap int
    align Align = .stretch
}

@[params]
pub struct FlexInit {
  Box
  pub:
    children []&Component
    horizontal bool
    gap int
}

pub fn Flex.new(init FlexInit) &Flex {
  mut flex := &Flex{
    Box: init.Box
    children: init.children
    horizontal: init.horizontal
    gap: init.gap
  }

  for mut child in flex.children { child.parent = flex }

  return flex
}

pub fn (mut flex Flex) draw(mut context tui.Context, transform Vector2) {
  if !flex.visible { return }

  flex.set_colors(mut context)
  direction := if flex.horizontal { Vector2{ 1, 0 } } else { Vector2{ 0, 1 } }
  across := if flex.horizontal { Vector2{ 0, 1 } } else { Vector2{ 1, 0 } }
  mut child_transform := transform + flex.offset

  mut growers := 0
  for index in 0..flex.children.len {
    child := flex.children[index]
    if child.grow { growers += 1 }
  }
  // Space taken by children before growth
  size := flex.natural_size()
  // Space available for children to grow
  available := flex.resolved.size
  // Space to share among growers
  leftover := available - size
  // Space initially assigned to each grower
  assigned := Vector2{ leftover.x / growers, leftover.y / growers }
  // Remainder space, shared among the first growers until none left
  mut remainder := (leftover.x % growers) * direction.x + (leftover.y % growers) * direction.y

  for index in 0..flex.children.len {
    mut child := flex.children[index]
    mut resolved_size := child.natural_size()
    if child.grow {
      resolved_size += assigned * direction
      if remainder > 0 {
        resolved_size += direction
        remainder -= 1
      }
    }

    if flex.align == .stretch {
      // When .stretch, every child fills the complete cross-axis
      resolved_size = resolved_size * direction + size * across
    }

    child.resolved.size = resolved_size
    child.draw(mut context, child_transform)
    child_transform += resolved_size * direction + direction.scale(flex.gap)
  }
}

pub fn (flex Flex) natural_size() Vector2 {
  if !flex.visible { return Vector2{} }

  direction := if flex.horizontal { Vector2{ 1, 0 } } else { Vector2{ 0, 1 } }
  across :=  if flex.horizontal { Vector2{ 0, 1 } } else { Vector2{ 1, 0 } }
  mut sum := Vector2{}
  mut max := Vector2{}

  for child in flex.children {
    child_size := child.natural_size()
    sum += child_size + direction.scale(flex.gap)
    max = Vector2.max(max, child_size)
  }

  return sum * direction + max * across
}

pub fn (mut flex Flex) add(mut child Component) {
  child.parent = flex
  flex.children << child
}

pub fn (flex Flex) children() []&Component {
  return flex.children
}