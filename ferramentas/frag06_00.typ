%%% BEFORE_CHAPTER_END: == Capítulo 1 --- Fundamentos: O Valor do Dinheiro no Tempo
#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria, exemplos resolvidos passo a passo e implementação em Python]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Capítulo 0 --- Como Usar Esta Apostila
<capítulo-0-como-usar-esta-apostila>
=== 0.1. Objetivo e método de estudo
<objetivo-e-método-de-estudo>
A matemática financeira responde a uma pergunta só, repetida de muitas
formas: #strong[quanto vale, hoje, um valor que será pago ou recebido em
outra data?] Com essa pergunta resolvem-se financiamentos, aplicações,
descontos de títulos, avaliação de projetos e preços de ativos.

Cada tópico desta apostila é apresentado em três camadas, e o estudo rende
mais quando você as percorre #strong[na ordem]:

+ #strong[O porquê (teoria).] De onde vem a fórmula, quais hipóteses ela
  esconde e quando deixa de valer. Decorar fórmulas sem isso leva a
  erros silenciosos --- aquele tipo de erro em que a conta "dá certo" e o
  resultado está errado.
+ #strong[O como (exemplos resolvidos à mão).] Cada conceito vem com pelo
  menos um exemplo numérico resolvido passo a passo, com calculadora. Refaça
  a conta no papel antes de olhar a resposta.
+ #strong[O automatizar (Python).] O código reproduz o exemplo, generaliza
  para outros valores e serve de conferência. Todos os resultados impressos
  nesta apostila foram obtidos executando o código mostrado.

Para sinalizar o tipo de conteúdo, usamos caixas coloridas:

#exemplo("modelo")[
  Um problema numérico, resolvido em etapas. Tente resolver sozinho antes
  de ler a solução.
]

#intuicao[
  A ideia por trás da fórmula, em linguagem comum, sem símbolos.
]

#teoria("modelo")[
  Demonstrações e detalhes que explicam #emph[por que] a fórmula funciona.
  Podem ser lidos numa segunda passada.
]

#atencao[
  Um erro que costuma aparecer em provas, no trabalho e em contratos reais.
]

#mercado[
  Como o conceito aparece na prática do sistema financeiro e da regulação
  brasileira.
]

=== 0.2. Notação e convenções
<notação-e-convenções>
#figure(
  align(center)[#table(
    columns: (14%, 46%, 40%),
    align: (left, left, left),
    table.header([Símbolo], [Significado], [Observação],),
    [$"PV"$ ou $C$], [Valor presente (capital)], [Valor na data zero],
    [$"FV"$ ou $M$], [Valor futuro (montante)], [Valor na data $n$],
    [$J$], [Juros], [$J = "FV" - "PV"$],
    [$i$], [Taxa de juros por período], [Sempre em #strong[forma decimal] nas fórmulas: 2% = 0,02],
    [$n$], [Número de períodos], [Na mesma unidade da taxa],
    [$"PMT"$], [Prestação (pagamento periódico)], [Constante nas séries uniformes],
    [$"SD"_k$], [Saldo devedor após o pagamento $k$], [Capítulo 5],
    [$A_k$, $J_k$], [Amortização e juros da prestação $k$], [$"PMT"_k = A_k + J_k$],
    [$d$], [Taxa de desconto], [Capítulo 2],
    [$pi$, $i_r$, $i_n$], [Inflação, taxa real, taxa nominal], [Capítulo 6],
    [TMA, TIR, VPL], [Taxa mínima de atratividade, taxa interna de retorno, valor presente líquido], [Capítulo 7],
  )]
  , kind: table
  )

#strong[Siglas de período:] a.d. (ao dia), a.m. (ao mês), a.t. (ao
trimestre), a.s. (ao semestre), a.a. (ao ano).

#strong[Três regras de higiene numérica.]

- #strong[Taxa e prazo na mesma unidade.] Taxa mensal exige $n$ em meses.
  Esta é a fonte de erro mais frequente de todo o assunto.
- #strong[Não arredonde no meio da conta.] Guarde todas as casas decimais
  até o resultado final. Arredondar uma taxa de $1,8088%$ para $1,8%$ já
  desloca o resultado na terceira ou quarta casa do valor final.
- #strong[Separadores.] No texto usamos o padrão brasileiro
  (R\$ 1.550,43). As saídas do Python usam o padrão internacional
  (1550.43 ou 1,550.43), porque é assim que a linguagem imprime.

