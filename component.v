module vitrine

type Renderer = fn () &Element

@[heap]
pub struct Component {
mut:
	signal   Signal[&Element] = Signal[&Element]{
		value: Flex.new()
	}
	renderer Renderer = fn () &Element {
		return Flex.new()
	}
}

pub fn (component Component) use() &Element {
	return component.signal.read()
}

pub fn (mut component Component) create_child(constructor fn (mut Component) Renderer) &Component {
	mut child := Component.create(constructor)
	child.signal.subscribe(component.render)

	return child
}

pub fn (mut component Component) create_signal[T](value T) &Signal[T] {
	mut signal := &Signal[T]{
		value: value
	}

	signal.subscribe(component.render)

	return signal
}

pub fn Component.create(constructor fn (mut Component) Renderer) &Component {
	mut component := &Component{}
	mut renderer := constructor(mut component)
	component.renderer = renderer
	component.render()

	return component
}

fn (mut component Component) render() {
	component.signal.update(component.renderer())
}
