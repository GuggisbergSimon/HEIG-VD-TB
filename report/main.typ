/*
 Vars
*/
#let language = "fr"
#set text(lang: language)

#let studentFirstname = "Simon"
#let studentLastname = "Guggisberg"

#let confidential = false

#let TBtitle = "Open World Game Prototype"
#let TBsubtitle = "Exploration et implémentation de l'état de l'art de techniques d'optimisation pour une application en temps réel"
#let TByear = "2025"
#let TBacademicYears = "2024-25"

#let TBdpt = "Département des Technologie de l'information et de la communication (TIC)"
#let TBfiliere = "Informatique et systèmes de communication"
#let TBorient = "Informatique logicielle"

#let TBauthor = studentFirstname + " " + studentLastname
#let TBsupervisor = "Professeur Bertil Chapuis"

#let TBresumePubliable = [
  #include "chapters/resume.typ"
]

/*
 Includes
*/
#import "template/macros.typ": *

#import "template/style.typ": TBStyle
#show: TBStyle.with(TBauthor, confidential)

/*
 Title and template
*/
#import "template/_title.typ": *
#_title(TBtitle, TBsubtitle, TBacademicYears, TBdpt, TBfiliere, TBorient, TBauthor, TBsupervisor, confidential)
#import "template/_second_title.typ": *
#_second_title(TBtitle, TBacademicYears, TBdpt, TBfiliere, TBorient, TBauthor, TBsupervisor, TBresumePubliable)

/*
 Table of Content
*/

// Set numbering for content
#set heading(numbering: "1.1")

#outline(title: "Table des matières", depth: 3, indent: 15pt)

/*
 Content
*/
#include "template/_preambule.typ"

#include "chapters/cdc.typ"

#include "chapters/etat-de-lart.typ"

#include "chapters/outils.typ"

#include "chapters/architecture.typ"

#include "chapters/implementation.typ"

#include "chapters/conclusion.typ"


// Remove numbering after content
#set heading(numbering: none)

/*
 Tables
*/

= Annexes

#include "template/_bibliography.typ"
//#include "template/_glossary.typ"
#include "template/_jdt.typ"
#include "template/_figures.typ"
#include "template/_tables.typ"

/*
 Annexes
*/

#import "template/_authentification.typ": *
#_authentification(TBauthor)
