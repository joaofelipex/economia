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
  #text(size: 24pt, weight: "bold", fill: rgb(7, 55, 99), font: "Georgia")[
    Economia Informal no Brasil
  ]
  #v(0.4cm)
  #text(size: 16pt, fill: rgb(68, 68, 68))[Fundamentos teóricos e evidências empíricas]
  #v(1.2cm)
  #text(size: 11pt, fill: rgb(102, 102, 102))[Artefato acadêmico de apoio ao Trabalho de Conclusão de Curso]
  #v(2.5cm)
  #text(size: 10pt, fill: rgb(153, 153, 153))[Dados atualizados — IBGE/PNAD Contínua · 2025-2026]
]

#pagebreak()

#outline(title: "Sumário", depth: 2)

#pagebreak()

// ============================================================
= Introdução
#v(0.2cm)

A informalidade é um dos traços mais persistentes e controversos do mercado de trabalho brasileiro. Mesmo após décadas de políticas de formalização, de crescimento econômico e de recuperação do emprego com carteira assinada, a proporção de trabalhadores em situação informal permaneceu por longo tempo acima de um terço da população ocupada. Compreender esse fenômeno exige transitar por três frentes complementares: a #strong[conceitual] (o que é, afinal, a economia informal), a #strong[teórica] (as diferentes escolas que explicam suas causas) e a #strong[empírica] (como ela se manifesta e se transforma no Brasil contemporâneo).

Este artefato tem por objetivo sistematizar esses três níveis de análise, servindo de referencial para a construção de um Trabalho de Conclusão de Curso (TCC) em economia. A pretensão não é esgotar o tema, tampouco defender uma única corrente, mas organizar o estado da arte de modo a permitir que o pesquisador delimite seu problema, suas hipóteses e sua estratégia empírica com rigor.

#quote(block: true)[
  *Problema de pesquisa sugerido:* diante da redução recente da informalidade no Brasil, quais fatores — estruturais, institucionais e conjunturais — explicam a persistência de um contingente superior a 38 milhões de trabalhadores em ocupações informais, e quais políticas têm sido mais efetivas na transição para a formalidade?
]

== Justificativa e relevância

A informalidade não é um fenômeno marginal: ela envolve aproximadamente 38,5 milhões de brasileiros e condiciona diretamente a arrecadação fiscal, a qualidade das ocupações, a proteção previdenciária e a produtividade média do trabalho. No plano internacional, estimativas indicam que o emprego informal corresponde a cerca de #strong[60% do emprego mundial] e que a produção informal representa entre #strong[15% e 35% do PIB total], dependendo da região (OIT; Ohnsorge e Yu, 2021). No Brasil, os estudos convergem para uma produção não observada da ordem de #strong[16% a 18% do PIB], o que torna o tema central tanto para a teoria do desenvolvimento quanto para o desenho de políticas públicas.

== Objetivos

+ #strong[Objetivo geral:] analisar o conceito, as teorias explicativas e as evidências empíricas da economia informal no Brasil, com dados atualizados.
+ #strong[Objetivos específicos:]
  - delimitar as noções de *setor informal*, *emprego informal*, *economia informal* e *economia não observada*;
  - apresentar as principais vertentes teóricas, do dualismo clássico ao estruturalismo e à abordagem legalista;
  - sistematizar as estratégias de mensuração e as estimativas disponíveis;
  - caracterizar, com base na PNAD Contínua, a evolução e o perfil da informalidade brasileira;
  - discutir políticas de formalização e as perspectivas futuras.

// ============================================================
= Marco conceitual
#v(0.2cm)

Uma dificuldade recorrente na literatura é a ambiguidade terminológica. "Informalidade" é usada para designar realidades distintas, e a confusão entre elas compromete tanto a análise quanto a comparação internacional. A OIT, em suas conferências internacionais dos estatísticos do trabalho (CIET), consolidou uma distinção metodológica fundamental entre quatro níveis.

== Setor informal

O conceito de *setor informal* refere-se à #emph[unidade de produção]. Surgiu no estudo sobre o Quênia do Programa Mundial de Emprego (ILO, 1972) e foi formalizado na 15ª Conferência Internacional dos Estatísticos do Trabalho (1993). Refere-se às unidades produtivas de pequeno porte, não constituídas como pessoa jurídica separada de seus proprietários, que operam à margem das regulamentações. A definição de referência foi ratificada na 19ª CIET (2013) e atualizada na 21ª CIET (2023).

