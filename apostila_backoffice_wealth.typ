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

// Apostila — Back Office Analítico e Wealth Advisory
// Versão estendida: conteúdo original (Módulos 1-6) + Módulo 7 (compliance,
// regulamentação, eventos corporativos, previdência e preparação para a reunião).
// Compilar: typst compile apostila_backoffice_wealth.typ

#set document(
  title: "Apostila — Back Office Analítico e Wealth Advisory",
  author: "Material de estudo",
)
#set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1")
#set text(lang: "pt", size: 10.5pt)
#set par(justify: true)
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set table(stroke: 0.5pt, inset: 6pt)
#set list(indent: 1em, tight: false)
#set enum(indent: 1em, tight: false)

#align(center)[
  #v(4cm)
  #text(size: 24pt, weight: "bold")[Apostila]
  #v(0.2cm)
  #text(size: 16pt)[Back Office Analítico e Wealth Advisory]
  #v(0.6cm)
  #text(size: 11pt, fill: luma(100))[Sete módulos: do mercado financeiro à entrevista com o gestor]
  #v(0.3cm)
  #text(size: 9pt, fill: luma(120))[Versão estendida --- inclui o Módulo 7: compliance, regulamentação e preparação específica para a reunião]
]
#pagebreak()
#outline(title: [Sumário], depth: 2)

= Como usar esta apostila

Material de estudo organizado em sete módulos, do mercado financeiro à
preparação para a entrevista com o gestor. Cada módulo traz conceitos,
exemplos e exercícios. As regras de tributação, liquidação e
regulamentação citadas são referências didáticas: confirme sempre a norma
vigente antes de aplicar na prática ou de afirmar algo em entrevista.

- Estude um módulo por vez e resolva os exercícios ao final de cada um.
- Monte, ao longo do estudo, uma base fictícia de clientes e operações em Excel: ela será reaproveitada nos módulos 3, 4 e 5.
- Mantenha um glossário próprio. Vocabulário técnico preciso é parte da avaliação em entrevistas.

#line()

= Módulo 1 --- Fundamentos do mercado financeiro e Wealth Management

== 1.1 Como funciona o mercado financeiro

O sistema financeiro conecta quem tem recursos sobrando (poupadores e
investidores) a quem precisa de recursos (empresas, governo, famílias).
Essa conexão acontece de duas formas:

- *Intermediação financeira*: o banco capta dinheiro (depósitos, CDBs) e empresta com uma margem (spread).
- *Mercado de capitais*: o investidor aplica diretamente em títulos emitidos por empresas ou pelo governo, como ações e debêntures.

No Brasil, a estrutura de regulação e supervisão se organiza assim:

#table(
  columns: (auto, 1fr),
  table.header([Instituição], [Papel principal]),
  [CMN], [Define as diretrizes gerais do sistema financeiro],
  [Banco Central], [Supervisiona bancos, conduz a política monetária (Selic)],
  [CVM], [Regula e fiscaliza o mercado de capitais e os fundos],
  [ANBIMA], [Autorregulação e códigos de conduta; divulga índices e taxas de referência],
  [B3], [Bolsa e infraestrutura de negociação, registro, custódia e liquidação],
)

Taxas de referência que você precisa dominar: *Selic* (taxa básica), *CDI*
(taxa dos empréstimos interbancários, muito próxima da Selic e benchmark da
renda fixa), *IPCA* (inflação oficial) e *câmbio* (dólar/real).

#teoria("Selic, CDI e a transmissão da política monetária")[
  O Copom define a #strong[meta da Selic]. A taxa Selic "over" é a média
  das operações diárias entre instituições lastreadas em títulos públicos; o CDI,
  das operações interbancárias sem lastro, costuma ficar um pouco abaixo da meta
  (cerca de 0,10 ponto percentual). Quando o Copom #emph[sobe] a Selic, o custo de
  todo o crédito aumenta, o consumo e o investimento desaceleram, e a
  inflação tende a cair. Para o investidor, o efeito é duplo: títulos
  #strong[pós-fixados] passam a render mais, e títulos #strong[pré-fixados] já
  comprados #strong[perdem valor de mercado] (a taxa que o mercado exige subiu).
  Por isso a leitura da trajetória da Selic orienta a alocação entre
  pós, pré e inflação.
]

#exemplo("spread bancário")[
  Um banco capta em CDB a 100% do CDI (13,25% a.a.) e empresta a 22% a.a. O
  spread, em termos compostos, é $"1,22"/"1,1325" - 1 = "7,73"%$ ao ano (ou 8,75 pontos
  percentuais pela diferença simples). Esse é o #strong[spread bruto]: dele saem a
  inadimplência, os custos operacionais, os impostos e a remuneração do capital do
  banco. Quando um cliente pergunta "por que o banco paga 13% e cobra 22%?", essa
  é a resposta honesta --- e a razão de serviços de assessoria independente
  focarem no #emph[custo total] da relação com o sistema financeiro.
]

== 1.2 Bancos, corretoras, gestoras e assessorias

- *Bancos*: captam, emprestam, oferecem produtos próprios e, muitas vezes, têm braço de investimentos e de private banking.
- *Corretoras e distribuidoras*: executam ordens de compra e venda e distribuem produtos de terceiros. O cliente acessa a bolsa por meio delas.
- *Gestoras de recursos*: administram carteiras e fundos, tomando as decisões de investimento dentro de um mandato.
- *Administradores fiduciários e custodiantes*: cuidam da parte regulatória, contábil e da guarda dos ativos dos fundos.
- *Assessorias de investimento (e agentes autônomos)*: orientam clientes e distribuem produtos, vinculadas a uma corretora ou distribuidora. Não custodiam o patrimônio do cliente.

Um ponto de atenção para o Back Office: saber quem faz o quê evita erros
de responsabilidade, por exemplo, quem é a fonte oficial de uma posição
(custodiante) e quem apenas a reporta (assessoria).

#exemplo("quem faz o quê numa compra de ações")[
  Acompanhe uma compra de 100 ações de um cliente:

  #figure(
    align(center)[#table(
      columns: (6%, 30%, 64%),
      align: (center, left, left),
      table.header([\#], [Quem], [O que faz],),
      [1], [Assessor], [Entende o perfil, recomenda a compra e registra a recomendação (suitability)],
      [2], [Cliente], [Autoriza a ordem],
      [3], [Corretora], [Envia a ordem ao mercado e a executa],
      [4], [B3], [Casa as ordens (negociação) e, com sua câmara, compensa e liquida a operação em D+2],
      [5], [Custodiante], [Registra as ações em nome do cliente; é a #strong[fonte oficial da posição]],
      [6], [Back Office], [Concilia a posição do sistema interno com o extrato do custodiante e consolida o patrimônio],
    )]
    , kind: table
    )

  Se o back office usar o #emph[relatório da assessoria] como fonte da posição, em vez do extrato do
  custodiante, a conciliação perde o sentido: não se concilia uma fonte consigo mesma.
]

== 1.3 O que é Wealth Management e Advisory

Wealth Management é a gestão integrada do patrimônio de clientes de alta
renda ou grande patrimônio. Vai além de escolher investimentos e inclui:

- planejamento financeiro e definição de objetivos;
- alocação de ativos e rebalanceamento;
- planejamento tributário e sucessório;
- proteção (seguros, previdência);
- gestão de liquidez e de passivos.

Advisory (assessoria) é o serviço de recomendação e acompanhamento: o
assessor entende o perfil do cliente, propõe uma estratégia e acompanha o
resultado, enquanto a execução é feita por meio da corretora ou do banco.

O papel do *Back Office Analítico* nesse ecossistema é sustentar a operação
com informação correta: consolidar posições, conferir movimentações,
preparar relatórios e dar ao assessor dados confiáveis para a conversa com
o cliente.

#teoria("fee fixo versus comissão: um problema de agência")[
  Quem aconselha um investimento pode ser remunerado de duas formas. Na
  #strong[comissão por produto], recebe uma fração do que o cliente aplica em cada
  produto, e o interesse do assessor pode divergir do do cliente (produtos com
  comissão maior, giro desnecessário da carteira). No #strong[fee]
  (honorário fixo ou percentual sobre o patrimônio acompanhado), a remuneração
  independe do produto escolhido, o que alinha melhor os interesses --- ainda que
  o fee percentual crie o incentivo a aumentar o patrimônio sob assessoria.
  Em ambos os modelos, a #strong[transparência] sobre o que é cobrado e a
  qualidade do relatório de acompanhamento são o que sustenta a confiança do
  cliente. Em um modelo de fee, "o relatório é o produto".
]

== 1.4 Produtos financeiros e classes de ativos

*Renda fixa*

- Pós-fixados: rendem conforme um indicador, como o CDI (ex.: CDB a 100% do CDI), ou a Selic (Tesouro Selic).
- Prefixados: a taxa é conhecida na compra (ex.: 13% ao ano).
- Híbridos: parte fixa mais inflação (ex.: IPCA + 6% ao ano).
- Isentos de IR para pessoa física: LCI, LCA, CRI, CRA e debêntures incentivadas (regra vigente à época desta apostila; confira).
- Crédito privado: CDB, LC, debêntures, CRI, CRA. Envolvem risco de crédito do emissor, e o FGC cobre apenas parte dos produtos bancários, dentro de limites.
- Títulos públicos: Tesouro Selic, Tesouro Prefixado, Tesouro IPCA+.

*Renda variável*

- Ações, ETFs, fundos imobiliários (FIIs), BDRs.

*Fundos de investimento*

- Renda fixa, multimercado, ações, cambiais, FIIs, fundos exclusivos e reservados. O cliente compra cotas; o valor da cota varia conforme o patrimônio do fundo.
- Cobram taxa de administração e, em alguns casos, taxa de performance.
- Fundos abertos de renda fixa e multimercado têm o *come-cotas*, antecipação semestral de IR (maio e novembro).

*Outros*

- Previdência privada (PGBL e VGBL, detalhados no Módulo 7), moedas e ativos no exterior, produtos estruturados, COE.

Tributação, de forma resumida (verifique a regra vigente):

#table(
  columns: (auto, 1fr),
  table.header([Produto], [Regra geral]),
  [Renda fixa tradicional], [Tabela regressiva de 22,5% (até 180 dias) a 15% (acima de 720 dias), sobre o rendimento; IOF nos primeiros 30 dias],
  [Ações à vista], [15% sobre o ganho, com regras de isenção por volume mensal de vendas e day trade a 20%],
  [Fundos de renda fixa e multimercado], [Come-cotas semestral e alíquota final conforme o prazo],
)

#exemplo("CDB, LCI e imposto: qual rende mais em um ano?")[
  CDI de 13,25% a.a. e aplicação de 365 dias (alíquota regressiva de 17,5%, conforme a
  tabela acima): um CDB a 100% do CDI rende 13,25% bruto e
  $"13,25"% times (1 - "0,175") approx "10,93"%$ líquido. Uma LCI a 90% do CDI, isenta de IR, rende
  cerca de $"0,90" times "13,25"% = "11,93"%$ #strong[líquido]: a LCI "paga menos" na taxa
  anunciada, mas rende mais no bolso. O percentual do CDI que um CDB precisaria
  pagar para igualar a LCI é $"0,90"/(1 - "0,175") approx 109%$. #strong[A comparação deve
  ser sempre líquida] (e o FGC cobre ambos, dentro dos limites).
]

#exemplo("come-cotas: o imposto antecipado")[
  Um fundo de renda fixa de longo prazo rende 6,5% por semestre. O come-cotas cobra
  15% (alíquota mínima do longo prazo) sobre o rendimento de cada semestre,
  em maio e novembro, #emph[diminuindo o número de cotas]. Quem aplica em um CDB com
  o mesmo rendimento bruto paga IR só no final. O código compara os dois caminhos
  em três anos:
]

```python
capital_cc, rend_sem, aliq_cc, semestres = 100_000, 0.065, 0.15, 6
sem_cc = capital_cc * (1 + rend_sem) ** semestres
sem_cc_liquido = sem_cc - (sem_cc - capital_cc) * aliq_cc          # IR pago só no resgate (como num CDB)
com_cc = capital_cc * (1 + rend_sem * (1 - aliq_cc)) ** semestres  # IR descontado a cada semestre
print(f"IR só no final (CDB): R${sem_cc_liquido:,.2f} líquidos")
print(f"Com come-cotas (fundo): R${com_cc:,.2f} líquidos")
print(f"Diferença a favor do diferimento: R${sem_cc_liquido - com_cc:,.2f} ({(sem_cc_liquido / com_cc - 1):.2%})")
```

```
IR só no final (CDB): R$139,027.10 líquidos
Com come-cotas (fundo): R$138,080.44 líquidos
Diferença a favor do diferimento: R$946.65 (0.69%)
```

#intuicao[
  O come-cotas não aumenta a alíquota (no resgate, a alíquota final continua
  a mesma), mas #strong[antecipa o pagamento]: o imposto sai do investimento a cada
  semestre e deixa de render juros sobre juros. A vantagem do diferimento é
  pequena em três anos e cresce com o prazo e com a taxa.
]

== 1.5 Funcionamento de uma carteira de investimentos

Uma carteira é o conjunto de ativos de um cliente (ou de uma família),
organizado para atender objetivos com um nível de risco compatível com o
perfil.

Conceitos-chave:

- *Perfil de investidor (suitability)*: conservador, moderado ou arrojado, definido por questionário. É obrigatório verificar a adequação do produto ao perfil (ver seção 7.2).
- *Alocação estratégica*: a divisão de longo prazo entre classes (ex.: 60% renda fixa, 20% renda variável, 10% multimercado, 10% exterior).
- *Alocação tática*: desvios temporários da estratégica para aproveitar cenários.
- *Rebalanceamento*: voltar aos pesos-alvo quando o mercado os distorce.
- *Diversificação*: reduzir risco específico distribuindo o capital entre ativos pouco correlacionados.
- *Liquidez*: em quanto tempo e a que custo o ativo vira dinheiro.

#exemplo("rebalanceando uma carteira de 2 milhões")[
  O perfil moderado do cliente define pesos-alvo e uma banda de tolerância de 5 pontos percentuais. O código
  calcula o desvio e o #emph[valor em reais] a comprar ou vender em cada classe:
]

```python
carteira = pd.DataFrame({
    "classe": ["RF pós-fixada", "RF inflação", "Ações", "Multimercado", "Exterior"],
    "valor": [840_000, 260_000, 560_000, 120_000, 220_000],
    "alvo": [0.35, 0.25, 0.20, 0.10, 0.10],
})
total_c = carteira["valor"].sum()
carteira["peso"] = carteira["valor"] / total_c
carteira["desvio_pp"] = (carteira["peso"] - carteira["alvo"]) * 100
carteira["ajuste_R$"] = carteira["alvo"] * total_c - carteira["valor"]
carteira["fora_da_banda"] = carteira["desvio_pp"].abs() > 5
pd.options.display.float_format = "{:,.2f}".format
print(carteira.round({"peso": 3}).to_string(index=False))
print(f"\nPatrimônio total: R${total_c:,.0f} | soma dos ajustes: R${carteira['ajuste_R$'].sum():,.0f} (deve ser zero)")
```

