#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.2cm),
  footer: context [ #h(1fr) #counter(page).display() ],
  numbering: "1",
)
#set text(
  font: ("Georgia", "Times New Roman"),
  size: 11pt,
  lang: "pt",
)
#set par(justify: true, leading: 0.72em, first-line-indent: 0.6em)
#set heading(numbering: "1.1")
#set table(
  stroke: 0.4pt,
  fill: none,
)

#show heading: it => {
  set text(font: ("Georgia"), fill: rgb(7, 55, 99))
  it.body
}

// ---- Capa ----
#align(center)[
  #v(3cm)
  #text(size: 20pt, weight: "bold", fill: rgb(7, 55, 99), font: "Georgia")[
    Informalidade como estratégia de geração de renda no Brasil
  ]
  #v(0.4cm)
  #text(size: 14pt, fill: rgb(68, 68, 68))[
    Uma análise da renda complementar e da sobrevivência econômica \
    em um contexto de inflação (2016–2025)
  ]
  #v(1.2cm)
  #text(size: 11pt, fill: rgb(102, 102, 102))[Trabalho de Conclusão de Curso — Projeto de Pesquisa]
  #v(2.5cm)
  #text(size: 10pt, fill: rgb(153, 153, 153))[Base de dados: IBGE/PNAD Contínua · 2016–2025]
]

#pagebreak()

#outline(title: "Sumário", depth: 2)

#pagebreak()

// ============================================================
= Introdução
#v(0.2cm)

A informalidade é um traço estrutural do mercado de trabalho brasileiro, mas sua função econômica não é homogênea: para uma parte dos trabalhadores, ela representa uma *renda complementar* à ocupação principal; para outra, é a *fonte principal de sobrevivência* diante da ausência de alternativas formais. Compreender o que leva um trabalhador a se posicionar em um ou outro grupo — e como esse posicionamento se relaciona com o cenário inflacionário — é o objeto deste trabalho.

== Tema

#quote(block: true)[
  *Informalidade como estratégia de geração de renda no Brasil: uma análise da renda complementar e da sobrevivência econômica em um contexto de inflação (2016–2025).*
]

O recorte é deliberadamente restrito: não se pretende explicar toda a informalidade brasileira, mas investigar uma dinâmica específica — como a inflação empurra trabalhadores para a informalidade, seja como complemento de renda, seja como estratégia de sobrevivência. Essa delimitação permite (i) trabalhar com um período consistente (2016–2025), (ii) apoiar-se em dados públicos estáveis e comparáveis (PNAD Contínua) e (iii) sustentar conclusões defensáveis sem exigir econometria avançada.

== Problema de pesquisa

#quote(block: true)[
  *De que forma a inflação no período 2016–2025 influenciou a decisão dos trabalhadores brasileiros de recorrer à informalidade como renda complementar ou como fonte principal de sobrevivência?*
]

== Objetivos

=== Objetivo geral

Analisar como a inflação no período 2016–2025 afetou a decisão dos trabalhadores de recorrer à informalidade como estratégia de geração de renda.

=== Objetivos específicos

+ Caracterizar o perfil dos trabalhadores que usam a informalidade como renda complementar.
+ Identificar o perfil dos trabalhadores que dependem da informalidade como fonte principal de renda.
+ Comparar como a inflação afetou a renda real de ambos os grupos no período 2016–2025.
+ Discutir as implicações dessa dinâmica para políticas públicas de formalização e proteção social.

== Justificativa

O recorte proposto é relevante por três razões. Primeiro, a distinção entre informalidade *complementar* e informalidade de *sobrevivência* raramente é explorada com dados sistemáticos, embora tenha implicações distintas para o desenho de políticas públicas — um trabalhador que complementa renda formal responde a incentivos diferentes de um trabalhador cuja única fonte de renda é informal. Segundo, o período 2016–2025 compreende ciclos inflacionários distintos (a alta de 2015–2016, a inflação baixa de 2017–2019, o choque de 2021–2022 e a desaceleração posterior), o que oferece variação suficiente para observar padrões. Terceiro, a disponibilidade de microdados da PNAD Contínua ao longo de todo o período permite construir séries comparáveis sem necessidade de fontes alternativas.

== Delimitação e escopo

O estudo cobre o período de 2016 a 2025, com base nos microdados e tabelas agregadas da PNAD Contínua (IBGE). Não serão empregados modelos econométricos complexos: a estratégia analítica é descritiva e comparativa, eventualmente complementada por um questionário para captar percepções qualitativas dos próprios trabalhadores informais.

// ============================================================
= Referencial teórico
#v(0.2cm)

== Informalidade: complemento de renda versus sobrevivência

A literatura sobre informalidade frequentemente distingue dois tipos de inserção informal segundo a motivação do trabalhador (cf. Cacciamali, 1983; PREALC/OIT):

+ #strong[Informalidade por complementação:] trabalhador com ocupação principal (formal ou não) que busca uma renda extra por meio de atividade informal — presente sobretudo em contextos de perda de poder de compra do salário principal.
+ #strong[Informalidade por sobrevivência:] trabalhador sem alternativa de ocupação formal, para quem a atividade informal é a única ou a principal fonte de renda — associada a baixa escolaridade, informalidade intergeracional e ausência de rede de proteção social.