== Emprego informal

O conceito de *emprego informal* refere-se à #emph[posição na ocupação (o emprego)], e não à unidade onde ele ocorre. Um emprego é informal quando o trabalhador não goza de proteção legal ou social (carteira assinada, contribuição previdenciária, direitos trabalhistas). Isso pode ocorrer tanto no setor informal quanto no setor formal — por exemplo, um empregado sem registro contratado por uma empresa constituída.

#quote(block: true)[
  *Ponto metodológico-chave:* "emprego no setor informal" e "emprego informal" não são sinônimos. O primeiro observa a empresa; o segundo observa o posto de trabalho. Essa distinção (OIT, 2013) é decisiva para não inflar nem subestimar os indicadores.
]

== Economia informal e economia não observada

A *economia informal* é o conceito mais amplo e engloba tanto o setor informal (unidades) quanto o emprego informal (ocupações). A OIT a define como o conjunto de atividades econômicas, trabalhadores e unidades produtivas que, na prática ou na lei, não são abrangidos ou não são plenamente cobertos por disposições formais.

Já a *economia não observada (ENO)* é um conceito da contabilidade nacional (SNA 2008, cap. 25). Engloba, além da produção informal, a economia subterrânea, a economia ilegal e a produção das famílias para consumo próprio, bem como erros de mensuração estatística. É fundamental: parte da população informal não devidamente captada, e toda estimativa do PIB precisa incorporá-la.

== A proxy brasileira (IBGE)

Na prática estatística brasileira, o IBGE divulga uma *proxy da taxa de informalidade* da população ocupada, composta pelas seguintes categorias:

+ empregado no setor privado sem carteira de trabalho assinada;
+ empregado doméstico sem carteira de trabalho assinada;
+ empregador sem registro no CNPJ;
+ trabalhador por conta própria sem registro no CNPJ;
+ trabalhador familiar auxiliar.

Essa definição operacional, embora amplamente utilizada, exclui segmentos como os servidores públicos sem carteira e os "falsos" PJ, o que justifica a leitura de que há "informalidades dentro da informalidade".

// ============================================================
= Fundamentação teórica
#v(0.2cm)

As explicações para a informalidade organizam-se em torno de grandes famílias teóricas, que diferem segundo o que identificam como *causa* e como *solução* para o fenômeno.

== A tradição dualista e a modernização

A abordagem mais antiga trata a informalidade como resíduo do *setor tradicional* ("atrasado"), que coexistiria com o setor moderno e migraria, gradualmente, para a formalidade conforme o desenvolvimento avançasse. Essa visão tem raiz no modelo de Athur Lewis (1954), em que a agricultura fornecia excedente de mão de obra à indústria sem pressões salariais — o pressuposto da "oferta ilimitada de trabalho".

== O modelo de Harris e Todaro (1970)

Complementarmente, Harris e Todaro (1970) construíram um modelo de dois setores para explicar a migração urbano-rural e o desemprego urbano em países em desenvolvimento. A ideia central é que a migração responde à #emph[diferença entre o salário esperado urbano] (salário formal ajustado pela probabilidade de obter emprego) e o rendimento rural. Salários formais institucionalmente elevados atraem migrantes mesmo diante de desemprego; é o "desemprego urbano como equilíbrio". Extensões posteriores introduziram explicitamente o setor urbano informal como absorvedor de mão de obra, mostrando que o movimento para a informalidade pode ser racional diante do prêmio salarial formal-informal.

== PREALC e a vertente do excedente (OIT)

O Programa Regional do Emprego para a América Latina e o Caribe (PREALC), vinculado à OIT, adotou uma leitura estruturalista: o setor informal é consequência de um excedente estrutural de força de trabalho que a economia moderna é incapaz de absorver, dado o padrão de acumulação da periferia. Trata-se de um *problema de emprego*, não de empresariado, e a solução exige crescimento e políticas de geração de ocupação de qualidade.

== A interpretação legalista (De Soto)

