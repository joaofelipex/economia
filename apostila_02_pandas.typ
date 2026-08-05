= Apostila 2 --- pandas para Economia (Teoria Completa)
<apostila-2-pandas-para-economia-teoria-completa>

#line()

== Capítulo 1 --- O que é pandas e por que ele existe
<capítulo-1-o-que-é-pandas-e-por-que-ele-existe>
=== 1.1. Um pouco de história
<um-pouco-de-história>
pandas foi criado por Wes McKinney em 2008, enquanto ele trabalhava como
analista quantitativo na AQR Capital Management, um fundo de
investimentos. O problema que ele enfrentava era muito concreto: análise
financeira e econômica exige manipular tabelas --- cortar, filtrar,
agrupar, juntar, alinhar séries temporais --- e, na época, Python não
tinha uma ferramenta boa para isso. Existia `numpy` para arrays
numéricos, mas um array não tem noção de "coluna com nome" ou "linha
identificada por uma data". McKinney construiu pandas exatamente para
preencher essa lacuna, e o nome não é acidental: #strong[pandas vem de
"panel data"], o termo econométrico para dados que combinam a dimensão
temporal com a dimensão de corte transversal (ex: PIB de vários países
ao longo de vários anos) --- uma homenagem direta à origem do problema
que a biblioteca resolve. A biblioteca foi liberada como código aberto
em 2009 e hoje é, com folga, a ferramenta mais usada no mundo para
análise de dados tabulares em Python --- em bancos centrais, fundos de
investimento, universidades e institutos de pesquisa.

=== 1.2. pandas é construído sobre numpy --- e isso importa
<pandas-é-construído-sobre-numpy-e-isso-importa>
`numpy` é a biblioteca de computação numérica de Python: sua estrutura
central é o `ndarray`, um array de tamanho fixo onde todos os elementos
têm o #strong[mesmo tipo] (todos inteiros, ou todos decimais, por
exemplo) e ficam armazenados de forma contígua na memória. Essa
uniformidade é o que permite ao numpy delegar operações inteiras a
código compilado em C, evitando o laço `for` do Python (lento, como
vimos na Apostila 1, Capítulo 10.4) elemento por elemento.

pandas herda diretamente essa arquitetura: cada coluna de um `DataFrame`
é, por baixo dos panos, um array numpy (ou, em casos mais modernos, uma
"extension array" --- falaremos disso nos dtypes, Capítulo 3.3). Isso
explica um comportamento central que confunde muitos iniciantes vindos
do Excel: #strong[operações em pandas são vetorizadas por padrão]. Somar
duas colunas inteiras (`df["a"] + df["b"]`) não percorre linha por linha
em Python --- delega a soma inteira ao numpy, que a executa em C,
elemento a elemento, de uma só vez. O ganho de velocidade para tabelas
grandes (milhões de linhas, como o CADASTUR do BCB ou os microdados da
PNAD) é de ordens de grandeza.

```
Excel/planilha            numpy                      pandas
─────────────────────────────────────────────────────────────────
Células soltas       →    array homogêneo        →   DataFrame
(qualquer tipo,           (1 tipo, contíguo,          (várias colunas numpy,
sem estrutura)             rápido em C)                cada uma com Index e nome)
```

A relação não é apenas histórica --- ela é prática todos os dias: sempre
que você importa `import pandas as pd`, o numpy é importado junto
(geralmente como `import numpy as np`), porque pandas depende dele
internamente para quase toda operação numérica.

=== 1.3. Os dois objetos centrais: Series e DataFrame
<os-dois-objetos-centrais-series-e-dataframe>
pandas oferece duas estruturas de dados principais:

- #strong[`Series`] --- um array unidimensional rotulado. Pense nele
  como #strong[uma coluna de planilha com nome e índice]: cada valor
  tem, além da sua posição, um rótulo (o #emph[Index]) que o identifica.
- #strong[`DataFrame`] --- uma estrutura bidimensional, com linhas e
  colunas rotuladas. Pense nele como #strong[a planilha inteira]: uma
  coleção de `Series` que compartilham o mesmo Index (o mesmo "eixo de
  linhas").

```python
import pandas as pd

# Series: uma coluna
ipca = pd.Series([0.50, 0.70, 0.88, 0.67], name="ipca")
print(ipca)
```

Saída:

```
0    0.50
1    0.70
2    0.88
3    0.67
Name: ipca, dtype: float64
```

Repare na saída: à esquerda de cada valor aparece um número (`0`, `1`,
`2`, `3`) --- esse é o #strong[Index], e ele é criado automaticamente
quando você não especifica um. `dtype: float64` informa o tipo de dado
armazenado (voltaremos a isso no Capítulo 3.3).

Um `DataFrame`, por sua vez, é literalmente um dicionário de `Series`
que compartilham o mesmo Index:

```python
dados = {
    "pais": ["Brasil", "Argentina", "Chile", "Colômbia"],
    "pib": [2.2, -1.8, 3.1, 2.8],
    "inflacao": [4.5, 98.0, 3.8, 7.2],
    "populacao": [214, 46, 19, 52],  # milhões
}

df = pd.DataFrame(dados)
print(df)
```

Saída:

```
        pais  pib  inflacao  populacao
0     Brasil  2.2       4.5        214
1  Argentina -1.8      98.0         46
2      Chile  3.1       3.8         19
3   Colômbia  2.8       7.2         52
```

Se você já entende dicionários e dicionários aninhados (Apostila 1,
Capítulo 8), o `DataFrame` deve parecer familiar: `dados` era um
dicionário `{coluna: lista_de_valores}`, e o `pd.DataFrame(...)`
simplesmente organiza isso em uma tabela, adicionando um Index
automático. Essa ponte conceitual é deliberada --- pandas não inventa
uma forma nova de pensar sobre dados, ele formaliza uma estrutura que
você já usava informalmente com dicionários e listas.

=== 1.4. O Index: o rótulo que a lista Python não tem
<o-index-o-rótulo-que-a-lista-python-não-tem>
Esta é talvez a ideia mais estruturalmente importante de pandas, e a que
menos aparece explicada nos tutoriais rápidos: #strong[toda `Series` e
todo `DataFrame` têm um Index], e o Index não é "só uma coluna a mais"
--- é um objeto com papel funcional próprio.

O Index serve a três propósitos:

+ #strong[Identificação de linha.] Em vez de acessar "a linha 5"
  (posição), você pode acessar "a linha do dia 2024-03-15" ou "a linha
  do Brasil" (rótulo). Isso é o que torna `df.loc["Brasil"]` possível.
+ #strong[Alinhamento automático.] Quando você opera dois `DataFrame`s
  ou `Series` juntos (soma, subtração), pandas primeiro #strong[alinha
  pelos rótulos do Index], não pela posição física. Isso é crucial e
  surpreende iniciantes: se `serie_a` tem índice `[2020, 2021, 2022]` e
  `serie_b` tem índice `[2021, 2022, 2023]`, `serie_a + serie_b` alinha
  por ano, e o resultado tem `NaN` (Capítulo 8) onde um dos dois não
  tinha dado --- mesmo que as duas séries tenham o mesmo número de
  elementos.
+ #strong[Performance de busca.] Um Index monotonicamente ordenado (por
  exemplo, datas em ordem crescente) permite que pandas localize um
  valor por busca binária ($O\(log n\)$); um Index não ordenado usa uma
  tabela hash internamente, análoga à de um dicionário Python (Apostila
  1, Capítulo 8.1) --- em ambos os casos, muito mais rápido que
  percorrer a tabela inteira.

```python
serie_a = pd.Series([2.9, 3.1, 2.2], index=[2022, 2023, 2024], name="pib_a")
serie_b = pd.Series([0.2, 2.6, 3.1], index=[2023, 2024, 2025], name="pib_b")

print(serie_a + serie_b)
```

Saída:

```
2022    NaN
2023    3.3
2024    5.3
2025    NaN
dtype: float64
```

Note que o resultado tem #strong[quatro] anos (a união dos dois
índices), não três --- e os anos que só existiam em uma das séries
viraram `NaN` (Not a Number, o marcador de dado ausente do pandas ---
Capítulo 8). Isso é o oposto do que aconteceria somando duas listas
Python posicionalmente (`lista_a[i] + lista_b[i]`), que ignoraria
completamente os rótulos e simplesmente somaria por posição ---
produzindo um resultado silenciosamente errado se as séries não
estivessem alinhadas na mesma ordem.

Por padrão, quando você não especifica um índice, pandas cria um
`RangeIndex` --- uma sequência `0, 1, 2, ...`, que é armazenada de forma
extremamente eficiente em memória (não guarda cada número
individualmente, só o início, fim e passo, como um `range()` do Python
puro). Assim que você faz qualquer operação que reordene ou filtre as
linhas, esse `RangeIndex` normalmente vira um `Index` genérico
(guardando cada rótulo de fato) --- o que explica por que, após um
`sort_values()` ou um filtro, os números do índice "ficam fora de ordem"
(ex: `2, 0, 3, 1`) até você chamar `reset_index()`.

=== 1.5. Instalação e convenção de import
<instalação-e-convenção-de-import>
```python
# pip install pandas numpy
import pandas as pd
import numpy as np
```

`pd` e `np` são apelidos (aliases) convencionais --- não obrigatórios
pela linguagem, mas seguidos universalmente pela comunidade
(analogamente a `snake_case`, PEP 8, na Apostila 1). Usar esses apelidos
não é apenas estética: qualquer economista que ler seu código, em
qualquer lugar do mundo, reconhece `pd.DataFrame` e `np.array`
instantaneamente.

=== 1.6. Exemplo Resolvido --- Alinhamento de Index em séries de fontes diferentes
<exemplo-resolvido-alinhamento-de-index-em-séries-de-fontes-diferentes>
#strong[Enunciado:] você baixou o IPCA do BCB (código SGS 433) e, de
outra fonte, uma projeção do Boletim Focus para os mesmos meses --- mas
a fonte do Focus só cobre até dois meses antes do fim da série do BCB
(dado ainda não disponível). Ambas vêm como `Series` indexadas por mês
(`"2024-01"`, `"2024-02"`, …). Escreva o código que soma as duas séries
e explique o que aparece nos meses finais, sem rodar no computador
antes.

```python
ipca_real = pd.Series(
    [0.42, 0.83, 0.56, 0.44, 1.20],
    index=["2024-01", "2024-02", "2024-03", "2024-04", "2024-05"],
    name="ipca_real",
)
foco_proj = pd.Series(
    [0.40, 0.75, 0.60],
    index=["2024-01", "2024-02", "2024-03"],
    name="foco_proj",
)
```

#strong[Solução comentada:]

```python
soma = ipca_real + foco_proj
print(soma)
```

Saída:

```
2024-01    0.82
2024-02    1.58
2024-03    1.16
2024-04     NaN
2024-05     NaN
dtype: float64
```

O Index de `soma` é a #strong[união] dos dois índices (`2024-01` a
`2024-05`), porque pandas alinha por rótulo antes de somar (Capítulo
1.4), não por posição. Nos meses `2024-04` e `2024-05`, `foco_proj`
simplesmente não tem uma linha correspondente --- e, em vez de um erro,
pandas produz `NaN`: "não sei somar um número com a ausência de um
número". Isso é uma diferença de comportamento importante frente a uma
lista Python comum, onde `lista_a[i] + lista_b[i]` sequer rodaria se as
listas tivessem tamanhos diferentes (`IndexError`), e rodaria
silenciosamente errado se tivessem o mesmo tamanho mas ordens
diferentes. O alinhamento por Index é uma rede de segurança --- mas
também significa que você deve #strong[sempre verificar se apareceram
`NaN` inesperados] depois de somar duas séries de fontes diferentes,
tratando-os com as ferramentas do Capítulo 8.

#line()

== Capítulo 2 --- Criando DataFrames e lendo dados reais
<capítulo-2-criando-dataframes-e-lendo-dados-reais>
=== 2.1. A partir de estruturas Python
<a-partir-de-estruturas-python>
```python
import pandas as pd

# A partir de um dicionário de listas (uma chave = uma coluna)
dados = {
    "pais": ["Brasil", "Argentina", "Chile", "Colômbia"],
    "pib": [2.2, -1.8, 3.1, 2.8],
}
df = pd.DataFrame(dados)

# A partir de uma lista de dicionários (um dicionário = uma linha)
registros = [
    {"pais": "Brasil", "pib": 2.2},
    {"pais": "Argentina", "pib": -1.8},
]
df2 = pd.DataFrame(registros)

# A partir de listas de listas, com nomes de coluna explícitos
linhas = [["Brasil", 2.2], ["Argentina", -1.8]]
df3 = pd.DataFrame(linhas, columns=["pais", "pib"])
```

A escolha entre "dicionário de listas" (orientado a coluna) e "lista de
dicionários" (orientado a linha) geralmente é ditada pelo formato em que
o dado chega até você: uma API que devolve um registro por vez (uma
linha, com vários campos) naturalmente produz uma lista de dicionários;
um arquivo já tabular naturalmente produz um dicionário de colunas.

=== 2.2. `read_csv` em detalhe --- a função mais usada de pandas
<read_csv-em-detalhe-a-função-mais-usada-de-pandas>
```python
df = pd.read_csv("dados.csv")
```

Na prática profissional, quase nunca é tão simples assim --- arquivos
CSV reais, principalmente os exportados de sistemas brasileiros (Excel
em português, sistemas legados de órgãos públicos), têm particularidades
que `read_csv` precisa ser instruído a tratar:

#figure(
  align(center)[#table(
    columns: (20%, 30.91%, 49.09%),
    align: (auto,auto,auto,),
    table.header([Parâmetro], [Para que serve], [Exemplo típico no
      Brasil],),
    table.hline(),
    [`sep`], [Caractere separador de colunas], [`sep=";"` --- Excel BR
    usa `;`, não `,`, porque `,` já é o separador decimal],
    [`decimal`], [Caractere separador decimal], [`decimal=","` ---
    "3,14" em vez de "3.14"],
    [`encoding`], [Codificação de caracteres], [`encoding="latin1"` ou
    `"cp1252"` --- arquivos exportados de sistemas antigos do governo
    raramente estão em UTF-8],
    [`thousands`], [Separador de milhar], [`thousands="."` ---
    "1.234.567"],
    [`parse_dates`], [Colunas a converter para data já na
    leitura], [`parse_dates=["data"]`],
    [`dayfirst`], [Interpreta datas ambíguas como
    dia/mês/ano], [`dayfirst=True` --- "01/02/2024" = 1º de fevereiro,
    não 2 de janeiro],
    [`na_values`], [Strings adicionais a tratar como
    nulo], [`na_values=["-", "..", "ND", "N/D"]`],
    [`skiprows`], [Pula linhas do topo (cabeçalhos extras,
    notas)], [`skiprows=3`],
    [`usecols`], [Lê só um subconjunto de
    colunas], [`usecols=["data", "valor"]`],
    [`dtype`], [Força o tipo de uma coluna na
    leitura], [`dtype={"codigo_ibge": str}` --- evita que um código vire
    número e perca zeros à esquerda],
  )]
  , kind: table
  )

