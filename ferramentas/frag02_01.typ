%%% BEFORE_CHAPTER_END: == Capítulo 1 --- O que é pandas e por que ele existe
#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria, exemplos executados com dados reais e armadilhas, com foco em economia]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
Esta é a segunda apostila da série. Ela pressupõe a #strong[Apostila 1] (listas, dicionários,
funções, tratamento de erro) e ensina a trabalhar com #strong[tabelas] --- a estrutura em que quase
todo dado econômico vive. Em cada capítulo, o conteúdo original ganha, ao final, um bloco de
#strong[aprofundamento] com exemplos #emph[executados] (os resultados impressos vêm da execução do código) e,
sempre que possível, #strong[dados reais deste repositório]: a Selic meta diária (`selic_meta.json`), o IPCA
acumulado em 12 meses (`ipca_12m.json`), a abertura do IPCA por grupos (`ipca_abertura_grupos.csv`) e a
série da regra de Taylor (`taylor_rule_series.csv`). Rode os blocos na pasta do repositório para reproduzir.

#exemplo("modelo")[Um exemplo executado e comentado.]

#intuicao[A ideia por trás da operação, sem jargão.]

#teoria("modelo")[O que acontece "por baixo": modelo mental preciso.]

#atencao[Um erro clássico (de iniciante e de veterano distraído).]

#mercado[Como o conceito aparece no trabalho de um economista.]

#atencao[
  #strong[Versão do pandas.] Os resultados desta apostila foram gerados com o #strong[pandas 2.2]. O
  pandas 3.0 mudou três comportamentos relevantes: (1) o #strong[Copy-on-Write] passou a ser o padrão ---
  a indexação encadeada deixa de funcionar e o `SettingWithCopyWarning` some (capítulo 5); (2) o tipo padrão
  de texto passou a ser um `str` dedicado em vez de `object`; (3) alguns apelidos de frequência
  (`"M"`, `"Q"`, `"A"`) foram substituídos por `"ME"`, `"QE"`, `"YE"`. Se seu resultado diferir em algum
  detalhe (tipo `str` no lugar de `object`, por exemplo), verifique com `pd.__version__`.
]
%%% END

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- Criando DataFrames e lendo dados reais
#teoria("por que pandas é rápido: arrays tipados, vetorização e broadcasting")[
  Uma lista Python guarda #emph[referências] a objetos espalhados na memória; um array NumPy guarda os
  valores #strong[contíguos] e de #strong[um único tipo] (`dtype`). Operar sobre o array inteiro de uma só vez
  (#strong[vetorização]) delega o laço a código compilado, centenas de vezes mais rápido que o `for` do Python.
  O #strong[broadcasting] estende operações entre arrays de formatos diferentes (por exemplo, subtrair a média de
  cada coluna). O argumento `axis` indica #emph[em que direção] operar: `axis=0` percorre as #emph[linhas] (resulta uma
  linha por coluna); `axis=1`, as #emph[colunas]. Todo `Series` é um array com rótulos; todo `DataFrame`, um conjunto
  de colunas-array de mesmo comprimento.
]

```python
precos = np.array([100.0, 104.0, 109.2, 113.6])
deflator = np.array([1.00, 1.02, 1.05, 1.08])
print(f"ndarray de 1 milhão de inteiros: {np.arange(1_000_000).nbytes:,} bytes (dtype {np.arange(3).dtype})")
print("Preços reais, vetorizado (sem laço):", np.round(precos / deflator, 2))

m = np.array([[1, 2, 3], [4, 5, 6]])
print("soma axis=0 (uma por coluna):", m.sum(axis=0), "| axis=1 (uma por linha):", m.sum(axis=1))
print("broadcasting (matriz - média da coluna):")
print(m - m.mean(axis=0))
```