```
       classe  valor  alvo  peso  desvio_pp   ajuste_R$  fora_da_banda
RF pós-fixada 840000  0.35  0.42       7.00 -140,000.00           True
  RF inflação 260000  0.25  0.13     -12.00  240,000.00           True
        Ações 560000  0.20  0.28       8.00 -160,000.00           True
 Multimercado 120000  0.10  0.06      -4.00   80,000.00          False
     Exterior 220000  0.10  0.11       1.00  -20,000.00          False

Patrimônio total: R$2,000,000 | soma dos ajustes: R$0 (deve ser zero)
```

#atencao[
  Rebalancear tem #strong[custo]: impostos sobre ganhos realizados, taxas e spread de
  negociação. Por isso se usam #strong[bandas] (só ajusta-se quando o desvio passa de um limite)
  ou se direcionam #emph[novos aportes] às classes abaixo do alvo, em vez de vender
  as acima. O ajuste é uma recomendação para o assessor discutir, não uma ordem automática.
]

=== Exercícios do Módulo 1

+ Explique a diferença entre uma corretora, uma gestora e uma assessoria de investimentos.
+ Um cliente conservador quer investir em um fundo de ações de pequenas empresas. O que o Back Office e o assessor devem verificar?
+ Monte uma alocação estratégica para um perfil moderado e justifique cada faixa.

#line()

= Módulo 2 --- Fundamentos de operações de investimentos

== 2.1 Posições, movimentações e saldos

- *Posição*: o que o cliente tem em determinada data (ativo, quantidade, preço, valor de mercado).
- *Movimentação*: qualquer evento que altera a posição: compra, venda, aplicação, resgate, transferência, amortização, pagamento de juros e dividendos, desdobramento, grupamento, bonificação.
- *Saldo*: o resultado das movimentações sobre a posição inicial.

A relação básica é:

$
"Posição final" = "Posição inicial" + "Entradas" - "Saídas" plus.minus "Proventos e ajustes"
$

O valor de mercado de um ativo é quantidade × preço. A fonte do preço
importa: preço de fechamento da B3, cota divulgada pelo administrador,
preço de mercado do título público (ANBIMA) ou curva do papel (marcação na
curva em alguns produtos de renda fixa).

#exemplo("uma posição ao longo de eventos corporativos")[
  Um cliente tem 1.000 ações compradas a R\$ 30,00 (custo total de R\$ 30.000). Ocorrem:
  desdobramento de 2 para 1 e, depois, bonificação de 10%. #strong[O custo total não muda]
  (nenhum dinheiro entrou ou saiu); mudam a quantidade e o preço médio.
]

```python
qtd_e, custo_total_e = 1000, 30_000
print(f"Inicial      : {qtd_e:>6} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
qtd_e *= 2                                  # desdobramento 2:1 -> quantidade dobra, preço médio cai à metade
print(f"Após split   : {qtd_e:>6} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
qtd_e = qtd_e * 1.10                        # bonificação de 10% -> ações gratuitas
print(f"Após bonific.: {qtd_e:>6.0f} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
print(f"Dividendo de R$0,50/ação sobre {qtd_e:.0f} ações: R${qtd_e * 0.50:,.2f} em caixa (a quantidade não muda)")
```

```
Inicial      :   1000 ações | preço médio R$30.00 | custo total R$30,000
Após split   :   2000 ações | preço médio R$15.00 | custo total R$30,000
Após bonific.:   2200 ações | preço médio R$13.64 | custo total R$30,000
Dividendo de R$0,50/ação sobre 2200 ações: R$1,100.00 em caixa (a quantidade não muda)
```

== 2.2 Custódia e consolidação de carteiras

Custódia é a guarda e o registro dos ativos em nome do investidor. Na
bolsa, o custodiante é o responsável perante a B3. Na renda fixa privada,
o registro é feito em câmaras como a B3 e a CERC (verifique o ambiente de
registro aplicável a cada produto).

Quando o cliente tem ativos em várias instituições, surge a necessidade de
*consolidação*: reunir posições de custodiantes diferentes em uma visão
única de patrimônio. Desafios comuns:

- nomes de ativos diferentes para o mesmo papel;
- datas de referência diferentes entre instituições;
- ativos fora do sistema (imóveis, participações, previdência);
- moedas distintas, exigindo conversão por uma taxa de câmbio padronizada.

Boas práticas: definir uma fonte oficial para cada tipo de informação, uma
data-base única e um identificador único de ativo (ticker, ISIN ou código
interno).

#exemplo("consolidando duas custódias com nomes diferentes")[
  O mesmo ativo aparece com nomes diferentes em cada instituição, e há uma posição em dólar. O
  back office precisa de uma #strong[chave única] e de uma #strong[taxa de câmbio padronizada]:
]

```python
custodia_a = pd.DataFrame({"ativo": ["PETR4", "ITUB4", "TESOURO SELIC 2029"], "valor": [120_000, 80_000, 200_000], "moeda": "BRL"})
custodia_b = pd.DataFrame({"ativo": ["PETROBRAS PN", "ETF S&P500 (US$)"], "valor": [60_000, 25_000], "moeda": ["BRL", "USD"]})
de_para = {"PETROBRAS PN": "PETR4", "ETF S&P500 (US$)": "IVVB11-EXT"}      # chave única de ativo
classes = {"PETR4": "Ações", "ITUB4": "Ações", "TESOURO SELIC 2029": "Renda fixa", "IVVB11-EXT": "Exterior"}
ptax = 5.20                                                                  # câmbio padronizado, mesma data-base

base_c = pd.concat([custodia_a.assign(origem="A"), custodia_b.assign(origem="B")])
base_c["ativo"] = base_c["ativo"].replace(de_para)
base_c["valor_brl"] = base_c["valor"] * base_c["moeda"].map({"BRL": 1, "USD": ptax})
base_c["classe"] = base_c["ativo"].map(classes)
print(base_c[["origem", "ativo", "classe", "valor_brl"]].to_string(index=False))
print("\nConsolidado por classe (R$):")
print(base_c.groupby("classe")["valor_brl"].sum().to_string())
print(f"Total: R${base_c['valor_brl'].sum():,.2f} | PETR4 aparece em {base_c['ativo'].eq('PETR4').sum()} custódias (somadas: R${base_c.loc[base_c['ativo']=='PETR4', 'valor_brl'].sum():,.0f})")
```

```
origem              ativo     classe  valor_brl
     A              PETR4      Ações 120,000.00
     A              ITUB4      Ações  80,000.00
     A TESOURO SELIC 2029 Renda fixa 200,000.00
     B              PETR4      Ações  60,000.00
     B         IVVB11-EXT   Exterior 130,000.00

Consolidado por classe (R$):
classe
Ações        260,000.00
Exterior     130,000.00
Renda fixa   200,000.00
Total: R$590,000.00 | PETR4 aparece em 2 custódias (somadas: R$180,000)
```

#atencao[
  Sem o de-para, "PETR4" e "PETROBRAS PN" seriam tratados como ativos diferentes: a
  posição apareceria dividida, a concentração por emissor, subestimada, e a conciliação
  geraria uma "divergência" falsa. #strong[A qualidade da chave decide a qualidade do relatório.]
]

== 2.3 Liquidação e conciliação

Liquidação é o momento em que a operação se completa financeiramente, com
a entrega do ativo contra o pagamento. Prazos de referência (confirme a
regra de cada mercado):

- ações à vista na B3: em geral D+2;
- Tesouro Direto: tipicamente D+1 útil;
- fundos: variam. Há prazo de cotização (quando o dinheiro vira cotas ou cotas viram dinheiro) e de liquidação financeira (quando o dinheiro entra na conta), definidos em regulamento.

Conciliação é a conferência entre duas fontes que deveriam concordar.
Exemplos:

- posição no sistema interno × posição no extrato do custodiante;
- movimentações do cliente × lançamentos na conta corrente;
- saldo contábil × saldo de gestão.

Passo a passo de uma conciliação:

+ Reunir as duas bases com a mesma data-base.
+ Padronizar chaves (código do ativo, conta do cliente).
+ Cruzar as bases e calcular as diferenças de quantidade e de valor.
+ Classificar as diferenças (timing, preço, falha de lançamento, evento corporativo não registrado).
+ Corrigir, documentar e registrar a causa para evitar reincidência.

#exemplo("liquidação em D+2 com feriado")[
  Compra de ações na sexta-feira, 30/10/2026. A liquidação é D+2 #emph[úteis]. Como
  segunda-feira, 02/11 (Finados), é feriado, a liquidação é na quarta-feira, 04/11.
  A data de liquidação define quando o caixa sai e quando a posição aparece no extrato do
  custodiante: conferir uma compra "recente" antes dela é a causa mais comum de
  divergência de timing.
]

```python
import numpy as np
compra = np.datetime64("2026-10-30")
liquidacao = np.busday_offset(compra, 2, roll="forward", holidays=["2026-11-02"])
print(f"Compra em {compra} -> liquidação D+2 útil em {liquidacao}")
print("Sem considerar o feriado:", np.busday_offset(compra, 2, roll="forward"))
```

```
Compra em 2026-10-30 -> liquidação D+2 útil em 2026-11-04
Sem considerar o feriado: 2026-11-03
```

#exemplo("cinco divergências típicas entre o sistema e o custodiante")[
  #figure(
    align(center)[#table(
      columns: (5%, 27%, 36%, 32%),
      align: (center, left, left, left),
      table.header([\#], [Sintoma], [Causa provável], [Tratamento],),
      [1], [Custodiante mostra 100 ações a menos], [Compra liquidando em D+2 (timing)], [Esperar a liquidação; registrar como "em trânsito"],
      [2], [Quantidade do custodiante é o dobro], [Desdobramento não lançado no sistema], [Ajustar a base e o histórico de preços],
      [3], [Custodiante tem 10% a mais], [Bonificação não lançada], [Lançar a bonificação e recalcular o preço médio],
      [4], [Valor difere centavos por cota], [Cota de fundo de datas diferentes], [Alinhar a data-base e a fonte do preço],
      [5], [Ativo existe no custodiante e não no sistema], [Aplicação feita direto pelo cliente], [Incluir, com origem documentada],
    )]
    , kind: table
    )

  O roteiro para qualquer divergência: #strong[(1)] mesma data-base; #strong[(2)] mesma chave; #strong[(3)]
  diferença de quantidade e depois de valor; #strong[(4)] classificar a causa; #strong[(5)] corrigir na
  origem; #strong[(6)] registrar. A seção 5.2 mostra esse roteiro em pandas.
]

== 2.4 Rentabilidade e acompanhamento patrimonial

- *Rentabilidade nominal*: variação percentual do valor investido.
- *Rentabilidade líquida*: após custos, taxas e impostos.
- *Rentabilidade real*: descontada a inflação.
- *Comparação com benchmark*: resultado em relação a CDI, IPCA + taxa, Ibovespa ou outro índice adequado.

O cálculo correto precisa tratar aportes e resgates:

- *Retorno ponderado pelo tempo (TWR)*: isola a decisão de investimento, eliminando o efeito do momento dos aportes. É o padrão para comparar gestores e carteiras.
- *Retorno ponderado pelo dinheiro (MWR / TIR)*: considera o momento e o tamanho dos fluxos, refletindo a experiência real do cliente.

Exemplo simples de rentabilidade acumulada a partir de retornos mensais:

$
(1 + r_1) times (1 + r_2) times dots.h times (1 + r_n) - 1
$

Para converter taxa anual em mensal equivalente:

$
(1 + i_"anual")^(frac(1, 12)) - 1
$

O acompanhamento patrimonial inclui evolução do patrimônio, composição por
classe, concentração por emissor, vencimentos próximos e fluxo de caixa
esperado (cupons, dividendos, vencimentos).

#exemplo("TWR × MWR: o gestor foi bem, o cliente não")[
  Um cliente aplica R\$ 100 mil. No mês 1 a carteira rende +10%; o saldo vai a R\$ 110 mil e
  o cliente, animado, aporta mais R\$ 100 mil (saldo de R\$ 210 mil). No mês 2, o mercado cai e a
  carteira rende −5%, terminando em R\$ 199,5 mil.

  - #strong[TWR] (ignora o momento dos aportes): $("1,10")("0,95") - 1 = +"4,50"%$ --- é o desempenho
    da #emph[carteira], a medida justa do gestor.
  - #strong[MWR / TIR] (considera os fluxos do cliente): a taxa mensal que iguala
    $100 (1 + r)^2 + 100 (1 + r) = "199,5"$ é $r approx -"0,17"%$ ao mês, ou cerca de
    #strong[−0,33%] em dois meses --- o #emph[cliente] terminou com perda, porque aportou
    mais #emph[antes] da queda.

  Os dois números estão corretos e respondem a perguntas diferentes: "o gestor
  investiu bem?" (TWR) e "como foi a minha experiência?" (MWR).
]

```python
fluxos_cli = [-100_000, -100_000, 199_500]          # t0: aporte, t1: aporte, t2: valor final
tir_mensal = np.roots([-fluxos_cli[0], -fluxos_cli[1], -fluxos_cli[2]])   # 100x² + 100x - 199,5 = 0 em x = 1 + r
x_ok = [x.real - 1 for x in tir_mensal if abs(x.imag) < 1e-12 and x.real > 0][0]
print(f"TWR (2 meses): {(1.10 * 0.95 - 1):+.2%}")
print(f"MWR (taxa mensal): {x_ok:+.3%} | em 2 meses: {(1 + x_ok) ** 2 - 1:+.3%}")
```

```
TWR (2 meses): +4.50%
MWR (taxa mensal): -0.167% | em 2 meses: -0.333%
```

== 2.5 Qualidade e integridade das informações

Decisões de investimento dependem de dados confiáveis. As dimensões de
qualidade a monitorar:

- *Completude*: todos os campos e todas as contas estão presentes.
- *Exatidão*: valores batem com a fonte.
- *Consistência*: o mesmo dado tem o mesmo valor em todos os sistemas.
- *Atualidade*: a data-base é a esperada.
- *Unicidade*: sem registros duplicados.
- *Rastreabilidade*: é possível voltar do relatório até a fonte.

Controles práticos: checagens automáticas (soma das partes = total),
alertas para variações atípicas, dupla conferência em eventos manuais e
trilha de auditoria de alterações.

#exemplo("verificações automáticas de qualidade de dados")[
  As seis dimensões de qualidade podem ser verificadas por regras simples. Veja uma base
  com problemas plantados e o relatório que o back office geraria:
]

