== Figures <list-of-figures>

#context {
  let figures = query(figure.where(kind: image))
  if figures.len() != 0 {
    outline(title: none, target: figure.where(kind: image))
  }
}