```python
df = pd.read_csv(
    "ipca_ibge.csv",
    sep=";",
    decimal=",",
    encoding="latin1",
    parse_dates=["data"],
    dayfirst=True,
    na_values=["-", "..", "ND"],
)
```

#strong[Armadilha comum:] um código de município do IBGE como
`"03550308"` (São Paulo) tem um zero à esquerda que carrega informação.
Se `read_csv` não for instruído com `dtype={"codigo_ibge": str}`, pandas
infere automaticamente que a coluna é numérica e #strong[descarta o zero
à esquerda silenciosamente], virando `3550308` --- um erro sutil que só
aparece quando você tenta cruzar (merge) essa coluna com outra fonte que
preservou o zero.

=== 2.3. `read_excel`
<read_excel>
```python
df = pd.read_excel("dados.xlsx", sheet_name="Planilha1")

# Múltiplas abas de uma vez (retorna um dicionário {nome_aba: DataFrame})
todas_abas = pd.read_excel("dados.xlsx", sheet_name=None)

# Pular linhas de cabeçalho/nota (comum em planilhas do BCB/IBGE, que têm
# título e fonte antes da tabela de verdade)
df = pd.read_excel("serie_bcb.xlsx", skiprows=4, skipfooter=2)
```

`read_excel` exige o pacote `openpyxl` instalado (para `.xlsx`) por
baixo dos panos --- pandas delega a leitura do formato binário/XML da
planilha a essas bibliotecas especializadas, e só organiza o resultado
em um `DataFrame`.

=== 2.4. Fontes de dados econômicos brasileiros
<fontes-de-dados-econômicos-brasileiros>
Um economista raramente digita dados manualmente --- ele os baixa de uma
API ou repositório público. As três fontes mais usadas no Brasil, e como
elas aparecem em Python:

#figure(
  align(center)[#table(
    columns: (13.21%, 30.19%, 39.62%, 16.98%),
    align: (auto,auto,auto,auto,),
    table.header([Fonte], [O que oferece], [Biblioteca
      Python], [Exemplo],),
    table.hline(),
    [#strong[BCB SGS] (Sistema Gerenciador de Séries
    Temporais)], [+25.000 séries temporais: IPCA, SELIC, câmbio,
    crédito, etc.], [`python-bcb`
    (`from bcb import sgs`)], [`sgs.get({"IPCA": 433}, start="2010-01-01")`],
    [#strong[Ipeadata]], [Séries do IBGE, BCB e do próprio IPEA
    compiladas em um só lugar, incluindo contas
    nacionais], [`ipeadatapy`], [`ipeadatapy.timeseries("PRECOS12_IPCA12")`],
    [#strong[IBGE SIDRA]], [Censo, PNAD Contínua, Contas Nacionais
    Trimestrais, microdados
    agregados], [`sidrapy`], [`sidrapy.get_table(table_code="1737", ...)`],
  )]
  , kind: table
  )

Cada uma dessas bibliotecas devolve, ao final, um `pandas.DataFrame` (ou
`Series`) --- é por isso que dominar pandas é o pré-requisito comum a
qualquer uma dessas fontes: a biblioteca de acesso muda, a forma de
manipular o resultado, não.

```python
from bcb import sgs

# Código 433 = IPCA (variação mensal, %); código 11 = SELIC (taxa diária, % a.a.)
ipca = sgs.get({"IPCA": 433}, start="2020-01-01")
selic = sgs.get({"SELIC": 11}, start="2020-01-01")

print(ipca.head())
print(type(ipca))   # <class 'pandas.core.frame.DataFrame'>
```

=== 2.5. Outras origens
<outras-origens>
```python
# Área de transferência — copie uma tabela do Excel e rode:
df = pd.read_clipboard()

# Dicionário Python já em memória
df = pd.DataFrame.from_dict({"a": [1, 2], "b": [3, 4]})

# Lista de tuplas/registros com nomes de campo
df = pd.DataFrame.from_records([(1, "Brasil"), (2, "Chile")], columns=["id", "pais"])

# JSON (comum em respostas de API)
df = pd.read_json("dados.json")
```

=== 2.6. Exemplo Resolvido --- Importando um CSV "sujo" do jeito certo
<exemplo-resolvido-importando-um-csv-sujo-do-jeito-certo>
#strong[Enunciado:] você recebeu o arquivo `pib_estados.csv`, exportado
de um sistema legado, com o seguinte conteúdo (mostrado aqui como texto
para fins didáticos):

```
Fonte: Sistema Legado Estadual - Uso Interno
Gerado em: 15/03/2024
uf;pib_r_milhoes;populacao
SP;2.450.123,50;46.000.000
RJ;890.456,20;17.500.000
MG;620.789,10;21.400.000
```

Escreva a chamada de `pd.read_csv` que lê esse arquivo corretamente,
resultando em colunas numéricas de verdade (não texto).

#strong[Solução comentada:]

```python
df = pd.read_csv(
    "pib_estados.csv",
    sep=";",           # separador é ponto e vírgula, não vírgula
    decimal=",",       # a vírgula em "2.450.123,50" é o separador decimal
    thousands=".",     # o ponto em "2.450.123" é separador de milhar
    skiprows=2,        # pula as duas linhas de "Fonte:" e "Gerado em:"
    encoding="latin1", # sistemas legados raramente exportam em UTF-8
)

print(df)
print(df.dtypes)
```

Saída esperada:

```
   uf  pib_r_milhoes  populacao
0  SP     2450123.50   46000000
1  RJ      890456.20   17500000
2  MG      620789.10   21400000

uf                object
pib_r_milhoes    float64
populacao          int64
dtype: object
```

O raciocínio segue a mesma lógica de "limpar antes de converter" vista
na Apostila 1 (Capítulo 4.6, conversão de `"R$ 1.234,56"`): primeiro
identificamos o que #strong[não é] um número válido em formato americano
(separador de milhar `.` e decimal `,`, invertidos frente ao padrão que
`float()`/pandas esperam), e instruímos `read_csv` a desfazer isso na
leitura, em vez de importar tudo como texto e corrigir depois --- mais
rápido e menos propenso a erro. Repare também que `skiprows=2` descarta
as duas primeiras linhas de metadado, um padrão extremamente comum em
planilhas de órgãos públicos brasileiros, que costumam colocar título e
fonte acima da tabela real.

#line()

== Capítulo 3 --- Explorando e entendendo a estrutura dos dados
<capítulo-3-explorando-e-entendendo-a-estrutura-dos-dados>
=== 3.1. Primeiro contato com uma tabela nova
<primeiro-contato-com-uma-tabela-nova>
Antes de qualquer análise, o primeiro hábito profissional é
#strong[nunca confiar cegamente] em um DataFrame recém-importado ---
sempre inspecioná-lo:

```python
df.head()        # primeiras 5 linhas
df.head(10)      # primeiras 10
df.tail(3)       # últimas 3 (útil para ver se a série termina onde deveria)
df.sample(5)     # 5 linhas aleatórias (útil para pegar problemas "no meio" da tabela)

df.shape         # (número de linhas, número de colunas) — uma tupla
df.info()        # tipos de dados + contagem de não-nulos + uso de memória
df.describe()    # estatísticas descritivas das colunas numéricas
df.dtypes        # tipo de cada coluna
df.columns       # nomes das colunas (um Index de strings)
df.index         # o Index das linhas
```

`df.info()` merece destaque: em uma única chamada, ele revela três
coisas que costumam expor problemas de importação --- (1) se o número de
linhas "não-nulas" bate com o total esperado (revelando dados
faltantes), (2) se o `dtype` de cada coluna é o esperado (uma coluna de
datas lida como `object`, por exemplo, é sinal de que `parse_dates`
deveria ter sido usado), e (3) o uso de memória do DataFrame, relevante
para bases muito grandes.

```python
print(df.info())
```

Saída típica:

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 4 entries, 0 to 3
Data columns (total 4 columns):
 #   Column     Non-Null Count  Dtype
---  ------     --------------  -----
 0   pais       4 non-null      object
 1   pib        4 non-null      float64
 2   inflacao   4 non-null      float64
 3   populacao  4 non-null      int64
dtypes: float64(2), int64(1), object(1)
memory usage: 260.0+ bytes
```

=== 3.2. `describe()`, `unique()`, `value_counts()`
<describe-unique-value_counts>
```python
df.describe()               # count, mean, std, min, 25%, 50%, 75%, max — só colunas numéricas
df.describe(include="all")  # inclui colunas de texto (mostra unique, top, freq)

df["pais"].unique()          # array com os valores distintos, na ordem em que aparecem
df["pais"].nunique()         # quantos valores distintos existem
df["pais"].value_counts()    # contagem de cada valor, ordenado do mais frequente ao menos
df["pais"].value_counts(normalize=True)  # o mesmo, mas em proporção (soma 1.0)
```

`value_counts()` é, na prática, uma das ferramentas de diagnóstico mais
usadas no dia a dia: rodá-la sobre uma coluna categórica logo após
importar um arquivo revela imediatamente problemas de digitação
(`"Brasil"` vs `"brasil"` vs `"BRASIL"` contados como três categorias
diferentes) --- um sintoma comum de dados digitados manualmente.

=== 3.3. Tipos de dados (dtypes) do pandas --- mais do que parece
<tipos-de-dados-dtypes-do-pandas-mais-do-que-parece>
Um `dtype` (data type) descreve como os bytes de uma coluna são
interpretados na memória. Entender os principais evita bugs sutis (o
próximo capítulo, sobre `NaN`, depende diretamente disso):

#figure(
  align(center)[#table(
    columns: (17.07%, 31.71%, 21.95%, 29.27%),
    align: (auto,auto,auto,auto,),
    table.header([dtype], [Representa], [Exemplo], [Observação],),
    table.hline(),
    [`int64`], [Inteiro de 64 bits], [`populacao`], [Não aceita `NaN`
    --- se um `NaN` entrar, a coluna inteira é promovida a `float64`],
    [`float64`], [Decimal de ponto flutuante de 64 bits], [`pib`,
    `inflacao`], [Aceita `NaN` nativamente (é o tipo padrão para colunas
    numéricas com dados faltantes)],
    [`bool`], [Verdadeiro/Falso], [`em_recessao`], [Também não aceita
    `NaN` nativamente (mesma lógica do `int64`)],
    [`object`], [Texto (`str`) ou tipos mistos], [`pais`, `sigla`], [O
    "tipo genérico" --- qualquer coluna que não seja puramente numérica
    cai aqui, mesmo que só contenha texto],
    [`category`], [Texto com um conjunto #strong[fixo e pequeno] de
    valores possíveis], [`regiao` (Norte, Nordeste, …)], [Muito mais
    eficiente em memória que `object` quando há poucos valores únicos
    repetidos muitas vezes],
    [`datetime64[ns]`], [Data/hora], [`data`], [Permite aritmética de
    datas e o acessor `.dt` (Capítulo 11)],
    [`timedelta64[ns]`], [Duração (diferença entre
    datas)], [`data_fim - data_inicio`], [Resultado de subtrair duas
    colunas `datetime64`],
    [`Int64` (nullable, "I" maiúsculo)], [Inteiro que #strong[aceita]
    `NaN`/`pd.NA`], [Introduzido no pandas 1.0], [Diferente de `int64`
    (minúsculo) --- resolve o problema de upcast a `float`],
  )]
  , kind: table
  )

```python
df.dtypes
# pais          object
# pib          float64
# inflacao     float64
# populacao      int64
# dtype: object

# Convertendo o tipo de uma coluna
df["populacao"] = df["populacao"].astype("int64")
df["regiao"] = df["regiao"].astype("category")   # economiza memória se houver poucas regiões repetidas
```

#strong[Por que `object` é o dtype "genérico" e por que isso é lento.]
Quando uma coluna é `object`, cada célula é, na prática, um ponteiro
Python para um objeto `str` (ou qualquer outro tipo) separado na memória
--- exatamente como uma lista Python comum, e não como um array numpy
contíguo de números. Isso significa que operações em colunas `object`
#strong[não se beneficiam da vetorização em C] da mesma forma que
colunas numéricas --- são mais lentas e usam mais memória. Converter uma
coluna de texto repetitivo (como uma sigla de país ou região) para
`category` recupera parte dessa eficiência, porque `category` armazena
internamente só os valores únicos (o "dicionário" de categorias) e um
array de códigos inteiros apontando para eles --- a mesma ideia de um
dicionário Python (Apostila 1, Capítulo 8.1) aplicada a uma coluna
inteira.

=== 3.4. Exemplo Resolvido --- Diagnosticando um DataFrame recém-importado
<exemplo-resolvido-diagnosticando-um-dataframe-recém-importado>
#strong[Enunciado:] você rodou `pd.read_csv("serie_bcb.csv")` sem nenhum
parâmetro extra e obteve o `df.info()` abaixo. Aponte, usando só essa
saída, dois prováveis problemas de importação e o parâmetro de
`read_csv` que resolveria cada um.

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 300 entries, 0 to 299
Data columns (total 3 columns):
 #   Column   Non-Null Count  Dtype
---  ------   --------------  -----
 0   data     300 non-null    object
 1   ipca     287 non-null    object
 2   selic    300 non-null    float64
dtypes: float64(1), object(2)
memory usage: 7.2+ KB
```

#strong[Solução comentada:]

+ #strong[A coluna `data` está como `object`, não `datetime64[ns]`.]
  Isso indica que `read_csv` não recebeu `parse_dates=["data"]`. Sem
  essa conversão, você não consegue usar o acessor `.dt` (Capítulo 11)
  nem fatiar por período com `.loc["2020":"2021"]`.

+ #strong[A coluna `ipca` está como `object` (texto), mas deveria ser
  numérica] --- e ainda por cima tem só 287 valores não-nulos em 300
  linhas, contra 300/300 de `selic`. A causa mais provável: a coluna
  `ipca` contém, em algumas linhas, um marcador de dado ausente que
  `read_csv` não reconheceu como nulo (por exemplo, `"-"` ou `"ND"`), ou
  usa vírgula decimal sem `decimal=","` especificado --- em ambos os
  casos, pandas não consegue interpretar a coluna inteira como número e
  a mantém como texto (`object`). A correção:

```python
df = pd.read_csv(
    "serie_bcb.csv",
    parse_dates=["data"],
    decimal=",",
    na_values=["-", "ND", ".."],
)
print(df.dtypes)
# data     datetime64[ns]
# ipca            float64
# selic           float64
```

O ponto central deste exemplo: #strong[`df.info()` é a primeira coisa a
rodar depois de qualquer importação], porque um `dtype` errado raramente
gera um erro imediato --- ele se manifesta silenciosamente, mais tarde,
como um `TypeError` ao tentar somar a coluna, ou como um resultado
numericamente sem sentido (comparar strings como se fossem números
compara por ordem alfabética, não por valor).

#line()

== Capítulo 4 --- Seleção de dados: `[]`, `.loc`, `.iloc`, `.at`, `.iat`
<capítulo-4-seleção-de-dados-.loc-.iloc-.at-.iat>
=== 4.1. Selecionando colunas
<selecionando-colunas>
```python
df["pais"]              # uma coluna → retorna Series
df.pais                  # atalho de atributo — funciona só se o nome não tiver espaço,
                         # não colidir com um método existente (ex: df.count) e for um
                         # identificador Python válido; em código de produção, prefira df["pais"]
df[["pais", "pib"]]      # várias colunas, passadas como LISTA → retorna DataFrame (repare nos dois colchetes)
```