A corrente legalista, associada a Hernando de Soto (*O Outro Caminho*, 1986, sobre o Peru), inverte o diagnóstico: a informalidade não estaria na subdesenvolvimento, mas na #strong[excessiva regulação estatal]. O custo e o tempo de formalizar seriam tão elevados que empurrariam os agentes para a "extralegalidade". A solução seria desburocratizar, garantir direitos de propriedade e simplificar o registro da atividade. Nessa leitura, o informal não é vítima, mas *empreendedor* excluído pela regulação.

== Estruturalismo e neo-marxismo

Autores (Kowarick, Singer, Portes, Castells, e, na linha do PREALC, Baltar) rejeitam a dicotomia formal/informal como esferas separadas. Argumentam que setor formal e informal são a #emph[mesma unidade do processo capitalista]: a informalidade é um mecanismo de flexibilização e redução de custos do capital, estruturalmente funcional para a acumulação. A "nova informalidade" — terceirização, contratos como PJ, entregas por plataforma — estenderia a informalização *para dentro* de empresas estruturadas.

== Síntese comparativa

#figure(
  align(center)[#table(
    columns: (24%, 19%, 26%, 31%),
    align: (left, center, left, left),
    table.header([Corrente], [Causa], [Solução], [Protagonista]),
    table.hline(),
    [Dualismo/Modernização], [Resíduo tradicional], [Crescimento/modernização], [Trabalhador migrante],
    [Harris-Todaro], [Prêmio salarial urbano], [Equilíbrio de salários], [Migrantes racionais],
    [PREALC (excedente)], [Excedente estrutural], [Geração de emprego], [Excluído do emprego],
    [Legalista (De Soto)], [Excesso de regulação], [Desburocratização], [Empreendedor],
    [Estruturalista/marxista], [Flexibilização do capital], [Relações de poder], [Inseridos no capital],
  )],
  kind: table,
)

Essa oposição sugere uma interpretação complementar: a informalidade brasileira atual combina uma "velha informalidade" de sobrevivência e baixa produtividade com uma "nova informalidade" induzida pela reestruturação do capitalismo contemporâneo (Tavares e muitas contribuições da linha da nova informalidade).

// ============================================================
= Mensuração da economia informal
#v(0.2cm)

A mensuração da informalidade divide-se em duas frentes: a do *emprego* (pesquisas domiciliares, como a PNAD Contínua) e a da *produção/valor adicionado* (contas nacionais e métodos indiretos). Cada uma responde a perguntas distintas.

== Medidas de emprego

A PNAD Contínua, coordenada pelo IBGE desde 2012, é a principal fonte sobre a força de trabalho brasileira, abrangendo cerca de 211 mil domicílios e 3.500 municípios por trimestre. Sua proxy de informalidade é a mais citada nos meios de comunicação e oferece desagregação por região, sexo, idade, cor/raça e instrução.

== Medidas de produção (ENO e economia subterrânea)

No âmbito do Sistema de Contas Nacionais, a *economia não observada* é estimada por métodos indiretos, como a expansão da produção das famílias e o ajuste oferta-demanda. A literatura (Hallak Neto et al.) estimou a ENO brasileira em cerca de #strong[15,8% do PIB em 2000], caindo para #strong[11,6% em 2009]. Já o Índice de Economia Subterrânea (ETCO/FGV IBRE) usa método baseado na demanda por moeda e estimou, em 2022, uma produção à margem das regulações de aproximadamente #strong[17,8% do PIB], equivalente a cerca de R\$ 1,7 trilhão. Painéis internacionais (Schneider et al.) costumam atribuir ao Brasil valores mais elevados, na casa de 35% do PIB, evidenciando a sensibilidade dos resultados à metodologia.

#quote(block: true)[
  *Implicação:* toda comparação de "tamanho da informalidade" deve explicitar qual indicador está sendo usado (emprego versus valor adicionado) e qual método subjacente, sob pena de conclusões enganosas.
]

== Indicadores em camadas (FGV IBRE)

A partir dos microdados da PNAD, o IBRE/FGV propôs cinco medidas encadeadas de informalidade, da mais abrangente à mais restrita:

#figure(
  align(center)[#table(
    columns: (10%, 90%),
    table.header([Medida], [Descrição — trabalhador ocupado...]),
    table.hline(),
    [M1], [sem carteira de trabalho nem CNPJ, incluindo alguns servidores públicos],
    [M2], [proxy oficial do IBGE (M1 excluídos os servidores públicos sem carteira)],
    [M3], [M2 + não contribuinte da previdência social],
    [M4], [M3 + há menos de dois anos na ocupação atual],
    [M5], [M4 + renda abaixo da média do grupo — núcleo de maior vulnerabilidade],
  )],
  kind: table,
)