```python
base_q = pd.DataFrame({
    "conta": ["001", "002", "002", "003", "004", "005"],
    "ativo": ["PETR4", "ITUB4", "ITUB4", "VALE3", None, "BBDC4"],
    "quantidade": [100, 200, 200, -50, 300, 150],
    "valor": [3000.0, 5000.0, 5000.0, 4500.0, 9000.0, np.nan],
    "data_base": pd.to_datetime(["2026-09-30"] * 5 + ["2026-09-29"]),
})
problemas = {
    "Completude (ativo nulo)": base_q["ativo"].isna().sum(),
    "Completude (valor nulo)": base_q["valor"].isna().sum(),
    "Unicidade (linhas duplicadas)": base_q.duplicated().sum(),
    "Exatidão (quantidade negativa)": (base_q["quantidade"] < 0).sum(),
    "Atualidade (data_base fora do esperado)": (base_q["data_base"] != "2026-09-30").sum(),
}
for nome_q, n_q in problemas.items():
    print(f"{'⚠' if n_q else '✓'} {nome_q}: {n_q}")
print(f"Registros analisados: {len(base_q)}")
```

```
⚠ Completude (ativo nulo): 1
⚠ Completude (valor nulo): 1
⚠ Unicidade (linhas duplicadas): 1
⚠ Exatidão (quantidade negativa): 1
⚠ Atualidade (data_base fora do esperado): 1
Registros analisados: 6
```

=== Exercícios do Módulo 2

+ O sistema mostra 1.000 ações da empresa X e o extrato do custodiante mostra 900. Liste três causas possíveis e como investigaria cada uma.
+ Calcule a rentabilidade acumulada de três meses com retornos de 1,0%, −0,5% e 1,5%.
+ Explique por que TWR e MWR podem divergir para o mesmo cliente.

#line()

= Módulo 3 --- Excel aplicado ao mercado financeiro

== 3.1 Organização de bases

Antes de qualquer fórmula, a base precisa estar bem estruturada:

- uma linha por registro e uma coluna por atributo (formato tabular);
- cabeçalho único na primeira linha, sem células mescladas;
- um tipo de dado por coluna (datas como data, valores como número);
- sem linhas de subtotal no meio dos dados;
- uso de Tabelas do Excel (Ctrl+T), que expandem sozinhas e permitem referências estruturadas como `Movimentos[Valor]`.

Exemplo de colunas de uma base de movimentações: Data, Cliente, Conta,
Ativo, Classe, Tipo (compra, venda, provento), Quantidade, Preço, Valor.

#exemplo("números que parecem números, mas são texto")[
  A origem mais comum de somas erradas é uma coluna de valores importada como #strong[texto]
  ("1.000,50" com ponto de milhar e vírgula decimal). No Excel, o sinal é uma
  célula alinhada à esquerda e a soma que ignora essas células. Em Python, a conversão precisa
  respeitar o formato brasileiro:
]

```python
valores_txt = pd.Series(["1.000,50", "2.300,00", " 450,25 ", "R$ 1.200,00", "abc"])
limpo = (valores_txt.str.replace("R$", "", regex=False).str.strip()
         .str.replace(".", "", regex=False).str.replace(",", ".", regex=False))
numerico = pd.to_numeric(limpo, errors="coerce")        # o que não converte vira NaN (e fica visível)
print(pd.DataFrame({"original": valores_txt, "convertido": numerico}).to_string())
print(f"Soma dos valores válidos: {numerico.sum():,.2f} | itens que não converteram: {numerico.isna().sum()}")
```

```
      original  convertido
0     1.000,50    1,000.50
1     2.300,00    2,300.00
2      450,25       450.25
3  R$ 1.200,00    1,200.00
4          abc         NaN
Soma dos valores válidos: 4,950.75 | itens que não converteram: 1
```

#atencao[
  #strong[Nunca "force" uma conversão que esconde o erro.] O `errors="coerce"` transforma o
  lixo em vazio de propósito, para que a contagem de nulos o denuncie. Sumir com a linha
  problemática em silêncio gera um total errado que ninguém percebe.
]

== 3.2 Fórmulas e funções essenciais

#table(
  columns: (auto, 1fr),
  table.header([Função], [Uso]),
  [SOMA, MÉDIA, MÁXIMO, MÍNIMO], [Agregações básicas],
  [SE, E, OU], [Lógica condicional],
  [SEERRO], [Tratar erros de forma controlada],
  [ARRUMAR, ESQUERDA, DIREITA, EXT.TEXTO, TEXTO], [Limpeza e padronização de texto],
  [DATA, DIA.DA.SEMANA, DIATRABALHO, FIMMÊS], [Datas e dias úteis],
  [ARRED], [Arredondamento consistente],
)

Dica de qualidade: evite números digitados dentro de fórmulas. Coloque
premissas (taxas, datas-base) em células identificadas.

#figure(
  align(center)[#table(
    columns: (30%, 30%, 40%),
    align: (left, left, left),
    table.header([Português (Excel BR)], [Inglês], [Equivalente em pandas],),
    [PROCX], [XLOOKUP], [`merge` ou `map`],
    [PROCV], [VLOOKUP], [`merge`],
    [SOMASES], [SUMIFS], [`groupby().sum()` com filtro],
    [CONT.SES], [COUNTIFS], [`groupby().size()` com filtro],
    [SEERRO], [IFERROR], [`fillna` / `try`],
    [ARRUMAR], [TRIM], [`str.strip()`],
    [DIATRABALHO], [WORKDAY], [`np.busday_offset`],
    [Tabela dinâmica], [PivotTable], [`pivot_table`],
  )]
  , kind: table
  )

Duas diferenças de ambiente costumam atrapalhar: o #strong[separador de argumentos]
(`;` no Excel em português, `,` em inglês) e o #strong[separador decimal]; ao receber uma
planilha de outra instituição, verifique a configuração regional antes de copiar fórmulas.
Em valores monetários, prefira `ARRED` a só formatar a célula: a formatação #emph[mostra] duas casas,
mas o valor armazenado segue com muitas, e totais "não fecham" por centavos.

== 3.3 PROCX, SOMASES, CONT.SES e funções condicionais

PROCX busca um valor e retorna outro, substituindo o PROCV com mais
flexibilidade:

` =PROCX(A2; Cadastro[Ativo]; Cadastro[Classe]; "Não encontrado") `

O quarto argumento trata a ausência do item, o que já evita muitos erros
\#N/D. Vale conhecer também o parâmetro de modo de correspondência e a
busca do último para o primeiro.

SOMASES soma valores que atendem a vários critérios:

` =SOMASES(Movimentos[Valor]; Movimentos[Cliente]; A2; Movimentos[Tipo]; "Compra") `

CONT.SES conta registros por critérios:

` =CONT.SES(Movimentos[Conta]; A2; Movimentos[Data]; ">="&DATA(2026;1;1)) `

Outras funções condicionais úteis: SOMASE, CONT.SE, MÉDIASES, MÁXIMOSES e
MÍNIMOSES.

Conciliação em Excel (padrão de uso):

` =SEERRO(PROCX(C2; Custodia[Chave]; Custodia[Quantidade]); 0) - D2 `

Essa fórmula traz a quantidade do custodiante e subtrai a quantidade do
sistema interno. Filtre as linhas com diferença diferente de zero para
tratar as exceções.

#exemplo("as fórmulas de busca e soma, espelhadas em pandas")[
  O código reproduz, com uma base pequena, o que `SOMASES`, `CONT.SES` e `PROCX` fazem --- útil
  para #strong[conferir] uma fórmula do Excel por um segundo caminho:
]

```python
mov = pd.DataFrame({
    "cliente": ["Ana", "Ana", "Bruno", "Bruno", "Bruno", "Carla"],
    "ativo": ["PETR4", "ITUB4", "PETR4", "VALE3", "PETR4", "ITUB4"],
    "tipo": ["Compra", "Compra", "Compra", "Venda", "Compra", "Compra"],
    "valor": [10_000, 4_000, 6_000, 3_000, 2_500, 7_000],
})
cadastro = pd.DataFrame({"ativo": ["PETR4", "ITUB4", "VALE3"], "classe": ["Ações", "Ações", "Ações"], "emissor": ["Petrobras", "Itaú", "Vale"]})

# =SOMASES(valor; cliente; "Bruno"; tipo; "Compra")
soma_bruno = mov.loc[(mov["cliente"] == "Bruno") & (mov["tipo"] == "Compra"), "valor"].sum()
# =CONT.SES(cliente; "Ana")
cont_ana = (mov["cliente"] == "Ana").sum()
# =PROCX(ativo; cadastro[ativo]; cadastro[emissor])
mov_emissor = mov.merge(cadastro[["ativo", "emissor"]], on="ativo", how="left")
print(f"SOMASES (Bruno, Compra): R${soma_bruno:,.0f} | CONT.SES (Ana): {cont_ana}")
print(mov_emissor.groupby(["cliente", "emissor"])["valor"].sum().unstack(fill_value=0).to_string())
```

```
SOMASES (Bruno, Compra): R$8,500 | CONT.SES (Ana): 2
emissor  Itaú  Petrobras  Vale
cliente
Ana      4000      10000     0
Bruno       0       8500  3000
Carla    7000          0     0
```

== 3.4 Tabelas dinâmicas

Tabelas dinâmicas resumem grandes bases sem fórmulas. Estrutura:

- *Linhas*: como você quer agrupar (cliente, classe de ativo).
- *Colunas*: como quer abrir (mês, instituição).
- *Valores*: o que quer medir (soma de valor, contagem, média).
- *Filtros e segmentações*: recortes interativos.

Boas práticas: partir de uma Tabela do Excel, atualizar com Dados >
Atualizar tudo, formatar valores como moeda e usar Mostrar valores como >
% do total para ver a composição da carteira.

#exemplo("lendo uma tabela dinâmica: patrimônio por classe e cliente")[
  A tabela dinâmica equivale ao `pivot_table`. Linhas = cliente, colunas = classe, valores = soma,
  com a opção #emph[mostrar valores como % do total da linha] para ver a composição de cada carteira:
]

```python
pos = pd.DataFrame({
    "cliente": ["Ana", "Ana", "Ana", "Bruno", "Bruno", "Carla", "Carla"],
    "classe": ["Renda fixa", "Ações", "Exterior", "Renda fixa", "Ações", "Renda fixa", "Exterior"],
    "valor": [500_000, 300_000, 200_000, 900_000, 100_000, 400_000, 100_000],
})
dinamica = pos.pivot_table(index="cliente", columns="classe", values="valor", aggfunc="sum", fill_value=0)
dinamica["Total"] = dinamica.sum(axis=1)
print(dinamica.to_string())
print("\n% do total da linha (composição de cada carteira):")
print((dinamica.drop(columns="Total").div(dinamica["Total"], axis=0) * 100).round(1).to_string())
```

```
classe    Ações  Exterior  Renda fixa    Total
cliente
Ana      300000    200000      500000  1000000
Bruno    100000         0      900000  1000000
Carla         0    100000      400000   500000

% do total da linha (composição de cada carteira):
classe   Ações  Exterior  Renda fixa
cliente
Ana      30.00     20.00       50.00
Bruno    10.00      0.00       90.00
Carla     0.00     20.00       80.00
```

== 3.5 Power Query

O Power Query automatiza a importação e a limpeza dos dados e guarda cada
passo, de modo que basta atualizar para repetir o tratamento.

Operações mais usadas:

- importar de pastas, planilhas, CSV e bancos de dados;
- remover colunas e linhas indesejadas, promover cabeçalhos;
- alterar tipos de dados;
- dividir e mesclar colunas;
- acrescentar consultas (empilhar arquivos de vários meses);
- mesclar consultas (equivale a um join, para cruzar bases);
- desdinamizar colunas (transformar colunas de meses em linhas).

Um fluxo típico de Back Office: arquivos mensais de extratos em uma pasta,
tratados e empilhados por uma única consulta, alimentando a base de
conciliação.

#exemplo("o fluxo de um Power Query mensal, passo a passo")[
  Cada passo fica registrado em #emph[Etapas Aplicadas]; para repetir no mês seguinte, basta atualizar:

  #figure(
    align(center)[#table(
      columns: (6%, 30%, 64%),
      align: (center, left, left),
      table.header([\#], [Etapa], [Por que existe],),
      [1], [Fonte: pasta com os extratos mensais], [Novos arquivos entram sozinhos na próxima atualização],
      [2], [Combinar arquivos (acrescentar consultas)], [Empilha os meses numa só tabela],
      [3], [Promover cabeçalhos e remover linhas de rodapé/total], [Evita somar totais já calculados],
      [4], [Alterar tipos (data, número decimal, texto)], [Conversão explícita, como no exemplo de números em texto],
      [5], [Remover duplicados e espaços (Cortar/Limpar)], [Garante unicidade e chaves consistentes],
      [6], [Mesclar com o cadastro de ativos], [Traz classe e emissor (o `PROCX` do Power Query)],
      [7], [Carregar para a base de conciliação], [A tabela dinâmica e o relatório usam essa base],
    )]
    , kind: table
    )

  Boa prática: manter uma consulta de #strong[staging] (dados brutos, sem alterações) e outra de #strong[tratamento]; se a
  fonte mudar de layout, só a primeira etapa quebra --- e o erro é visível.
]

== 3.6 Relatórios e dashboards

Princípios de um bom relatório:

- responda a uma pergunta clara (ex.: "como está a composição do patrimônio de cada cliente?");
- destaque poucos indicadores principais no topo;
- use gráficos adequados: barras para comparar categorias, linhas para evolução no tempo, rosca ou pizza só para poucas fatias;
- padronize formatos, cores e unidades;
- documente a fonte e a data-base.

Para dashboards: conecte gráficos a tabelas dinâmicas, adicione segmentações
e proteja as abas de cálculo.

#figure(
  align(center)[#table(
    columns: (38%, 30%, 32%),
    align: (left, left, left),
    table.header([Pergunta do leitor], [Gráfico adequado], [Evite],),
    [Como se compõe o patrimônio hoje?], [Barras empilhadas 100% ou rosca (até 5 fatias)], [Pizza com 10 fatias],
    [Como evoluiu o patrimônio?], [Linha no tempo], [Barras sem escala comum],
    [Carteira × benchmark?], [Linhas sobrepostas, base 100], [Eixos diferentes sem aviso],
    [Quais ativos mais contribuíram?], [Barras horizontais ordenadas], [Ordem alfabética],
    [Atual × alvo?], [Barras lado a lado com a banda], [Tabela sem destaque dos desvios],
  )]
  , kind: table
  )

#mercado[
  Um relatório de acompanhamento não é um "extrato bonito": ele responde a #emph[uma pergunta do cliente] (como
  estou, contra o quê, o que mudou, o que fazer) com poucos números destacados. Cada gráfico deve ter
  data-base, fonte e unidade --- sem elas, o gráfico não é auditável.
]

=== Exercícios do Módulo 3

+ Com uma base de movimentações, calcule o total comprado por cliente em um período usando SOMASES.
+ Cruze duas bases (sistema × custodiante) com PROCX e liste as divergências.
+ Empilhe três arquivos mensais com Power Query e gere uma tabela dinâmica de patrimônio por classe.

#line()

= Módulo 4 --- Análise de dados e indicadores financeiros

== 4.1 Tratamento e estruturação de dados

O ciclo de tratamento de dados segue uma sequência estável:

+ Coletar das fontes oficiais.
+ Inspecionar: tipos, nulos, duplicados, valores fora do esperado.
+ Limpar e padronizar: nomes, datas, moedas, chaves.
+ Estruturar em formato tabular e, quando possível, separar cadastros (clientes, ativos) de fatos (movimentações, preços).
+ Validar com totais de controle e contra a fonte.
+ Documentar as regras aplicadas.

Separe sempre dados brutos de dados tratados: o bruto nunca deve ser
sobrescrito.

#exemplo("ciclo de tratamento de uma base de preços")[
  Inspecionar, limpar e validar, nessa ordem, mantendo o dado bruto intacto:
]

```python
bruto = pd.DataFrame({
    "data": ["2026-09-28", "2026-09-29", "2026-09-29", "2026-09-30", "2026-09-30"],
    "ativo": [" petr4", "PETR4 ", "PETR4", "petr4", "PETR4"],
    "preco": ["38,10", "38,40", "38,40", "38,95", None],
})
tratado = bruto.copy()                                             # o bruto nunca é sobrescrito
tratado["ativo"] = tratado["ativo"].str.strip().str.upper()
tratado["data"] = pd.to_datetime(tratado["data"])
tratado["preco"] = pd.to_numeric(tratado["preco"].str.replace(",", "."), errors="coerce")
antes = len(tratado)
tratado = tratado.drop_duplicates(subset=["data", "ativo"], keep="last")
print(f"Registros: {antes} -> {len(tratado)} após remover duplicados | nulos restantes: {tratado['preco'].isna().sum()}")
print(tratado.to_string(index=False))
```

```
Registros: 5 -> 3 após remover duplicados | nulos restantes: 1
      data ativo  preco
2026-09-28 PETR4  38.10
2026-09-29 PETR4  38.40
2026-09-30 PETR4    NaN
```

== 4.2 Análise de rentabilidade

Perguntas que a análise deve responder:

- Quanto a carteira rendeu no período e contra qual benchmark?
- Quais ativos ou classes mais contribuíram para o resultado (atribuição de performance)?
- Qual foi o efeito dos custos e dos impostos?
- O resultado foi compatível com o risco assumido?

A contribuição de um ativo é, em primeira aproximação, o seu peso inicial
multiplicado pelo seu retorno. A soma das contribuições aproxima o retorno
total da carteira.

Para comparar com o CDI, use o *percentual do CDI*: rentabilidade do
período dividida pelo CDI do mesmo período.

#exemplo("rentabilidade, % do CDI e atribuição de performance")[
  Retornos mensais de 12 meses de uma carteira, do CDI (1,05% ao mês, simplificação) e do benchmark. A
  rentabilidade acumulada #strong[multiplica] os fatores; o percentual do CDI divide o retorno acumulado
  da carteira pelo do CDI no #emph[mesmo] período (nunca a média dos percentuais mensais).
]

```python
ret_cart = np.array([.0190, .0120, -.0150, .0210, .0170, -.0050, .0200, .0140, .0200, -.0070, .0160, .0180])
ret_cdi = np.full(12, 0.0105)
ret_bm = np.array([.0185, .0115, -.0100, .0190, .0160, -.0030, .0185, .0135, .0185, -.0050, .0150, .0170])

acum_cart = np.prod(1 + ret_cart) - 1
acum_cdi = np.prod(1 + ret_cdi) - 1
acum_bm = np.prod(1 + ret_bm) - 1
print(f"Carteira {acum_cart:.2%} | CDI {acum_cdi:.2%} | benchmark {acum_bm:.2%}")
print(f"% do CDI: {acum_cart / acum_cdi:.1%} | excesso sobre o benchmark: {(acum_cart - acum_bm) * 100:+.2f} p.p.")

# atribuição de performance de um mês: contribuição = peso inicial x retorno da classe
atrib = pd.DataFrame({
    "classe": ["RF pós-fixada", "RF inflação", "Ações", "Exterior"],
    "peso": [0.45, 0.15, 0.25, 0.15],
    "retorno_mes": [0.0105, 0.0075, 0.0190, 0.0140],
})
atrib["contribuicao_pp"] = atrib["peso"] * atrib["retorno_mes"] * 100
print("\nAtribuição de performance no mês:")
print(atrib.assign(retorno_mes=lambda d: (d["retorno_mes"] * 100).round(2)).round(3).to_string(index=False))
print(f"Retorno da carteira no mês (soma das contribuições): {atrib['contribuicao_pp'].sum():.3f}%")
```

```
Carteira 13.71% | CDI 13.35% | benchmark 13.68%
% do CDI: 102.7% | excesso sobre o benchmark: +0.03 p.p.

Atribuição de performance no mês:
       classe  peso  retorno_mes  contribuicao_pp
RF pós-fixada  0.45         1.05             0.47
  RF inflação  0.15         0.75             0.11
        Ações  0.25         1.90             0.47
     Exterior  0.15         1.40             0.21
Retorno da carteira no mês (soma das contribuições): 1.270%
```

#atencao[
  A atribuição por "peso inicial × retorno" é uma #strong[aproximação] (ignora a interação entre mudança de
  pesos e retorno, e os fluxos no meio do período). Para relatórios formais, usam-se métodos como o
  de Brinson, que separam o efeito da #emph[alocação] (estar mais em uma classe) do da #emph[seleção]
  (escolher melhores ativos dentro da classe).
]

== 4.3 Alocação de ativos

A análise de alocação compara a carteira atual com a alvo:

#table(
  columns: (1fr, auto, auto, auto),
  table.header([Classe], [Peso atual], [Peso alvo], [Desvio]),
  [Renda fixa pós-fixada], [45%], [40%], [+5 p.p.],
  [Renda fixa inflação], [15%], [20%], [−5 p.p.],
  [Ações], [25%], [25%], [0],
  [Exterior], [15%], [15%], [0],
)

Indicadores úteis: concentração por emissor, por instituição, por
vencimento e por moeda. Desvios acima de uma banda de tolerância (por
exemplo, 5 p.p.) sinalizam necessidade de rebalanceamento.

#exemplo("concentração: o caso do CRI de 42%")[
  Além do peso do maior ativo, mede-se a concentração do conjunto pelo índice de #strong[Herfindahl
  (HHI)]: a soma dos pesos ao quadrado. Com $N$ ativos iguais, $"HHI" = 1/N$; quanto mais próximo de 1,
  mais concentrada a carteira. Para um cliente com 42% em um único CRI:
]

```python
pesos_cli = pd.Series({"CRI emissor X": 0.42, "Tesouro Selic": 0.18, "Fundo multimercado": 0.15, "Ações": 0.15, "Exterior": 0.10})
hhi = (pesos_cli ** 2).sum()
print(f"HHI = {hhi:.3f} (equivale a ~{1 / hhi:.1f} ativos de mesmo peso) | maior posição: {pesos_cli.max():.0%} | top 2: {pesos_cli.nlargest(2).sum():.0%}")
limite_pos = 0.20                                   # política hipotética: máx. 20% por emissor privado
excesso = (pesos_cli["CRI emissor X"] - limite_pos) * 1_500_000
print(f"Excesso sobre o limite de {limite_pos:.0%}: R${excesso:,.0f} em uma carteira de R$ 1,5 milhão")
```

```
HHI = 0.264 (equivale a ~3.8 ativos de mesmo peso) | maior posição: 42% | top 2: 60%
Excesso sobre o limite de 20%: R$330,000 em uma carteira de R$ 1,5 milhão
```

#intuicao[
  O HHI "traduz" a carteira em um número de ativos equivalentes: aqui, cerca de 3,8 ativos de peso igual,
  embora haja cinco. Isso ajuda a conversar com o cliente: ele pode ter muitos ativos e, ainda assim,
  pouca diversificação. #strong[O risco de crédito e de liquidez de um único CRI não aparece na
  volatilidade] --- por isso a concentração por emissor é um indicador à parte.
]

== 4.4 Indicadores de risco e desempenho

- *Volatilidade*: desvio-padrão dos retornos. Mede a oscilação; costuma ser anualizada.
- *Drawdown máximo*: maior queda do pico ao vale no período.
- *Índice de Sharpe*: retorno excedente ao ativo livre de risco dividido pela volatilidade. Mede retorno por unidade de risco.
- *Beta*: sensibilidade do ativo ou da carteira ao mercado de referência.
- *Tracking error*: volatilidade da diferença de retorno em relação ao benchmark.
- *VaR (Value at Risk)*: perda máxima estimada, em um horizonte e com um nível de confiança, em condições normais.
- *Risco de crédito, de liquidez e de concentração*: nem sempre aparecem na volatilidade e precisam de análise própria.

Cuidado de interpretação: indicadores calculados sobre janelas curtas ou
sobre ativos pouco líquidos podem enganar. Sempre informe o período
utilizado.

#teoria("volatilidade, Sharpe, drawdown, tracking error e VaR: o que cada um diz")[
  - #strong[Volatilidade anualizada:] desvio padrão dos retornos mensais multiplicado por $sqrt(12)$ (se os retornos
    são independentes, a variância soma).
  - #strong[Sharpe:] $(R_p - R_f)/sigma_p$ --- retorno excedente ao CDI por unidade de volatilidade. Para
    carteiras de renda fixa com volatilidade muito baixa, o denominador pequeno torna o Sharpe instável.
  - #strong[Drawdown máximo:] maior queda do pico ao vale; mede a "dor" da pior fase.
  - #strong[Tracking error:] desvio padrão da #emph[diferença] entre a carteira e o benchmark; mede o quanto a
    carteira se afasta dele. Quem quer replicar o índice busca TE baixo.
  - #strong[VaR paramétrico:] $"VaR" = z dot sigma_h dot "Patrimônio"$, com $z = "1,645"$ (95%) e
    $sigma_h$ a volatilidade no horizonte.
]

```python
vol_a = ret_cart.std(ddof=1) * np.sqrt(12)
sharpe_a = (acum_cart - acum_cdi) / vol_a
valores = np.cumprod(1 + ret_cart)
mdd_a = (valores / np.maximum.accumulate(valores) - 1).min()
te_a = (ret_cart - ret_bm).std(ddof=1) * np.sqrt(12)
patrimonio_v = 2_000_000
var_mes = 1.645 * (vol_a / np.sqrt(12)) * patrimonio_v
print(f"Volatilidade anualizada {vol_a:.2%} | Sharpe {sharpe_a:.2f} | drawdown máximo {mdd_a:.2%} | tracking error {te_a:.2%}")
print(f"VaR 95% de 1 mês sobre R${patrimonio_v:,.0f}: R${var_mes:,.0f} ({var_mes / patrimonio_v:.2%} do patrimônio)")
```

```
Volatilidade anualizada 4.31% | Sharpe 0.08 | drawdown máximo -1.50% | tracking error 0.70%
VaR 95% de 1 mês sobre R$2,000,000: R$40,920 (2.05% do patrimônio)
```

== 4.5 Interpretação de informações financeiras

Analisar não é apenas calcular, é explicar. Estrutura sugerida para um
comentário de carteira:

+ *Resultado*: o que aconteceu (ex.: carteira rendeu 1,1% no mês, equivalente a 98% do CDI).
+ *Causa*: o que explicou o resultado (ex.: queda das taxas de juros longas ajudou os títulos IPCA+, enquanto ações foram o principal detrator).
+ *Risco*: o que mudou na exposição.
+ *Ação sugerida*: o que o assessor pode discutir com o cliente.

Leia também demonstrações e relatórios gerenciais de fundos (lâmina,
regulamento, relatório do gestor), entendendo política de investimento,
taxas, prazos de resgate e principais posições.

#exemplo("um comentário de carteira montado a partir dos números")[
  O código monta o texto da estrutura sugerida (resultado, causa, risco, ação) a partir de números
  calculados --- em um fluxo real, isso evita erros de digitação e economiza tempo mensal:
]

```python
maior_contrib = atrib.loc[atrib["contribuicao_pp"].idxmax()]
menor_contrib = atrib.loc[atrib["contribuicao_pp"].idxmin()]
comentario = (
    f"Resultado: a carteira rendeu {atrib['contribuicao_pp'].sum():.2f}% no mês, "
    f"{atrib['contribuicao_pp'].sum() / (ret_cdi[0] * 100):.0%} do CDI ({ret_cdi[0]:.2%}).\n"
    f"Causa: a maior contribuição veio de {maior_contrib['classe']} ({maior_contrib['contribuicao_pp']:.2f} p.p.); "
    f"a menor, de {menor_contrib['classe']} ({menor_contrib['contribuicao_pp']:.2f} p.p.).\n"
    f"Risco: volatilidade anualizada de {vol_a:.1%} e drawdown máximo de {mdd_a:.1%} em 12 meses; "
    f"concentração mais relevante em um único emissor ({pesos_cli.max():.0%} da carteira de exemplo).\n"
    f"Ação sugerida: discutir com o cliente a diversificação do emissor concentrado e o rebalanceamento das classes fora da banda."
)
print(comentario)
```

```
Resultado: a carteira rendeu 1.27% no mês, 121% do CDI (1.05%).
Causa: a maior contribuição veio de Ações (0.47 p.p.); a menor, de RF inflação (0.11 p.p.).
Risco: volatilidade anualizada de 4.3% e drawdown máximo de -1.5% em 12 meses; concentração mais relevante em um único emissor (42% da carteira de exemplo).
Ação sugerida: discutir com o cliente a diversificação do emissor concentrado e o rebalanceamento das classes fora da banda.
```

#atencao[
  Um comentário gerado automaticamente é um #strong[rascunho]: a parte de "causa" exige interpretação
  (cenário de juros, notícias do setor) que o código não produz. Revise sempre antes de enviar ao cliente.
]

=== Exercícios do Módulo 4

+ Uma carteira rendeu 0,95% no mês e o CDI foi 1,00%. Quanto foi em percentual do CDI?
+ Calcule o desvio entre alocação atual e alvo para uma carteira de sua escolha e proponha um rebalanceamento.
+ Escreva um comentário de carteira de cinco linhas seguindo a estrutura da seção 4.5.

#line()

= Módulo 5 --- Automação, Python, SQL e IA

== 5.1 Automação de rotinas

Candidatas à automação são tarefas repetitivas, regradas e frequentes:
baixar extratos, padronizar arquivos, conciliar, gerar relatórios mensais.

Escada de automação, do mais simples ao mais robusto:

+ Atalhos, fórmulas e tabelas dinâmicas.
+ Power Query com atualização em um clique.
+ Macros VBA ou Office Scripts para ações no Excel.
+ Scripts em Python agendados.
+ Pipelines com banco de dados e orquestração.

Antes de automatizar, mapeie o processo manual e defina o resultado
esperado e os controles. Automatizar um processo mal definido apenas
acelera o erro.

== 5.2 Manipulação de dados com Python

A biblioteca pandas é a ferramenta central. Exemplo de conciliação entre
duas bases:

