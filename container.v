module vitrine

pub interface Container {
  Component
  children() []&Component
  mut:
    add(mut Component)
}