#atencao[
  #strong[Operações entre tipos diferentes alteram o `dtype`.] Uma coluna de inteiros com um único `NaN` vira
  `float64`, porque `NaN` é um float; somar `True`/`False` conta verdadeiros. Quando o resultado de uma conta
  parecer estranho, a primeira checagem é `.dtype`.
]

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- Explorando e entendendo a estrutura dos dados
#exemplo("laboratório de `read_csv`: um arquivo \"à brasileira\" lido do jeito certo")[
  Arquivos brasileiros costumam usar `;` como separador, vírgula decimal, ponto de milhar, datas `dd/mm/aaaa` e
  marcadores de ausente como `N/D`. Cada convenção tem um parâmetro:

  #figure(
    align(center)[#table(
      columns: (26%, 74%),
      align: (left, left),
      table.header([Parâmetro], [Para quê],),
      [`sep=";"`], [Separador de colunas],
      [`decimal=","` e `thousands="."`], [Números no padrão brasileiro],
      [`parse_dates=[...]` e `dayfirst=True`], [Converter colunas em datas, com dia antes do mês],
      [`na_values=["N/D", "-"]`], [Textos que significam "ausente"],
      [`usecols=[...]`, `nrows=N`], [Ler só algumas colunas ou linhas (arquivos grandes)],
      [`dtype={"col": "string"}`], [Forçar o tipo de uma coluna],
      [`encoding="latin-1"`], [Arquivos antigos em codificação não UTF-8],
      [`skiprows=N`, `header=...`], [Pular linhas de título e escolher o cabeçalho],
    )]
    , kind: table
    )
]

```python
from io import StringIO
csv_br = """Data;Estado;PIB (R$ mi);Obs
31/03/2025;SP;"2.345,6";ok
31/03/2025;RJ;"1.020,5";
30/06/2025;SP;"2.401,0";revisado
30/06/2025;RJ;N/D;ok"""
ingenuo = pd.read_csv(StringIO(csv_br))
correto = pd.read_csv(StringIO(csv_br), sep=";", decimal=",", thousands=".", parse_dates=["Data"],
                      dayfirst=True, na_values=["N/D"], dtype={"Estado": "string"})
print("Leitura ingênua -> colunas:", list(ingenuo.columns))
print(correto)
print(correto.dtypes)
```

#exemplo("lendo um JSON de API (a Selic meta diária do Banco Central)")[
  Séries do BCB chegam como lista de registros com a data (`"dd/mm/aaaa"`) e o valor como #emph[texto]. O padrão é: ler,
  converter a data (indicando o formato), converter o valor para número e usar a data como #strong[índice]:
]

```python
selic_d = pd.read_json("selic_meta.json", dtype=False)
selic_d["data"] = pd.to_datetime(selic_d["data"], format="%d/%m/%Y")
selic_d["valor"] = pd.to_numeric(selic_d["valor"])
selic_d = selic_d.set_index("data")["valor"].rename("selic_meta")
print(f"{len(selic_d)} dias | de {selic_d.index.min():%d/%m/%Y} a {selic_d.index.max():%d/%m/%Y}")
print(selic_d.tail(3))

ipca12 = pd.read_json("ipca_12m.json", dtype=False)
ipca12["data"] = pd.to_datetime(ipca12["data"], format="%d/%m/%Y")
ipca12 = ipca12.set_index("data")["valor"].astype(float).rename("ipca_12m")
print(f"IPCA 12m: {len(ipca12)} meses | último: {ipca12.iloc[-1]:.2f}% em {ipca12.index[-1]:%m/%Y}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Seleção de dados: `[]`, `.loc`, `.iloc`, `.at`, `.iat`
#exemplo("receita de diagnóstico de uma base nova (abertura do IPCA por grupos)")[
  Antes de qualquer análise, a rotina de cinco comandos: #emph[formato, tipos, memória, resumo estatístico e
  nulos]. Aplicada ao arquivo `ipca_abertura_grupos.csv` (acumulado em 12 meses por grupo de preços):
]

```python
grupos = pd.read_csv("ipca_abertura_grupos.csv", parse_dates=["data"], index_col="data")
print("Formato:", grupos.shape, "| período:", grupos.index.min().strftime("%m/%Y"), "a", grupos.index.max().strftime("%m/%Y"))
grupos.info()
print("\nResumo estatístico:")
print(grupos.describe().round(2).T[["mean", "std", "min", "max"]].to_string())
print(f"\nNulos por coluna: {grupos.isna().sum().to_dict()}")
print(f"Memória: {grupos.memory_usage(deep=True).sum():,} bytes")
```

#teoria("tipos do pandas: `object`, `category`, tipos anuláveis e economia de memória")[
  Colunas de texto vêm como `object` (referências a strings Python), que ocupam muita memória e são lentas. Se a
  coluna tem #strong[poucos valores distintos repetidos] (região, setor, rating), o tipo `category` guarda cada valor distinto
  #emph[uma vez] e um código inteiro por linha --- grande economia e ordenação lógica possível. Os tipos
  #strong[anuláveis] (`Int64`, `boolean`, `string`) aceitam ausentes sem converter para `float` (inteiros com `NaN`
  viram `float64` nos tipos clássicos). `convert_dtypes()` escolhe automaticamente os tipos mais adequados.
]

```python
rating = pd.Series(["AAA", "AA", "A", "BBB"] * 25_000, name="rating")
rating_cat = rating.astype("category")
print(f"object   : {rating.memory_usage(deep=True):>10,} bytes")
print(f"category : {rating_cat.memory_usage(deep=True):>10,} bytes ({1 - rating_cat.memory_usage(deep=True) / rating.memory_usage(deep=True):.0%} menos)")