```python
import pandas as pd

sistema = pd.read_excel("sistema.xlsx")
custodia = pd.read_excel("custodia.xlsx")

# padronizar chave
for df in (sistema, custodia):
    df["ativo"] = df["ativo"].str.strip().str.upper()

# cruzar as bases
conc = sistema.merge(
    custodia,
    on=["conta", "ativo"],
    how="outer",
    suffixes=("_sis", "_cust"),
    indicator=True,
)

conc["dif_qtd"] = conc["qtd_sis"].fillna(0) - conc["qtd_cust"].fillna(0)
divergencias = conc[conc["dif_qtd"] != 0]
divergencias.to_excel("divergencias.xlsx", index=False)
```

Operações essenciais de pandas: `read_csv` e `read_excel`, filtros
booleanos, `groupby`, `merge`, `pivot_table`, `to_datetime`, tratamento de
nulos (`fillna`, `dropna`) e `drop_duplicates`.

Exemplo de rentabilidade acumulada:

```python
retornos = pd.Series([0.010, -0.005, 0.015])
acumulado = (1 + retornos).prod() - 1
print(f"{acumulado:.2%}")
```

```
2.00%
```

#exemplo("a conciliação completa, com classificação automática da causa")[
  O código reproduz as cinco divergências típicas da seção 2.3 (quantidade a mais, a menos, ativo ausente), mas agora
  em pandas, com uma #strong[primeira triagem automática] da causa provável a partir da razão entre as quantidades. A triagem
  é uma #emph[hipótese]: o analista confirma consultando o custodiante.
]

```python
sis = pd.DataFrame({"conta": ["001", "001", "002", "002", "003", "003"],
                    "ativo": ["PETR4", "ITUB4", "VALE3", "BBDC4", "WEGE3", "MGLU3"],
                    "qtd": [1000, 500, 300, 800, 200, 1000]})
cus = pd.DataFrame({"conta": ["001", "001", "002", "002", "003", "003", "003"],
                    "ativo": ["PETR4", "ITUB4", "VALE3", "BBDC4", "WEGE3", "MGLU3", "PRIO3"],
                    "qtd": [1000, 550, 300, 400, 200, 1040, 50]})
conc = sis.merge(cus, on=["conta", "ativo"], how="outer", suffixes=("_sis", "_cust"), indicator=True)
conc["dif_qtd"] = conc["qtd_cust"].fillna(0) - conc["qtd_sis"].fillna(0)

def triagem(linha):
    if linha["_merge"] == "right_only":
        return "Só no custodiante: aplicação direta/não lançado"
    if linha["_merge"] == "left_only":
        return "Só no sistema: baixa não refletida?"
    razao = linha["qtd_cust"] / linha["qtd_sis"]
    if abs(razao - 1.10) < 1e-9:
        return "Razão 1,10: bonificação 10% não lançada"
    if abs(razao - 0.5) < 1e-9:
        return "Razão 0,5: grupamento 2:1 não lançado"
    if abs(razao - 2.0) < 1e-9:
        return "Razão 2,0: desdobramento não lançado"
    return "Diferença pequena: possível D+2 (timing)"

diverg = conc[conc["dif_qtd"] != 0].copy()
diverg["causa_provavel"] = diverg.apply(triagem, axis=1)
print(f"Linhas conciliadas: {len(conc)} | com divergência: {len(diverg)}")
print(diverg[["conta", "ativo", "qtd_sis", "qtd_cust", "dif_qtd", "causa_provavel"]]
      .rename(columns={"qtd_sis": "sis", "qtd_cust": "custódia", "dif_qtd": "dif", "causa_provavel": "causa provável"}).to_string(index=False))
```

```
Linhas conciliadas: 7 | com divergência: 4
conta ativo      sis  custódia     dif                                  causa provável
  001 ITUB4   500.00       550   50.00         Razão 1,10: bonificação 10% não lançada
  002 BBDC4   800.00       400 -400.00           Razão 0,5: grupamento 2:1 não lançado
  003 MGLU3 1,000.00      1040   40.00        Diferença pequena: possível D+2 (timing)
  003 PRIO3      NaN        50   50.00 Só no custodiante: aplicação direta/não lançado
```

== 5.3 Consultas SQL

SQL permite consultar bases grandes e centralizadas. Comandos
fundamentais:

```sql
-- patrimônio por cliente na data-base
SELECT c.nome,
       SUM(p.quantidade * p.preco) AS patrimonio
FROM posicoes p
JOIN clientes c ON c.id = p.cliente_id
WHERE p.data_base = '2026-09-30'
GROUP BY c.nome
ORDER BY patrimonio DESC;
```

```sql
-- clientes com concentração acima de 30% em um único ativo
SELECT cliente_id, ativo, peso
FROM (
    SELECT cliente_id,
           ativo,
           valor / SUM(valor) OVER (PARTITION BY cliente_id) AS peso
    FROM posicoes
    WHERE data_base = '2026-09-30'
) t
WHERE peso > 0.30;
```

Conceitos a dominar: SELECT, WHERE, GROUP BY, HAVING, ORDER BY, JOIN
(inner, left), CASE WHEN, subconsultas, funções de janela (OVER,
PARTITION BY) e datas.

#exemplo("rodando as consultas da seção em um banco de verdade (SQLite em memória)")[
  O módulo `sqlite3` do Python permite treinar SQL sem instalar nada. As duas consultas da seção, com
  dados pequenos para conferir a lógica à mão:
]

```python
import sqlite3
con = sqlite3.connect(":memory:")
con.executescript("""
CREATE TABLE clientes (id INTEGER PRIMARY KEY, nome TEXT);
CREATE TABLE posicoes (cliente_id INTEGER, ativo TEXT, quantidade REAL, preco REAL, data_base TEXT, valor REAL);
INSERT INTO clientes VALUES (1, 'Ana'), (2, 'Bruno'), (3, 'Carla');
INSERT INTO posicoes VALUES
 (1, 'PETR4', 1000, 38.0, '2026-09-30', 38000), (1, 'TESOURO', 1, 62000, '2026-09-30', 62000),
 (2, 'CRI X', 1, 420000, '2026-09-30', 420000), (2, 'TESOURO', 1, 300000, '2026-09-30', 300000),
 (2, 'ITUB4', 2000, 140, '2026-09-30', 280000),
 (3, 'VALE3', 500, 60, '2026-09-30', 30000), (3, 'TESOURO', 1, 70000, '2026-09-30', 70000);
""")
q1 = """SELECT c.nome, SUM(p.quantidade * p.preco) AS patrimonio
        FROM posicoes p JOIN clientes c ON c.id = p.cliente_id
        WHERE p.data_base = '2026-09-30' GROUP BY c.nome ORDER BY patrimonio DESC"""
q2 = """SELECT cliente_id, ativo, ROUND(peso, 3) AS peso FROM (
          SELECT cliente_id, ativo, valor / SUM(valor) OVER (PARTITION BY cliente_id) AS peso
          FROM posicoes WHERE data_base = '2026-09-30') t WHERE peso > 0.30"""
print("Patrimônio por cliente:")
print(pd.read_sql_query(q1, con).to_string(index=False))
print("\nPosições com mais de 30% do patrimônio do cliente:")
print(pd.read_sql_query(q2, con).to_string(index=False))
```

```
Patrimônio por cliente:
 nome   patrimonio
Bruno 1,000,000.00
Carla   100,000.00
  Ana   100,000.00

Posições com mais de 30% do patrimônio do cliente:
 cliente_id   ativo  peso
          1   PETR4  0.38
          1 TESOURO  0.62
          2   CRI X  0.42
          3 TESOURO  0.70
```

#intuicao[
  A função de janela `SUM(valor) OVER (PARTITION BY cliente_id)` calcula o total #emph[de cada cliente] #strong[sem
  colapsar as linhas], o que permite dividir cada posição pelo total do seu cliente numa única consulta. Compare com
  `GROUP BY`, que devolve uma linha por grupo.
]

== 5.4 Aplicação de IA em processos financeiros

Usos adequados de IA no Back Office e na assessoria:

- Extração de informações de documentos (extratos, lâminas, contratos) para planilhas;
- Resumo de relatórios de gestores e de comunicados;
- Apoio à escrita de e-mails e comentários de carteira;
- Geração de código (fórmulas, scripts, consultas) com revisão humana;
- Classificação de ocorrências e detecção de padrões anormais.

Cuidados essenciais:

- IA pode errar com segurança aparente. Todo resultado que alimenta uma decisão ou um cliente precisa de conferência.
- Não inclua dados pessoais ou sigilosos em ferramentas não autorizadas pela instituição.
- Peça saídas estruturadas (tabela, JSON) para facilitar a validação.
- Registre qual ferramenta e qual versão geraram o resultado, quando relevante.

#exemplo("validando a saída de uma IA que extrai dados de um documento")[
  Ao pedir à IA que extraia campos de uma lâmina de fundo em formato estruturado (JSON), o back office não
  confia: #strong[valida] cada campo antes de usá-lo. Abaixo, uma resposta correta e uma com erro
  de unidade (taxa de 80 em vez de 0,8):
]

```python
import json
def validar_extracao(texto_json):
    erros = []
    try:
        d = json.loads(texto_json)
    except json.JSONDecodeError as e:
        return [f"JSON inválido: {e.msg}"]
    for campo in ("fundo", "taxa_adm_aa", "prazo_resgate_dias", "perfil"):
        if campo not in d:
            erros.append(f"campo ausente: {campo}")
    if "taxa_adm_aa" in d and not (0 <= d["taxa_adm_aa"] <= 5):
        erros.append(f"taxa de administração implausível: {d['taxa_adm_aa']}% a.a.")
    if "prazo_resgate_dias" in d and not isinstance(d["prazo_resgate_dias"], int):
        erros.append("prazo de resgate não é inteiro")
    if d.get("perfil") not in ("conservador", "moderado", "arrojado", None):
        erros.append(f"perfil desconhecido: {d.get('perfil')}")
    return erros

resposta_ok = '{"fundo": "Alfa RF", "taxa_adm_aa": 0.8, "prazo_resgate_dias": 30, "perfil": "moderado"}'
resposta_ruim = '{"fundo": "Alfa RF", "taxa_adm_aa": 80, "prazo_resgate_dias": "trinta"}'
for nome_r, r_ in (("resposta correta", resposta_ok), ("resposta com erro", resposta_ruim), ("não é JSON", "taxa: 0,8")):
    e_ = validar_extracao(r_)
    print(f"{nome_r}: {'OK' if not e_ else 'REJEITADA -> ' + '; '.join(e_)}")
```

```
resposta correta: OK
resposta com erro: REJEITADA -> campo ausente: perfil; taxa de administração implausível: 80% a.a.; prazo de resgate não é inteiro
não é JSON: REJEITADA -> JSON inválido: Expecting value
```

#atencao[
  Validar #strong[formato] não basta: uma taxa plausível (0,8%) pode estar #emph[errada] mesmo assim. Para valores
  que vão ao cliente, a regra é #strong[conferir contra a fonte] (a lâmina) por amostragem ou integralmente.
]

== 5.5 Validação, segurança e controle de erros

*Validação*

- Totais de controle: soma de entradas e saídas bate com a origem.
- Contagem de registros antes e depois de cada etapa.
- Testes com casos conhecidos e com casos de borda (base vazia, datas inválidas).
- Revisão por uma segunda pessoa (princípio dos quatro olhos).

*Segurança*

- Nunca deixe senhas ou chaves dentro do código ou de planilhas.
- Limite o acesso a dados de clientes ao necessário.
- Mantenha cópias de segurança e versionamento.
- Atenção à LGPD no tratamento de dados pessoais (ver também a seção 7.3).

*Controle de erros em código*

```python
try:
    df = pd.read_excel("extrato.xlsx")
except FileNotFoundError:
    raise SystemExit("Arquivo de extrato não encontrado.")

assert df["valor"].notna().all(), "Existem valores nulos na base."
assert not df.duplicated().any(), "Existem linhas duplicadas."
```

Registre logs do que foi processado e crie alertas para falhas, para que
ninguém dependa de perceber o erro por acaso.

#exemplo("totais de controle e log em uma rotina mensal")[
  Toda etapa de uma rotina automatizada deve provar que #emph[não perdeu nem duplicou dados]. O padrão é comparar
  contagem de registros e soma de valores entre origem e destino, registrando o resultado:
]

```python
import logging, io
buffer_log = io.StringIO()
logging.basicConfig(stream=buffer_log, level=logging.INFO, format="%(levelname)s | %(message)s", force=True)

def checar_totais(origem, destino, coluna="valor", etapa=""):
    ok_cont = len(origem) == len(destino)
    ok_soma = abs(origem[coluna].sum() - destino[coluna].sum()) < 0.01
    nivel = logging.INFO if ok_cont and ok_soma else logging.ERROR
    logging.log(nivel, f"{etapa}: registros {len(origem)}->{len(destino)} | soma {origem[coluna].sum():,.2f}->{destino[coluna].sum():,.2f}")
    return ok_cont and ok_soma

origem_m = pd.DataFrame({"conta": list("ABCD"), "valor": [100.0, 250.5, 80.25, 40.0]})
tratada_m = origem_m.assign(valor=origem_m["valor"].round(2))
perdida_m = origem_m.iloc[:3]
checar_totais(origem_m, tratada_m, etapa="Etapa 1 (limpeza)")
checar_totais(origem_m, perdida_m, etapa="Etapa 2 (merge com cadastro)")
print(buffer_log.getvalue())
```

```
INFO | Etapa 1 (limpeza): registros 4->4 | soma 470.75->470.75
ERROR | Etapa 2 (merge com cadastro): registros 4->3 | soma 470.75->430.75
```

=== Exercícios do Módulo 5

+ Escreva um script em Python que leia dois arquivos e liste as divergências de quantidade.
+ Escreva uma consulta SQL que retorne os cinco maiores clientes por patrimônio.
+ Descreva três controles que você colocaria em uma rotina automatizada de relatório mensal.

#line()

= Módulo 6 --- Aplicação prática e preparação para o gestor

== 6.1 Estudos de caso

*Caso A --- Divergência de posição* O relatório do cliente mostra
patrimônio de R\$ 2,40 milhões, mas o extrato do custodiante mostra R\$ 2,31
milhões. Há diferença de R\$ 90 mil.

Roteiro de análise:

+ Confirmar a data-base e a fonte dos preços nas duas pontas.
+ Comparar posição ativo a ativo para localizar a origem.
+ Verificar eventos recentes: aplicações e resgates ainda não cotizados, proventos, vencimentos, evento corporativo.
+ Corrigir a causa, registrar e comunicar o assessor.

*Caso B --- Cliente com concentração* Um cliente moderado tem 42% do
patrimônio em um único CRI de um emissor.

Roteiro: calcular concentração por ativo e por emissor, comparar com a
política de alocação e com o perfil, apontar risco de crédito e liquidez e
preparar material para o assessor discutir diversificação.

*Caso C --- Relatório mensal atrasado* O relatório consolidado depende de
cinco arquivos e sempre é entregue com atraso por retrabalho manual.

Roteiro: mapear o processo, identificar gargalos, automatizar importação e
limpeza com Power Query ou Python, definir checagens e medir o tempo antes
e depois.

