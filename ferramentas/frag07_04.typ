%%% BEFORE: === 5.2. Análise Vertical e Horizontal
#intuicao[
  As três demonstrações são #strong[três ângulos da mesma empresa] e precisam
  "fechar" entre si: o lucro da DRE aumenta o patrimônio líquido no balanço, e a
  variação do caixa no balanço é explicada pela DFC. A pergunta mais útil que
  uma análise financeira faz é: #strong[por que o lucro não é igual ao caixa?]
  A resposta está nas diferenças de #emph[tempo] (vendas a prazo, estoques
  acumulados, compras a prazo) e de #emph[natureza] (depreciação não é saída
  de caixa; investimento em máquinas é saída de caixa que não passa pela DRE).
]

#exemplo("do lucro ao caixa: a DFC pelo método indireto")[
  Uma empresa teve lucro líquido de R\$ 100 mil no ano. Além disso: depreciação
  de R\$ 80 mil (despesa sem saída de caixa); contas a receber aumentaram R\$
  30 mil (vendeu, mas ainda não recebeu); estoques aumentaram R\$ 20 mil
  (comprou e não vendeu); fornecedores aumentaram R\$ 25 mil (comprou a
  prazo). Investiu R\$ 120 mil em máquinas, captou R\$ 50 mil de dívida e
  pagou R\$ 40 mil de dividendos.

  #figure(
    align(center)[#table(
      columns: (62%, 38%),
      align: (left, right),
      table.header([Item], [R\$ mil],),
      [Lucro líquido], [100],
      [(+) Depreciação (não é caixa)], [+80],
      [(−) Aumento de contas a receber], [−30],
      [(−) Aumento de estoques], [−20],
      [(+) Aumento de fornecedores], [+25],
      [#strong[= Caixa operacional (CFO)]], [#strong[155]],
      [(−) Investimento em máquinas (CapEx)], [−120],
      [#strong[= Caixa de investimento]], [#strong[−120]],
      [(+) Captação de dívida], [+50],
      [(−) Dividendos pagos], [−40],
      [#strong[= Caixa de financiamento]], [#strong[+10]],
      [#strong[Variação do caixa]], [#strong[+45]],
    )]
    , kind: table
    )

  Um lucro de R\$ 100 mil virou R\$ 155 mil de caixa operacional (por conta da
  depreciação e do crédito dos fornecedores), mas só R\$ 45 mil de variação
  de caixa líquida. Uma empresa pode ter lucro e quebrar por falta de caixa
  --- é a ideia central do capítulo 8 (capital de giro).
]

```python
lucro_l, deprec_l = 100, 80
d_receber, d_estoque, d_fornec = -30, -20, +25
capex_l, captacao_l, dividendos_l = -120, +50, -40

cfo = lucro_l + deprec_l + d_receber + d_estoque + d_fornec
cfi = capex_l
cff = captacao_l + dividendos_l
print(f"Caixa operacional (CFO)   : {cfo:>5}")
print(f"Caixa de investimento (CFI): {cfi:>5}")
print(f"Caixa de financiamento (CFF): {cff:>4}")
print(f"Variação líquida do caixa : {cfo + cfi + cff:>5}")
print(f"Conversão lucro -> caixa operacional: {cfo / lucro_l:.0%}")
```

%%% BEFORE: === 5.3. Indicadores de Liquidez
#exemplo("análise horizontal: crescimento e CAGR")[
  A análise #strong[horizontal] compara um mesmo item em vários períodos.
  Receita de R\$ 800 milhões (ano 1), 880 (ano 2), 990 (ano 3) e 1.100 (ano 4):

  - Variação ano a ano: $+10,0%$, $+12,5%$, $+11,1%$.
  - #strong[CAGR] (taxa composta de crescimento anual) em 3 anos:
    $(1.100/800)^(1\/3) - 1 = 11,2%$ a.a.

  Compare com a variação do custo e das despesas: se a receita cresce 11%
  e as despesas operacionais 15%, a margem está sendo comprimida mesmo
  que o lucro absoluto ainda suba. A análise #strong[vertical] (tudo como %
  da receita) mostra a estrutura num ano; a horizontal mostra a #emph[dinâmica].
]