Os dados indicam que, embora o contingente "amplo" gire em torno de 39 milhões, o grupo mais vulnerável (M5) é bem menor e vem caindo: a parcela da força de trabalho na condição mais precária atingiu cerca de 10,8% em 2025, com tendência de redução desde o pico de 2020-2021. Isso revela que a informalidade não é homogênea e que os indicadores agregados ocultam distintas gradações de insegurança.

// ============================================================
= Panorama empírico do Brasil (dados atualizados)
#v(0.2cm)

Os dados mais recentes do IBGE revelam uma inflexão relevante: após o pico pandêmico, a taxa de informalidade vem caindo desde 2022, com aceleração a partir de 2023.

== Evolução da taxa anual de informalidade

#figure(
  align(center)[#table(
    columns: (22%, 18%, 18%, 18%, 24%),
    align: (left, center, center, center, center),
    table.header([Ano], [Formais (%)], [Informais (%)], [Informais (milhões)], [Observação]),
    table.hline(),
    [2022], [60,5], [39,5], [—], [Recuperação pós-pandemia],
    [2023], [60,8], [39,2], [—], [Início da aceleração da queda],
    [2024], [61,0], [39,0], [~39,2], [Mercado de trabalho robusto],
    [2025], [61,9], [38,1], [~38,5], [Menor patamar desde 2020],
  )],
  kind: table,
  caption: [Fonte: IBGE, PNAD Contínua anual e trimestral.]
)

#quote(block: true)[
  Em 2025, a taxa anual de informalidade foi de *38,1%* da população ocupada, contra 39,0% em 2024. No trimestre móvel de novembro de 2025 a janeiro de 2026, o indicador atingiu *37,5%*, o menor nível desde julho de 2020, equivalendo a *38,5 milhões* de trabalhadores informais. À parte a anomalia pandêmica de 2020, trata-se da *melhor composição de emprego da série* — na avaliação do próprio IBGE.
]

Os fatores apontados para a queda: retração do emprego sem carteira no setor privado e, sobretudo, a expansão da cobertura de registro no CNPJ dos trabalhadores por conta própria, movimento facilitado pelo crescente uso de mecanismos formais de pagamento e pelo desenho de políticas como o MEI.

== Heterogeneidade regional

A informalidade é fortemente associada ao nível de desenvolvimento regional, concentrando-se no Norte e Nordeste e sendo menor no Sul e Sudeste.