O atalho `df.pais` é conveniente no terminal interativo, mas tem
armadilhas reais: se uma coluna se chamar `"count"` ou `"mean"`,
`df.count` acessa o #strong[método] `count()` do DataFrame, não a coluna
--- um bug silencioso, já que não gera erro, apenas devolve o objeto
errado. Por essa razão, código destinado a ser reaproveitado ou revisado
por terceiros deve usar sempre `df["coluna"]`.

=== 4.2. `.iloc` --- seleção por posição (i de "integer location")
<iloc-seleção-por-posição-i-de-integer-location>
```python
df.iloc[0]         # primeira linha (posição 0), como Series
df.iloc[-1]        # última linha
df.iloc[0:3]       # linhas nas posições 0, 1, 2 (o fim, 3, NÃO é incluído)
df.iloc[[0, 2]]    # linhas nas posições 0 e 2 (lista explícita de posições)

df.iloc[0, 1]      # escalar: linha na posição 0, coluna na posição 1
df.iloc[0:3, 0:2]  # sublinha/subcoluna: linhas 0-2, colunas 0-1
df.iloc[:, 0]      # todas as linhas, primeira coluna
```

`.iloc` segue exatamente a mesma convenção de fatiamento (slicing) de
listas Python vista na Apostila 1 (Capítulo 7.2): o índice final é
#strong[exclusivo]. `df.iloc[0:3]` traz 3 linhas (posições 0, 1, 2), não
\4.

=== 4.3. `.loc` --- seleção por rótulo ("location" pelo Index)
<loc-seleção-por-rótulo-location-pelo-index>
```python
df.index = ["a", "b", "c", "d"]

df.loc["a"]          # a linha cujo ÍNDICE (rótulo) é "a" — não a primeira posição
df.loc["a":"c"]      # linhas de "a" até "c" — repare: "c" está INCLUÍDO!
df.loc[:, "pib"]     # todas as linhas, coluna "pib"
df.loc["a", "pib"]   # escalar: linha "a", coluna "pib"
df.loc[["a", "c"]]   # linhas "a" e "c" (lista explícita de rótulos)

# .loc também aceita uma máscara booleana — é a base do filtro do Capítulo 6
df.loc[df["pib"] > 2]
```

=== 4.4. A diferença crucial entre `.loc` e `.iloc`: inclusivo vs.~exclusivo
<a-diferença-crucial-entre-.loc-e-.iloc-inclusivo-vs.-exclusivo>
Esta é a armadilha mais comum de quem começa com pandas, e vale
destacá-la isoladamente:

#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([], [`.iloc` (posição)], [`.loc` (rótulo)],),
    table.hline(),
    [Índice usado], [Posição inteira (0, 1, 2, …), sempre, independente
    do Index real], [O rótulo do Index, seja ele número, string ou
    data],
    [Fim do fatiamento (`a:b`)], [#strong[Exclusivo] --- `b` não entra,
    igual a uma lista Python], [#strong[Inclusivo] --- `b` entra!],
    [`df.iloc[0:3]`], [3 linhas (posições 0, 1, 2)], [---],
    [`df.loc["a":"c"]` (índice = a,b,c,d)], [---], [3 linhas ("a", "b",
    "c" --- "c" está incluído)],
    [Funciona se o Index não for numérico?], [Sim (posição sempre
    existe)], [Sim, é o caso de uso natural],
    [Funciona se o Index for numérico mas fora de ordem (ex:
    `[3, 1, 2]`)?], [Sim, ignora o Index, usa só a posição
    física], [Sim, mas `.loc[1:2]` busca os #emph[rótulos] 1 e 2, não as
    posições 1 e 2!],
  )]
  , kind: table
  )

A razão para `.loc` incluir o rótulo final (diferente de toda convenção
de fatiamento do restante do Python) é justamente por ser baseado em
#strong[rótulo], não posição: não existe uma noção geral de "o próximo
rótulo depois de 'c'" para todo tipo de Index (ele poderia ser uma data,
uma string, um número não sequencial) --- então incluir o limite final é
a única forma consistente de garantir que `df.loc["2020-01":"2020-06"]`
traga o mês de junho inteiro, e não pare "um pouco antes" dele.

```python
serie = pd.Series([10, 20, 30, 40], index=[3, 1, 2, 0])
print(serie.iloc[0:2])   # posições 0 e 1 → valores 10 e 20 (rótulos 3 e 1)
print(serie.loc[0:2])    # ATENÇÃO: com índice não ordenado, .loc[0:2] pode
                         # até lançar erro (KeyError) ou se comportar de forma
                         # não intuitiva — .loc espera, idealmente, um índice ordenado
                         # para fatiamento por intervalo
```

=== 4.5. `.at` e `.iat` --- acesso a um único valor, mais rápido
<at-e-.iat-acesso-a-um-único-valor-mais-rápido>
```python
df.at["a", "pib"]     # equivalente a df.loc["a", "pib"], mas otimizado para UM valor escalar
df.iat[0, 1]          # equivalente a df.iloc[0, 1], mesma otimização
```

Para acessar um valor único, `.at`/`.iat` evitam parte da sobrecarga
interna de `.loc`/`.iloc` (que são generalizados para lidar com fatias,
listas e máscaras). Em um laço que acessa milhares de células
individualmente (embora, como veremos no Capítulo 7, um laço explícito
raramente é a melhor abordagem em pandas), `.at`/`.iat` são
mensuravelmente mais rápidos.

=== 4.6. Exemplo Resolvido --- Escolhendo a ferramenta certa de seleção
<exemplo-resolvido-escolhendo-a-ferramenta-certa-de-seleção>
#strong[Enunciado:] dado o DataFrame abaixo, indexado por sigla de país,
escreva a expressão de seleção mais apropriada (usando `.loc`, `.iloc`,
`.at` ou colchetes simples) para cada uma das quatro tarefas.

```python
df = pd.DataFrame(
    {"pib": [2.2, -1.8, 3.1], "inflacao": [4.5, 98.0, 3.8]},
    index=["BRA", "ARG", "CHL"],
)
```

#block[
#set enum(numbering: "a)", start: 1)
+ Obter só a coluna `inflacao` inteira.
+ Obter a linha do Chile.
+ Obter apenas o valor do PIB da Argentina (um único número).
+ Obter a segunda linha da tabela, seja qual for seu rótulo.
]

#strong[Solução comentada:]

```python
# a) coluna inteira -> colchetes simples, sem .loc necessário
print(df["inflacao"])

# b) linha por RÓTULO (sigla do país) -> .loc
print(df.loc["CHL"])

# c) um único valor, por rótulo -> .at é o mais direto e rápido
print(df.at["ARG", "pib"])   # -1.8

# d) linha por POSIÇÃO, independente do rótulo -> .iloc
print(df.iloc[1])            # segunda linha = ARG, aqui coincide com (c), mas por outro caminho
```

O critério de decisão é sempre o mesmo: #strong[pergunte-se se você está
pensando em "onde fisicamente" (posição) ou "o quê"
(identificador/rótulo)]. Tarefa (d) pede explicitamente "a segunda
linha, seja qual for seu rótulo" --- uma noção de posição, portanto
`.iloc`. Tarefas (b) e (c) pedem por identidade (o país "Chile", a
"Argentina") --- noção de rótulo, portanto `.loc`/`.at`. Usar `.iloc[1]`
para a tarefa (b) funcionaria #emph[neste exemplo específico], porque o
Chile por acaso está na posição 2 --- mas seria um código frágil, que
quebraria silenciosamente se a ordem das linhas mudasse (por exemplo,
após um `sort_values`).

#line()

== Capítulo 5 --- Cópia vs.~view: o `SettingWithCopyWarning`
<capítulo-5-cópia-vs.-view-o-settingwithcopywarning>
=== 5.1. Por que este capítulo existe
<por-que-este-capítulo-existe>
Na Apostila 1 (Capítulo 7.3), vimos que listas Python são mutáveis e que
atribuir uma lista a outra variável não cria uma cópia --- cria um
segundo rótulo apontando para o mesmo objeto (#emph[aliasing]). pandas
tem um problema #strong[irmão] desse, só que mais traiçoeiro, porque ele
não é binário (cópia ou não-cópia) --- depende de detalhes internos de
implementação que nem sempre são visíveis a partir do código-fonte. O
sintoma é um aviso que todo economista que usa pandas encontra
eventualmente:

```
SettingWithCopyWarning: A value is trying to be set on a copy of a slice from a DataFrame.
```

=== 5.2. Reproduzindo o problema
<reproduzindo-o-problema>
```python
df = pd.DataFrame({"pais": ["Brasil", "Argentina", "Chile"], "pib": [2.2, -1.8, 3.1]})

# "Indexação encadeada" (chained indexing) — dois passos de seleção em sequência
positivos = df[df["pib"] > 0]     # passo 1: filtra (pode devolver view OU cópia — pandas não garante)
positivos["situacao"] = "cresceu" # passo 2: tenta atribuir na "fatia" resultante
# SettingWithCopyWarning!
```

O problema: `df[df["pib"] > 0]` #strong[pode] devolver uma nova cópia
independente de `df`, ou #strong[pode] devolver uma #emph[view] (uma
"janela" que aponta para os mesmos dados de `df`) --- e isso depende de
detalhes internos (o tipo de operação, o dtype das colunas envolvidas)
que o próprio pandas não expõe como garantia estável entre versões.
Quando você faz `positivos["situacao"] = ...` sobre o resultado, pandas
não consegue garantir se essa atribuição:

- alterou de fato `df` original (porque `positivos` era uma
  #emph[view]), ou
- criou a coluna só em `positivos`, e `df` original permaneceu intocado
  (porque `positivos` era uma #emph[cópia]),

e é exatamente essa ambiguidade --- silenciosa, sem quebrar o programa
--- que o aviso existe para sinalizar. É um "aliasing" na sua forma mais
perigosa: ao contrário do aliasing de listas da Apostila 1, aqui você
pode nem saber se o efeito colateral aconteceu ou não sem inspecionar
manualmente.

=== 5.3. As duas formas corretas de resolver
<as-duas-formas-corretas-de-resolver>
#strong[Opção 1 --- quando você realmente quer um subconjunto
independente], copie explicitamente:

```python
positivos = df[df["pib"] > 0].copy()   # .copy() garante independência total
positivos["situacao"] = "cresceu"      # seguro: positivos não tem nenhuma relação com df
print(df)                              # df original, sem a coluna "situacao" — garantido
```

#strong[Opção 2 --- quando você quer, de fato, alterar o DataFrame
original], faça filtro e atribuição em #strong[uma única operação] com
`.loc`, em vez de dois passos separados:

```python
df.loc[df["pib"] > 0, "situacao"] = "cresceu"   # filtra e atribui na mesma chamada, sem ambiguidade
print(df)
```

```
        pais  pib situacao
0     Brasil  2.2  cresceu
1  Argentina -1.8      NaN
2      Chile  3.1  cresceu
```

A regra prática que evita o problema por completo: #strong[nunca
encadeie dois colchetes/seleções separados quando a intenção é atribuir
um valor] (`df[mascara]["coluna"] = valor` é sempre suspeito). Se a
intenção é modificar o original, use `df.loc[mascara, "coluna"] = valor`
em uma única chamada; se a intenção é trabalhar com uma cópia separada,
torne isso explícito com `.copy()`.

=== 5.4. Tabela-resumo do capítulo
<tabela-resumo-do-capítulo>
#figure(
  align(center)[#table(
    columns: (43.48%, 56.52%),
    align: (auto,auto,),
    table.header([Situação], [O que fazer],),
    table.hline(),
    [Quero um subconjunto de `df` para analisar sem afetar o
    original], [`sub = df[mascara].copy()`],
    [Quero modificar `df` original com base em um
    filtro], [`df.loc[mascara, "coluna"] = valor` (uma chamada só)],
    [Vi o aviso `SettingWithCopyWarning`], [Pare e identifique se há
    indexação encadeada (`df[...][...] =`); reescreva com `.loc` ou
    `.copy()`],
    [Preciso passar um subconjunto de `df` para uma função que talvez o
    modifique], [Sempre `.copy()` antes de passar, exatamente como a
    função pura da Apostila 1 (Capítulo 11.8) evita efeitos colaterais],
  )]
  , kind: table
  )

=== 5.5. Exemplo Resolvido --- Corrigindo um pipeline com aviso silencioso
<exemplo-resolvido-corrigindo-um-pipeline-com-aviso-silencioso>
#strong[Enunciado:] o código abaixo roda sem erro, mas produz o
`SettingWithCopyWarning` e o analista suspeita (corretamente) que o
resultado final está errado. Identifique o problema e reescreva o trecho
de forma segura.

```python
df = pd.DataFrame({
    "pais": ["Brasil", "Argentina", "Chile", "Peru"],
    "inflacao": [4.5, 98.0, 3.8, 3.2],
})

alta_inflacao = df[df["inflacao"] > 10]
alta_inflacao["alerta"] = True   # gera SettingWithCopyWarning

print(df["alerta"].sum())  # o analista espera 1, mas isso lança KeyError:
                            # 'alerta' nem existe em df!
```

#strong[Solução comentada:]

O erro de raciocínio do analista: ele #emph[supôs] que
`alta_inflacao["alerta"] = True` teria alterado `df` original
(adicionando a coluna `"alerta"` também lá), mas isso não é garantido
--- e, neste caso, de fato não acontece: `df` original nunca ganha a
coluna, daí o `KeyError` ao tentar `df["alerta"]`. A correção depende da
real intenção:

```python
# Se a intenção é marcar isso no DataFrame ORIGINAL:
df["alerta"] = False                                   # cria a coluna com um padrão
df.loc[df["inflacao"] > 10, "alerta"] = True            # atualiza só onde a condição é verdadeira

print(df["alerta"].sum())  # 1 — agora funciona, sem ambiguidade

# Se a intenção era só analisar o subconjunto, sem alterar df:
alta_inflacao = df[df["inflacao"] > 10].copy()
alta_inflacao["alerta"] = True
print(alta_inflacao)   # subconjunto independente, df original permanece sem a coluna
```

O ponto pedagógico central: o `SettingWithCopyWarning` não é "só um
aviso irritante para ignorar" --- ele é o pandas admitindo que
#strong[não sabe dizer] se sua intenção foi cumprida. Tratá-lo como um
erro de fato (parar e reescrever, nunca silenciar com
`pd.options.mode.chained_assignment = None`) é a prática correta.

#line()

== Capítulo 6 --- Filtragem booleana
<capítulo-6-filtragem-booleana>
=== 6.1. O que realmente acontece por baixo dos panos
<o-que-realmente-acontece-por-baixo-dos-panos>
A operação mais usada em pandas é filtrar linhas por condição. A
sintaxe:

```python
df[df["coluna"] condicao]
```

parece mágica, mas é a composição de dois passos simples:

```python
mascara = df["pib"] > 2.0
print(mascara)
```

Saída:

```
0     True
1    False
2     True
3     True
Name: pib, dtype: bool
```

`df["pib"] > 2.0` não retorna um único `True`/`False` --- retorna uma
#strong[Series booleana] do mesmo tamanho que `df`, com um
`True`/`False` para cada linha, calculada de forma vetorizada (Capítulo
1.2). Em seguida, `df[mascara]` seleciona #strong[apenas as linhas onde
a máscara é `True`] --- isso é chamado de #emph[boolean indexing]
(indexação booleana), e é o mecanismo por trás de todo filtro em pandas:

```python
df[mascara]     # equivalente a df[df["pib"] > 2.0]
```

=== 6.2. Combinando condições: por que `and`/`or` não funcionam
<combinando-condições-por-que-andor-não-funcionam>
```python
df[(df["pib"] > 0) & (df["inflacao"] < 10)]   # E lógico
df[(df["pib"] > 3) | (df["pais"] == "Argentina")]  # OU lógico
df[~(df["pais"] == "Brasil")]                  # negação
```

Um erro extremamente comum de quem vem da Apostila 1 é tentar escrever
`df["pib"] > 0 and df["inflacao"] < 10`, usando os operadores lógicos
`and`/`or`/`not` do Python puro (Capítulo 5.3 da Apostila 1). Isso lança
um erro:

```
ValueError: The truth value of a Series is ambiguous. Use a.empty, a.bool(), a.any() or a.all().
```

A razão: `and`/`or`/`not` do Python puro são desenhados para operar
sobre #strong[um único valor de verdade] por vez (um `bool` escalar).
Mas `df["pib"] > 0` é uma #strong[Series inteira] de `True`/`False` ---
Python não sabe como decidir se uma Series inteira é "verdadeira" ou
"falsa" de uma vez só (isso seria ambíguo: bastaria um `True` para
considerar a Series toda "verdadeira"? Todos precisariam ser `True`?).
Por isso, pandas exige os operadores #strong[bit a bit] `&` (E), `|`
(OU) e `~` (negação), que foram redefinidos para funcionar elemento a
elemento em arrays/Series inteiras --- e, crucialmente, #strong[cada
condição precisa estar entre parênteses], porque `&`/`|` têm precedência
mais alta que `>`/`<`/`==` em Python, e sem parênteses a expressão seria
avaliada na ordem errada.

#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([], [Python puro (escalar)], [pandas (elemento a
      elemento)],),
    table.hline(),
    [E lógico], [`and`], [`&` (com parênteses em cada lado)],
    [OU lógico], [`or`], [`\|` (com parênteses em cada lado)],
    [Negação], [`not`], [`~`],
    [Opera sobre], [Um `bool` por vez], [Uma Series/array inteira,
    célula a célula],
  )]
  , kind: table
  )

=== 6.3. Métodos de filtro especializados
<métodos-de-filtro-especializados>
```python
df[df["pais"].isin(["Brasil", "Chile"])]          # está dentro de uma lista de valores
df[df["pib"].between(0, 3)]                        # está entre dois valores (inclusive)
df[df["pais"].str.contains("Bra")]                 # contém um trecho de texto
df[df["pais"].str.startswith("A")]                 # começa com
df[df["pais"].str.endswith("e")]                   # termina com
df[df["pais"].str.contains("bra", case=False)]     # ignora maiúsc./minúsc.
df[df["ipca"].isna()]                              # linhas com dado faltante (Capítulo 8)
```

O acessor `.str` (visto acima em `.str.contains`, `.str.startswith`)
expõe, vetorizado sobre a coluna inteira, praticamente todos os métodos
de string do Python puro vistos na Apostila 1 (Capítulo 6.4: `.upper()`,
`.lower()`, `.strip()`, etc. --- todos têm equivalente como
`df["coluna"].str.upper()`).

=== 6.4. `.query()` --- uma sintaxe alternativa mais legível
<query-uma-sintaxe-alternativa-mais-legível>
```python
df.query("pib > 2 and inflacao < 10")        # dentro de query(), and/or funcionam normalmente!
df.query("pais in ['Brasil', 'Chile']")
df.query("pib > @limite")                     # @variavel referencia uma variável Python externa
```

Dentro de uma string passada a `.query()`, pandas interpreta a expressão
com seu próprio motor (baseado na biblioteca `numexpr`, quando
disponível), que entende `and`/`or`/`in` da forma "natural" --- porque,
nesse contexto, não há ambiguidade sobre Series (a expressão inteira já
é avaliada linha a linha pelo motor de `query`). É uma questão de gosto
e legibilidade: para filtros complexos com muitas condições, `.query()`
costuma ser mais fácil de ler do que uma cadeia longa de `&`/`|` com
parênteses.

=== 6.5. Exemplo Resolvido --- Diagnosticando um filtro que retorna vazio
<exemplo-resolvido-diagnosticando-um-filtro-que-retorna-vazio>
#strong[Enunciado:] o código abaixo deveria retornar os países com PIB
positivo #strong[e] inflação controlada (abaixo de 10%), mas retorna um
DataFrame vazio. Identifique os dois erros.

```python
df = pd.DataFrame({
    "pais": ["Brasil", "Argentina", "Chile", "Colômbia"],
    "pib": [2.2, -1.8, 3.1, 2.8],
    "inflacao": [4.5, 98.0, 3.8, 7.2],
})

resultado = df[df["pib"] > 0 and df["inflacao"] < 10]
```

#strong[Solução comentada:]

Há dois problemas na linha:

+ #strong[`and` em vez de `&`] --- como visto na Seção 6.2, isso deveria
  lançar um `ValueError` ("truth value of a Series is ambiguous"), não
  silenciosamente devolver algo. Ou seja, o primeiro problema real é que
  esse código #strong[nem chegaria a rodar] --- o enunciado descreve um
  sintoma que só ocorreria se o erro fosse outro; isso reforça o hábito
  de sempre ler a mensagem de erro completa (Apostila 1, Capítulo 13.1)
  em vez de assumir qual foi a causa.
+ #strong[Falta de parênteses] em cada condição --- mesmo trocando `and`
  por `&`, `df["pib"] > 0 & df["inflacao"] < 10` seria avaliado
  incorretamente, porque `&` tem precedência maior que `>`, então o
  Python tentaria calcular `0 & df["inflacao"]` antes de comparar com
  `df["pib"]` --- um erro de precedência de operadores.

A correção:

```python
resultado = df[(df["pib"] > 0) & (df["inflacao"] < 10)]
print(resultado)
```

```
     pais  pib  inflacao
0  Brasil  2.2       4.5
2   Chile  3.1       3.8
3  Colômbia 2.8       7.2
```

A forma equivalente com `.query()`, que evita os dois problemas de uma
vez (usa `and` normalmente e não exige parênteses adicionais):

```python
resultado = df.query("pib > 0 and inflacao < 10")
```

#line()

== Capítulo 7 --- Criando, transformando e removendo colunas
<capítulo-7-criando-transformando-e-removendo-colunas>
=== 7.1. Atribuição direta vetorizada (a forma preferida)
<atribuição-direta-vetorizada-a-forma-preferida>
```python
df["pib_per_capita"] = df["pib"] / df["populacao"] * 1000
df["log_pib"] = np.log(df["pib"] + 10)
df["inflacao_decimal"] = df["inflacao"] / 100   # atualiza coluna existente
```

Cada uma dessas linhas é vetorizada (Capítulo 1.2): a divisão,
multiplicação e o logaritmo (`np.log`, do numpy) são aplicados à coluna
#strong[inteira] de uma vez, em código compilado, sem nenhum laço Python
explícito. Essa é, de longe, a forma mais rápida e mais idiomática de
criar uma coluna em pandas.

=== 7.2. `.apply()` com função ou `lambda`
<apply-com-função-ou-lambda>
Quando a transformação não é uma operação aritmética simples entre
colunas --- por exemplo, uma regra condicional linha a linha ---,
`.apply()` permite rodar uma função Python arbitrária sobre cada
elemento (ou cada linha):

```python
# lambda inline
df["classificacao"] = df["pib"].apply(lambda x: "Crescendo" if x > 0 else "Recessão")

# função nomeada, para regras mais elaboradas (mais legível, testável isoladamente)
def classificar_pib(x):
    if x > 3:
        return "Alto"
    elif x > 0:
        return "Médio"
    else:
        return "Negativo"

df["categoria"] = df["pib"].apply(classificar_pib)

# apply em uma LINHA inteira (axis=1) — acessa várias colunas ao mesmo tempo
df["situacao"] = df.apply(
    lambda linha: "Estagflação" if linha["pib"] < 0 and linha["inflacao"] > 5 else "Normal",
    axis=1,
)
```

=== 7.3. Por que `.apply()` é mais lento --- e quando isso importa
<por-que-.apply-é-mais-lento-e-quando-isso-importa>
Este é o análogo direto, em pandas, da comparação "laço vs.~vetorização"
vista na Apostila 1 (Capítulo 10.4). `.apply()` #strong[parece]
vetorizado (é uma única linha, aplicada à coluna "inteira"), mas por
baixo dos panos, para a maioria dos casos, pandas ainda executa a função
Python #strong[uma vez por linha], em um laço interno --- perdendo o
benefício de delegar tudo ao numpy em C. A diferença de desempenho é
irrelevante em tabelas de algumas centenas de linhas, mas se torna
significativa (pode ser 10 a 100 vezes mais lento) em tabelas com
milhões de linhas, como microdados da PNAD ou séries diárias de alta
frequência.

Sempre que existir uma alternativa vetorizada, prefira-a:

```python
# Mais lento (apply percorre linha a linha em Python)
df["classificacao"] = df["pib"].apply(lambda x: "Alto" if x > 3 else ("Médio" if x > 0 else "Negativo"))

# Mais rápido (np.select é vetorizado: avalia todas as condições de uma vez, em C)
condicoes = [df["pib"] > 3, df["pib"] > 0]
categorias = ["Alto", "Médio"]
df["classificacao"] = np.select(condicoes, categorias, default="Negativo")

# Também vetorizado, para uma única condição binária
df["cresceu"] = np.where(df["pib"] > 0, "Sim", "Não")
```

`np.where(condicao, valor_se_verdadeiro, valor_se_falso)` é o
equivalente vetorizado do operador ternário do Python (Apostila 1,
Capítulo 9.3), aplicado a uma coluna inteira de uma vez. `np.select`
generaliza isso para múltiplas condições em cascata, substituindo uma
cadeia de `if/elif/else` (Apostila 1, Capítulo 9.1) por uma única
chamada vetorizada.

#figure(
  align(center)[#table(
    columns: (34.21%, 34.21%, 31.58%),
    align: (auto,auto,auto,),
    table.header([Ferramenta], [Quando usar], [Velocidade],),
    table.hline(),
    [Operação aritmética direta (`df["a"] + df["b"]`)], [Sempre que a
    transformação é matemática entre colunas], [Mais rápida (100%
    vetorizada em C)],
    [`np.where`], [Uma condição binária (se/senão)], [Rápida
    (vetorizada)],
    [`np.select`], [Várias condições em cascata (equivalente a
    `if/elif/elif/else`)], [Rápida (vetorizada)],
    [`.map()` (com dicionário)], [Substituir valores de acordo com um
    mapeamento fixo], [Rápida],
    [`.apply()`], [Lógica arbitrária, complexa demais para as opções
    acima], [Mais lenta --- último recurso],
  )]
  , kind: table
  )

=== 7.4. `.map()`, `.replace()` e renomeação/remoção de colunas
<map-.replace-e-renomeaçãoremoção-de-colunas>
```python
# .map() com um dicionário — substituição elemento a elemento
sigla_para_nome = {"BRA": "Brasil", "ARG": "Argentina", "CHL": "Chile"}
df["nome_pais"] = df["sigla"].map(sigla_para_nome)

# .replace() — troca valores específicos, sem exigir mapear TODOS os valores
df["pais"] = df["pais"].replace({"Bra": "Brasil", "Arg": "Argentina"})

# Renomear colunas
df = df.rename(columns={"pib": "crescimento_pib"})
df.rename(columns={"pib": "crescimento_pib"}, inplace=True)  # altera no lugar, sem reatribuir

# Remover coluna(s)
df = df.drop("coluna_que_nao_quero", axis=1)
df = df.drop(columns=["col_a", "col_b"])   # forma mais explícita, sem precisar de axis=1

# Reordenar colunas (basta selecionar na ordem desejada)
df = df[["pais", "pib", "inflacao", "populacao"]]
```

#strong[Nota sobre `inplace=True`:] esse parâmetro modifica o DataFrame
no próprio objeto, sem exigir reatribuição
(`df.rename(..., inplace=True)` em vez de `df = df.rename(...)`). Parece
conveniente, mas tem o mesmo tipo de risco de ambiguidade visto no
Capítulo 5: se `df` for, ele mesmo, uma #emph[view] de outro DataFrame,
`inplace=True` pode disparar o mesmo `SettingWithCopyWarning`. A
comunidade pandas vem, gradualmente, recomendando #strong[evitar
`inplace=True`] e preferir sempre a forma que retorna um novo objeto
(`df = df.rename(...)`), por ser mais previsível e permitir encadeamento
de métodos (#emph[method chaining], Capítulo 14).

=== 7.5. Exemplo Resolvido --- Reescrevendo um `.apply()` como vetorizado
<exemplo-resolvido-reescrevendo-um-.apply-como-vetorizado>
#strong[Enunciado:] o código abaixo classifica o regime de juro real
(Apostila 1, Capítulo 5.4) usando `.apply()`. Reescreva-o de forma
totalmente vetorizada, sem nenhuma função Python chamada linha a linha.

```python
df = pd.DataFrame({
    "pais": ["Brasil", "Argentina", "Chile", "Turquia"],
    "selic": [10.5, 80.0, 5.5, 45.0],
    "ipca": [4.2, 120.0, 3.8, 55.0],
})

def classifica_juro_real(linha):
    juro_real = linha["selic"] - linha["ipca"]
    if juro_real > 3:
        return "Fortemente positivo"
    elif juro_real > 0:
        return "Positivo"
    else:
        return "Negativo"

df["regime"] = df.apply(classifica_juro_real, axis=1)
```

#strong[Solução comentada:]

```python
# Passo 1: a subtração já é vetorizada (não precisa de apply para isso)
df["juro_real"] = df["selic"] - df["ipca"]

# Passo 2: np.select troca o if/elif/else linha a linha por uma
# avaliação vetorizada das condições sobre a coluna inteira
condicoes = [df["juro_real"] > 3, df["juro_real"] > 0]
categorias = ["Fortemente positivo", "Positivo"]
df["regime"] = np.select(condicoes, categorias, default="Negativo")

print(df[["pais", "juro_real", "regime"]])
```

```
       pais  juro_real               regime
0    Brasil        6.3  Fortemente positivo
1 Argentina      -40.0             Negativo
2     Chile        1.7             Positivo
3   Turquia      -10.0             Negativo
```

O ganho de reescrever não é visível em 4 linhas --- é visível quando
`df` tem 5 milhões de linhas (como uma base de crédito do SCR do BCB,
por exemplo): `.apply(..., axis=1)` chamaria a função Python
`classifica_juro_real` 5 milhões de vezes, uma por uma; a versão com
`np.select` avalia as duas condições sobre o array inteiro de uma vez,
delegando o trabalho ao numpy. A lição estrutural: sempre que uma
transformação "linha a linha" pode ser reescrita como uma sequência de
operações entre colunas inteiras (subtração + comparação), prefira essa
forma.

#line()

== Capítulo 8 --- Dados faltantes (`NaN`) em profundidade
<capítulo-8-dados-faltantes-nan-em-profundidade>
=== 8.1. O que é `NaN`, tecnicamente
<o-que-é-nan-tecnicamente>
`NaN` significa #emph[Not a Number] --- não é uma invenção do pandas, é
um valor especial definido no padrão #strong[IEEE 754], o mesmo padrão
que rege a representação de números de ponto flutuante em praticamente
qualquer linguagem (o mesmo padrão citado na Apostila 1, Capítulo 4.2, a
propósito de `0.1 + 0.2`). `NaN` é tecnicamente um `float`, e isso tem
uma consequência direta e importante:

#quote(block: true)[
#strong[Uma coluna `int64` que ganha um valor faltante é automaticamente
promovida a `float64`] --- porque não existe uma representação de `NaN`
dentro do espaço de bits reservado para inteiros. Uma coluna de
população (`int64`) que, ao ser cruzada com outra fonte, ganha um `NaN`
em uma linha, silenciosamente vira `float64` inteira, e valores que eram
`214` passam a aparecer como `214.0`.
]

