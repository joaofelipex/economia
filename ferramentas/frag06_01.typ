%%% BEFORE: === 1.2. Conceitos Primitivos
#teoria("por que o dinheiro tem preço?")[
  O juro é o preço do #emph[tempo]. Três ideias clássicas da economia
  explicam por que ele existe:

  - #strong[Preferência temporal] (Böhm-Bawerk, Irving Fisher). As pessoas
    preferem consumir hoje a consumir amanhã; para abrir mão do consumo
    presente exigem uma compensação. Quanto maior a impaciência média da
    sociedade, maior o juro de equilíbrio.
  - #strong[Produtividade do capital.] Recursos aplicados hoje em uma
    máquina, num imóvel ou num estoque geram mais recursos amanhã. Quem
    toma emprestado pode pagar juros porque o capital #emph[rende] mais do
    que custa.
  - #strong[Preferência pela liquidez] (Keynes). Abrir mão de dinheiro
    disponível implica perder flexibilidade; o juro remunera essa renúncia.

  Na prática, a taxa cobrada em uma operação pode ser vista como a
  #strong[composição] de três componentes, que se #emph[multiplicam]:

  $ (1 + i) = (1 + r) dot (1 + pi) dot (1 + theta) $

  onde $r$ é a taxa #strong[real] livre de risco (a remuneração pura do
  tempo), $pi$ é a inflação esperada e $theta$ é o #strong[prêmio de risco]
  (de crédito, de liquidez, de prazo). O Capítulo 6 desenvolve a relação
  entre $i$, $r$ e $pi$ (equação de Fisher).
]

#exemplo("receber hoje ou daqui a um ano?")[
  Você pode receber R\$ 10.000 hoje ou R\$ 10.800 daqui a 12 meses. Sua
  melhor alternativa de aplicação rende 1% a.m. Qual oferta é melhor?

  #strong[Raciocínio 1 --- levar tudo para o futuro.] Os R\$ 10.000
  recebidos hoje, aplicados a 1% a.m. por 12 meses, viram
  $10.000 times 1,01^12 = $ R\$ 11.268,25. Como isso supera R\$ 10.800,
  #strong[receber hoje é melhor].

  #strong[Raciocínio 2 --- trazer tudo para hoje.] Os R\$ 10.800 de daqui a
  um ano valem hoje $10.800 / 1,01^12 = $ R\$ 9.584,45, menos que R\$
  10.000. Mesma conclusão.

  #strong[Raciocínio 3 --- comparar taxas.] A oferta de R\$ 10.800
  equivale a uma taxa de $(10.800 / 10.000)^(1\/12) - 1 = 0,643%$ a.m.,
  menor que os 1% a.m. da alternativa.

  Os três raciocínios são equivalentes --- e é isso que dá consistência à
  matemática financeira: #strong[qualquer data pode servir de referência],
  desde que todos os valores sejam levados para a mesma.
]

```python
oferta_hoje, oferta_futura, taxa_alt = 10000, 10800, 0.01   # 1% a.m., prazo de 12 meses
vf_alternativa = oferta_hoje * (1 + taxa_alt) ** 12
vp_oferta_futura = oferta_futura / (1 + taxa_alt) ** 12
taxa_da_oferta = (oferta_futura / oferta_hoje) ** (1 / 12) - 1

print(f"R$10.000 hoje, aplicados por 12 meses -> R${vf_alternativa:,.2f}")
print(f"R$10.800 daqui a 12 meses valem hoje  -> R${vp_oferta_futura:,.2f}")
print(f"Taxa implícita da oferta futura       -> {taxa_da_oferta*100:.4f}% a.m.")
```

%%% BEFORE: === 1.3. Fluxo de Caixa
#exemplo("lendo um enunciado")[
  #emph["Aplicou-se R\$ 5.000 por 8 meses e resgatou-se R\$ 5.600."]

  Traduza para símbolos: $"PV" = 5.000$; $"FV" = 5.600$; $n = 8$ meses;
  $J = "FV" - "PV" = 600$; taxa $i$ #emph[desconhecida].

  - Em #strong[juros simples]: $i = J / ("PV" dot n) = 600 / (5.000 dot 8) = 1,5%$ a.m.
  - Em #strong[juros compostos]: $i = ("FV"/"PV")^(1\/n) - 1 = 1,12^(1\/8) - 1 approx 1,4267%$ a.m.

  A mesma operação tem taxas diferentes conforme o regime adotado. Por
  isso, #strong[nunca se compara uma taxa simples com uma composta]
  sem convertê-las.
]

