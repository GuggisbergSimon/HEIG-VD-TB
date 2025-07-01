== Tables <list-of-tables>

#context {
  let tables = query(figure.where(kind: table))
  if tables.len() != 0 {
    outline(title: none, target: figure.where(kind: table))
  }
}