```python
populacao = pd.Series([214, 46, 19], dtype="int64")
populacao_com_falha = pd.Series([214, None, 19])
print(populacao_com_falha.dtype)   # float64, não int64!
print(populacao_com_falha)
# 0    214.0
# 1      NaN
# 2     19.0
# dtype: float64
```

Isso é diferente de `None`, o valor "vazio" do Python puro (Apostila 1,
Capítulo 9.5): `None` é um objeto Python genérico, que pode aparecer em
qualquer coluna `object`\; `NaN` é especificamente um valor de ponto
flutuante. Quando você escreve `None` dentro de uma lista/Series que
pandas está tentando tornar numérica, pandas geralmente o
#strong[converte para `NaN`] automaticamente, como no exemplo acima.

Desde a versão 1.0, pandas introduziu #strong[`pd.NA`], um marcador de
ausência mais genérico, pensado para funcionar com os #strong[dtypes
anuláveis] (`Int64`, `boolean`, `string` --- com letra maiúscula,
diferentes de `int64`, `bool`, `object`). Uma coluna `Int64` (nullable)
pode ter um valor faltante #strong[sem] perder o tipo inteiro:

```python
populacao_nullable = pd.Series([214, None, 19], dtype="Int64")  # "I" maiúsculo
print(populacao_nullable)
# 0     214
# 1    <NA>
# 2      19
# dtype: Int64
```

=== 8.2. Detectando dados faltantes
<detectando-dados-faltantes>
```python
df.isnull()           # DataFrame de True/False, célula a célula (isna() é sinônimo exato)
df.isnull().sum()      # quantos nulos por coluna
df.isnull().sum().sum()  # total de nulos na tabela inteira
df.notnull()           # o oposto de isnull()

df["ipca"].isna()      # versão para uma única coluna
```

=== 8.3. Removendo linhas/colunas com dado faltante
<removendo-linhascolunas-com-dado-faltante>
```python
df.dropna()                       # remove QUALQUER linha com pelo menos um nulo
df.dropna(subset=["pib"])         # remove só se "pib" especificamente for nulo
df.dropna(how="all")              # remove só se TODOS os valores da linha forem nulos
df.dropna(thresh=3)               # mantém a linha se tiver ao menos 3 valores não-nulos
df.dropna(axis=1)                 # remove COLUNAS (não linhas) com algum nulo
```

=== 8.4. Preenchendo dados faltantes
<preenchendo-dados-faltantes>
```python
df.fillna(0)                        # preenche com um valor fixo
df.fillna(df.mean(numeric_only=True))  # preenche cada coluna com sua própria média
df["pib"].fillna(df["pib"].median()) # preenche com a mediana (mais robusta a outliers que a média)

df["ipca"].ffill()   # "forward fill" — repete o último valor válido conhecido
df["ipca"].bfill()   # "backward fill" — usa o próximo valor válido conhecido

df["ipca"].interpolate()   # interpolação linear entre os valores vizinhos válidos
```

A escolha entre essas estratégias depende do #strong[motivo] do dado
faltar --- um ponto conceitual, não apenas técnico, que muitos tutoriais
pulam:

#figure(
  align(center)[#table(
    columns: (22.22%, 57.78%, 20%),
    align: (auto,auto,auto,),
    table.header([Situação], [Estratégia recomendada], [Por quê],),
    table.hline(),
    [Feriado bancário (câmbio, SELIC diária)], [`ffill()`], [O valor do
    dia útil anterior é a melhor aproximação --- o mercado só não
    operou],
    [Divulgação atrasada do IBGE (dado ainda não saiu)], [Deixar como
    `NaN`, não preencher], [Preencher "inventaria" um dado que ainda não
    existe; melhor esperar ou marcar explicitamente como projeção],
    [Erro de digitação isolado, sem padrão], [`interpolate()` ou remover
    a linha], [Depende do quanto esse ponto isolado afeta a análise (ex:
    uma média móvel)],
    [Série realmente descontínua (país começou a existir em certo
    ano)], [`dropna()` no período sem dado], [Preencher artificialmente
    distorceria qualquer estatística sobre o período anterior],
  )]
  , kind: table
  )

#strong[Armadilha comum:] preencher `NaN` com `0` em uma coluna de taxa
de crescimento (PIB, inflação) é quase sempre um erro --- `0` tem um
significado econômico próprio ("estabilidade", "nem cresceu nem caiu"),
e não deve ser confundido com "não sei o valor". Preencher com `0`
silenciosamente distorce qualquer média ou correlação calculada depois.

=== 8.5. Exemplo Resolvido --- Diagnosticando a causa de um `NaN` antes de tratá-lo
<exemplo-resolvido-diagnosticando-a-causa-de-um-nan-antes-de-tratá-lo>
#strong[Enunciado:] ao rodar `df.isnull().sum()` você obtém:

```
data        0
selic       0
ipca        2
cambio     45
dtype: int64
```

A coluna `cambio` (câmbio diário) tem 45 valores faltantes em uma série
de 260 dias úteis de um ano; a coluna `ipca` (mensal) tem 2 valores
faltantes em 12 meses. Antes de escolher `ffill`, `dropna` ou
`interpolate`, que hipótese você investigaria para cada coluna, e como
confirmaria cada hipótese em código?

#strong[Solução comentada:]

Para `cambio`: 45 em 260 dias úteis é compatível com feriados nacionais
e municipais (não todo feriado é feriado bancário em todo lugar, mas a
ordem de grandeza bate). A hipótese: os `NaN` se concentram em datas
específicas conhecidas (feriados), não espalhados aleatoriamente.

```python
print(df[df["cambio"].isna()]["data"])   # inspeciona quais datas específicas faltam
```

Se as datas baterem com feriados conhecidos, `ffill()` é apropriado (o
câmbio do último dia útil é a melhor aproximação para um dia sem
pregão):

```python
df["cambio"] = df["cambio"].ffill()
```

Para `ipca`: 2 em 12 meses é uma proporção muito mais alta (16%) para
uma série mensal que deveria ser completa --- isso sugere um problema de
importação (Capítulo 2.6/3.4), não uma ausência genuína de dado. A
hipótese aqui é diferente: #strong[provavelmente não é dado realmente
ausente, é erro de leitura].

```python
print(df[df["ipca"].isna()])   # inspeciona as linhas inteiras — o valor bruto (antes do parse) ajuda
```

Se a inspeção mostrar que essas duas linhas tinham um valor como `"-"`
ou vírgula decimal mal interpretada, a correção correta é #strong[voltar
ao Capítulo 2] e ajustar `na_values`/`decimal` na importação --- não
aplicar `ffill()` cegamente sobre um problema que na verdade é de
leitura do arquivo. A lição central: #strong[o tratamento certo de um
`NaN` depende de diagnosticar a causa primeiro]\; aplicar `fillna()` ou
`dropna()` sem entender por que o dado falta é tratar o sintoma, não a
causa.

#line()

== Capítulo 9 --- Agrupamento (`groupby`)
<capítulo-9-agrupamento-groupby>
=== 9.1. O paradigma split-apply-combine
<o-paradigma-split-apply-combine>
`groupby` é o equivalente de uma tabela dinâmica do Excel, mas a lógica
por trás dele tem nome formal, cunhado por Hadley Wickham (autor do
pacote `dplyr`, de R) e adotado também pela documentação de pandas:
#strong[split-apply-combine].

```
              SPLIT                    APPLY                  COMBINE
        (divide por grupo)      (aplica uma função        (junta os resultados
                                  a cada grupo)              de volta em uma tabela)

  df.groupby("pais")  →   ["pib"].mean()  →   uma linha por país, com a média
```

+ #strong[Split]: os dados são divididos em grupos, de acordo com os
  valores de uma ou mais colunas (`groupby("pais")` cria um grupo para
  cada país distinto).
+ #strong[Apply]: uma função (média, soma, contagem, ou uma função
  personalizada) é aplicada #strong[independentemente] a cada grupo.
+ #strong[Combine]: os resultados de cada grupo são recombinados em uma
  única estrutura de saída.

```python
dados = {
    "ano": [2020, 2020, 2020, 2021, 2021, 2021],
    "pais": ["Brasil", "Argentina", "Chile", "Brasil", "Argentina", "Chile"],
    "pib": [-3.3, -9.9, -6.1, 4.8, 10.4, 11.7],
}
df = pd.DataFrame(dados)

df.groupby("pais")["pib"].mean()
```

```
pais
Argentina    0.25
Brasil       0.75
Chile        2.80
Name: pib, dtype: float64
```

Repare que `df.groupby("pais")` sozinho #strong[não retorna uma tabela]
--- retorna um objeto intermediário (`DataFrameGroupBy`), que representa
a "divisão" ainda sem a etapa de aplicar/combinar. É só ao encadear
`["pib"].mean()` que as três etapas se completam.

=== 9.2. Múltiplas agregações com `.agg()`
<múltiplas-agregações-com-.agg>
```python
df.groupby("pais")["pib"].agg(["mean", "min", "max", "std"])

# Nomeando as colunas de saída explicitamente (agregação nomeada,
# a forma mais legível e recomendada em pandas moderno)
df.groupby("pais")["pib"].agg(
    media_pib=("pib", "mean"),
    minimo_pib=("pib", "min"),
    volatilidade=("pib", "std"),
)

# Agregações diferentes para colunas diferentes
df.groupby("pais").agg({
    "pib": ["mean", "std"],
    "ano": "count",
})
```

=== 9.3. Agrupando por múltiplas colunas
<agrupando-por-múltiplas-colunas>
```python
df.groupby(["ano", "pais"])["pib"].sum()
```

```
ano   pais
2020  Argentina    -9.9
      Brasil       -3.3
      Chile        -6.1
2021  Argentina    10.4
      Brasil        4.8
      Chile        11.7
Name: pib, dtype: float64
```

O resultado tem um #strong[MultiIndex] (índice hierárquico, com dois
níveis: ano e país) --- a extensão natural do Index visto no Capítulo
1.4 para mais de uma dimensão, análoga ao dicionário aninhado da
Apostila 1 (Capítulo 8.4: `pib_por_ano["Brasil"]["2024"]`), só que como
estrutura tabular nativa do pandas. Para voltar a um formato "plano"
(colunas normais, sem hierarquia), use `.reset_index()`:

```python
resultado = df.groupby(["ano", "pais"])["pib"].sum().reset_index()
```

=== 9.4. `.transform()` vs.~`.agg()` --- resultado do mesmo tamanho ou reduzido
<transform-vs.-.agg-resultado-do-mesmo-tamanho-ou-reduzido>
Uma distinção que confunde iniciantes: `.agg()` (e `.mean()`, `.sum()`,
etc.) #strong[reduz] cada grupo a um único valor --- a tabela de saída é
menor que a de entrada (uma linha por grupo). `.transform()`, por outro
lado, devolve um resultado do #strong[mesmo tamanho] da tabela original,
repetindo o valor agregado em cada linha do seu grupo --- útil para
comparar cada observação individual contra a média do seu próprio grupo:

```python
# Cria uma coluna com a média do PIB do PRÓPRIO grupo (país), repetida em cada linha
df["pib_medio_pais"] = df.groupby("pais")["pib"].transform("mean")

# Isso permite calcular, por exemplo, o desvio de cada observação frente à média do seu país
df["desvio_da_media_do_pais"] = df["pib"] - df["pib_medio_pais"]

print(df)
```

```
    ano       pais   pib  pib_medio_pais  desvio_da_media_do_pais
0  2020     Brasil  -3.3            0.75                    -4.05
1  2020  Argentina  -9.9            0.25                   -10.15
2  2020      Chile  -6.1            2.80                    -8.90
3  2021     Brasil   4.8            0.75                     4.05
4  2021  Argentina  10.4            0.25                    10.15
5  2021      Chile  11.7            2.80                     8.90
```

=== 9.5. Exemplo Resolvido --- Volatilidade do PIB por país, ordenada
<exemplo-resolvido-volatilidade-do-pib-por-país-ordenada>
#strong[Enunciado:] dado o `df` com PIB de vários países ao longo de
vários anos (mesma estrutura da Seção 9.1, mas com mais anos), calcule o
desvio-padrão do PIB de cada país e ordene do mais volátil ao mais
estável. Em seguida, identifique quais países têm volatilidade acima da
média de todos os países.

```python
dados = {
    "ano": [2019, 2020, 2021, 2019, 2020, 2021, 2019, 2020, 2021],
    "pais": ["Brasil", "Brasil", "Brasil", "Argentina", "Argentina", "Argentina",
             "Chile", "Chile", "Chile"],
    "pib": [1.2, -3.3, 4.8, -2.0, -9.9, 10.4, 0.8, -6.1, 11.7],
}
df = pd.DataFrame(dados)
```

#strong[Solução comentada:]

```python
volatilidade = df.groupby("pais")["pib"].std().sort_values(ascending=False)
print(volatilidade)
```

```
pais
Chile        9.294...
Argentina    10.312...
Brasil       4.114...
Name: pib, dtype: float64
```

\(A ordem exata depende do cálculo --- o ponto é o método, não os
números decorados.)

```python
media_das_volatilidades = volatilidade.mean()
acima_da_media = volatilidade[volatilidade > media_das_volatilidades]
print(acima_da_media)
```

O desvio-padrão amostral que `.std()` calcula segue:

$ s = sqrt(frac(1, n - 1) sum_(i = 1)^n\(x_i - macron(x)\)^2) $