=== 0.3. Revisão de matemática necessária
<revisão-de-matemática-necessária>
==== Porcentagem como fator multiplicativo
<porcentagem-como-fator-multiplicativo>
Aumentar um valor em 8% é multiplicá-lo por $1 + 0,08 = 1,08$. Reduzi-lo
em 8% é multiplicá-lo por $1 - 0,08 = 0,92$. Variações sucessivas
#strong[multiplicam-se]; não se somam.

#exemplo("variações sucessivas")[
  Um preço sobe 25% e depois cai 20%. Volta ao valor original?

  #strong[Solução.] Fator total: $1,25 times 0,80 = 1,00$. Sim --- mas
  #strong[só por coincidência numérica]: os 20% de queda incidem sobre uma
  base 25% maior. Já uma alta de 25% seguida de queda de 25% dá
  $1,25 times 0,75 = 0,9375$, uma perda líquida de 6,25%.
]

==== Potências, raízes e logaritmos
<potências-raízes-e-logaritmos>
Toda a matemática dos juros compostos usa três operações inversas entre si:

$ x = y^n quad arrow.l.r.double quad y = x^(1\/n) quad arrow.l.r.double quad n = ln(x) / ln(y) $

- #strong[Potência] --- calcula o montante: $1,02^12 approx 1,2682$.
- #strong[Raiz] ($x^(1\/n)$) --- calcula a taxa por período: a taxa mensal
  que dobra um capital em 12 meses é $2^(1\/12) - 1 approx 5,95%$ a.m.
- #strong[Logaritmo] --- calcula o prazo. A propriedade
  $ln(a^b) = b dot ln(a)$ "desce o expoente": de $1,02^n = 2$ obtém-se
  $n dot ln(1,02) = ln(2)$, logo $n = ln(2)/ln(1,02) approx 35,0$ meses.

==== Progressões aritmética e geométrica
<progressões-aritmética-e-geométrica>
Os juros simples formam uma #strong[progressão aritmética] (PA): somam uma
constante a cada período. Os compostos formam uma #strong[progressão
geométrica] (PG): multiplicam por uma constante. As séries de pagamentos
(Capítulo 4) exigem a #strong[soma de uma PG], que se demonstra em duas linhas.

#teoria("soma dos termos de uma PG")[
  Seja uma PG de primeiro termo $a_1$ e razão $q != 1$, com $n$ termos:

  $ S = a_1 + a_1 q + a_1 q^2 + dots + a_1 q^(n-1) $

  Multiplique tudo por $q$:

  $ q S = a_1 q + a_1 q^2 + dots + a_1 q^(n-1) + a_1 q^n $

  Subtraia a segunda linha da primeira. Quase tudo se cancela:

  $ S - q S = a_1 - a_1 q^n quad arrow.r.double quad S = a_1 (1 - q^n)/(1 - q) = a_1 (q^n - 1)/(q - 1) $

  Se $|q| < 1$ e $n$ cresce sem limite, $q^n -> 0$ e a soma converge para
  $S_infinity = a_1 / (1 - q)$. Esse resultado é a #strong[perpetuidade] da
  seção 4.5. Exemplo: $1 + 1/2 + 1/4 + dots = 1/(1 - 1/2) = 2$.
]

=== 0.4. Roteiro de cinco passos para resolver qualquer problema
<roteiro-de-cinco-passos>
Quase todo problema de matemática financeira se resolve com a mesma
sequência. Adote-a como hábito:

+ #strong[Identifique a incógnita] e os dados: qual dos valores ($"PV"$,
  $"FV"$, $i$, $n$, $"PMT"$) foi pedido e quais foram dados?
+ #strong[Padronize as unidades.] Taxa e prazo precisam estar na mesma
  base de tempo. Se não estiverem, converta a taxa (equivalência, Capítulo
  3) ou o prazo.
+ #strong[Desenhe o fluxo de caixa.] Marque a data de cada valor, com
  entradas para cima e saídas para baixo. Em 80% dos erros, o desenho
  teria evitado a confusão.
+ #strong[Escolha o regime e a fórmula] (simples ou composto; pagamento
  único ou série) e leve todos os valores #strong[para uma mesma data],
  geralmente a data zero.