#exemplo("Caso A resolvido: de 90 mil de diferença a zero")[
  O relatório mostra R\$ 2,40 milhões e o extrato do custodiante, R\$ 2,31 milhões. Seguindo o roteiro,
  a investigação ativo a ativo encontrou três causas que, somadas, explicam toda a diferença:
]

```python
causas_a = pd.DataFrame({
    "causa": ["Resgate de fundo já cotizado, não liquidado (D+1 do relatório)",
              "Dividendo creditado pelo custodiante, não lançado no sistema",
              "Preço de um CRI marcado em data diferente (D-1 no relatório)"],
    "tipo": ["Timing", "Falha de lançamento", "Fonte de preço"],
    "valor": [60_000, 18_000, 12_000],
})
diferenca_obs = 2_400_000 - 2_310_000
print(causas_a.to_string(index=False))
print(f"\nSoma das causas: R${causas_a['valor'].sum():,.0f} | diferença observada: R${diferenca_obs:,.0f} | resíduo: R${diferenca_obs - causas_a['valor'].sum():,.0f}")
print("Ações corretivas:", "lançar o dividendo; alinhar a data do preço do CRI; documentar o resgate como 'em trânsito'")
```

```
                                                         causa                tipo  valor
Resgate de fundo já cotizado, não liquidado (D+1 do relatório)              Timing  60000
  Dividendo creditado pelo custodiante, não lançado no sistema Falha de lançamento  18000
  Preço de um CRI marcado em data diferente (D-1 no relatório)      Fonte de preço  12000

Soma das causas: R$90,000 | diferença observada: R$90,000 | resíduo: R$0
Ações corretivas: lançar o dividendo; alinhar a data do preço do CRI; documentar o resgate como 'em trânsito'
```

#exemplo("Caso B resolvido: o que propor para o cliente com 42% em um CRI")[
  Para um cliente moderado com R\$ 1,5 milhão e limite de 20% por emissor privado, o excesso é de R\$ 330 mil
  (cálculo da seção 4.4). O back office #strong[não decide]: prepara três opções para o assessor discutir ---
  (a) vender parte do CRI (se houver liquidez; o mercado secundário pode exigir deságio); (b) direcionar novos aportes para
  classes subponderadas até o peso cair; (c) manter com justificativa formal documentada e reavaliação periódica.
  Material de apoio: concentração por emissor, vencimento e liquidez do papel, e o perfil registrado do cliente.
]

#exemplo("Caso C resolvido: o retorno da automação em horas")[
  Cinco arquivos de 40 minutos de tratamento manual por mês consomem 3h20; com Power Query, a atualização
  leva cerca de 10 minutos. Se o desenvolvimento da rotina custou 12 horas, o #strong[ponto de equilíbrio]
  é $12/("3,33" - "0,17") approx "3,8"$ meses --- e a economia seguinte (cerca de 3 horas por mês) vem
  com #strong[menos erro manual], o ganho que mais importa. Meça o tempo antes e depois: é o número que se mostra ao gestor.
]

```python
horas_antes, horas_depois, horas_dev = 5 * 40 / 60, 10 / 60, 12
economia_mes = horas_antes - horas_depois
print(f"Antes: {horas_antes:.2f} h/mês | depois: {horas_depois:.2f} h/mês | economia: {economia_mes:.2f} h/mês")
print(f"Ponto de equilíbrio do desenvolvimento ({horas_dev} h): {horas_dev / economia_mes:.1f} meses | economia em 12 meses: {economia_mes * 12 - horas_dev:.1f} h líquidas")
```

```
Antes: 3.33 h/mês | depois: 0.17 h/mês | economia: 3.17 h/mês
Ponto de equilíbrio do desenvolvimento (12 h): 3.8 meses | economia em 12 meses: 26.0 h líquidas
```

== 6.2 Resolução de problemas de Back Office

Método recomendado para qualquer problema operacional:

+ Entender: qual é o sintoma e qual é o impacto no cliente?
+ Delimitar: quando começou, quem e o que são afetados?
+ Levantar hipóteses ordenadas por probabilidade e esforço de verificação.
+ Testar com dados, não com suposições.
+ Corrigir a causa e não apenas o sintoma.
+ Prevenir: criar controle ou automação que evite repetição.
+ Comunicar de forma objetiva, com status, impacto, causa e próximo passo.

Erros comuns: corrigir direto na planilha final sem rastrear a origem,
ignorar diferenças pequenas que escondem falhas sistêmicas e não
documentar a solução.

#teoria("os cinco porquês: da falha ao controle")[
  Para encontrar a #strong[causa raiz] de um problema recorrente, pergunte "por quê?" repetidamente até
  chegar a algo que o processo pode controlar. Aplicado ao Caso C (relatório sempre atrasado):

  + Por que o relatório atrasa? #emph[Porque o tratamento dos cinco arquivos é manual e longo.]
  + Por que é manual? #emph[Porque os arquivos chegam em layouts diferentes e ninguém padronizou.]
  + Por que não há padrão? #emph[Porque cada custodiante envia no seu formato e não existe uma etapa de normalização.]
  + Por que não existe a etapa? #emph[Porque o processo nunca foi mapeado.]
  + Por que não foi mapeado? #emph[Porque sempre foi tratado como "urgência do mês", sem dono.]

  A ação deixa de ser "trabalhar mais rápido" e passa a ser #strong[mapear o processo, nomear um responsável e
  automatizar a normalização] --- ataca a causa, não o sintoma.
]

#figure(
  align(center)[#table(
    columns: (30%, 35%, 35%),
    align: (left, left, left),
    table.header([Situação], [Prioridade], [Conduta],),
    [Erro em relatório já enviado ao cliente], [#strong[Alta]: impacto externo e de confiança], [Avisar o responsável, corrigir, reenviar com nota objetiva da causa],
    [Pedido de dois assessores conflitantes], [Depende de impacto e prazo], [Alinhar com o gestor, explicar o critério, comunicar o prazo a ambos],
    [Melhoria de processo sem prazo], [Baixa no curto prazo], [Registrar, estimar o ganho e agendar],
  )]
  , kind: table
  )

== 6.3 Apresentação de soluções técnicas

Ao apresentar uma solução a um gestor, use a estrutura:

- *Contexto*: o problema em uma frase.
- *Impacto*: tempo, risco ou custo envolvidos.
- *Solução*: o que foi feito, em linguagem simples, com um exemplo.
- *Resultado*: ganho mensurável (horas economizadas, redução de erros).
- *Riscos e controles*: o que pode falhar e como foi mitigado.
- *Próximos passos*.

Adapte o nível técnico ao público: o gestor quer saber o que muda e que
risco existe, e só entra em detalhes de fórmula ou código se perguntar.

#exemplo("uma apresentação de dois minutos (Contexto, Impacto, Solução, Resultado, Riscos)")[
  #emph["O relatório mensal do comitê dependia de cinco extratos tratados à mão, e a entrega atrasava em média dois
  dias (contexto). Isso reduzia o tempo do comitê para analisar e criava risco de erro de digitação (impacto). Mapeei
  o processo, criei uma consulta no Power Query que empilha e padroniza os arquivos, e uma aba de conciliação que
  compara os totais com o custodiante (solução). O tempo de preparo caiu de cerca de três horas para dez minutos, e
  as divergências passaram a ser detectadas antes do envio (resultado). Os riscos são a mudança de layout dos extratos
  --- o erro aparece na primeira etapa da consulta --- e a dependência de uma pessoa, mitigada com documentação e
  revisão por segunda pessoa (riscos). O próximo passo é automatizar a coleta dos arquivos (próximos passos)."]

  Observe a estrutura: um número em cada bloco, a causa do risco e o controle, e linguagem sem jargão.
]

== 6.4 Entrevistas simuladas

Perguntas para treinar em voz alta:

*Conhecimento*

- Qual a diferença entre custódia e gestão?
- O que é come-cotas e quando acontece?
- Como você calcularia a rentabilidade de uma carteira com aportes e resgates?
- O que é suitability e por que importa?

*Técnicas*

- Como você concilia duas bases com chaves diferentes?
- Quando usaria PROCX, quando usaria Power Query e quando partiria para Python?
- Como garantiria que um relatório automatizado está correto?

*Situacionais*

- Você percebe um erro em um relatório já enviado ao cliente. O que faz?
- Dois assessores pedem prioridades conflitantes ao mesmo tempo. Como decide?
- Descreva uma rotina que você automatizou e o resultado.

*Comportamentais*

- Conte uma situação em que identificou um erro antes que causasse impacto.
- Como você lida com prazos curtos e alto volume de demandas?

Técnica de resposta: *SITUAÇÃO, AÇÃO, RESULTADO*. Seja específico, cite
números e admita o que aprendeu.

#exemplo("resposta SAR a uma pergunta comportamental")[
  #strong[Pergunta:] "Conte uma situação em que identificou um erro antes que causasse impacto."

  #emph[Situação:] "Ao conferir o relatório mensal antes do envio, a soma das posições por classe não batia com o total consolidado.
  Ação: em vez de ajustar o total, rastreei a diferença até um ativo duplicado vindo de dois extratos com nomes diferentes; corrigi o
  de-para de ativos e adicionei um teste automático de unicidade. Resultado: o relatório saiu correto, a diferença de R\$ 48 mil
  deixou de existir, e o teste passou a rodar todo mês. Aprendizado: o erro parecia 'arredondamento', mas era estrutural."

  Uma boa resposta SAR tem #strong[um fato específico], #strong[o que você fez] (não o que "a equipe" fez), um
  #strong[resultado mensurável] e o #strong[aprendizado].
]

== 6.5 Comunicação profissional e vocabulário técnico

Glossário essencial:

#table(
  columns: (auto, 1fr),
  table.header([Termo], [Significado resumido]),
  [AuC / AuM], [Patrimônio sob custódia / sob gestão],
  [Benchmark], [Índice de referência para comparar o desempenho],
  [Come-cotas], [Antecipação semestral de IR em certos fundos],
  [Cotização], [Data em que aplicação ou resgate vira cotas ou dinheiro],
  [Duration], [Prazo médio ponderado dos fluxos de um título; mede sensibilidade a juros],
  [Marcação a mercado], [Avaliação do ativo pelo preço de mercado],
  [Marcação na curva], [Avaliação pela taxa contratada na compra],
  [Rebalanceamento], [Retorno da carteira aos pesos-alvo],
  [Spread], [Diferença de taxa entre dois instrumentos ou a margem de crédito],
  [Suitability], [Adequação do produto ao perfil do investidor],
  [Slippage], [Diferença entre preço esperado e preço executado],
  [KYC], [Conheça seu cliente: identificação, perfil e monitoramento contínuo (ver Módulo 7)],
  [PLD-FT], [Prevenção à lavagem de dinheiro e ao financiamento ao terrorismo (ver Módulo 7)],
)

Boas práticas de comunicação escrita:

- assunto de e-mail que diga a ação ou o tema;
- primeira frase com a conclusão, detalhes depois;
- números com unidade, período e fonte;
- tom cordial e objetivo, sem jargão desnecessário com quem não é da área;
- revisão antes de enviar, em especial de valores e nomes de clientes.

#exemplo("e-mail objetivo de comunicação de um erro")[
  ```text
  Assunto: Correção do relatório de setembro — Cliente Ana S. (ação necessária: nenhuma)

  Olá, [nome],

  Identifiquei um erro no relatório de setembro enviado ontem: o dividendo de R$ 1.100 de PETR4 não estava lançado,
  subestimando o patrimônio em R$ 1.100 (0,06%). A causa foi o provento ter sido creditado após o fechamento da
  base. Já corrigi e reenviei o relatório (anexo). Incluí uma checagem de proventos no fechamento para evitar repetição.

  Qualquer dúvida, estou à disposição.
  ```

  Quatro ingredientes: #strong[o que aconteceu], #strong[o impacto em número], #strong[a causa] e #strong[a prevenção], em tom
  cordial e sem culpar terceiros.
]

=== Exercícios do Módulo 6

+ Resolva o Caso A criando uma base fictícia com uma divergência e documente o passo a passo.
+ Prepare uma apresentação de dois minutos sobre uma rotina que você automatizaria.
+ Grave suas respostas a cinco perguntas da seção 6.4 e reavalie clareza e objetividade.

#line()

= Módulo 7 --- Compliance, regulamentação e preparação para a reunião

Este módulo cobre os temas que costumam faltar em apostilas técnicas e que
diferenciam um candidato bem preparado: as normas que moldam o dia a dia de
uma assessoria, o fluxo de cadastro de clientes, eventos corporativos,
previdência e o preparo específico dos últimos dias antes da entrevista.
Regulamentação muda: use os nomes e números abaixo como mapa de estudo e
confirme a norma vigente.

== 7.1 O quadro regulatório do advisory

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Norma], [Objeto], [Por que importa para o Back Office]),
  [Resolução CVM 178], [Disciplina a atividade de assessoria de investimento (substituiu a Instrução CVM 527)], [Define o que a assessoria pode e não pode fazer: orienta e recomenda, sempre vinculada a uma corretora ou distribuidora; não custodia recursos nem administra carteiras],
  [Resolução CVM 30], [Suitability: adequação do produto ao perfil do investidor], [Torna obrigatório conhecer cliente, conhecer produto e verificar adequação (seção 7.2)],
  [Resolução CVM 21], [Define públicos de investidores (varejo, qualificado, profissional)], [Determina a que produtos cada cliente pode acessar (seção 7.4)],
  [Código ANBIMA de assessoria], [Autorregulação e melhores práticas de conduta], [Complementa as regras da CVM com padrões de conduta esperados pela indústria],
  [Resolução CVM 50 e normas do CMN/BCB], [Prevenção à lavagem de dinheiro (PLD-FT)], [Obriga a instituição a monitorar e comunicar operações suspeitas (seção 7.3)],
  [LGPD], [Proteção de dados pessoais], [Rege o tratamento de dados de clientes em relatórios, bases e ferramentas de IA],
)

Essa tabela reforça o mapa de responsabilidades do Módulo 1: a assessoria
orienta e distribui; a corretora executa e custodia via custodiante; a
gestora decide; o back office consolida, confere e sustenta o compliance
operacional com dados corretos.

#exemplo("quem responde a quê: um mapa de decisão")[
  #figure(
    align(center)[#table(
      columns: (40%, 30%, 30%),
      align: (left, left, left),
      table.header([Situação], [Quem decide/age], [Base],),
      [Cliente moderado quer produto arrojado], [Assessor registra; compliance avalia], [Suitability (RCVM 30)],
      [Cliente comum quer produto restrito a qualificados], [Instituição veda sem comprovar condição], [RCVM 21],
      [Movimentação incompatível com a renda], [Back office/compliance comunica ao COAF], [PLD-FT],
      [Posição divergente entre sistema e custodiante], [Back office investiga e corrige], [Controle operacional],
      [Cliente pede dados de outro cliente], [Recusa; registra o pedido], [Sigilo e LGPD],
    )]
    , kind: table
    )
]

== 7.2 Suitability como obrigação regulatória

No Módulo 1, suitability apareceu como conceito de perfil. Aqui está o que
a regra exige, em três deveres encadeados:

