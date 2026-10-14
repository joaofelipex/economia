#show raw: set text(size: 8.5pt)
#show raw.where(block: true): it => block(
  width: 100%,
  fill: if it.lang == none { rgb("#fbfcf8") } else { luma(247) },
  stroke: if it.lang == none {
    (left: 2.5pt + rgb("#7aa37a"), rest: 0.5pt + luma(225))
  } else {
    0.5pt + luma(215)
  },
  inset: 7pt,
  radius: 2pt,
  it,
)
#set line(length: 100%, stroke: 0.6pt + luma(170))

// ---- Caixas de destaque -------------------------------------------------
#let caixa(titulo, cor, fundo, corpo) = block(
  width: 100%,
  inset: (x: 10pt, y: 8pt),
  radius: 3pt,
  fill: fundo,
  stroke: (left: 3pt + cor),
  above: 1em,
  below: 1em,
  breakable: true,
)[
  #block(sticky: true, below: 4pt)[#text(weight: "bold", fill: cor, size: 9.5pt)[#titulo]]
  #corpo
]
#let exemplo(titulo, corpo) = caixa("Exemplo resolvido — " + titulo, rgb("#1f6f4a"), rgb("#eef7f1"), corpo)
#let intuicao(corpo) = caixa("Intuição", rgb("#1d4f91"), rgb("#edf3fb"), corpo)
#let atencao(corpo) = caixa("Atenção — erro comum", rgb("#a33a1c"), rgb("#fcf1ec"), corpo)
#let teoria(titulo, corpo) = caixa("Aprofundando a teoria — " + titulo, rgb("#5b3a8c"), rgb("#f4f0fa"), corpo)
#let mercado(corpo) = caixa("No mercado brasileiro", rgb("#8a6100"), rgb("#fdf6e3"), corpo)
#let resumo(corpo) = caixa("Em resumo", rgb("#444444"), rgb("#f2f2f2"), corpo)

// ---- Linha do tempo de fluxo de caixa ------------------------------------
// valores: strings; começando com "-" = saída (seta para baixo), "" = nada.
#let fluxo(..valores) = {
  let v = valores.pos()
  let n = v.len()
  block(width: 100%, inset: 8pt, stroke: 0.5pt + luma(210), radius: 3pt, above: 1em, below: 1em)[
    #set text(size: 8.5pt)
    #grid(
      columns: (1fr,) * n,
      row-gutter: 3pt,
      align: center,
      ..v.map(x => if x == "" { [] } else if x.starts-with("-") {
        text(fill: rgb("#a33a1c"))[↓ #x.slice(1)]
      } else {
        text(fill: rgb("#1f6f4a"))[↑ #x]
      }),
      ..range(n).map(_ => line(length: 100%, stroke: 0.7pt + luma(90))),
      ..range(n).map(t => text(fill: luma(90))[t = #t]),
    )
  ]
}