#atencao[
  #strong[Unidades incompatíveis.] "Qual o montante de R\$ 1.000 a 24% a.a.
  durante 18 meses?" Aqui a taxa é anual e o prazo, mensal. Há duas saídas
  equivalentes: usar $n = 18/12 = 1,5$ #strong[anos]; ou converter a taxa
  para mensal, $(1,24)^(1\/12) - 1 approx 1,8088%$ a.m., e usar $n = 18$.
  O resultado é o mesmo (R\$ 1.380,81). O erro típico é digitar
  $n = 18$ com a taxa anual --- e obter um valor absurdo (veja a última
  linha da saída abaixo).
]

```python
capital_ex, taxa_aa, meses_ex = 1000, 0.24, 18
via_anos = capital_ex * (1 + taxa_aa) ** (meses_ex / 12)
taxa_mensal_eq = (1 + taxa_aa) ** (1 / 12) - 1
via_meses = capital_ex * (1 + taxa_mensal_eq) ** meses_ex
errado = capital_ex * (1 + taxa_aa) ** meses_ex      # taxa anual com prazo em meses!
print(f"Prazo em anos : R${via_anos:.2f}")
print(f"Prazo em meses: R${via_meses:.2f}")
print(f"Errado (misturou unidades): R${errado:,.2f}")
```

%%% BEFORE: === 1.4. Regimes de Capitalização
#intuicao[
  Um fluxo de caixa é uma #strong[fotografia da operação financeira], tirada
  de um ponto de vista. O mesmo empréstimo é uma #emph[entrada] para quem
  toma e uma #emph[saída] para quem empresta --- e os dois desenhos são
  espelhos um do outro. Antes de qualquer conta, decida de quem é o ponto
  de vista.
]

#exemplo("o mesmo empréstimo, duas visões")[
  Um banco empresta R\$ 30.000 e recebe 4 prestações mensais de R\$ 8.500.

  #strong[Visão do banco] (credor): sai dinheiro em $t = 0$, entra em
  $t = 1$ a $4$.

  #fluxo("-30.000", "+8.500", "+8.500", "+8.500", "+8.500")

  #strong[Visão do cliente] (devedor): entra dinheiro em $t = 0$, saem
  prestações depois.

  #fluxo("+30.000", "-8.500", "-8.500", "-8.500", "-8.500")

  Os dois fluxos têm a #strong[mesma taxa interna]: a taxa $i$ que
  satisfaz $8.500 dot a_(4 | i) = 30.000$ (a notação $a_(n|i)$ aparece na
  seção 4.2). Resolvendo numericamente, $i approx 5,20%$ a.m. --- um juro
  alto que dificilmente seria percebido olhando só as prestações.
]

```python
def bisseccao(funcao, baixo, alto, passos=200):
    """Raiz de uma função contínua por bissecção (usada em vários capítulos)."""
    for _ in range(passos):
        meio = (baixo + alto) / 2
        if funcao(baixo) * funcao(meio) > 0:
            baixo = meio
        else:
            alto = meio
    return (baixo + alto) / 2

def vp_das_parcelas(taxa, parcela, n):
    return sum(parcela / (1 + taxa) ** t for t in range(1, n + 1))

taxa_do_emprestimo = bisseccao(lambda r: vp_das_parcelas(r, 8500, 4) - 30000, 1e-9, 1)
print(f"Taxa do empréstimo: {taxa_do_emprestimo*100:.4f}% a.m.")
```

#strong[A regra de ouro dos fluxos de caixa.] Só é possível #strong[somar,
subtrair ou comparar] valores que estejam na #strong[mesma data]. Dois
pagamentos de R\$ 1.000, um hoje e outro daqui a 12 meses, #strong[não
somam R\$ 2.000]; a 1% a.m., valem $1.000 + 1.000/1,01^12 = $ R\$ 1.887,45
em valores de hoje (ou R\$ 2.126,83 em valores de daqui a 12 meses). A data
escolhida para a comparação chama-se #strong[data focal]; o resultado de
qualquer problema não depende dela, desde que todos os valores sejam
levados para a mesma.

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- Juros Simples
#strong[Comparando com números.] A tabela mostra o montante de R\$ 1.000
aplicados a 10% por período nos dois regimes.

