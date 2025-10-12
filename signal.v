module vitrine

struct Signal[T] {
mut:
	value       T
	subscribers []fn () = []
}

pub fn (mut signal Signal[T]) update[T](value T) {
	signal.value = value
	for subscriber in signal.subscribers {
		subscriber()
	}
}

pub fn (signal Signal[T]) read[T]() T {
	return signal.value
}

fn (mut signal Signal[T]) subscribe[T](subscriber fn ()) {
	signal.subscribers << subscriber
}