```python
receita_h = [800, 880, 990, 1100]
variacoes = [receita_h[i + 1] / receita_h[i] - 1 for i in range(len(receita_h) - 1)]
cagr_h = (receita_h[-1] / receita_h[0]) ** (1 / (len(receita_h) - 1)) - 1
print("Variações anuais:", [f"{v:+.1%}" for v in variacoes])
print(f"CAGR em {len(receita_h) - 1} anos: {cagr_h:.2%} a.a.")
```

%%% BEFORE: === 5.4. Indicadores de Endividamento
#teoria("como interpretar a liquidez --- e quando ela engana")[
  Os quatro índices formam uma #strong[escada de rigor]: a liquidez corrente
  inclui estoques e outros itens de difícil conversão; a seca retira os estoques;
  a imediata considera só o caixa; a geral amplia para o longo prazo. Leitura
  típica:

  - #strong[Corrente alta, seca baixa:] o ativo circulante é composto de
    estoques --- a empresa depende de #emph[vender] para pagar as dívidas de curto
    prazo.
  - #strong[Imediata muito baixa] não é, sozinha, sinal de crise: muitas empresas
    saudáveis mantêm pouco caixa porque conseguem renovar linhas de crédito.
  - #strong[Os limites "ideais" (1,5 e 1,0) são convenções] que dependem do setor:
    varejo e supermercados operam com liquidez corrente abaixo de 1 de forma
    saudável (capítulo 8); indústria pesada precisa de mais folga.
]

#atencao[
  Liquidez alta pode esconder problemas: estoques obsoletos, contas a receber
  de clientes inadimplentes ou caixa "preso" (garantias, depósitos judiciais)
  inflam o ativo circulante sem poder pagar contas. Sempre pergunte
  #strong[qual é a qualidade] do ativo circulante, além de olhar a razão.
]

%%% BEFORE: === 5.5. Indicadores de Rentabilidade
#exemplo("dívida líquida e alavancagem operacional")[
  Mais usado por bancos e agências de rating que a razão Dívida/PL é a
  #strong[Dívida Líquida/EBITDA]: quantos anos de geração operacional de
  caixa seriam necessários para quitar a dívida líquida. Com dívida bruta de R\$
  900 milhões, caixa de R\$ 200 milhões e EBITDA de R\$ 300 milhões:

  $ "Dívida líquida"/"EBITDA" = (900 - 200)/300 = 2,33 "x" $

  Contratos de dívida (debêntures, empréstimos) costumam ter #strong[covenants]:
  cláusulas que obrigam a empresa a manter, por exemplo, Dívida Líquida/EBITDA
  abaixo de 3,0x e cobertura de juros acima de 2,0x --- a quebra do covenant
  permite aos credores exigir o vencimento antecipado da dívida.
]

```python
divida_bruta, caixa_l, ebitda_l = 900, 200, 300
print(f"Dívida líquida/EBITDA: {(divida_bruta - caixa_l) / ebitda_l:.2f}x")
print(f"Folga até o covenant de 3,0x: EBITDA pode cair até R${(divida_bruta - caixa_l) / 3:.1f} milhões "
      f"({1 - (divida_bruta - caixa_l) / 3 / ebitda_l:.0%} de queda)")
```

%%% BEFORE: === 5.6. Sistema DuPont
#teoria("a relação entre ROE, ROIC e alavancagem")[
  O ROE e o ROIC medem retornos sobre bases diferentes: o ROE sobre o capital
  #emph[do acionista]; o ROIC sobre #emph[todo] o capital investido (próprio + de
  terceiros). A ponte entre os dois é a alavancagem:

  $ "ROE" = "ROIC" + ("ROIC" - K_d (1 - "IR")) dot D/E $

  Se o retorno do negócio (ROIC) supera o custo líquido da dívida, cada real
  tomado emprestado #strong[eleva] o ROE; se não supera, #strong[reduz]. Com
  ROIC = 15%, $K_d = 12%$, IR de 34% e $D/E = 0,8$, o ROE é
  $15% + (15% - 7,92%) times 0,8 = 20,7%$ --- a alavancagem acrescenta 5,7
  pontos. Por isso um ROE alto sozinho não prova qualidade: pode ser só dívida.
  O ROIC é o indicador mais limpo da qualidade do #emph[negócio].

  #strong[Definições práticas.] $"NOPAT" = "EBIT" (1 - "IR")$ (o lucro operacional
  após impostos, como se não houvesse dívida). O #strong[capital investido] é a
  soma de capital de giro operacional líquido e ativo fixo (ou, equivalentemente,
  dívida líquida + patrimônio líquido).
]

