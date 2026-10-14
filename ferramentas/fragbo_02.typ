%%% BEFORE: == 3.2 Fórmulas e funções essenciais
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

#atencao[
  #strong[Nunca "force" uma conversão que esconde o erro.] O `errors="coerce"` transforma o
  lixo em vazio de propósito, para que a contagem de nulos o denuncie. Sumir com a linha
  problemática em silêncio gera um total errado que ninguém percebe.
]

%%% BEFORE: == 3.3 PROCX, SOMASES, CONT.SES e funções condicionais
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

%%% BEFORE: == 3.4 Tabelas dinâmicas
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

%%% BEFORE: == 3.5 Power Query
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

%%% BEFORE: == 3.6 Relatórios e dashboards
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

%%% BEFORE: === Exercícios do Módulo 3
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

%%% BEFORE: == 4.2 Análise de rentabilidade
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

%%% BEFORE: == 4.3 Alocação de ativos
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

#atencao[
  A atribuição por "peso inicial × retorno" é uma #strong[aproximação] (ignora a interação entre mudança de
  pesos e retorno, e os fluxos no meio do período). Para relatórios formais, usam-se métodos como o
  de Brinson, que separam o efeito da #emph[alocação] (estar mais em uma classe) do da #emph[seleção]
  (escolher melhores ativos dentro da classe).
]

%%% BEFORE: == 4.4 Indicadores de risco e desempenho
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

#intuicao[
  O HHI "traduz" a carteira em um número de ativos equivalentes: aqui, cerca de 3,8 ativos de peso igual,
  embora haja cinco. Isso ajuda a conversar com o cliente: ele pode ter muitos ativos e, ainda assim,
  pouca diversificação. #strong[O risco de crédito e de liquidez de um único CRI não aparece na
  volatilidade] --- por isso a concentração por emissor é um indicador à parte.
]

%%% BEFORE: == 4.5 Interpretação de informações financeiras
#teoria("volatilidade, Sharpe, drawdown, tracking error e VaR: o que cada um diz")[
  - #strong[Volatilidade anualizada:] desvio padrão dos retornos mensais multiplicado por $sqrt(12)$ (se os retornos
    são independentes, a variância soma).
  - #strong[Sharpe:] $(R_p - R_f)/sigma_p$ --- retorno excedente ao CDI por unidade de volatilidade. Para
    carteiras de renda fixa com volatilidade muito baixa, o denominador pequeno torna o Sharpe instável.
  - #strong[Drawdown máximo:] maior queda do pico ao vale; mede a "dor" da pior fase.
  - #strong[Tracking error:] desvio padrão da #emph[diferença] entre a carteira e o benchmark; mede o quanto a
    carteira se afasta dele. Quem quer replicar o índice busca TE baixo.
  - #strong[VaR paramétrico:] $"VaR" = z dot sigma_h dot "Patrimônio"$, com $z = 1,645$ (95%) e
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

%%% BEFORE: === Exercícios do Módulo 4
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

#atencao[
  Um comentário gerado automaticamente é um #strong[rascunho]: a parte de "causa" exige interpretação
  (cenário de juros, notícias do setor) que o código não produz. Revise sempre antes de enviar ao cliente.
]

%%% END