+ #strong[Calcule e teste a razoabilidade.] O montante deve ser maior que o
  capital; a soma das prestações deve ser maior que o valor financiado; uma
  taxa de 2% a.m. não pode resultar em 90% a.a.

#exemplo("o roteiro em ação")[
  Uma loja vende um notebook por R\$ 3.000 à vista, ou em 5 prestações
  mensais iguais, sem entrada, com juros de 2% a.m. Qual é a prestação?

  + #strong[Incógnita:] PMT. #strong[Dados:] PV = 3.000; $i$ = 2% a.m.;
    $n$ = 5.
  + #strong[Unidades:] taxa mensal, prazo em meses --- já compatíveis.
  + #strong[Fluxo de caixa] (visão do comprador):

  #fluxo("+3.000", "-PMT", "-PMT", "-PMT", "-PMT", "-PMT")

  + #strong[Fórmula:] série uniforme postecipada (Capítulo 4):
    $"PMT" = "PV" dot i (1+i)^n / ((1+i)^n - 1)$.
  + #strong[Conta:] $1,02^5 = 1,10408$; fator
    $= 0,02 times 1,10408 / 0,10408 = 0,21216$; logo
    $"PMT" = 3.000 times 0,21216 approx$ #strong[R\$ 636,48].
    #strong[Teste:] $5 times 636,48 = 3.182,38 > 3.000$ ✓ (a diferença,
    R\$ 182,38, são os juros).
]

```python
caso_pv, caso_i, caso_n = 3000, 0.02, 5
caso_fator = caso_i * (1 + caso_i) ** caso_n / ((1 + caso_i) ** caso_n - 1)
caso_pmt = caso_pv * caso_fator
print(f"Fator de recuperação de capital: {caso_fator:.5f}")
print(f"Prestação: R${caso_pmt:.2f}")
print(f"Total pago: R${caso_pmt * caso_n:.2f} (juros: R${caso_pmt * caso_n - caso_pv:.2f})")
```

=== 0.5. Ferramentas: HP-12C, planilha e Python
<ferramentas-hp-12c-planilha-e-python>
Os mesmos cálculos podem ser feitos em três ambientes. Conhecer a
correspondência evita reinventar a roda e permite conferir o resultado
por dois caminhos independentes.

#figure(
  align(center)[#table(
    columns: (22%, 24%, 30%, 24%),
    align: (left, left, left, left),
    table.header([Cálculo], [HP-12C], [Excel / Planilhas (pt-BR)], [Python (nesta apostila)],),
    [Valor futuro], [n, i, PV, PMT → FV], [`=VF(taxa; nper; pgto; vp)`], [`juros_compostos`],
    [Valor presente], [n, i, PMT, FV → PV], [`=VP(taxa; nper; pgto; vf)`], [`juros_compostos`],
    [Prestação], [n, i, PV → PMT], [`=PGTO(taxa; nper; vp)`], [`serie_postecipada`],
    [Número de períodos], [i, PV, PMT, FV → n], [`=NPER(taxa; pgto; vp; vf)`], [`juros_compostos`],
    [Taxa], [n, PV, PMT, FV → i], [`=TAXA(nper; pgto; vp; vf)`], [`calcular_cet`],
    [VPL], [`f NPV` (g CF0, g CFj)], [`=VPL(taxa; valores)` + valor em t=0], [`vpl`],
    [TIR], [`f IRR`], [`=TIR(valores)`], [`tir`],
    [Taxa efetiva a partir da nominal], [---], [`=EFETIVA(nominal; k)`], [`nominal_para_efetiva`],
  )]
  , kind: table
  )

#atencao[
  #strong[Duas armadilhas clássicas das planilhas.] (1) As funções
  financeiras seguem a convenção de #strong[sinais do fluxo de caixa]: o
  dinheiro que sai tem sinal negativo. `=VF(2%; 12; 0; -5000)` devolve
  $+$6.341,21; sem o sinal negativo no valor presente, o resultado vem
  negativo. (2) A função `VPL` do Excel #strong[desconta o primeiro valor
  da lista em $t = 1$], não em $t = 0$. O investimento inicial, que está
  em $t = 0$, deve ser somado #emph[fora] da função:
  `=VPL(taxa; fluxos_1_a_n) + fluxo_0`. A HP-12C não tem esse problema,
  porque o `CF0` é informado separadamente.
]

%%% END