#figure(
  align(center)[#table(
    columns: (46%, 27%, 27%),
    align: (left, center, center),
    table.header([Unidade da Federação], [4º trim. 2025 (%)], [Ano 2025 (%)]),
    table.hline(),
    [#strong[Maranhão]], [#strong[57,3]], [#strong[58,7]],
    [Pará], [56,7], [58,5],
    [Amazonas], [51,6], [—],
    [Bahia], [—], [52,8],
    [#emph[Brasil]], [#emph[37,6]], [#emph[38,1]],
    [São Paulo], [29,7], [29,0],
    [Distrito Federal], [27,1], [27,3],
    [#strong[Santa Catarina]], [#strong[25,7]], [#strong[26,3]],
  )],
  kind: table,
  caption: [Fonte: IBGE, PNAD Contínua. Maiores e menores taxas.]
)

== Perfil dos trabalhadores informais

A informalidade brasileira tem perfil sociodemográfico bem definido: é maior entre mulheres, jovens, pessoas com menor escolaridade e população preta e parda. Essas dimensões se sobrepõem e reforçam o vínculo entre informalidade, pobreza e desigualdade, tema central para os determinantes sociais do fenômeno. Além disso, os trabalhadores informais auferem, em média, rendimentos consideravelmente menores que os formais, o que amplia a desigualdade de renda e reduz a eficácia dos mecanismos de proteção social.

== A nova informalidade digital

A expansão das plataformas digitais (aplicativos de transporte e entrega, marketplaces) deu novo contorno ao fenômeno. Trata-se de um *emprego informal no interior do setor formal*: empresas de grande porte organizam a demanda, mas os trabalhadores atuam como "parceiros" autônomos sem vínculo formal nem proteção social. Segmentos como o de transporte por aplicativo registraram forte alta de preço/relevância nos últimos anos, evidenciando a centralidade contemporânea dessa modalidade e o desafio regulatório que impõe.

// ============================================================
= Determinantes e consequências
#v(0.2cm)

== Determinantes

A literatura converge para um conjunto amplo de fatores determinantes da informalidade:

+ #strong[Estrutura produtiva:] economias com maior peso de serviços de baixa produtividade e menor sofisticação tecnológica tendem a mais informalidade, mesmo controlando por crescimento do PIB per capita (OIT).
+ #strong[Regulação e custo de formalização:] impostos sobre o trabalho, burocracia e custos de registro afetam a decisão de formalizar (De Soto).
+ #strong[Ciclo econômico:] em recessões, o desemprego expulsa trabalhadores para o autoemprego informal; em expansões, há migração em direção à formalidade, com elasticidades distintas por faixa de renda.
+ #strong[Instituições e proteção social:] a qualidade da proteção social e o alcance dos programas de transferência condicionam os incentivos à formalização.
+ #strong[Fatores demográficos e educacionais:] a oferta de trabalho de baixa qualificação e o perfil etário da população.

== Consequências

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (left, left),
    table.header([Microeconômicas], [Macroeconômicas]),
    table.hline(),
    [Menor rendimento médio], [Perda de arrecadação tributária],
    [Ausência de proteção previdenciária], [Menor produtividade média do trabalho],
    [Insegurança e instabilidade de renda], [Base tributária menor e distorcida],
    [Menor acesso a crédito e direitos], [Dificuldade de mensuração do PIB],
    [Precariedade e riscos à saúde], [Segmentação do mercado de trabalho],
  )],
  kind: table,
)

A informalidade, portanto, não é apenas um indicador do mercado de trabalho: ela afeta a trajetória de longo prazo da economia ao deprimir a produtividade, restringir a acumulação de capital humano e reduzir a capacidade fiscal do Estado de financiar políticas de desenvolvimento.

// ============================================================
= Políticas públicas e transição para a formalidade
#v(0.2cm)

A agenda de combate à informalidade no Brasil combina instrumentos de desoneração, simplificação e estímulo ao registro.

== O MEI (Microempreendedor Individual)

Criado em 2008, o MEI foi um dos instrumentos mais efetivos de formalização do trabalho por conta própria, permitindo ao trabalhador tornar-se pessoa jurídica individual com tributo reduzido, acesso ao INSS e nota fiscal. Sua expansão foi associada tanto à redução da informalidade quanto ao aumento do registro no CNPJ, observado com mais intensidade a partir de 2023.

== Reforma trabalhista (2017) e plataformas

A reforma trabalhista de 2017 flexibilizou diversas normas, ampliando formas de contratação como o trabalho intermitente e incentivando contratos de pessoa jurídica. Seus efeitos sobre a informalidade são ambíguos: reduziu o custo relativo da formalização em alguns segmentos, mas também criou formas atípicas que, sem proteção social, podem ser lidas como "nova informalidade".

== Programas de renda e proteção social

Programas de transferência de renda e a expansão do acesso ao crédito contribuem para sustentar a renda das famílias mesmo fora do emprego formal, funcionando como estabilizadores da renda, embora não sejam substitutos do emprego formal de qualidade.

== Recomendações de política

#figure(
  align(center)[#table(
    columns: (38%, 62%),
    align: (left, left),
    table.header([Frente], [Ações]),
    table.hline(),
    [Crescimento e estrutura], [Estrutura produtiva mais complexa, com incorporação de tecnologia],
    [Regulação], [Redução do custo de formalizar e simplificação de procedimentos],
    [Proteção social], [Ampliação da cobertura previdenciária a trabalhadores autônomos],
    [Plataformas], [Regulamentação do trabalho por aplicativo com garantias mínimas],
    [Crédito e capacitação], [Microcrédito produtivo e formação profissional],
  )],
  kind: table,
)

A experiência internacional e os dados brasileiros recentes indicam que a transição para a formalidade não depende de uma única alavanca, mas de *coerência entre políticas macroeconômicas, regulatórias e de proteção social* (OIT).

// ============================================================
= Considerações finais
#v(0.2cm)

