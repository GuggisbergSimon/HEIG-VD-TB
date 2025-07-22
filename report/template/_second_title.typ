#import "macros.typ": *

#let _second_title(TBtitle, TBacademicYears, TBdpt, TBfiliere, TBorient, TBauthor, TBsupervisor, TBresumePubliable) = {
  pagebreak(to: "odd")
  align(right)[
    #TBdpt\
    #TBfiliere\
    #TBorient\
    Étudiant : #TBauthor\
    Enseignant responsable : #TBsupervisor\
  ]

  v(8%)

  align(center)[Travail de Bachelor #TBacademicYears]
  align(center)[#TBtitle]
  v(8%)

  hr()

  v(8%)
  
  [
    *Résumé publiable*\
    #v(1%)
    #TBresumePubliable
  ]

  v(8%)
  
  table(
    stroke: none,
    columns: (40%, 30%, 30%),
    row-gutter: 1em,
    align: bottom,
    [Étudiant :], [Date et lieu :], [Signature :],
    [#TBauthor], [#hr_dotted()], [#hr_dotted()]
  )
  v(2%)
  table(
    stroke: none,
    columns: (40%, 30%, 30%),
    row-gutter: 1em,
    align: bottom,
    [Enseignant responsable :], [Date et lieu :], [Signature :],
    [#TBsupervisor], [#hr_dotted()], [#hr_dotted()]
  )
}