== Inflação, renda real e decisão de trabalho

A literatura de mercado de trabalho e inflação sugere que a erosão do poder de compra causada por inflação persistente altera a oferta de trabalho das famílias: (i) membros adicionais do domicílio passam a buscar ocupação (efeito "trabalhador adicional"); (ii) trabalhadores já ocupados buscam uma segunda atividade para compensar a perda de renda real; (iii) em contextos de inflação muito elevada ou de choques de preços de itens essenciais (alimentação, combustíveis), o efeito é mais agudo sobre famílias de baixa renda, que têm menor capacidade de substituição de consumo. Esses mecanismos fundamentam a hipótese de que picos inflacionários (2015–2016 e 2021–2022) devem coincidir com aumentos da informalidade complementar.

== Informalidade de sobrevivência como resposta estrutural

Para o segmento sem alternativa formal, a resposta à inflação é distinta: não há uma ocupação principal cuja renda real se erode, mas sim uma necessidade contínua de geração de renda diante de baixa demanda por trabalho formal. Nesse caso, a inflação atua sobre a *renda real do total auferido* na informalidade, e não sobre a decisão de entrada — o que motiva a comparação, no objetivo 3, entre o efeito da inflação sobre a renda real de cada grupo, e não apenas sobre a taxa de participação.

// ============================================================
= Metodologia
#v(0.2cm)

== Fonte de dados

A base empírica principal é a PNAD Contínua (IBGE), 2016–2025, explorada por meio de:

- tabelas agregadas do SIDRA (proxy de informalidade, rendimento médio real, ocupação em mais de um trabalho);
- séries de inflação do IBGE (IPCA) e, quando pertinente, do Banco Central (expectativas e meta), para contextualizar os ciclos inflacionários do período.

== Estratégia analítica

+ Construção de uma série anual/trimestral de taxa de informalidade e de proporção de trabalhadores com mais de uma ocupação (proxy de complementação de renda), 2016–2025.
+ Cruzamento dessas séries com a série de inflação (IPCA acumulado 12 meses) para identificar coincidência ou defasagem entre picos inflacionários e mudanças na informalidade.
+ Estatística descritiva do perfil sociodemográfico (idade, escolaridade, sexo, região) dos dois grupos — complementar e sobrevivência —, aproximados a partir das categorias disponíveis na PNAD Contínua (posição na ocupação, número de trabalhos, contribuição previdenciária).
+ Comparação da evolução do rendimento real médio de cada grupo ao longo do período, deflacionado pelo IPCA.
+ (Complementar, se viável) aplicação de questionário estruturado a uma amostra não probabilística de trabalhadores informais, para captar percepção subjetiva sobre o motivo de estar na informalidade.

== Limitações

A PNAD Contínua não identifica diretamente a motivação do trabalhador informal (complemento vs. sobrevivência); o estudo aproxima essa distinção por meio de variáveis proxy (múltiplas ocupações, posição na ocupação, contribuição previdenciária, rendimento). Essa limitação deve ser explicitada na análise dos resultados e, quando possível, mitigada pelo componente qualitativo do questionário.

// ============================================================
= Considerações finais (preliminares)
#v(0.2cm)

Este documento consolida o tema, o problema de pesquisa, os objetivos e a estratégia metodológica do TCC. As próximas etapas envolvem: (i) levantamento das séries do SIDRA/IPCA para o período 2016–2025; (ii) construção das proxies de informalidade complementar e de sobrevivência; (iii) análise descritiva comparativa; e (iv) redação da revisão de literatura completa a partir das referências já reunidas em `referencias_economia_informal.md`.

// ============================================================
= Referências
#v(0.2cm)

#set par(first-line-indent: 0em, leading: 0.5em)

#text(size: 9.5pt)[
+ CACCIAMALI, M. C. *Setor informal urbano e formas de participação na produção.* São Paulo: IPE/USP, 1983.
+ IBGE. *Pesquisa Nacional por Amostra de Domicílios Contínua (PNAD Contínua)*. Rio de Janeiro: IBGE, 2012-2026. Disponível em: https://sidra.ibge.gov.br.
+ IBGE. *Índice Nacional de Preços ao Consumidor Amplo (IPCA)*. Rio de Janeiro: IBGE, 2016-2025.
+ ORGANIZAÇÃO INTERNACIONAL DO TRABALHO (OIT). *Measuring informality: a statistical manual on the informal sector and informal employment.* Genebra: ILO, 2013.
+ PORTES, A.; CASTELLS, M.; BENTON, L. (orgs.). *The Informal Economy: Studies in Advanced and Less Developed Countries.* Baltimore: Johns Hopkins University Press, 1989.
]

#v(1cm)
#quote(block: true)[
  *Nota metodológica:* este é um documento de projeto de pesquisa, não a versão final do TCC. Todas as estatísticas e análises empíricas ainda precisam ser levantadas a partir das fontes citadas.
]