#table(
  columns: (12%, 29%, 29%, 30%),
  align: (center, right, right, right),
  table.header([$n$], [Montante simples], [Montante composto], [Diferença],),
  [0], [R\$ 1.000,00], [R\$ 1.000,00], [R\$ 0,00],
  [1], [R\$ 1.100,00], [R\$ 1.100,00], [R\$ 0,00],
  [2], [R\$ 1.200,00], [R\$ 1.210,00], [R\$ 10,00],
  [3], [R\$ 1.300,00], [R\$ 1.331,00], [R\$ 31,00],
  [4], [R\$ 1.400,00], [R\$ 1.464,10], [R\$ 64,10],
  [5], [R\$ 1.500,00], [R\$ 1.610,51], [R\$ 110,51],
)

#v(0.4em)
#strong[Tabela 1.1] --- R\$ 1.000 a 10% por período. Os dois regimes coincidem
em $n = 0$ e $n = 1$ e se separam a partir daí.

#teoria("por que o composto vence a partir do segundo período")[
  No regime simples, o ganho a cada período é #strong[constante em reais]
  ($J = "PV" dot i$). No composto, o ganho a cada período é #strong[constante
  em proporção ao saldo] (o saldo cresce $i%$ ao período), de modo que o
  ganho em reais cresce junto com o saldo. A prova algébrica usa o
  #strong[binômio de Newton]. Para $n$ inteiro,

  $ (1 + i)^n = 1 + n i + binom(n, 2) i^2 + binom(n, 3) i^3 + dots + i^n $

  Os dois primeiros termos, $1 + n i$, são exatamente o fator de
  capitalização #emph[simples]. Todos os termos restantes são positivos
  (para $i > 0$ e $n >= 2$); logo $(1 + i)^n > 1 + n i$. A diferença é o
  "juros sobre juros": $binom(n, 2) i^2$ é o juro do juro do 1º período
  incidindo sobre o 2º, e assim por diante.

  #strong[Para $0 < n < 1$ a desigualdade se inverte]: $(1 + i)^n < 1 + n i$
  (desigualdade de Bernoulli aplicada à função côncava $x |-> x^n$). Com
  $i = 10%$ e $n = 0,5$, o montante simples é R\$ 1.050,00 e o composto, R\$
  1.048,81. É a razão pela qual a convenção adotada para prazos fracionários
  importa (seção 3.5).
]

#mercado[
  #strong[Juros sobre juros é legal no Brasil?] Esse tema é recorrente em
  disputas judiciais. A Súmula 121 do STF veda a capitalização de juros
  ("anatocismo") ainda que pactuada; porém, a MP 2.170-36/2001 autorizou a
  capitalização em periodicidade inferior a um ano nas operações do Sistema
  Financeiro Nacional, e o STJ firmou entendimento (Súmulas 539 e 541) de
  que ela é válida quando expressamente pactuada --- bastando que a taxa
  anual contratada supere o duodécuplo da mensal. Na prática, todo crédito
  bancário no país é composto. Os juros #strong[simples] sobrevivem em
  situações específicas, como juros de mora e certos descontos de curtíssimo
  prazo. Como regras legais mudam, confirme a norma vigente antes de usá-la
  em qualquer contexto profissional.
]

#resumo[
  - O dinheiro tem preço no tempo por três razões: custo de oportunidade,
    inflação e risco. Só o primeiro é "juro puro".
  - Taxa e prazo devem estar na mesma unidade; valores só se somam na
    #strong[mesma data].
  - Simples = crescimento linear (PA); composto = exponencial (PG). Eles
    coincidem em $n = 1$; para $n > 1$ o composto é maior; para $0 < n < 1$
    o simples é maior.
  - Desenhar o fluxo de caixa --- do ponto de vista correto --- evita a
    maior parte dos erros.
]
%%% END