com_nulo = pd.Series([1, 2, None, 4])
print("Série com ausente:", com_nulo.dtype, "| com tipo anulável:", com_nulo.astype("Int64").dtype, "->", com_nulo.astype("Int64").tolist())
```

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Cópia vs.~view: o `SettingWithCopyWarning`
#exemplo("seleção por rótulo e por posição em uma série temporal real")[
  Com a Selic meta diária indexada por data, a diferença entre `.loc` (rótulos, extremo #emph[inclusivo]) e `.iloc`
  (posições, extremo #emph[exclusivo]) fica concreta --- e o fatiamento por data aceita strings parciais:
]

```python
print("loc  ('2025-12-30':'2026-01-02'), os dois extremos incluídos:")
print(selic_d.loc["2025-12-30":"2026-01-02"].to_string())
print("\niloc [0:3], três primeiras posições (fim exclusivo):")
print(selic_d.iloc[0:3].to_string())
print("\nFatiamento por ano inteiro e por mês:", len(selic_d.loc["2025"]), "dias em 2025 |", len(selic_d.loc["2026-03"]), "dias em mar/2026")
print("Valor num único dia (.at):", selic_d.at[pd.Timestamp("2026-09-16")])

mudancas = selic_d[selic_d.diff().fillna(0) != 0]
print(f"\nA meta mudou {len(mudancas)} vezes no período; as últimas:")
print(mudancas.tail(4).to_string())
print(f"Máxima: {selic_d.max()}% (primeira vez em {selic_d.idxmax():%d/%m/%Y}) | mínima: {selic_d.min()}%")
```

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Filtragem booleana
#teoria("Copy-on-Write: por que o aviso existe e como o pandas 3.0 o elimina")[
  Quando você escreve `df[mascara]["col"] = 0`, são #emph[duas] operações: primeiro `df[mascara]` produz um
  objeto (que pode ser uma #emph[cópia] ou uma #emph[visão] dos dados originais --- o pandas 2.x não garante qual);
  depois o `["col"] = 0` altera #emph[esse objeto intermediário], que muitas vezes é descartado. Daí o aviso. A regra de
  ouro (capítulo 5): faça a seleção e a atribuição numa só chamada, `df.loc[mascara, "col"] = 0`, ou use `.copy()`
  explícito. O #strong[Copy-on-Write] (CoW) elimina a ambiguidade: toda seleção se comporta como cópia, e a cópia
  real é adiada até a primeira modificação. No pandas 2.2 é possível ativá-lo para testar (`mode.copy_on_write`); no
  3.0 é o padrão.
]

```python
import warnings
base_cow = pd.DataFrame({"pais": ["Brasil", "Chile", "Peru"], "pib": [2.2, 3.1, 2.5]})

with warnings.catch_warnings(record=True) as avisos:
    warnings.simplefilter("always")
    sub = base_cow[base_cow["pib"] > 2.3]          # pode ser cópia ou visão: o pandas não promete
    sub["pib"] = 0                          # modifica o objeto intermediário
print("Sem CoW, avisos emitidos:", [a.category.__name__ for a in avisos])
print("Base original após a atribuição encadeada:\n", base_cow.to_string(), sep="")

with pd.option_context("mode.copy_on_write", True):
    base2 = pd.DataFrame({"pais": ["Brasil", "Chile", "Peru"], "pib": [2.2, 3.1, 2.5]})
    sub2 = base2[base2["pib"] > 2.3].copy()
    sub2["pib"] = 0
    base2.loc[base2["pib"] > 2.3, "pib"] = 99      # forma correta, em uma só chamada