%%% BEFORE: === 5.7. EBITDA e EBITDA Ajustado
#teoria("DuPont estendido: cinco componentes")[
  O DuPont de três fatores esconde o efeito dos impostos e dos juros. Decompor
  em cinco:

  $ "ROE" = underbrace("LL"/"LAIR", "carga tributária") times underbrace("LAIR"/"EBIT", "carga de juros")
  times underbrace("EBIT"/"Receita", "margem EBIT") times underbrace("Receita"/"Ativo", "giro")
  times underbrace("Ativo"/"PL", "alavancagem") $

  Exemplo: LL = 90, LAIR = 130, EBIT = 170, Receita = 1.500, Ativo = 1.000,
  PL = 500. Os fatores são: $90/130 = 0,692$ (a empresa fica com 69,2% do
  lucro antes de impostos), $130/170 = 0,765$ (os juros consomem 23,5% do
  EBIT), margem EBIT de 11,33%, giro de 1,5x e alavancagem de 2,0x. Produto:
  $0,692 times 0,765 times 11,33% times 1,5 times 2,0 = 18,0%$, igual a $90/500$.
  A vantagem do modelo estendido é separar o que a gestão controla
  (margem e giro), o que depende da estrutura de capital (juros e alavancagem)
  e o que é fiscal.
]

```python
ll_d, lair_d, ebit_d, rec_d, ativo_d, pl_d = 90, 130, 170, 1500, 1000, 500
fatores = {
    "Carga tributária (LL/LAIR)": ll_d / lair_d,
    "Carga de juros (LAIR/EBIT)": lair_d / ebit_d,
    "Margem EBIT (EBIT/Receita)": ebit_d / rec_d,
    "Giro do ativo (Receita/Ativo)": rec_d / ativo_d,
    "Alavancagem (Ativo/PL)": ativo_d / pl_d,
}
roe_5 = 1.0
for nome_f, f_ in fatores.items():
    roe_5 *= f_
    print(f"{nome_f:<32} {f_:8.4f}   ROE acumulado: {roe_5:.2%}")
print(f"ROE direto (LL/PL): {ll_d / pl_d:.2%}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Estrutura de Capital
#exemplo("EBITDA não é caixa: duas empresas com o mesmo EBITDA")[
  A e B têm EBITDA de R\$ 300 milhões. A é um negócio de serviços, com CapEx de
  R\$ 50 milhões por ano; B é uma siderúrgica, com CapEx de R\$ 250 milhões.
  Ignorando variação do capital de giro e impostos, o caixa disponível
  após investimentos é $300 - 50 = 250$ para A e $300 - 250 = 50$ para B.
  Com o mesmo EBITDA, A gera #strong[cinco vezes mais caixa] para pagar dívidas e
  dividendos. Por isso, em setores de capital intensivo, o indicador
  #strong[EBITDA − CapEx] (ou o fluxo de caixa livre) é mais honesto que o EBITDA.
]

#atencao[
  #strong[EBITDA "ajustado" é opinião.] Cada empresa define seus ajustes (itens
  não recorrentes, despesas com remuneração em ações, custos de
  reestruturação). Antes de comparar, verifique o que foi excluído e se os
  ajustes "não recorrentes" se repetem todos os anos. A regulamentação
  da CVM exige a divulgação da conciliação entre EBITDA e lucro líquido, o que
  facilita o escrutínio.
]

#resumo[
  - As três demonstrações precisam fechar entre si; a DFC explica por que lucro #strong[não é] caixa.
  - Análise vertical (estrutura) e horizontal (dinâmica, CAGR).
  - Liquidez, endividamento e rentabilidade devem ser lidos #strong[por setor] e pela qualidade dos ativos.
  - $"ROE" = "ROIC" + ("ROIC" - K_d(1 - "IR")) D/E$: a alavancagem amplifica o retorno só se o ROIC supera o $K_d$ líquido.
  - DuPont estendido separa carga fiscal, juros, margem, giro e alavancagem.
  - EBITDA ignora CapEx, capital de giro, impostos e juros: não é fluxo de caixa.
]
%%% END