+ *Conhecer o cliente*: coletar e manter atualizado o questionário de perfil (objetivos, horizonte, experiência, situação financeira e tolerância a perdas), classificando-o em conservador, moderado ou arrojado.
+ *Conhecer o produto*: a instituição deve classificar os produtos que distribui por complexidade e risco.
+ *Verificar a adequação*: só recomendar produtos compatíveis com o perfil. Em linhas gerais, é vedado recomendar a clientes conservadores produtos moderados ou agressivos, e recomendar a moderados produtos agressivos exige justificativa formal e registro (confirme os detalhes na norma vigente).

O papel do back office na prática:

- gerar e acompanhar *relatórios de exceção* de suitability (recomendações fora do perfil);
- monitorar a validade dos questionários e cobrar atualização periódica;
- garantir que o registro da recomendação fique rastreável (quem recomendou, o quê, quando, para qual perfil).

Pergunta clássica de entrevista: *"um cliente moderado insiste em um
produto arrojado, o que você faz?"* --- a resposta espera o conceito de
inadequação registrada, o papel do compliance e a demonstração de que o
back office sustenta esse controle com dados.

#exemplo("relatório de exceção de suitability")[
  O back office cruza o perfil registrado de cada cliente com o risco dos produtos recomendados, listando as
  inadequações para o compliance. A regra do código é uma #emph[simplificação didática] das regras vistas na seção:
  (confirme a norma vigente):
]

```python
perfis = {"conservador": 1, "moderado": 2, "arrojado": 3}
recomendacoes = pd.DataFrame({
    "cliente": ["Ana", "Bruno", "Carla", "Diego"],
    "perfil": ["conservador", "moderado", "arrojado", "moderado"],
    "produto": ["Fundo de ações small caps", "COE de capital não protegido", "Fundo multimercado", "Tesouro IPCA+"],
    "risco_produto": [3, 3, 2, 1],
    "justificativa_formal": [False, True, False, False],
})
recomendacoes["nivel_perfil"] = recomendacoes["perfil"].map(perfis)
recomendacoes["acima_do_perfil"] = recomendacoes["risco_produto"] > recomendacoes["nivel_perfil"]
excecoes = recomendacoes[recomendacoes["acima_do_perfil"]].copy()
excecoes["situacao"] = np.where(excecoes["justificativa_formal"], "Acima do perfil, com justificativa registrada", "INADEQUADA: escalar ao compliance")
print(excecoes[["cliente", "perfil", "produto", "situacao"]].to_string(index=False))
```

```
cliente      perfil                      produto                                      situacao
    Ana conservador    Fundo de ações small caps             INADEQUADA: escalar ao compliance
  Bruno    moderado COE de capital não protegido Acima do perfil, com justificativa registrada
```

== 7.3 KYC, PLD-FT e COAF

*KYC (know your customer)* é a base de tudo: identificar o cliente,
entender sua atividade econômica e origem dos recursos, e manter o
cadastro atualizado. O mesmo cadastro alimenta o suitability e os
controles de lavagem de dinheiro.

*PLD-FT* é o conjunto de regras de prevenção à lavagem de dinheiro e ao
financiamento ao terrorismo. As instituições financeiras e as reguladas
pela CVM devem ter política interna, cadastrar clientes com dossiê,
monitorar operações e comunicar as suspeitas ao *COAF* (Conselho de
Controle de Atividades Financeiras), que é quem centraliza essas
comunicações no Brasil.

*PEP (pessoa exposta politicamente)* é quem exerce ou exerceu cargos
públicos relevantes (e seus familiares e estreitos associados): exige
tratamento reforçado de cadastramento e aprovação superior.

Sinais de alerta (*red flags*) que o back office pode ser o primeiro a
notar:

- movimentações incompatíveis com a renda e o patrimônio declarados;
- recusa ou demora em apresentar documentos de origem dos recursos;
- uso recorrente de contas de terceiros;
- instruções atípicas sem justificativa econômica.

Conduta esperada: registrar, escalar ao compliance e manter sigilo --- a
suspeita nunca se discute com o cliente. LGPD e sigilo bancário se
aplicam a tudo que passa pelas suas mãos.

#exemplo("sinais de alerta de PLD-FT como regras de monitoramento")[
  Sistemas de monitoramento transformam os "red flags" da seção em regras. O código ilustra duas (com limites #emph[hipotéticos],
  que na prática vêm da política da instituição) --- e lembra o princípio: a regra #strong[sinaliza], quem decide é o compliance:
]

```python
ops = pd.DataFrame({
    "cliente": ["Ana", "Bruno", "Carla", "Diego"],
    "renda": [30_000, 15_000, 50_000, 12_000],
    "aporte": [60_000, 400_000, 80_000, 11_000],
    "terceiros": [0.0, 0.7, 0.0, 0.0],
})
ops["aporte/renda"] = ops["aporte"] / ops["renda"]
ops["alerta_renda"] = ops["aporte/renda"] > 10                    # aporte > 10 meses de renda (limite hipotético)
ops["alerta_terc"] = ops["terceiros"] > 0.5                       # mais da metade via contas de terceiros
alertas = ops[ops["alerta_renda"] | ops["alerta_terc"]]
print(ops.round(2).to_string(index=False))
print(f"\nClientes sinalizados para análise do compliance: {', '.join(alertas['cliente'])}")
```

```
cliente  renda  aporte  terceiros  aporte/renda  alerta_renda  alerta_terc
    Ana  30000   60000       0.00          2.00         False        False
  Bruno  15000  400000       0.70         26.67          True         True
  Carla  50000   80000       0.00          1.60         False        False
  Diego  12000   11000       0.00          0.92         False        False

Clientes sinalizados para análise do compliance: Bruno
```

== 7.4 Cadastro e onboarding de clientes

Fluxo típico de abertura:

+ Coleta de documentos (identificação, comprovantes, dados fiscais).
+ Verificação de identidade e consulta a listas restritivas (PEP, sanções internacionais, listas de terroristas).
+ Questionário de suitability e definição do perfil.
+ Assinatura de termos (contrato de intermediação, adesões, avisos legais).
+ Vinculação bancária e primeira movimentação.

Pontos que aparecem em entrevista:

- *Atualização cadastral periódica*: perfis e documentos vencem; o back office acompanha e cobra.
- *Investidor qualificado*: acessa produtos restritos mediante condições da Resolução CVM 21 (ex.: investimentos acima de R\$ 1 milhão ou certificações aprovadas --- confira valores vigentes); o cadastro precisa comprovar a condição.
- *FATCA/CRS*: clientes com vínculo ou ativos no exterior exigem declarações adicionais; o processo é da instituição, mas o back office trata os dados.

#exemplo("checklist de onboarding com evidências")[
  #figure(
    align(center)[#table(
      columns: (30%, 35%, 35%),
      align: (left, left, left),
      table.header([Etapa], [Verificação], [Evidência arquivada],),
      [Identificação], [Documento válido e foto compatível], [Cópia do documento e data da conferência],
      [Origem dos recursos], [Compatível com renda e patrimônio], [Comprovantes e declaração],
      [Listas restritivas e PEP], [Consulta realizada], [Relatório da consulta com data],
      [Suitability], [Questionário respondido e perfil classificado], [Questionário assinado e perfil registrado],
      [Termos e contratos], [Assinados e arquivados], [Contrato e termos],
    )]
    , kind: table
    )
  O back office sustenta a #strong[trilha de auditoria]: para cada cliente ativo, é possível provar que cada etapa ocorreu, quando e por quem.
]

== 7.5 Eventos corporativos em detalhe

O Módulo 2 listou eventos como tipos de movimentação; aqui está o efeito
prático de cada um na base de posições:

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Evento], [Efeito na posição], [Ponto de atenção do Back Office]),
  [Dividendos e JCP], [Crédito em conta (caixa); não altera quantidade], [Conferir datas (data-com, data-ex, pagamento) e reconciliar recebido × previstos; IR de dividendos para PF passou a incidir acima de faixa de isenção a partir de 2026 (Lei 15.270/2025) --- confirme a regra vigente; JCP têm retenção na fonte],
  [Desdobramento (split)], [Quantidade multiplica pelo fator; preço divide pelo mesmo fator], [Ajustar a base histórica, senão o gráfico de rentabilidade distorce],
  [Grupamento (inplit)], [Quantidade divide; preço multiplica], [Mesmo ajuste espelhado do split],
  [Bonificação], [Novas ações gratuitas em proporção à posição], [Quantidade aumenta sem fluxo de caixa; ajustar preço de aquisição médio],
  [Direito de subscrição], [Opção de comprar novas ações a preço fixado, em prazo determinado], [Acompanhar prazo: não exercer nem vender o direito significa perder valor; posição temporária de um ativo novo],
  [Amortização (CRI, CRA, debêntures)], [Devolução parcial do valor de face ao investidor], [Reduz o preço/valor de face do papel; ajustar marcação e fluxo futuro],
)

Datas que importam em proventos: *data-com* (último dia com direito),
*data-ex* (primeiro dia sem o direito) e *data de pagamento*. Uma posição
vendida na data-ex não recebe o provento --- erro clássico de conciliação
de caixa.

Roteiro do back office diante de um evento:

+ Identificar o evento e os clientes afetados (por posição na data-com).
+ Calcular o efeito esperado (quantidade, preço, caixa).
+ Registrar na base e conferir o que o custodiante efetivou.
+ Comunicar divergências e documentar.

#exemplo("data-ex, JCP e direito de subscrição com números")[
  - #strong[Data-com e data-ex:] se a data-com é 15/10 (quinta-feira), a data-ex é 16/10. Quem comprou até 15/10 tem
    direito ao provento; quem comprou em 16/10 não tem. Quem #emph[vendeu] em 16/10 já tinha o direito e o recebe.
  - #strong[JCP (retenção ilustrativa de 15%):] um JCP bruto de R\$ 1.000 gera crédito líquido de R\$ 850 ao acionista pessoa
    física; o relatório deve mostrar o #emph[líquido] recebido e o bruto declarado (a retenção é de responsabilidade da companhia,
    e a alíquota pode mudar: confirme a vigente).
  - #strong[Direito de subscrição:] a companhia oferece 1 ação nova a R\$ 20,00 para cada 5 que o acionista possui, quando a ação
    vale R\$ 30,00. O #strong[preço teórico ex-direitos] é $(5 times 30 + 1 times 20)/6 = "28,33"$ e o valor do direito é
    $"30,00" - "28,33" = "1,67"$ por ação. Quem não exerce nem vende o direito perde esse valor: é o que o back
    office acompanha nos prazos.
]

```python
data_com = np.datetime64("2026-10-15")
data_ex = np.busday_offset(data_com, 1, roll="forward")
jcp_bruto, retencao = 1000, 0.15
p_atual, p_sub, razao_n, razao_m = 30.0, 20.0, 5, 1
p_ex_dir = (razao_n * p_atual + razao_m * p_sub) / (razao_n + razao_m)
print(f"Data-com {data_com} | data-ex {data_ex}")
print(f"JCP: bruto R${jcp_bruto:,.2f} | retenção ilustrativa {retencao:.0%} | líquido R${jcp_bruto * (1 - retencao):,.2f}")
print(f"Preço teórico ex-direitos: R${p_ex_dir:.2f} | valor do direito: R${p_atual - p_ex_dir:.2f} por ação")
```

```
Data-com 2026-10-15 | data-ex 2026-10-16
JCP: bruto R$1,000.00 | retenção ilustrativa 15% | líquido R$850.00
Preço teórico ex-direitos: R$28.33 | valor do direito: R$1.67 por ação
```

== 7.6 Previdência: PGBL × VGBL

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Aspecto], [PGBL], [VGBL]),
  [Dedução no IR], [Contribuições dedutíveis até o limite de 12% da renda tributável anual (exige declaração completa)], [Não dedutível],
  [Tributação no resgate], [Incide sobre o valor total resgatado (contribuições + rendimento)], [Incide apenas sobre os rendimentos],
  [Faz sentido para], [Quem declara IR completo e contribui até o teto dedutível], [Quem usa declaração simplificada ou já contribui acima do teto],
)

Regras comuns aos dois:

- *Regime tributário*: progressivo composto (alíquotas da tabela do IR) ou regressivo (começa em 35% e chega a 10% para aplicações com mais de 10 anos --- confirme a tabela vigente).
- A Lei 14.754/2023 padronizou prazos e passou a exigir que os planos permitam saque anual de até 10% do saldo acumulado; a tributação segue o regime escolhido. Confirme os detalhes no regulamento do plano.

Pergunta de entrevista pronta: *"PGBL ou VGBL?"* --- responda em três
frases: depende da declaração de IR e do teto de 12%; no PGBL o IR atinge
total resgatado, no VGBL só os rendimentos; a escolha errada transforma
dedução em armadilha.

#exemplo("PGBL × VGBL com números: um modelo simplificado")[
  Cliente com renda tributável de R\$ 300 mil/ano e alíquota marginal de 27,5% (declaração completa). Aporta 12% da renda
  (R\$ 36 mil) e deixa 12 anos a 8% ao ano; resgate no regime regressivo (10% após 10 anos). No #strong[PGBL], a
  contribuição reduz o IR em 27,5% × 36.000 = R\$ 9.900; supomos que a restituição seja investida em um fundo tributado a
  15% sobre o ganho. No #strong[VGBL] não há dedução, e o IR de 10% incide só sobre o rendimento.
]

```python
aporte_p, taxa_p, anos_p, aliq_resg, marginal = 36_000, 0.08, 12, 0.10, 0.275
fv_plano = aporte_p * (1 + taxa_p) ** anos_p
# PGBL: IR sobre o total resgatado; restituição reinvestida fora do plano (IR 15% sobre o ganho)
restituicao = aporte_p * marginal
fv_rest = restituicao * (1 + taxa_p) ** anos_p
liq_pgbl = fv_plano * (1 - aliq_resg) + fv_rest - (fv_rest - restituicao) * 0.15
# VGBL: IR só sobre o rendimento
liq_vgbl = fv_plano - (fv_plano - aporte_p) * aliq_resg
print(f"Valor do plano após {anos_p} anos: R${fv_plano:,.2f} (aporte de R${aporte_p:,.0f})")
print(f"PGBL: líquido do plano R${fv_plano * (1 - aliq_resg):,.2f} + restituição reinvestida líquida R${fv_rest - (fv_rest - restituicao) * 0.15:,.2f} = R${liq_pgbl:,.2f}")
print(f"VGBL: R${liq_vgbl:,.2f} | vantagem do PGBL: R${liq_pgbl - liq_vgbl:,.2f}")
```

```
Valor do plano após 12 anos: R$90,654.12 (aporte de R$36,000)
PGBL: líquido do plano R$81,588.71 + restituição reinvestida líquida R$22,675.40 = R$104,264.11
VGBL: R$85,188.71 | vantagem do PGBL: R$19,075.40
```