print("\nCom CoW e atribuição por .loc:\n", base2.to_string(), sep="")
```

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Criando, transformando e removendo colunas
#exemplo("filtros úteis: `isin`, `between`, `str.contains`, `~` e `query` com variáveis")[
  Sobre a abertura do IPCA (acumulado em 12 meses). Cada filtro devolve uma #strong[máscara booleana]; combinam-se
  com `&`, `|` e `~` (negação), sempre entre parênteses:
]

```python
meta = 4.5
acima_teto = grupos[grupos["IPCA cheio"] > meta]
servicos_acima = grupos.query("Servicos > `IPCA cheio`")                 # crase para colunas com espaço
faixa = grupos[grupos["IPCA cheio"].between(3.0, 4.5)]
print(f"Meses com IPCA 12m acima do teto ({meta}%): {len(acima_teto)} de {len(grupos)}")
print(f"Serviços acima do IPCA cheio: {len(servicos_acima)} meses | IPCA entre a meta e o teto: {len(faixa)} meses")
inflacao_serv_e_livres = grupos[(grupos["Servicos"] > 5) & ~(grupos["Administrados"] < 0)]
print("Serviços > 5% e administrados NÃO negativos:", len(inflacao_serv_e_livres), "meses")

nomes = pd.Series(["Banco Alfa", "Cia Beta", "Banco Gama", None])
print("str.contains('Banco'):", nomes.str.contains("Banco", na=False).tolist(), "| isin:", nomes.isin(["Cia Beta"]).tolist())
limite = 5.0                                                             # variável externa na query com @
print("query com @limite:", len(grupos.query("Servicos > @limite")), "meses")
```

#atencao[
  #strong[`NaN` não é igual a nada, nem a si mesmo.] `df["x"] == np.nan` devolve sempre `False`: use `isna()`. E
  `and`/`or` em máscaras provocam o erro de "valor de verdade ambíguo": use `&`, `|` com parênteses, porque o operador
  `&` tem #emph[precedência maior] que `>`.
]

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Dados faltantes (`NaN`) em profundidade
#exemplo("classificar em faixas: `pd.cut`, `rank`, `clip` e `where`")[
  O IPCA acumulado em 12 meses, classificado em relação ao regime de metas (meta de 3% com tolerância de 1,5 ponto
  percentual para cima e para baixo --- o intervalo de 1,5% a 4,5%):
]

```python
faixas = pd.cut(ipca12, bins=[-np.inf, 1.5, 3.0, 4.5, np.inf],
                labels=["abaixo do piso", "entre piso e meta", "entre meta e teto", "acima do teto"])
print(faixas.value_counts(sort=False).to_string())
print("\nRanking (1 = IPCA mais alto) dos 3 maiores:", ipca12.rank(ascending=False).nsmallest(3).index.strftime("%m/%Y").tolist())
print("Limitado entre 3 e 5 (clip) - min/max:", ipca12.clip(3, 5).min(), ipca12.clip(3, 5).max())
print("where (valor ou 'NaN' fora da banda):", ipca12.where(ipca12.between(1.5, 4.5)).isna().sum(), "meses fora da banda")

texto = pd.Series(["2024-Q1: 3.2%", "2024-Q2: 2.9%", "2024-Q3: n/d"])
print(texto.str.extract(r"(\d{4})-Q(\d): ([\d.]+)%").rename(columns={0: "ano", 1: "tri", 2: "valor"}).to_string())
```

%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Agrupamento (`groupby`)
#teoria("por que os dados faltam: MCAR, MAR e MNAR")[
  O tratamento certo depende de #emph[por que] o dado está faltando:

  - #strong[MCAR] (missing completely at random): a ausência não depende de nada (falha de sensor). Descartar linhas ou
    imputar a média quase não enviesa.
  - #strong[MAR] (missing at random): depende de outra variável #emph[observada] (pessoas jovens respondem menos a um item).
    Imputação condicional (por grupo) funciona.
  - #strong[MNAR] (missing not at random): depende do próprio valor ausente (quem tem renda alta omite a renda).
    Nenhuma técnica simples resolve; o viés é inevitável e deve ser reportado.

  Em séries temporais há uma pergunta extra: a série é um #strong[fluxo suave] (câmbio, onde interpolar faz sentido) ou
  um #strong[degrau] (meta da Selic, que muda em reuniões, e onde preencher com o último valor é o certo)?
]

```python
rng = np.random.default_rng(3)
verdadeira = selic_d.loc["2025-01-01":"2025-12-31"]
com_buracos = verdadeira.copy()
com_buracos[rng.random(len(com_buracos)) < 0.2] = np.nan                      # 20% de buracos aleatórios (MCAR)
metodos = {
    "ffill (último valor)": com_buracos.ffill(),
    "interpolate (linear)": com_buracos.interpolate(),
    "dropna (descartar)": com_buracos.dropna(),
}
print(f"Buracos: {com_buracos.isna().sum()} de {len(com_buracos)} | média verdadeira: {verdadeira.mean():.4f}")
for nome_m, serie_m in metodos.items():
    erro = (serie_m.reindex(verdadeira.index) - verdadeira).abs().mean()
    print(f"{nome_m:<22} média = {serie_m.mean():.4f} | erro absoluto médio por dia = {erro:.4f}")