Note o `n-1` no denominador (correção de Bessel) --- voltaremos a essa
fórmula, e a uma armadilha importante envolvendo ela, no Capítulo 12.1.
O raciocínio de todo o exercício segue o padrão split-apply-combine:
#strong[split] por país, #strong[apply] do desvio-padrão a cada grupo,
#strong[combine] em uma Series indexada por país --- e, depois, uma
segunda agregação (a média das volatilidades) sobre o resultado já
agregado, um padrão comum em análises de "agregação de agregações" (ex:
volatilidade média entre países de uma região).

#line()

== Capítulo 10 --- Combinando tabelas: `merge`, `concat`, `join`
<capítulo-10-combinando-tabelas-merge-concat-join>
=== 10.1. `merge` --- juntando por uma chave comum
<merge-juntando-por-uma-chave-comum>
`pd.merge` é o equivalente ao PROCV/PROCX do Excel, ou ao `JOIN` de SQL
--- mas opera em ambas as tabelas simultaneamente, e não célula por
célula.

```python
pib_df = pd.DataFrame({"pais": ["Brasil", "Argentina", "Chile"], "pib": [2.2, -1.8, 3.1]})
inf_df = pd.DataFrame({"pais": ["Brasil", "Argentina", "Peru"], "inflacao": [4.5, 98.0, 3.2]})

# INNER (padrão): só as linhas cuja chave existe nas DUAS tabelas
pd.merge(pib_df, inf_df, on="pais")
```

```
       pais  pib  inflacao
0    Brasil  2.2       4.5
1  Argentina -1.8      98.0
```

Repare que `Chile` (só está em `pib_df`) e `Peru` (só está em `inf_df`)
desaparecem --- essa é a característica do `inner join`: só sobrevive a
interseção.

```python
# LEFT: todas as linhas da tabela ESQUERDA, mesmo sem par na direita (vira NaN)
pd.merge(pib_df, inf_df, on="pais", how="left")

# RIGHT: todas as linhas da tabela DIREITA
pd.merge(pib_df, inf_df, on="pais", how="right")

# OUTER: união de tudo, com NaN onde faltar
pd.merge(pib_df, inf_df, on="pais", how="outer")
```

#figure(
  align(center)[#table(
    columns: (17.02%, 17.02%, 65.96%),
    align: (auto,auto,auto,),
    table.header([`how=`], [Mantém], [Analogia visual (conjuntos)],),
    table.hline(),
    [`"inner"` (padrão)], [Só chaves presentes nas #strong[duas]
    tabelas], [Interseção],
    [`"left"`], [Todas as chaves da tabela à #strong[esquerda],
    completando com `NaN` o que faltar na direita], [Tudo do círculo
    esquerdo],
    [`"right"`], [Todas as chaves da tabela à #strong[direita]], [Tudo
    do círculo direito],
    [`"outer"`], [União --- todas as chaves de ambas, `NaN` onde não
    houver correspondência], [União completa],
  )]
  , kind: table
  )

```python
# Quando os nomes das colunas-chave são diferentes entre as tabelas
pd.merge(pib_df, inf_df, left_on="pais", right_on="country")

# indicator=True adiciona uma coluna "_merge" dizendo a origem de cada linha
# ("left_only", "right_only", "both") -- ótimo para auditar merges
resultado = pd.merge(pib_df, inf_df, on="pais", how="outer", indicator=True)
print(resultado["_merge"].value_counts())
```

#strong[Armadilha comum: merge "muitos-para-muitos" acidental.] Se a
coluna-chave tiver valores duplicados nas duas tabelas (por exemplo,
várias linhas de "Brasil" em cada uma, por engano de importação),
`merge` gera o #strong[produto cartesiano] das duplicatas ---
silenciosamente multiplicando o número de linhas, sem erro. O parâmetro
`validate` protege contra isso:

```python
pd.merge(pib_df, inf_df, on="pais", validate="one_to_one")
# lança um erro explícito (MergeError) se qualquer um dos dois lados tiver chaves duplicadas
```

=== 10.2. `concat` --- empilhando tabelas
<concat-empilhando-tabelas>
`concat` serve a um propósito diferente de `merge`: #strong[não junta
por chave], apenas #strong[empilha] tabelas, seja adicionando linhas
(mais comum: juntar o mesmo tipo de dado de anos ou fontes diferentes)
ou colunas.

```python
pib_2023 = pd.DataFrame({"pais": ["Brasil", "Chile"], "pib": [2.9, 0.2]})
pib_2024 = pd.DataFrame({"pais": ["Brasil", "Chile"], "pib": [3.1, 2.6]})

# Empilha linhas (axis=0, o padrão) — como um UNION em SQL
todos_anos = pd.concat([pib_2023, pib_2024], keys=["2023", "2024"])

# ignore_index=True descarta os índices originais e cria um novo RangeIndex sequencial
todos_anos = pd.concat([pib_2023, pib_2024], ignore_index=True)

# Empilha colunas lado a lado (axis=1) -- exige que os índices estejam alinhados
lado_a_lado = pd.concat([pib_df.set_index("pais"), inf_df.set_index("pais")], axis=1)
```

=== 10.3. `join` --- atalho baseado no Index
<join-atalho-baseado-no-index>
```python
pib_indexado = pib_df.set_index("pais")
inf_indexada = inf_df.set_index("pais")

resultado = pib_indexado.join(inf_indexada, how="left")
```

`.join()` é essencialmente um `merge` especializado que usa o
#strong[Index] de ambas as tabelas como chave, em vez de uma coluna
explícita --- conveniente quando os dados já estão indexados pela mesma
coisa (o que reforça, de novo, por que o Capítulo 1.4 tratou o Index
como um cidadão de primeira classe, não como um detalhe cosmético).

=== 10.4. Exemplo Resolvido --- Cruzando três fontes com chaves diferentes
<exemplo-resolvido-cruzando-três-fontes-com-chaves-diferentes>
#strong[Enunciado:] você tem PIB (BCB), inflação (IBGE, via Ipeadata) e
câmbio médio anual (BCB) de países da América Latina, mas cada fonte usa
uma convenção de nome de país ligeiramente diferente, e nem todas cobrem
os mesmos países. Junte as três em uma única tabela, preservando todos
os países que aparecem em #strong[pelo menos uma] fonte, e identifique
quais países têm dado incompleto.

```python
pib = pd.DataFrame({"pais": ["Brasil", "Argentina", "Chile", "Peru"], "pib": [2.2, -1.8, 3.1, 2.5]})
inflacao = pd.DataFrame({"country": ["Brasil", "Argentina", "Colômbia"], "inflacao": [4.5, 98.0, 7.2]})
cambio = pd.DataFrame({"pais": ["Brasil", "Chile", "Colômbia"], "cambio_medio": [5.45, 950.2, 4100.0]})
```

#strong[Solução comentada:]

```python
# Passo 1: merge outer entre pib e inflacao, com nomes de coluna-chave diferentes
etapa1 = pd.merge(pib, inflacao, left_on="pais", right_on="country", how="outer")
etapa1 = etapa1.drop(columns="country")   # "country" é redundante após o merge

# Passo 2: merge outer do resultado com cambio
completo = pd.merge(etapa1, cambio, on="pais", how="outer")
print(completo)
```

```
       pais  pib  inflacao  cambio_medio
0    Brasil  2.2       4.5          5.45
1 Argentina -1.8      98.0           NaN
2     Chile  3.1       NaN        950.20
3      Peru  2.5       NaN           NaN
4  Colômbia  NaN       7.2       4100.00
```

```python
# Passo 3: identificar países com dado incompleto (algum NaN na linha)
incompletos = completo[completo.isnull().any(axis=1)]
print(incompletos["pais"].tolist())
# ['Argentina', 'Chile', 'Peru', 'Colômbia']
```

O uso de `how="outer"` em cascata (fonte 1 + fonte 2, depois esse
resultado + fonte 3) é o padrão correto quando o objetivo é #strong[não
perder nenhum país só porque uma fonte não o cobre] --- usar
`how="inner"` aqui destruiria silenciosamente três dos cinco países,
sobrando só o Brasil (única linha sem nenhum `NaN`).
`df.isnull().any(axis=1)` retorna `True` para qualquer linha que tenha
#strong[pelo menos um] `NaN` em qualquer coluna (`axis=1` pede para
verificar "ao longo das colunas", isto é, dentro de cada linha) --- a
forma idiomática de detectar registros incompletos após uma série de
merges externos.

#line()

== Capítulo 11 --- Datas e séries temporais
<capítulo-11-datas-e-séries-temporais>
=== 11.1. `to_datetime` e o acessor `.dt`
<to_datetime-e-o-acessor-.dt>
```python
df["data"] = pd.to_datetime(df["data"])         # converte texto/número para datetime64[ns]
df["data"] = pd.to_datetime(df["data"], dayfirst=True)  # trata "01/02/2024" como 1º de fevereiro

df["ano"] = df["data"].dt.year
df["mes"] = df["data"].dt.month
df["dia"] = df["data"].dt.day
df["trimestre"] = df["data"].dt.quarter
df["dia_semana"] = df["data"].dt.day_name()      # "Monday", "Tuesday", ...
df["fim_de_mes"] = df["data"].dt.is_month_end    # booleano
```

O acessor `.dt` funciona de forma análoga ao `.str` visto no Capítulo
6.3: ele expõe, vetorizado sobre a coluna inteira, um conjunto de
propriedades e métodos específicos de datas --- só disponível quando a
coluna já é `datetime64[ns]` (daí a importância de `parse_dates` na
leitura, Capítulo 2.2, ou de `pd.to_datetime` explícito).

=== 11.2. Data como Index --- a base de toda série temporal em pandas
<data-como-index-a-base-de-toda-série-temporal-em-pandas>
```python
df["data"] = pd.to_datetime(df["data"])
df = df.set_index("data")

df.loc["2020"]                  # todo o ano de 2020
df.loc["2020-01":"2020-06"]     # primeiro semestre de 2020 (fim INCLUSIVE, Capítulo 4.4)
df.loc["2020-01-15":"2020-03-15"]  # intervalo exato de datas

df[df.index >= "2020-01-01"]     # filtro booleano tradicional, também funciona
```

Quando o Index de um DataFrame é um `DatetimeIndex`, `.loc` ganha um
comportamento especial de #strong[parsing parcial de data]:
`df.loc["2020"]` entende que você quer o ano inteiro,
`df.loc["2020-01"]` entende o mês inteiro --- sem que você precise
escrever `df.loc["2020-01-01":"2020-01-31"]` manualmente. Essa é uma das
razões mais fortes para usar a data como Index em vez de mantê-la como
uma coluna comum.

=== 11.3. `resample` --- mudando a frequência de uma série temporal
<resample-mudando-a-frequência-de-uma-série-temporal>
```python
df.resample("M").mean()    # agrega para frequência MENSAL, calculando a média de cada mês
df.resample("Q").mean()    # trimestral
df.resample("Y").mean()    # anual
df.resample("D").mean()    # diário
df.resample("W").sum()     # semanal, somando (não fazendo média) os valores de cada semana
```

#strong[`resample` vs.~`groupby` --- qual a diferença conceitual?] Os
dois seguem o mesmo paradigma split-apply-combine (Capítulo 9.1), mas
`groupby` agrupa por #strong[valores discretos de uma coluna] (país,
categoria), enquanto `resample` agrupa por #strong[intervalos de tempo
fixos] (todo mês, todo trimestre) usando o `DatetimeIndex`.
Tecnicamente, `df.resample("M").mean()` é equivalente a agrupar por
`(df.index.year, df.index.month)` --- mas `resample` também
#strong[preenche automaticamente períodos sem nenhuma observação] (um
mês sem nenhum dado vira uma linha com `NaN`, em vez de simplesmente não
aparecer), o que `groupby` não faz.

#quote(block: true)[
#strong[Nota de versão:] a partir do pandas 2.2, os aliases de
frequência de calendário como `"M"` (mês) e `"Y"` (ano) foram renomeados
para `"ME"` (#emph[month end]) e `"YE"` (#emph[year end]) para maior
clareza, mantendo `"M"`/`"Y"` como sinônimos com aviso de depreciação em
versões de transição. Ao escrever código novo, prefira as formas
explícitas (`"ME"`, `"QE"`, `"YE"`) se sua versão de pandas já as
suportar.
]

=== 11.4. Defasagem (lag), diferenças e variação percentual
<defasagem-lag-diferenças-e-variação-percentual>
```python
df["pib_lag1"] = df["pib"].shift(1)     # valor do período ANTERIOR (defasagem de 1)
df["pib_lag2"] = df["pib"].shift(2)     # defasagem de 2 períodos
df["pib_lead1"] = df["pib"].shift(-1)   # valor do período SEGUINTE ("lead", defasagem negativa)

df["pib_diff"] = df["pib"].diff()           # diferença absoluta frente ao período anterior
df["pib_pct"] = df["pib"].pct_change() * 100  # variação percentual frente ao período anterior
```

`pct_change()` calcula, para cada linha, exatamente:

$ % Delta x_t = frac(x_t - x_(t - 1), x_(t - 1)) $

--- a mesma fórmula de taxa de crescimento usada para calcular a
variação mensal do IPCA a partir do índice de preços, ou a valorização
cambial mês a mês.

=== 11.5. Médias móveis (`rolling`) e janelas expansivas (`expanding`)
<médias-móveis-rolling-e-janelas-expansivas-expanding>
```python
df["pib_mm3"] = df["pib"].rolling(window=3).mean()    # média móvel de 3 períodos
df["pib_mm12"] = df["pib"].rolling(window=12).mean()  # média móvel de 12 períodos (comum p/ dados mensais)
df["pib_vol3"] = df["pib"].rolling(window=3).std()    # volatilidade móvel (desvio-padrão em janela)

# min_periods permite calcular mesmo antes da janela estar "cheia"
df["pib_mm12_parcial"] = df["pib"].rolling(window=12, min_periods=1).mean()

# expanding() usa TODOS os dados até a linha atual (janela que só cresce)
df["pib_media_acumulada"] = df["pib"].expanding().mean()
```

A diferença entre `rolling` e `expanding`: `rolling(window=N)` sempre
olha para os últimos `N` pontos (uma "janela deslizante" de tamanho
fixo); `expanding()` sempre olha para #strong[todos os pontos desde o
início da série] (uma janela que cresce a cada linha) --- útil, por
exemplo, para calcular a inflação acumulada desde o início do ano
corrente, ou uma média histórica que se atualiza a cada novo mês sem
"esquecer" o passado.

=== 11.6. Exemplo Resolvido --- IPCA acumulado em 12 meses, calculado do zero
<exemplo-resolvido-ipca-acumulado-em-12-meses-calculado-do-zero>
#strong[Enunciado:] o BCB divulga o "IPCA acumulado em 12 meses" como
uma série pronta (código SGS 13522), mas é instrutivo saber calculá-lo a
partir da série mensal (código 433) --- porque a mesma técnica serve
para deflacionar qualquer série de valores nominais. Dada a série mensal
de IPCA (%), calcule o IPCA acumulado nos últimos 12 meses, mês a mês,
usando `rolling`.