A economia informal é um fenômeno multidimensional. Do ponto de vista conceitual, exige-se separar setor informal, emprego informal, economia informal e economia não observada. Do ponto de vista teórico, nenhuma escola isolada esgota a explicação: a informalidade brasileira combina excedente estrutural de mão de obra, custos de formalização e lógica de flexibilização do capital, reunindo "velha" e "nova" informalidade. Do ponto de vista empírico, os dados mais recentes da PNAD Contínua mostram um ponto de inflexão: a taxa de informalidade caiu para 38,1% em 2025 (37,6% no quarto trimestre), a menor da série quando se exclui a anomalia pandêmica, ainda que cerca de 38,5 milhões de brasileiros permaneçam em ocupações informais.

Esse quadro oferece um campo fértil para a pesquisa empírica de TCC: avaliar, por meio de regressão ou análise descritiva desagregada, o quanto a redução recente decorre de fatores conjunturais (ciclo econômico, mercado de trabalho aquecido), institucionais (MEI, formalização de conta própria) ou estruturais (composição da produção). A identificação desses canais é condição para recomendar políticas que não apenas reduzam estatisticamente a informalidade, mas elevem a qualidade do emprego e a proteção social.

#quote(block: true)[
  *Sugestões de direções futuras de pesquisa:* (i) estimar determinantes da formalização com microdados PNAD Contínua e modelos de painel; (ii) quantificar o efeito do MEI sobre o registro no CNPJ; (iii) investigar a informalidade nas plataformas digitais; (iv) comparar a informalidade brasileira com pares latino-americanos controlados por estrutura produtiva.
]

// ============================================================
= Referências
#v(0.2cm)

#set par(first-line-indent: 0em, leading: 0.5em)

#text(size: 9.5pt)[
+ DE SOTO, H. *O outro caminho: uma análise da realidade peruana.* Rio de Janeiro: Globo, 1986.
+ HARRIS, J.; TODARO, M. Migration, unemployment and development: a two-sector analysis. *American Economic Review*, v. 60, n. 1, p. 126-142, 1970.
+ IBGE. *Pesquisa Nacional por Amostra de Domicílios Contínua (PNAD Contínua)*. Rio de Janeiro: IBGE, 2012-2026.
+ IBGE. *Indicadores Econômicos do Brasil 2025*. Rio de Janeiro: IBGE, 2026.
+ ILO (OIT). *Employment, incomes and equality: a strategy for increasing productive employment in Kenya*. Genebra, 1972.
+ OIT. *Measuring informality: a statistical manual on the informal sector and informal employment*. Genebra, 2013.
+ OIT. *Crescimento, estrutura econômica e informalidade*. Genebra: OIT, 2024.
+ OIT. *A economia informal e o trabalho digno: guia de recursos sobre as políticas.* Genebra, [s.d.].
+ LEWIS, W. A. Economic development with unlimited supplies of labour. *The Manchester School*, v. 22, n. 2, p. 139-191, 1954.
+ HALLACK NETO, J.; NAMIR, S.; KOZOVITS, L. A economia não observada no Brasil. *Revista de Economia Contemporânea*, 2012.
+ NOGUEIRA, M. O. *A problemática do dimensionamento da informalidade na economia brasileira.* Brasília: Ipea, 2016.
+ OHNSORGE, F.; YU, S. *Informal Economy - Frequently Asked Questions.* Washington: Banco Mundial, 2021.
+ PORTES, A.; CASTELLS, M.; BENTON, L. (orgs.). *The Informal Economy: Studies in Advanced and Less Developed Countries.* Baltimore: Johns Hopkins University Press, 1989.
+ SCHNEIDER, F.; BUEHN, A.; MONTENEGRO, C. New estimates for the shadow economies all over the world. *International Economic Journal*, v. 24, n. 4, 2010.
+ TAVARES, M. A. et al. O problema da informalidade ocupacional na periferia do capitalismo. *Texto para Discussão*, Unicamp/IE, 2008.
]

#v(1cm)
#quote(block: true)[
  *Nota metodológica:* todas as estatísticas citadas são de domínio público (IBGE, OIT, FGV IBRE, Ipea). Os valores de 2025/2026 referem-se às divulgações mais recentes da PNAD Contínua (fev./mar. 2026). O presente artefato é um material de estudo e referencial para a elaboração do TCC, não substituindo a consulta integral às fontes citadas.
]