```

#intuicao[
  A Selic meta é um #strong[degrau]: o último valor conhecido é, quase sempre, o valor verdadeiro, e `ffill` acerta. A
  interpolação linear "inventa" valores intermediários entre dois degraus --- um erro pequeno, mas que não existe na realidade.
  Conhecer o #emph[processo gerador] do dado é o que decide a técnica; o código só a executa.
]

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Combinando tabelas: `merge`, `concat`, `join`
#exemplo("agrupar por período: `Grouper`, `size` × `count`, `crosstab` e ranking dentro do grupo")[
  Sobre a Selic diária (mudando a #emph[base] do agrupamento de país para #emph[tempo]):
]

```python
por_trimestre = selic_d.groupby(pd.Grouper(freq="QE")).agg(media="mean", minimo="min", maximo="max", dias="size")
print(por_trimestre.tail(4).round(2).to_string())

mudancas_ano = (selic_d.diff().fillna(0) != 0).groupby(selic_d.index.year).sum()      # conta mudanças de meta por ano
print("Mudanças da meta por ano:", mudancas_ano.to_dict())

df_g = pd.DataFrame({"setor": ["Energia", "Energia", "Varejo", "Varejo", "Varejo"],
                     "uf": ["CE", "SP", "CE", "SP", "SP"],
                     "receita": [10.0, 12.0, 8.0, np.nan, 9.0]})
print("\nsize (inclui NaN):", df_g.groupby("setor").size().to_dict(), "| count (ignora NaN):", df_g.groupby("setor")["receita"].count().to_dict())
print(pd.crosstab(df_g["setor"], df_g["uf"]).to_string())
df_g["rank_no_setor"] = df_g.groupby("setor")["receita"].rank(ascending=False)
print(df_g.to_string())
```

%%% BEFORE_CHAPTER_END: == Capítulo 11 --- Datas e séries temporais
#teoria("a explosão de linhas no merge muitos-para-muitos")[
  O `merge` cria uma linha para #emph[cada combinação] de linhas que compartilham a chave. Se a chave se repete nas duas
  tabelas, o resultado tem #strong[$m times n$ linhas por chave] --- e é um dos erros silenciosos mais graves em
  análise de dados: totais que multiplicam sem aviso. Antes de qualquer merge, confira a #emph[cardinalidade] das chaves
  (`df["chave"].is_unique`) e o número de linhas depois.
]

```python
tab_a = pd.DataFrame({"pais": ["BR", "BR", "CL"], "ano": [2024, 2025, 2025], "pib": [3.1, 2.2, 3.1]})
tab_b = pd.DataFrame({"pais": ["BR", "BR", "CL"], "evento": ["eleição", "chuvas", "plebiscito"]})
print(f"chave única em a? {tab_a['pais'].is_unique} | em b? {tab_b['pais'].is_unique}")
explodido = tab_a.merge(tab_b, on="pais")
print(f"a tem {len(tab_a)} linhas, b tem {len(tab_b)}, merge tem {len(explodido)} (BR aparece 2 x 2 = 4 vezes):")
print(explodido.to_string(index=False))
```

#exemplo("`merge_asof`: juntando uma série diária com uma mensal pela data mais recente")[
  Selic (diária) e IPCA 12m (mensal) têm frequências diferentes. O `merge_asof` associa, a cada linha de uma
  tabela, a observação #emph[mais recente anterior] da outra --- sem reamostrar nada:
]

```python
diaria = selic_d.reset_index()
mensal = ipca12.reset_index()
casado = pd.merge_asof(diaria, mensal, on="data", direction="backward")
print(casado.dropna().tail(4).to_string(index=False))
ex_post = (1 + casado["selic_meta"] / 100) / (1 + casado["ipca_12m"] / 100) - 1
print(f"Juro real ex-post (Fisher) no último dia: {ex_post.iloc[-1] * 100:.2f}% a.a. (Selic {casado['selic_meta'].iloc[-1]}%, IPCA 12m {casado['ipca_12m'].iloc[-1]}%)")
```

%%% BEFORE_CHAPTER_END: == Capítulo 12 --- Estatística descritiva com pandas
#exemplo("`Period`, trimestres, dias úteis, `shift` por frequência e média móvel exponencial")[
  O pandas distingue o #emph[instante] (`Timestamp`) do #emph[período] (`Period`: "março de 2026" inteiro). Períodos
  facilitam agrupar por mês ou trimestre; `CustomBusinessDay` modela calendários com feriados:
]

```python
datas = pd.Series(pd.to_datetime(["2026-01-15", "2026-04-02", "2026-09-30"]))
print("Período mensal:", datas.dt.to_period("M").astype(str).tolist(), "| trimestre:", datas.dt.quarter.tolist(),
      "| dia da semana:", datas.dt.day_name().tolist())