```python
datas = pd.date_range("2023-01-01", periods=15, freq="MS")  # MS = início do mês
ipca_mensal = pd.Series(
    [0.53, 0.84, 0.71, 0.61, 0.23, 0.08, 0.12, 0.23, 0.26, 0.28, 0.28, 0.56,
     0.42, 0.83, 0.16],
    index=datas,
    name="ipca",
)
```

#strong[Solução comentada:]

O erro conceitual mais comum aqui é #strong[somar] as 12 taxas mensais.
Inflação #strong[composta], não soma --- a mesma distinção entre juros
simples e compostos da Apostila 1 (Capítulo 5.1). A fórmula correta para
a inflação acumulada em uma janela de $n$ meses é:

$ upright("IPCA")_(upright("acum")\,t) = [product_(k = 0)^(n - 1) (1 + i_(t - k) / 100)] - 1 $

```python
def acumulado_composto(janela):
    fatores = 1 + janela / 100
    return (fatores.prod() - 1) * 100

ipca_acum_12m = ipca_mensal.rolling(window=12).apply(acumulado_composto)
print(ipca_acum_12m.tail())
```

`rolling(window=12).apply(funcao)` aplica uma função personalizada a
cada janela de 12 observações consecutivas --- diferente de
`rolling(12).mean()`, que já vem pronta, aqui precisamos de uma
composição multiplicativa, não uma média, então fornecemos nossa própria
função. `janela.prod()` calcula o produtório dos 12 fatores
`(1 + i/100)` dentro daquela janela específica --- exatamente a mesma
lógica usada para compor juros mês a mês (Apostila 1, Capítulo 10.5), só
que aplicada automaticamente a cada janela deslizante de 12 meses pela
infraestrutura do `rolling`.

Vale registrar: como o `.rolling(window=12)` exige 12 observações
completas por padrão, os 11 primeiros meses da série de saída vêm como
`NaN` (Capítulo 8) --- não há 12 meses anteriores disponíveis para eles
ainda.

#line()

== Capítulo 12 --- Estatística descritiva com pandas
<capítulo-12-estatística-descritiva-com-pandas>
=== 12.1. Tendência central e dispersão
<tendência-central-e-dispersão>
```python
df["pib"].mean()      # média aritmética
df["pib"].median()    # mediana (mais robusta a outliers que a média)
df["pib"].std()       # desvio-padrão AMOSTRAL (ddof=1 por padrão)
df["pib"].var()       # variância amostral
df["pib"].min()
df["pib"].max()
df["pib"].quantile(0.25)               # 1º quartil
df["pib"].quantile([0.25, 0.5, 0.75])  # vários quantis de uma vez
df["pib"].skew()       # assimetria (skewness)
df["pib"].kurtosis()   # curtose (peso das caudas da distribuição)
```

Média e mediana:

$ macron(x) = 1 / n sum_(i = 1)^n x_i #h(2em) #h(2em) upright("mediana") = x_((frac(n + 1, 2))) upright(" (valor central, dados ordenados)") $

#strong[Armadilha importante: `pandas.std()` e `numpy.std()` usam
convenções diferentes por padrão.]

$ s_(upright("amostral")) = sqrt(frac(1, n - 1) sum_(i = 1)^n\(x_i - macron(x)\)^2) #h(2em) #h(2em) sigma_(upright("populacional")) = sqrt(1 / n sum_(i = 1)^n\(x_i - macron(x)\)^2) $

#figure(
  align(center)[#table(
    columns: (14.06%, 48.44%, 37.5%),
    align: (auto,auto,auto,),
    table.header([Chamada], [Convenção usada por padrão], [Parâmetro
      para mudar],),
    table.hline(),
    [`df["pib"].std()` (pandas)], [Amostral, `ddof=1` (denominador
    $n - 1$)], [`ddof=0` para populacional],
    [`np.std(array)` (numpy puro)], [Populacional, `ddof=0` (denominador
    $n$)], [`ddof=1` para amostral],
  )]
  , kind: table
  )

```python
serie = pd.Series([1, 2, 3, 4, 5])
print(serie.std())          # 1.5811... (ddof=1, amostral -- padrão do pandas)
print(np.std(serie))        # 1.4142... (ddof=0, populacional -- padrão do numpy!)
print(serie.std(ddof=0))    # 1.4142... (agora bate com numpy)
```

Essa divergência de convenção #strong[entre as duas bibliotecas mais
usadas juntas em Python] é uma fonte real de erro sutil: se um
economista calcula o desvio-padrão de uma série com `.std()` do pandas
em um lugar do código, e com `np.std()` em outro (por exemplo, ao
comparar contra um resultado de uma biblioteca de terceiros que só
aceita array numpy), os dois números #strong[não vão bater] --- não por
erro de cálculo, mas por convenção diferente de $n - 1$ vs.~$n$. A
diferença desaparece à medida que $n$ cresce (a razão $n\/\(n - 1\)$
tende a 1), mas é material para amostras pequenas --- exatamente o caso
comum em séries macroeconômicas anuais, que raramente têm mais que
algumas dezenas de observações.

=== 12.2. Correlação
<correlação>
```python
df["pib"].corr(df["inflacao"])       # correlação de Pearson entre duas Series
df[["pib", "inflacao", "populacao"]].corr()   # matriz de correlação completa
df.corr(numeric_only=True).round(2)  # arredondada, ignorando colunas de texto
```

A correlação de Pearson entre duas variáveis $x$ e $y$:

$ r_(upright("xy")) = frac(sum_(i = 1)^n\(x_i - macron(x)\)\(y_i - macron(y)\), sqrt(sum_(i = 1)^n\(x_i - macron(x)\)^2) thin sqrt(sum_(i = 1)^n\(y_i - macron(y)\)^2)) $

$r_(upright("xy"))$ varia entre $- 1$ (correlação negativa perfeita) e
$+ 1$ (correlação positiva perfeita), com $0$ indicando ausência de
relação #strong[linear] --- o que não implica ausência de qualquer
relação (duas variáveis podem ter uma relação forte, porém não-linear, e
ainda assim $r_(upright("xy")) approx 0$).

#strong[Correlação não é causalidade] --- o alerta mais repetido (e mais
frequentemente ignorado) em qualquer curso de estatística ou econometria
introdutória. `df.corr()` mede associação estatística, nunca prova que
uma variável causa outra: câmbio e inflação podem estar correlacionados
porque o câmbio afeta a inflação (#emph[pass-through] cambial), porque a
inflação afeta expectativas que afetam o câmbio, ou porque uma terceira
variável (por exemplo, a política monetária dos EUA) afeta as duas
simultaneamente. A Apostila 4 (Econometria) tratará ferramentas
desenhadas para investigar causalidade --- regressão com controles,
causalidade de Granger, variáveis instrumentais --- que exigem hipóteses
muito mais fortes do que uma simples correlação.

=== 12.3. Exemplo Resolvido --- Comparando volatilidade entre duas décadas
<exemplo-resolvido-comparando-volatilidade-entre-duas-décadas>
#strong[Enunciado:] dada uma série de câmbio (R\$/US\$) diário, compare
a volatilidade (desvio-padrão) do período 2010-2014 contra 2020-2024, e
verifique se a diferença é grande o suficiente para não ser só ruído
estatístico de amostra pequena (usando o raciocínio de `ddof` da Seção
12.1 --- sem fazer teste de hipótese formal, que é assunto de
estatística inferencial).

```python
np.random.seed(42)
datas = pd.date_range("2010-01-01", "2024-12-31", freq="B")  # dias úteis
cambio = pd.Series(
    5.0 + np.cumsum(np.random.normal(0, 0.01, size=len(datas))),
    index=datas,
    name="cambio",
)
```

#strong[Solução comentada:]

```python
periodo_1 = cambio.loc["2010":"2014"]
periodo_2 = cambio.loc["2020":"2024"]

vol_1 = periodo_1.std()
vol_2 = periodo_2.std()

print(f"Volatilidade 2010-2014: {vol_1:.4f}")
print(f"Volatilidade 2020-2024: {vol_2:.4f}")
print(f"n período 1: {len(periodo_1)}, n período 2: {len(periodo_2)}")
```

Repare que ambos os `.std()` usam `ddof=1` (padrão do pandas)
automaticamente --- o que é o correto aqui, porque estamos tratando cada
período como uma #strong[amostra] de um processo cambial mais amplo, não
como a população inteira de todos os valores de câmbio possíveis. Se os
dois períodos tiverem tamanhos de amostra muito diferentes ($n$ bem
diferente), isso por si só já introduz mais incerteza na comparação ---
outro motivo pelo qual, para uma conclusão estatisticamente rigorosa
(não apenas descritiva), seria necessário um teste de hipótese formal
(teste F de igualdade de variâncias, por exemplo), fora do escopo desta
apostila e reservado para a trilha de econometria.

#line()

== Capítulo 13 --- Exportando dados e um script completo do mundo real
<capítulo-13-exportando-dados-e-um-script-completo-do-mundo-real>
=== 13.1. Salvando resultados
<salvando-resultados>
```python
df.to_csv("dados_processados.csv", index=False)                         # sem a coluna de índice
df.to_csv("dados_processados.csv", index=False, decimal=",", sep=";")   # formato "brasileiro"
df.to_excel("dados_processados.xlsx", sheet_name="Dados", index=False)
df.to_parquet("dados_processados.parquet")   # formato binário colunar -- mais rápido e compacto
                                              # que CSV para bases grandes; preserva dtypes exatamente
```

`to_parquet` merece menção mesmo sem ter sido usado nos capítulos
anteriores: diferente de CSV (que é sempre texto, e por isso perde a
informação de `dtype` --- tudo volta a ser reinterpretado na leitura), o
formato Parquet preserva tipos de dado exatamente, comprime melhor e é
lido/escrito mais rápido. Para bases grandes (milhões de linhas, como
microdados), é preferível a CSV sempre que o arquivo não precisar ser
aberto manualmente no Excel.

=== 13.2. Script completo --- o que um economista faz no dia a dia
<script-completo-o-que-um-economista-faz-no-dia-a-dia>
```python
import pandas as pd
import numpy as np
from bcb import sgs

# 1. Baixar dados (BCB SGS: 433 = IPCA mensal, 11 = SELIC diária)
ipca = sgs.get({"IPCA": 433}, start="2015-01-01")
selic = sgs.get({"SELIC": 11}, start="2015-01-01")

# 2. Juntar as duas séries por data
df = pd.merge(ipca, selic, on="Date", how="inner")
df = df.set_index("Date")
df.index = pd.to_datetime(df.index)

# 3. Criar colunas derivadas
df["juro_real_aprox"] = df["SELIC"] - df["IPCA"]
df["ipca_acum_12m"] = df["IPCA"].rolling(window=12).apply(
    lambda janela: ((1 + janela / 100).prod() - 1) * 100
)

# 4. Filtrar o período de interesse (usando o Index datetime, Capítulo 11.2)
recentes = df.loc["2023":]

# 5. Diagnosticar dados faltantes antes de qualquer estatística (Capítulo 8)
print("Nulos por coluna:")
print(recentes.isnull().sum())

# 6. Estatísticas descritivas
print("\nCorrelação IPCA x SELIC (2023+):")
print(recentes[["IPCA", "SELIC"]].corr().round(3))

# 7. Salvar em formato brasileiro
recentes.to_csv("analise_bcb.csv", decimal=",", sep=";")
print("\nArquivo salvo: analise_bcb.csv")
```

Este script resume, em sequência, praticamente todos os capítulos desta
apostila: importação de fonte real (Capítulo 2), Index e alinhamento por
data (Capítulos 1 e 11), criação vetorizada de colunas (Capítulo 7),
diagnóstico de nulos antes de estatísticas (Capítulo 8), estatística
descritiva (Capítulo 12) e exportação no formato esperado por um leitor
brasileiro (Capítulo 13.1). É, deliberadamente, o roteiro que se repete
--- com variações --- em praticamente qualquer análise macroeconômica de
curto prazo.

#line()

== Capítulo 14 --- Boas práticas com pandas
<capítulo-14-boas-práticas-com-pandas>
Assim como a Apostila 1 fechou a teoria com um capítulo de boas práticas
gerais de código, pandas tem hábitos próprios que evitam retrabalho e
bugs sutis:

- #strong[Rode `df.info()` logo após qualquer importação.] É o
  equivalente pandas do "debugging por print" da Apostila 1 --- barato,
  rápido, e revela a maioria dos problemas de tipo e de dado faltante
  antes que eles se propaguem.

- #strong[Prefira vetorização a `.apply()`, e `.apply()` a um loop `for`
  manual.] Nessa ordem de preferência (Capítulo 7.3). Reserve
  `.apply()`/loops para lógica genuinamente impossível de vetorizar.

- #strong[Trate `SettingWithCopyWarning` como um erro, nunca o
  silencie.] Ele existe porque o pandas não consegue garantir a intenção
  do seu código (Capítulo 5) --- ignorá-lo é assinar um cheque em branco
  para um bug que vai aparecer mais tarde, em outro lugar do pipeline.

- #strong[Evite `inplace=True`] na maior parte do código novo ---
  prefira reatribuir (`df = df.metodo(...)`), que é mais previsível e
  permite encadear métodos (#emph[method chaining]):

  ```python
  resultado = (
      df.dropna(subset=["pib"])
        .query("pib > 0")
        .assign(pib_milhares=lambda d: d["pib"] * 1000)
        .sort_values("pib", ascending=False)
  )
  ```

  Esse estilo --- uma sequência de métodos encadeados, cada um numa
  linha, formando uma "receita" legível de cima a baixo --- é
  considerado idiomático em pandas moderno, e evita a criação de várias
  variáveis intermediárias (`df2`, `df3`, `df_final`) que só existem
  para guardar um passo intermediário.

- #strong[Nomeie colunas em `snake_case`, sem espaços ou acentos quando
  possível] (`pib_per_capita`, não `"PIB per Capita"`) --- evita ter que
  usar sempre colchetes (nunca o atalho `df.coluna`) e problemas de
  codificação ao salvar/reabrir arquivos.

- #strong[Sempre confira o `dtype` antes de comparar ou agregar uma
  coluna.] Uma coluna numérica lida como `object` (Capítulo 3.3/3.4) vai
  silenciosamente comparar como texto, produzindo resultados sem sentido
  sem lançar erro algum.

#line()

== Capítulo 15 --- Exercícios para Executar (na mão)
<capítulo-15-exercícios-para-executar-na-mão>
Estes exercícios não exigem computador: o objetivo é treinar o
raciocínio sobre como pandas se comporta antes de testar no código.
Resolva no papel. #strong[As soluções não estão neste documento] ---
quando terminar, peça para eu conferir suas respostas.

=== Exercício 1 --- Trace de `.loc` vs.~`.iloc`
<exercício-1-trace-de-.loc-vs.-.iloc>
Dado o DataFrame abaixo (índice #strong[não] é 0,1,2,… --- foi definido
manualmente):

```python
df = pd.DataFrame(
    {"pib": [2.2, -1.8, 3.1, 2.8]},
    index=[10, 20, 30, 40],
)
```

Sem rodar no computador, diga o que cada expressão abaixo retorna
(quantas linhas, quais valores):

```python
a) df.iloc[0:2]
b) df.loc[10:30]
c) df.iloc[1:3]
d) df.loc[20:40]
```