#atencao[
  O resultado depende das #strong[premissas]: alíquota marginal, uso da restituição, prazo e regime tributário. Para quem
  declara pelo modelo simplificado, ou já usa o teto de dedução, a vantagem do PGBL desaparece. O exemplo existe para
  mostrar a #emph[lógica] (diferimento mais dedução) e não para recomendar um plano.
]

== 7.7 Power BI e o mapa de ferramentas

Onde o Power BI entra em relação ao que você já estudou:

- *Excel + tabelas dinâmicas*: resolve análises pontuais de um analista por vez.
- *Power Query*: comum ao Excel e ao Power BI --- tudo o que o Módulo 3 ensina reaproveita.
- *Power BI*: quando o relatório precisa ser consultado por várias pessoas, atualizado recorrentemente contra fontes múltiplas e interativo (filtros por cliente, período, classe). Usa *DAX* para criar medidas calculadas (a lógica é parente das fórmulas de tabela dinâmica).

Como posicionar na entrevista, sem inflar: "domino Excel a fundo, entendo
modelo de dados e o conceito de medidas; Power BI entra naturalmente
quando a audiência e a recorrência do relatório crescem".

#exemplo("medidas DAX: as mesmas contas de uma tabela dinâmica, como medidas")[
  No Power BI, cálculos viram #strong[medidas] sensíveis ao filtro do relatório (cliente, período, classe):

  ```dax
  Patrimônio = SUMX(Posicoes, Posicoes[Quantidade] * Posicoes[Preco])

  % da carteira =
      DIVIDE([Patrimônio], CALCULATE([Patrimônio], ALL(Ativos[Classe])))
  ```

  A primeira soma quantidade × preço no contexto atual; a segunda divide pelo total ignorando o filtro de classe, o que dá a composição
  (equivale ao "% do total" da tabela dinâmica). Se o usuário filtra um cliente, ambas recalculam sozinhas.
]

== 7.8 Preparação específica para a reunião

Nos dias finais, o estudo técnico rende menos que o preparo dirigido:

- *Pesquise a casa*: site institucional, produtos que distribui, porte e dono (banco, gestora independente, plataforma), notícias recentes, área de atuação do gestor.
- *Saiba com quem vai falar*: nome do entrevistador, área (back office, middle office, dados) e o que a área mede (prazo, qualidade, volume).
- *Prepare 3 a 5 perguntas para o gestor*, por exemplo: "qual o maior gargalo operacional da área hoje?", "como vocês medem a qualidade de um relatório?", "como é a divisão entre Excel e ferramentas próprias no dia a dia?", "o que um analista entrega bem no primeiro mês?".
- *"Me conte sobre você"* em 30--60 segundos: quem sou → o que estudo/fiz → por que back office de wealth → o que trago (método, Excel, dados).
- *Se a vaga exigir inglês*, treine essa mesma apresentação de 1 minuto em inglês.
- *Logística*: confirmar horário e link/endereço, chegar 10 minutos antes, ambiente silencioso, currículo à mão e seu mini-projeto de Excel aberto, se houver.

#exemplo("\"me conte sobre você\" em 45 segundos")[
  #emph["Sou estudante de economia e venho construindo uma base de método para operações de investimentos: montei um banco de
  estudo com conciliação e relatórios em Excel e SQL, e treino automatizar rotinas com Python. Escolho back office de wealth
  porque o relatório correto é o produto que o cliente recebe, e eu gosto da parte em que o dado precisa estar certo.
  Trago método, curiosidade e disciplina de conferência. Aprendo rápido ferramentas novas."]

  Estrutura: #strong[quem sou] $arrow.r$ #strong[o que fiz] $arrow.r$ #strong[por que esta área] $arrow.r$ #strong[o que trago]. Adapte aos seus fatos reais; um
  exemplo ensaiado em voz alta soa natural, um texto lido soa decorado.
]

=== Exercícios do Módulo 7

+ Explique em voz alta, em 1 minuto, a diferença entre KYC, suitability e PLD-FT, sem consultar.
+ Um cliente arrojado quer um produto reservado a qualificados; um moderado insiste em produto arrojado. O que fazer em cada caso?
+ Classifique os eventos corporativos da seção 7.5 em: alteram quantidade, alteram preço, geram caixa.
+ Responda em 3 frases: "PGBL ou VGBL para quem declara IR completo?".
+ Liste três perguntas que você faria ao gestor, adaptadas à empresa depois de pesquisá-la.

#line()

= Aplix Capital Group --- preparação específica para a vaga

Dossiê da empresa da vaga, montado a partir do site institucional e de
pesquisa pública (outubro de 2026). Releia na véspera e confirme os
detalhes que puder diretamente com a empresa.

== Quem é a Aplix

- *Origem*: fundada em 2010 em Fortaleza por *Alberto Saboia* e *Felipe Romcy*, com escritório também em São Paulo (desde 2022). Great Place to Work por três anos consecutivos.
- *Porte*: mais de 1.700 famílias e empresas clientes, *+R\$ 2,6 bilhões acompanhados*, NPS 95.
- *Cinco áreas*: Aplix Investments (assessoria credenciada à *XP Investimentos* desde 2011), Aplix Advisory (consultoria patrimonial independente, modelo family office para grandes patrimônios), Aplix Corporate (empresas), Aplix Protect (seguros e sucessão) e Aplix Learning (educação financeira).
- *Modelo de remuneração*: desde 2023, *honorários fixos (fee)* --- não comissão por produto. É o grande diferencial declarado da casa: "o alinhamento com o objetivo do cliente deixa de ser discurso e vira desenho".
- *Metodologia*: cinco etapas --- Introdução, Histórias (entrevista de profundidade), Análise, Planejamento e Acompanhamento contínuo com *comitê de investimentos mensal*. Princípio de "proteção primeiro".
- *Valores declarados*: Integridade, Humildade, Responsabilidade, Transparência, Resiliência e Pertencimento. A casa busca perfis de longo prazo, que "tratam o patrimônio dos outros como cuidariam do próprio".

== Por que isso importa para a vaga de back office

+ *Consolidação multi-instituição é o coração do trabalho.* Como advisory independente que cuida do patrimônio do cliente "em qualquer banco", o back office vive do problema do Módulo 2.2: consolidar posições de custodiantes diferentes (XP, bancos privados etc.) em uma visão única, com data-base e preços padronizados. Estude essa seção como prioridade máxima.
+ *Fee fixo muda a métrica de qualidade do relatório.* Sem comissão por produto, o valor percebido pelo cliente está no relatório de acompanhamento: rentabilidade vs. benchmark, atribuição, alocação vs. alvo (Módulos 2.4 e 4.5).
+ *Comitê mensal* significa rotina de preparar dados com prazo fixo e qualidade auditável todo mês --- é o Caso C do Módulo 6 com os controles do 5.5.
+ *Credenciamento à XP*: as operações executam via XP Investimentos; o extrato/posição da XP é uma das pontas da conciliação.
+ *Founder + cultura declarada*: fundadores avaliam fit pesadamente. Conecte seu método aos valores da casa --- transparência e responsabilidade aplicadas à conferência e à documentação (trilha de auditoria, quatro olhos, seções 2.5 e 5.5).

== Perguntas prontas para o founder

- "Como é hoje o fluxo de consolidação das posições entre custodiantes --- o que é manual e o que já é automatizado?"
- "O que o comitê mensal consome de informação da área de operações, e onde está o maior gargalo de prazo?"
- "Com o modelo de fee fixo, como vocês medem a qualidade da entrega ao cliente --- quais indicadores o back office alimenta?"
- "Onde um analista de back office entrega mais valor nos primeiros 90 dias, na sua leitura?"

== Como citar a casa na conversa

Sem parecer decorado, em uma frase: *"Li que vocês migraram para
honorários fixos em 2023 e cuidam do patrimônio do cliente em qualquer
instituição --- isso torna a consolidação multi-custodiante e a qualidade
do relatório mensal o coração da operação, que é exatamente a área que eu
quero fazer."*

== Fontes consultadas

- `aplix.com.br` (institucional, modelo e números)
- `aplix.com.br/advisory` (Aplix Advisory)
- `aplix.com.br/carreiras` (valores, cultura e GPTW)

#line()

= Cronograma sugerido

#table(
  columns: (auto, 1fr),
  table.header([Semana], [Foco]),
  [1], [Módulo 1 --- mercado, instituições, produtos e carteira],
  [2], [Módulo 2 --- posições, custódia, conciliação e rentabilidade],
  [3 a 4], [Módulo 3 --- Excel, tabelas dinâmicas e Power Query],
  [5], [Módulo 4 --- indicadores, alocação e análise],
  [6], [Módulo 5 --- Python, SQL, IA e controles],
  [7], [Módulo 6 --- casos, simulados e comunicação],
  [8], [Módulo 7 --- compliance, regulamentação e revisão geral],
)

Ajuste o ritmo à sua disponibilidade e ao prazo da vaga.

#block(fill: rgb("#f4f6f8"), inset: 10pt, radius: 4pt, width: 100%)[
  #strong[Prazo curto?] Se a entrevista estiver próxima, siga o cronograma
  dia a dia do arquivo `plano-estudos-backoffice-wealth.md` e use esta
  apostila como fonte de conteúdo, priorizando os Módulos 2, 3, 6 e 7.
]

= Revisão de véspera --- números e conceitos que caem em entrevista

Uma única página para reler na véspera. Cada item tem resposta em uma ou
duas frases; se alguma não sair de cabeça, volte à seção indicada.

#table(
  columns: (auto, 1fr),
  table.header([Pergunta], [Resposta curta]),
  [Prazo de liquidação de ações à vista na B3?], [D+2 em geral (seção 2.3)],
  [O que é come-cotas?], [Antecipação semestral de IR (maio e novembro) em fundos abertos de renda fixa e multimercado (seção 1.4)],
  [Alíquotas de IR na renda fixa?], [Regressiva: 22,5% até 180 dias, caindo até 15% acima de 720 dias; IOF nos primeiros 30 dias (seção 1.4)],
  [TWR × MWR?], [TWR isola a decisão de investimento (padrão para comparar gestores); MWR/TIR reflete a experiência do cliente com o timing dos aportes (seção 2.4)],
  [O que a Resolução CVM 178 define?], [A atividade de assessoria: orienta e recomenda, vinculada a corretora/distribuidora; não custodia nem administra carteira (seção 7.1)],
  [Os três deveres da suitability (RCVM 30)?], [Conhecer o cliente, conhecer o produto e verificar a adequação (seção 7.2)],
  [O que é KYC e para onde vai a suspeita de lavagem?], [Identificar o cliente e a origem dos recursos; operações suspeitas são comunicadas ao COAF, nunca discutidas com o cliente (seção 7.3)],
  [Quem é PEP?], [Pessoa exposta politicamente (e familiares/associados): exige cadastro reforçado e aprovação superior (seção 7.3)],
  [Data-com × data-ex?], [Data-com é o último dia com direito ao provento; data-ex é o primeiro dia sem o direito --- vender na data-ex perde o provento (seção 7.5)],
  [Efeito do split e do inplit?], [Split multiplica a quantidade e divide o preço pelo mesmo fator; inplit é o inverso; ajustar a base histórica (seção 7.5)],
  [PGBL × VGBL em três frases?], [Depende da declaração de IR e do teto de 12% da renda tributável; no PGBL o IR incide sobre o total resgatado, no VGBL só sobre rendimentos; escolha errada transforma dedução em armadilha (seção 7.6)],
  [Como conciliar duas bases?], [Mesma data-base, chaves padronizadas, cruzamento com PROCX ou merge do pandas, classificar a divergência (timing, preço, lançamento, evento), corrigir a causa e documentar (seções 2.3 e 3.3)],
  [O que a Aplix faz de diferente?], [Honorários fixos desde 2023 (sem comissão), advisory independente multi-custodiante e comitê de investimentos mensal --- o que torna consolidação e qualidade de relatório o coração da operação (dossiê Aplix)],
)

#line()

= Checklist final

- ☐ Explico cada tipo de instituição e produto sem consultar material.
- ☐ Concilio duas bases em Excel e em Python.
- ☐ Calculo rentabilidade, alocação e indicadores de risco com segurança.
- ☐ Construo um relatório ou dashboard a partir de dados brutos.
- ☐ Escrevo consultas SQL com JOIN e agregações.
- ☐ Sei apontar os cuidados no uso de IA e na proteção de dados.
- ☐ Apresento uma solução técnica em dois minutos, com impacto e controles.
- ☐ Explico KYC, PLD-FT e COAF --- e o papel do back office nesses controles.
- ☐ Sei o que suitability exige (RCVM 30) e o que fazer diante de produto inadequado ao perfil.
- ☐ Descrevo o efeito dos principais eventos corporativos na posição e no caixa.
- ☐ Explico a diferença tributária entre PGBL e VGBL em três frases.
- ☐ Tenho 3 a 5 perguntas prontas para o gestor, adaptadas à empresa.


#line()

= Apêndice A --- Glossário ampliado

#table(
  columns: (auto, 1fr),
  table.header([Termo], [Significado]),
  [Alocação estratégica × tática], [Distribuição de longo prazo entre classes × desvios temporários para aproveitar cenários],
  [Atribuição de performance], [Decomposição do retorno nas contribuições de alocação e seleção],
  [Banda de rebalanceamento], [Desvio máximo tolerado em relação ao peso-alvo antes de reajustar],
  [Câmara de compensação], [Entidade que compensa e liquida operações entre os participantes (na B3)],
  [Conciliação], [Conferência de duas fontes que deveriam concordar, com classificação das divergências],
  [Custodiante], [Instituição que guarda os ativos em nome do investidor; fonte oficial da posição],
  [Data-com / data-ex], [Último dia com direito ao provento / primeiro dia sem o direito],
  [Drawdown], [Maior queda do pico ao vale em um período],
  [FGC], [Fundo Garantidor de Créditos: cobre parte dos depósitos e produtos bancários, dentro de limites],
  [HHI], [Índice de Herfindahl: soma dos pesos ao quadrado, mede concentração],
  [Inplit / grupamento], [Várias ações viram uma: a quantidade cai e o preço sobe pelo mesmo fator],
  [LGPD], [Lei Geral de Proteção de Dados Pessoais],
  [MWR], [Retorno ponderado pelo dinheiro (TIR do cliente)],
  [PEP], [Pessoa exposta politicamente],
  [PTAX], [Taxa de câmbio de referência calculada pelo Banco Central],
  [Rebalanceamento], [Retorno da carteira aos pesos-alvo],
  [Red flag], [Sinal de alerta de possível irregularidade (PLD-FT)],
  [SAR], [Situação, ação, resultado: técnica de resposta comportamental],
  [Split], [Uma ação vira várias: a quantidade sobe e o preço cai pelo mesmo fator],
  [Tracking error], [Desvio-padrão da diferença de retorno entre carteira e benchmark],
  [TWR], [Retorno ponderado pelo tempo (mede o gestor, ignora o timing dos aportes)],
  [Trilha de auditoria], [Registro que permite refazer o caminho do dado até a fonte],
  [VaR], [Perda máxima estimada em um horizonte e com um nível de confiança],
)