feriados = pd.to_datetime(["2026-04-03", "2026-04-21"])                  # Sexta-feira Santa e Tiradentes
dia_util = pd.offsets.CustomBusinessDay(holidays=feriados)
print("Dias úteis de 30/03 a 24/04 de 2026:", len(pd.date_range("2026-03-30", "2026-04-24", freq=dia_util)),
      "(sem feriados seriam", len(pd.date_range("2026-03-30", "2026-04-24", freq="B")), ")")

serie_m = ipca12.loc["2025-06":"2026-03"]
print("shift(1) traz o valor do período anterior; ewm pesa mais os valores recentes:")
print(pd.DataFrame({"valor": serie_m, "posicao_-1": serie_m.shift(1), "ewm(span=3)": serie_m.ewm(span=3).mean().round(2)}).head(4).to_string())
```

#intuicao[
  A média móvel simples (`rolling`) pesa igualmente as últimas $n$ observações e descarta as anteriores de um golpe; a
  #strong[exponencial] (`ewm`) dá peso decrescente a todas, sem corte brusco, e reage mais rápido a mudanças recentes.
  Escolha pelo uso: suavizar uma série (rolling) ou acompanhar uma tendência que muda (ewm).
]

%%% BEFORE_CHAPTER_END: == Capítulo 13 --- Exportando dados e um script completo do mundo real
#teoria("quantis, assimetria, curtose e outliers")[
  A média resume mal distribuições assimétricas ou com caudas gordas; os #strong[quantis] descrevem a forma sem depender de
  extremos. O #strong[IQR] (intervalo interquartil, $Q_3 - Q_1$) define cercas para outliers: valores fora de
  $[Q_1 - 1,5 "IQR", Q_3 + 1,5 "IQR"]$ merecem inspeção. A #strong[assimetria] (`skew`) mede se a cauda direita
  ($> 0$) ou esquerda ($< 0$) é mais longa; a #strong[curtose] (`kurt`, excesso sobre a normal) mede o peso das caudas.
]

```python
amostra = grupos["Servicos"]
q1, q2, q3 = amostra.quantile([0.25, 0.5, 0.75])
iqr = q3 - q1
cercas = (q1 - 1.5 * iqr, q3 + 1.5 * iqr)
outliers = amostra[(amostra < cercas[0]) | (amostra > cercas[1])]
print(f"Serviços (12m): média {amostra.mean():.2f} | mediana {q2:.2f} | Q1 {q1:.2f} | Q3 {q3:.2f} | IQR {iqr:.2f}")
print(f"Cercas de outlier: ({cercas[0]:.2f}, {cercas[1]:.2f}) | outliers: {len(outliers)} | assimetria {amostra.skew():.2f} | curtose {amostra.kurt():.2f}")
z = (amostra - amostra.mean()) / amostra.std()
print(f"Maior |z|: {z.abs().max():.2f} (em {z.abs().idxmax():%m/%Y})")
```

#exemplo("correlação de Pearson × Spearman e o paradoxo de Simpson")[
  A correlação de Pearson mede associação #emph[linear]; a de Spearman, associação #emph[monotônica] (usa postos, é robusta a
  outliers). E uma correlação calculada sobre a base inteira pode #emph[inverter o sinal] dentro de cada subgrupo --- o
  #strong[paradoxo de Simpson], armadilha clássica em comparações entre regiões:
]

```python
xs = pd.Series([1, 2, 3, 4, 5, 6, 7, 8, 9, 100])
ys = pd.Series([2, 4, 5, 4, 5, 7, 8, 9, 10, 11])
print(f"Com um outlier -> Pearson {xs.corr(ys):.2f} | Spearman {xs.corr(ys, method='spearman'):.2f}")