=== Exercício 2 --- Calculando correlação de Pearson na mão
<exercício-2-calculando-correlação-de-pearson-na-mão>
Dadas as séries de PIB e inflação de 4 anos:

```
pib:      [1.0, 2.0, 3.0, 4.0]
inflacao: [8.0, 6.0, 4.0, 2.0]
```

Calcule, usando papel e caneta (ou calculadora, mas sem
`pandas`/`numpy`), a correlação de Pearson $r_(upright("xy"))$ entre as
duas séries, usando a fórmula da Seção 12.2. Que sinal (positivo ou
negativo) você esperava antes de calcular, só olhando o padrão das duas
séries?

=== Exercício 3 --- Encontre o erro: `SettingWithCopyWarning`
<exercício-3-encontre-o-erro-settingwithcopywarning>
O trecho abaixo gera um `SettingWithCopyWarning`. Explique, em suas
próprias palavras, por que o aviso ocorre (o que pandas não consegue
garantir) e reescreva o código de duas formas diferentes: uma que
garanta que `df` original seja modificado, e outra que garanta que `df`
original #strong[não] seja modificado.

```python
df = pd.DataFrame({"pais": ["Brasil", "Chile"], "pib": [2.2, 3.1]})
alta = df[df["pib"] > 2.5]
alta["destaque"] = True
```

=== Exercício 4 --- Pseudocódigo do split-apply-combine
<exercício-4-pseudocódigo-do-split-apply-combine>
Descreva, em português estruturado (sem precisar ser código Python
válido, no mesmo espírito do Exercício 5 da Apostila 1), o algoritmo que
`df.groupby("regiao")["pib"].mean()` executa internamente, nomeando
explicitamente as três etapas (split, apply, combine) e o que acontece
em cada uma.

=== Exercício 5 --- Prevendo dtypes após um merge externo
<exercício-5-prevendo-dtypes-após-um-merge-externo>
Duas tabelas são unidas com `how="outer"`: a primeira tem uma coluna
`populacao` como `int64`, sem nenhum valor faltante; a segunda tabela
não tem essa coluna. Depois do merge, algumas linhas (as que só existiam
na segunda tabela) não têm valor de `populacao`. Sem rodar no
computador, diga qual será o `dtype` final da coluna `populacao` no
resultado, e explique o porquê usando o conceito do Capítulo 8.1.

=== Exercício 6 --- `rolling` vs.~`expanding`, na mão
<exercício-6-rolling-vs.-expanding-na-mão>
Dada a série de PIB trimestral `[1.0, 2.0, -1.0, 3.0, 0.5]` (índices 0 a
4), calcule manualmente:

#block[
#set enum(numbering: "a)", start: 1)
+ `rolling(window=2).mean()` para cada posição (mostre `NaN` onde não
  houver 2 observações completas).
+ `expanding().mean()` para cada posição.
]

Compare os dois resultados na posição de índice 4 e explique a diferença
conceitual entre as duas janelas.

#line()

== Capítulo 16 --- Exercícios para Executar (em código)
<capítulo-16-exercícios-para-executar-em-código>
Implemente e execute cada um no seu editor ou notebook. #strong[As
soluções não estão neste documento] --- o objetivo é você rodar de
verdade e ver o resultado; quando terminar, peça para eu revisar seu
código.

=== Exercício 1 --- Primeira exploração
<exercício-1-primeira-exploração>
Crie um DataFrame com PIB, inflação, desemprego e câmbio médio de 6
países de sua escolha. Rode `df.info()`, `df.describe()` e `df.dtypes`,
e escreva um comentário para cada coluna dizendo se o `dtype` está como
esperado.

=== Exercício 2 --- `.loc` vs `.iloc` na prática
<exercício-2-.loc-vs-.iloc-na-prática>
Usando o DataFrame do Exercício 1 com o índice trocado para as siglas
dos países (`df.index = [...]`), escreva quatro seleções diferentes: uma
linha por posição, uma linha por rótulo, um intervalo de linhas por
posição, e um intervalo de linhas por rótulo. Confirme se o resultado
bate com o que você esperava sobre inclusão/exclusão do limite final.

=== Exercício 3 --- Reproduzindo o `SettingWithCopyWarning`
<exercício-3-reproduzindo-o-settingwithcopywarning>
Escreva deliberadamente um código que produza o aviso (indexação
encadeada), confirme que o aviso aparece, e então reescreva-o de forma
segura usando `.loc` em uma única chamada.

=== Exercício 4 --- Filtro composto
<exercício-4-filtro-composto>
Dado o DataFrame abaixo, filtre os países com PIB positivo #strong[e]
inflação abaixo de 10%, depois filtre os países com PIB negativo
#strong[ou] inflação acima de 50%. Refaça o segundo filtro usando
`.query()`.

```python
df = pd.DataFrame({
    "pais": ["Brasil", "Argentina", "Chile", "Turquia", "Peru"],
    "pib": [2.2, -1.8, 3.1, 3.0, 2.5],
    "inflacao": [4.5, 98.0, 3.8, 55.0, 3.2],
})
```

=== Exercício 5 --- `np.select` substituindo `.apply()`
<exercício-5-np.select-substituindo-.apply>
Reescreva a classificação abaixo (atualmente feita com `.apply()`)
usando `np.select`, e compare os dois resultados para garantir que são
idênticos:

```python
def classifica(pib):
    if pib > 3:
        return "Alto"
    elif pib > 0:
        return "Médio"
    else:
        return "Negativo"

df["categoria_apply"] = df["pib"].apply(classifica)
```

=== Exercício 6 --- Diagnóstico e tratamento de nulos
<exercício-6-diagnóstico-e-tratamento-de-nulos>
Dado o DataFrame abaixo, rode `isnull().sum()`, decida (e justifique em
comentário) uma estratégia de tratamento diferente para cada coluna com
base na Seção 8.4, e aplique-a.

```python
df = pd.DataFrame({
    "data": pd.date_range("2024-01-01", periods=10, freq="D"),
    "cambio": [5.10, 5.12, None, None, 5.15, 5.14, 5.16, None, 5.18, 5.20],
    "ipca_mensal": [0.42, None, None, None, None, None, None, None, None, None],
})
```

=== Exercício 7 --- `groupby` com múltiplas agregações nomeadas
<exercício-7-groupby-com-múltiplas-agregações-nomeadas>
Usando o DataFrame de PIB por país e ano (crie um com pelo menos 3
países e 4 anos), calcule, por país: média, desvio-padrão, mínimo e
máximo do PIB, usando agregação nomeada
(`.agg(nome=("coluna", "função"))`).

=== Exercício 8 --- `transform` para desvio em relação ao grupo
<exercício-8-transform-para-desvio-em-relação-ao-grupo>
Usando o mesmo DataFrame do Exercício 7, crie uma coluna com o desvio de
cada observação de PIB em relação à média do seu próprio país, usando
`.groupby(...).transform("mean")`.

=== Exercício 9 --- Merge com `indicator` e auditoria
<exercício-9-merge-com-indicator-e-auditoria>
Crie duas tabelas de países parcialmente sobrepostas (cada uma com
países que a outra não tem). Faça um merge `outer` com `indicator=True`
e conte quantas linhas vieram de `"left_only"`, `"right_only"` e
`"both"`.

=== Exercício 10 --- `validate` capturando um merge indevido
<exercício-10-validate-capturando-um-merge-indevido>
Crie duas tabelas em que a coluna-chave tenha uma duplicata proposital
em uma delas. Rode o merge sem `validate` e observe o número de linhas
resultante; depois rode com `validate="one_to_one"` e confirme que um
erro é lançado.

=== Exercício 11 --- `concat` de múltiplos anos
<exercício-11-concat-de-múltiplos-anos>
Crie três DataFrames pequenos, um para cada ano (2022, 2023, 2024),
todos com as mesmas colunas. Empilhe os três com `pd.concat`, usando
`keys=` para conseguir depois identificar de qual ano cada linha veio,
mesmo após juntar tudo.

=== Exercício 12 --- Índice de tempo e fatiamento por período
<exercício-12-índice-de-tempo-e-fatiamento-por-período>
Crie uma série diária de 3 anos de um valor simulado de câmbio (pode
usar `np.random`), com o Index como `DatetimeIndex`. Filtre: (a) o ano
do meio inteiro, (b) o segundo trimestre do primeiro ano, (c) um
intervalo arbitrário de 10 dias.

=== Exercício 13 --- `resample` mensal a partir de dados diários
<exercício-13-resample-mensal-a-partir-de-dados-diários>
Usando a série do Exercício 12, calcule a média mensal (`resample("M")`)
e a média trimestral. Compare o número de linhas resultante em cada
caso.

=== Exercício 14 --- Defasagem, diferença e variação percentual
<exercício-14-defasagem-diferença-e-variação-percentual>
Usando uma série mensal de 24 meses de um indicador de sua escolha, crie
colunas com defasagem de 1 e 3 períodos, diferença absoluta, e variação
percentual. Verifique manualmente (para as duas primeiras linhas) se os
valores calculados por pandas batem com o que você esperaria.

=== Exercício 15 --- Reconstruindo o IPCA acumulado em 12 meses
<exercício-15-reconstruindo-o-ipca-acumulado-em-12-meses>
Reproduza o Exemplo Resolvido do Capítulo 11.6 com uma série de 30 meses
de sua escolha (valores entre -0.5% e 1.5%, por exemplo). Depois,
confira o resultado do último mês somando manualmente (sem compor) as 12
taxas --- mostre que a soma simples e o resultado composto são
diferentes, e explique por que o composto é o correto.

=== Exercício 16 --- `std` do pandas vs.~`numpy`, lado a lado
<exercício-16-std-do-pandas-vs.-numpy-lado-a-lado>
Crie uma Series com 5 valores. Calcule o desvio-padrão de quatro formas:
`.std()` do pandas (padrão), `.std(ddof=0)`, `np.std()` (padrão) e
`np.std(ddof=1)`. Confirme quais pares batem entre si e explique o
porquê usando o conceito da Seção 12.1.

=== Exercício 17 --- Matriz de correlação com `numeric_only`
<exercício-17-matriz-de-correlação-com-numeric_only>
Crie um DataFrame com pelo menos 4 colunas numéricas e 1 coluna de texto
(nome do país). Calcule a matriz de correlação completa, arredondada a 2
casas decimais, sem que a coluna de texto cause erro.

=== Exercício 18 --- Método encadeado (#emph[method chaining])
<exercício-18-método-encadeado-method-chaining>
Reescreva o pipeline abaixo (escrito com variáveis intermediárias) como
uma única cadeia de métodos, no estilo do Capítulo 14:

```python
df1 = df.dropna(subset=["pib"])
df2 = df1[df1["pib"] > 0]
df3 = df2.sort_values("pib", ascending=False)
df3["pib_milhares"] = df3["pib"] * 1000
resultado = df3
```

=== Exercício 19 --- Exportando em dois formatos
<exercício-19-exportando-em-dois-formatos>
Dado qualquer DataFrame de sua criação com pelo menos 3 colunas
numéricas, exporte-o em `.csv` (formato brasileiro: `;` e `,`) e em
`.xlsx`. Releia os dois arquivos de volta em DataFrames separados e
confirme, com `.dtypes`, se algum tipo de dado mudou entre a exportação
e a releitura.

=== Exercício 20 --- `category` e uso de memória
<exercício-20-category-e-uso-de-memória>
Crie uma coluna de texto com 100.000 linhas, mas apenas 5 valores
distintos repetidos (por exemplo, região do país). Compare
`df.memory_usage(deep=True)` antes e depois de converter essa coluna
para `dtype="category"`, e reporte a economia de memória em percentual.

=== Exercício 21 --- Projeto integrador: painel BCB completo
<exercício-21-projeto-integrador-painel-bcb-completo>
Combine praticamente tudo do capítulo: baixe (ou simule, se não tiver
acesso à internet, usando `np.random` com uma tendência) o IPCA mensal e
a SELIC diária de 2018 até hoje; junte as duas séries por mês
(reamostrando a SELIC diária para mensal antes); calcule juro real
aproximado, IPCA acumulado em 12 meses e uma média móvel de 3 meses do
juro real; filtre para os últimos 3 anos; calcule a matriz de
correlação; e salve o resultado final em CSV no formato brasileiro.
Estruture o script em passos comentados, como no Capítulo 13.2.

#line()

== Capítulo Final --- Resumo
<capítulo-final-resumo>
#figure(
  align(center)[#table(
    columns: (55.56%, 44.44%),
    align: (auto,auto,),
    table.header([Operação], [Código],),
    table.hline(),
    [Abrir CSV (com opções
    brasileiras)], [`pd.read_csv("f.csv", sep=";", decimal=",", parse_dates=["data"])`],
    [Ver estrutura/tipos], [`df.info()` / `df.dtypes`],
    [Selecionar por posição], [`df.iloc[0:3]` (fim exclusivo)],
    [Selecionar por rótulo], [`df.loc["a":"c"]` (fim inclusivo!)],
    [Filtrar linhas], [`df[(df["x"] > 0) & (df["y"] < 10)]`],
    [Cópia explícita e segura], [`sub = df[mascara].copy()`],
    [Atribuir com filtro, sem
    aviso], [`df.loc[mascara, "col"] = valor`],
    [Nova coluna vetorizada], [`df["nova"] = df["x"] * 2`],
    [Classificação
    vetorizada], [`np.select([...], [...], default=...)`],
    [Checar/tratar nulos], [`df.isnull().sum()` / `df.fillna(...)` /
    `df.dropna(...)`],
    [Agrupar], [`df.groupby("x")["y"].agg(media=("y","mean"))`],
    [Desvio em relação ao
    grupo], [`df.groupby("x")["y"].transform("mean")`],
    [Juntar tabelas por
    chave], [`pd.merge(df1, df2, on="x", how="outer")`],
    [Empilhar tabelas], [`pd.concat([df1, df2], ignore_index=True)`],
    [Data como índice], [`df.set_index("data")`],
    [Filtrar por período], [`df.loc["2020-01":"2020-06"]`],
    [Mudar frequência], [`df.resample("M").mean()`],
    [Lag / diferença / variação %], [`df["x"].shift(1)` / `.diff()` /
    `.pct_change()`],
    [Média móvel], [`df["x"].rolling(3).mean()`],
    [Desvio-padrão amostral], [`df["x"].std()` (pandas: ddof=1; numpy:
    ddof=0!)],
    [Correlação], [`df.corr(numeric_only=True)`],
    [Salvar], [`df.to_csv("saida.csv", decimal=",", sep=";")`],
  )]
  , kind: table
  )

#line()

== Próxima apostila
<próxima-apostila>
Quando terminar os exercícios acima, siga para a #strong[Apostila 3 ---
Visualização de Dados (matplotlib e seaborn)]. Lá você vai aprender a
transformar as tabelas que já sabe manipular em gráficos prontos para
publicação --- séries temporais, dispersões, histogramas e painéis com
múltiplos subplots --- usando as mesmas fontes de dados brasileiras
(BCB, Ipeadata, IBGE) e os mesmos DataFrames construídos nesta apostila.