simpson = pd.DataFrame({
    "grupo": ["A"] * 4 + ["B"] * 4,
    "x": [1, 2, 3, 4, 8, 9, 10, 11],
    "y": [9, 8, 7, 6, 20, 19, 18, 17],
})
grupo_a, grupo_b = simpson[simpson["grupo"] == "A"], simpson[simpson["grupo"] == "B"]
print(f"Correlação geral: {simpson['x'].corr(simpson['y']):+.2f} (positiva) | dentro do grupo A: "
      f"{grupo_a['x'].corr(grupo_a['y']):+.2f} | dentro do B: {grupo_b['x'].corr(grupo_b['y']):+.2f} (ambas negativas)")
```

#atencao[
  Correlação #strong[não é causalidade]. Duas séries que crescem no tempo (PIB e número de celulares) têm correlação alta
  sem nenhuma relação causal --- a #strong[correlação espúria]. Séries temporais devem ser comparadas em #emph[variações]
  (diferenças ou taxas), não em níveis (Apostila 4).
]

%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Boas práticas com pandas
#exemplo("mini-projeto: lendo a regra de Taylor da Selic com pandas")[
  O repositório guarda a série `taylor_rule_series.csv` gerada pelo script `taylor_rule_selic.py`: a Selic meta, o IPCA 12m, a meta
  de inflação, a taxa neutra $r^*$, a Selic #emph[implícita] pela regra de Taylor e a diferença entre elas. O pipeline de um
  analista --- ler, conferir, resumir, salvar --- usa quase tudo da apostila:
]

```python
import tempfile, os
tay = pd.read_csv("taylor_rule_series.csv", parse_dates=["data"], index_col="data")
assert tay.index.is_monotonic_increasing and not tay.isna().any().any(), "base inconsistente"          # validação
print(f"{len(tay)} meses | colunas: {list(tay.columns)}")

tay["selic_acima"] = tay["gap_pp"] > 0                                      # Selic acima do que a regra sugere?
resumo = tay.groupby(tay.index.year).agg(gap_medio=("gap_pp", "mean"), pct_meses_acima=("selic_acima", "mean"),
                                         selic_media=("selic", "mean"), taylor_media=("taylor_selic", "mean"))
resumo["pct_meses_acima"] = (resumo["pct_meses_acima"] * 100).round(0)
print(resumo.round(2).to_string())
print(f"\nCorrelação Selic x Taylor: {tay['selic'].corr(tay['taylor_selic']):.2f} | último gap: {tay['gap_pp'].iloc[-1]:+.2f} p.p.")

with tempfile.TemporaryDirectory() as pasta:
    caminho = os.path.join(pasta, "resumo_taylor.csv")
    resumo.to_csv(caminho, sep=";", decimal=",")                            # formato brasileiro
    relido = pd.read_csv(caminho, sep=";", decimal=",", index_col=0)
    print("Releitura idêntica ao original:", np.allclose(relido.values, resumo.values))
```

#intuicao[
  A regra de Taylor diz qual taxa de juros seria "compatível" com a inflação e o hiato do produto; o #emph[gap] positivo
  indica política monetária mais apertada (juros acima do sugerido). O objetivo aqui não é discutir macroeconomia, e sim
  mostrar como o pipeline --- #strong[ler, validar, agrupar, resumir, exportar] --- se aplica a dados reais.
]

%%% BEFORE_CHAPTER_END: == Capítulo 15 --- Exercícios para Executar (na mão)
#figure(
  align(center)[#table(
    columns: (42%, 58%),
    align: (left, left),
    table.header([Anti-padrão], [Idioma recomendado],),
    [`for` sobre linhas com `iterrows`], [Operação vetorizada ou `groupby`/`merge`],
    [`apply(lambda ...)` linha a linha em tabelas grandes], [Operadores de coluna, `np.where`/`np.select`, `map`],
    [Atribuição encadeada `df[a][b] = x`], [`df.loc[a, b] = x`],
    [Colunas de texto repetido como `object`], [`astype("category")`],
    [`inplace=True` em toda parte], [Reatribuir ou encadear (`df = df.dropna()`)],
    [`concat` dentro de um laço (quadrático)], [Coletar numa lista e `pd.concat` uma vez],
    [Conferir resultado "a olho"], [`assert`, `pd.testing.assert_frame_equal`, contagem de linhas antes/depois],
    [Datas como texto], [`pd.to_datetime(..., format=...)` e `DatetimeIndex`],
  )]
  , kind: table
  )

```python
def valida_painel(d: pd.DataFrame) -> pd.DataFrame:
    """Pré-condições de um painel país-ano: falha cedo, com mensagem clara."""
    assert {"pais", "ano", "pib"} <= set(d.columns), "colunas obrigatórias ausentes"
    assert not d.duplicated(["pais", "ano"]).any(), "pares (pais, ano) duplicados"
    assert d["pib"].between(-50, 50).all(), "PIB fora do intervalo plausível"
    return d

bom = pd.DataFrame({"pais": ["BR", "BR", "CL"], "ano": [2024, 2025, 2025], "pib": [3.1, 2.2, 3.1]})
ruim = pd.concat([bom, bom.iloc[[0]]])                                       # duplicata acidental
print("painel ok:", len(bom.pipe(valida_painel)), "linhas")
try:
    ruim.pipe(valida_painel)
except AssertionError as erro:
    print("painel rejeitado:", erro)
pd.testing.assert_frame_equal(bom, bom.copy())                               # compara valores E tipos
print("assert_frame_equal passou: tabelas idênticas")
```

%%% BEFORE_CHAPTER_END: == Próxima apostila
#line()

== Capítulo 17 --- Erros Comuns e Teste Rápido
<capítulo-17-erros-comuns-e-teste-rapido>
=== 17.1. Os erros que mais aparecem
<os-erros-que-mais-aparecem>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Usar `and`/`or` em máscaras], [`&`, `|`, `~` com parênteses],
    [2], [`.loc[a:b]` esperando fim exclusivo], [`.loc` inclui os dois extremos; `.iloc` exclui o final],
    [3], [Atribuição encadeada `df[mascara]["x"] = 0`], [`df.loc[mascara, "x"] = 0`],
    [4], [Comparar com `np.nan` usando `==`], [`isna()` / `notna()`],
    [5], [Merge sem checar a chave], [`is_unique`, `validate=`, contar linhas antes e depois],
    [6], [Datas como texto, ordenação lexicográfica], [`to_datetime` e `DatetimeIndex`],
    [7], [Comparar séries em nível], [Compare variações (`pct_change`, `diff`)],
    [8], [`std()` do pandas × `np.std()`], [pandas usa `ddof=1`; NumPy, `ddof=0`],
    [9], [Preencher dado faltante sem entender a causa], [Diagnosticar MCAR/MAR/MNAR e a natureza da série],
    [10], [Resultado "parece certo" sem teste], [Asserções e conferência de totais],
  )]
  , kind: table
  )

=== 17.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rapido-verdadeiro-ou-falso>
+ #strong[V ou F:] `df.loc["a":"c"]` inclui a linha "c". #strong[Verdadeiro.] `.loc` é inclusivo nos dois extremos.
+ #strong[V ou F:] Uma coluna de inteiros com um `NaN` continua `int64`. #strong[Falso.] Vira `float64` (ou use `Int64`).
+ #strong[V ou F:] `merge` com chave duplicada nas duas tabelas devolve o mesmo número de linhas. #strong[Falso.] Multiplica as linhas.
+ #strong[V ou F:] `groupby().size()` e `.count()` dão o mesmo resultado com `NaN`. #strong[Falso.] `size` conta linhas; `count` ignora `NaN`.
+ #strong[V ou F:] `ffill` é adequado para a meta da Selic. #strong[Verdadeiro.] É uma série em degraus.
+ #strong[V ou F:] Correlação alta entre duas séries em nível prova causalidade. #strong[Falso.] Pode ser espúria.
+ #strong[V ou F:] `category` reduz memória em colunas com poucos valores distintos repetidos. #strong[Verdadeiro.]
+ #strong[V ou F:] `rolling(3).mean()` e `ewm(span=3).mean()` dão o mesmo resultado. #strong[Falso.] A segunda pesa as observações de forma decrescente.
+ #strong[V ou F:] No pandas 3.0, `df[m]["x"] = 0` altera o `df` original. #strong[Falso.] Com o Copy-on-Write, não altera.
+ #strong[V ou F:] `pd.cut` classifica valores em faixas definidas por você. #strong[Verdadeiro.]
%%% END
