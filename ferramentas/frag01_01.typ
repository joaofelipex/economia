%%% BEFORE_CHAPTER_END: == Capítulo 1 --- Por que Python
#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria, exemplos executados e boas práticas, com foco em economia]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
Esta é a primeira de uma série de apostilas de Python para economia. Ela
ensina a #strong[linguagem em si]: como o Python pensa (memória, tipos,
sequências, funções, erros). Sem esse alicerce, as bibliotecas de análise de
dados parecem mágica --- e a mágica falha de formas misteriosas. Com ele,
os erros ficam legíveis.

Cada tópico segue três camadas: #strong[(1) o porquê] (o que acontece "por baixo"),
#strong[(2) o exemplo] (código curto, #emph[executado] --- os resultados impressos
foram obtidos rodando o código) e #strong[(3) a prática] (exercícios no fim, sem
gabarito, para você resolver). Caixas coloridas:

#exemplo("modelo")[Um exemplo executado e comentado.]

#intuicao[A ideia por trás do mecanismo, sem jargão.]

#teoria("modelo")[O que acontece "por baixo": modelo mental preciso.]

#atencao[Um erro clássico de iniciante (e de veterano distraído).]

#mercado[Como o conceito aparece no trabalho de um economista.]

#strong[Como estudar.] (1) Digite o código (não copie e cole). (2) Antes de rodar, preveja a
saída. (3) Quando errar a previsão, descubra #emph[por quê]: é aí que o modelo mental se
corrige. (4) Só então olhe a explicação.
%%% END

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- Como o Python executa seu código
#figure(
  align(center)[#table(
    columns: (20%, 27%, 27%, 26%),
    align: (left, left, left, left),
    table.header([Ferramenta], [Ponto forte], [Limite], [Quando usar],),
    [Excel / Planilhas], [Visual, imediato, universal], [Difícil de auditar e de repetir em escala], [Cálculo pontual, comunicação com não técnicos],
    [Stata], [Econometria padrão em artigos acadêmicos], [Licença paga; linguagem de propósito específico], [Replicar artigos, equipes acostumadas],
    [R], [Estatística e gráficos; ótima comunidade acadêmica], [Menos usado fora da academia e estatística], [Estatística aplicada, pesquisa],
    [#strong[Python]], [Linguagem geral: dados, automação, web, IA], [Menos "pronto" para estatística que o R], [Pipeline completo, automação, produção],
  )]
  , kind: table
  )

#teoria("o ecossistema que esta série percorre")[
  Python sozinho faz pouco em análise de dados; o poder vem de #strong[bibliotecas] construídas sobre ele:

  - #strong[NumPy] --- arrays numéricos rápidos (a base de tudo).
  - #strong[pandas] --- tabelas (DataFrames), séries temporais, leitura de arquivos (Apostila 2).
  - #strong[Matplotlib / seaborn] --- gráficos (Apostila 3).
  - #strong[statsmodels / scikit-learn] --- econometria e aprendizado de máquina (Apostila 4).
  - #strong[python-bcb, wbdata, yfinance] --- acesso a dados do Banco Central, Banco Mundial, mercado.

  Todas dependem dos fundamentos desta apostila: listas viram arrays, dicionários viram
  DataFrames, funções viram transformações, erros viram sinais de dado sujo.
]

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- Variáveis e o modelo de memória
#teoria("do texto ao resultado: as etapas de execução")[
  Quando você roda um arquivo `.py`, o interpretador faz, em ordem: (1) #strong[análise léxica], quebrando o
  texto em "palavras" (tokens); (2) #strong[análise sintática], organizando-as numa árvore (AST) que reflete a
  estrutura do programa --- aqui nascem os `SyntaxError`; (3) #strong[compilação para bytecode], instruções
  de uma máquina virtual; (4) #strong[execução] do bytecode, linha a linha --- aqui nascem `NameError`,
  `TypeError`, `ZeroDivisionError` e demais erros de #emph[execução]. Um programa pode ter 100 linhas
  corretas e uma 101ª com erro de sintaxe: #strong[nenhuma] linha roda, porque a análise sintática falha antes.
  Já um erro de execução só aparece quando o código chega naquela linha.
]

```python
import ast
arvore = ast.parse("juros = capital * taxa")
print(ast.dump(arvore, indent=2))
```

#exemplo("erro de sintaxe e erro de execução")[
  O código abaixo tem um erro de #emph[sintaxe] (parêntese aberto) e outro de #emph[execução]. Compare
  quando cada um é detectado:
]

```python
codigo_sintaxe = "print('antes')\nx = (1 + 2\nprint('depois')"
try:
    compile(codigo_sintaxe, "<exemplo>", "exec")
except SyntaxError as erro:
    print(f"Erro de sintaxe detectado ANTES de rodar qualquer linha: {erro.msg} (linha {erro.lineno})")

codigo_execucao = "print('antes')\nx = 1 / 0\nprint('depois')"
try:
    exec(compile(codigo_execucao, "<exemplo>", "exec"))
except ZeroDivisionError as erro:
    print(f"Erro de execução: {erro} (a primeira linha já havia rodado)")
```

#mercado[
  #strong[Reprodutibilidade.] Em pesquisa e em trabalho profissional, "funciona no meu computador" não basta.
  Um ambiente isolado (`venv`) e um arquivo de dependências (`requirements.txt`) registram as bibliotecas
  e versões usadas, para que o resultado possa ser reproduzido meses depois ou por um colega:

  ```bash
  python -m venv .venv                 # cria um ambiente isolado
  .venv\Scripts\activate               # ativa (Windows); no Linux/macOS: source .venv/bin/activate
  pip install pandas numpy matplotlib  # instala dentro do ambiente
  pip freeze > requirements.txt        # registra as versões exatas
  ```
]

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Tipos de dados primitivos
#teoria("variáveis são rótulos: identidade, igualdade e contagem de referências")[
  Em `x = [1, 2]`, o Python cria o objeto lista na memória e #strong[amarra o nome] `x` a ele. `y = x`
  não copia nada: cria #emph[outro rótulo] para o mesmo objeto. Duas perguntas diferentes:

  - `a == b` --- os #strong[valores] são iguais?
  - `a is b` --- são o #strong[mesmo objeto] (mesma identidade)?

  Para tipos imutáveis (números, strings, tuplas), o aliasing é inofensivo, porque o objeto não muda. Para
  tipos #strong[mutáveis] (listas, dicionários), duas variáveis para o mesmo objeto significam que alterar por
  uma delas altera "as duas" --- fonte clássica de bugs.
]

```python
a = [1, 2, 3]
b = a                  # outro rótulo para o MESMO objeto
c = list(a)            # cópia: novo objeto com os mesmos valores
b.append(4)
print(f"a = {a} | b = {b} | c = {c}")
print(f"a is b: {a is b} | a is c: {a is c} | a == c (valores): {a == [1, 2, 3, 4]} / c == [1, 2, 3]: {c == [1, 2, 3]}")

x, y = 256, 256
m, n = 10_000, 10_000
print(f"Inteiros pequenos (256) são reaproveitados; para 10_000 isso é um detalhe de implementação: x == y -> {x == y}")
```

#atencao[
  Use `==` para comparar #emph[valores] e `is` apenas para comparar com `None` (`if x is None`). O
  comportamento de `is` com números e strings depende de otimizações da implementação, e não deve ser
  usado para testar igualdade.
]

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Operadores
#teoria("dinheiro em ponto flutuante: Decimal, arredondamento e tolerância")[
  O `float` é binário e aproximado (seção 4.2). Para #strong[valores monetários] com contabilidade exata, existe
  o módulo `decimal`, que opera em base 10. E o #strong[arredondamento] também tem armadilhas: `round()` no
  Python usa o #strong[arredondamento bancário] (para o par mais próximo no empate), e o `float` armazena
  `2.675` como algo ligeiramente abaixo de 2,675.
]

```python
from decimal import Decimal, ROUND_HALF_UP
import math

acumulado_float, acumulado_decimal = 0.0, Decimal("0")
for _ in range(10):                      # laço explícito (o sum() do Python 3.12 já compensa parte do erro)
    acumulado_float += 0.1
    acumulado_decimal += Decimal("0.1")
print("Dez vezes +0,10 em float  :", acumulado_float, "| == 1.0?", acumulado_float == 1.0)
print("Dez vezes +0,10 em Decimal:", acumulado_decimal, "| == 1?", acumulado_decimal == 1)

print("\nround(0.5), round(1.5), round(2.5):", round(0.5), round(1.5), round(2.5), "(empates vão para o par)")
print("round(2.675, 2) =", round(2.675, 2), "(esperaria 2.68)")
print("Decimal('2.675') arredondado: ", Decimal("2.675").quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))

print("\nmath.isclose(0.1 + 0.2, 0.3):", math.isclose(0.1 + 0.2, 0.3))
```

#mercado[
  #strong[Regra prática.] Para análise econômica (taxas, índices, séries), `float` basta: o erro de
  $10^(-16)$ é irrelevante frente à incerteza dos dados. Para #strong[contabilidade, faturamento e
  conciliação bancária], onde os centavos precisam fechar, use `Decimal` (ou inteiros em centavos). E,
  em qualquer caso, #strong[compare floats com tolerância], nunca com `==`.
]

#teoria("inteiros de precisão arbitrária e o cuidado com conversões")[
  O `int` do Python não tem limite de tamanho: `2 ** 200` é calculado exatamente. Isso é útil, por exemplo,
  em combinatória e em contagens enormes, mas #strong[converter] para `float` pode perder dígitos:
  `float(10 ** 30 + 1) == float(10 ** 30)` é `True`.
]

```python
print(2 ** 100)
print("float(10**30 + 1) == float(10**30) ->", float(10 ** 30 + 1) == float(10 ** 30), "(o '+1' sumiu na conversão)")
print("int(-5.9) =", int(-5.9), "| math.floor(-5.9) =", math.floor(-5.9), "| round(-5.9) =", round(-5.9))
```

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Strings em detalhe
#figure(
  align(center)[#table(
    columns: (10%, 56%, 34%),
    align: (center, left, left),
    table.header([Nível], [Operadores (do que "amarra" mais para o que amarra menos)], [Exemplo],),
    [1], [`**` (potência)], [`2 ** 3 ** 2` = 512],
    [2], [`+x`, `-x` (sinal), `not`], [`-2 ** 2` = −4],
    [3], [`*`, `/`, `//`, `%`], [`10 + 6 / 2` = 13,0],
    [4], [`+`, `-`], [],
    [5], [`<`, `<=`, `>`, `>=`, `==`, `!=`, `is`, `in`], [`1 < 2 == 2` encadeia],
    [6], [`and`], [],
    [7], [`or`], [`a or b and c` = `a or (b and c)`],
  )]
  , kind: table
  )

#teoria("divisão inteira e módulo com números negativos; `and`/`or` devolvem operandos")[
  `//` arredonda em direção a #strong[menos infinito] (não em direção a zero) e `%` herda o sinal do divisor,
  de modo que vale sempre `a == (a // b) * b + a % b`. E `and`/`or` não devolvem sempre `True`/`False`:
  devolvem #strong[um dos operandos], o que permite a expressão "valor padrão": `x or padrao`.
]

```python
print("-7 // 2 =", -7 // 2, "| -7 % 2 =", -7 % 2, "| divmod(-7, 2) =", divmod(-7, 2), "| identidade:", (-7 // 2) * 2 + (-7 % 2))
print("int(-7 / 2) =", int(-7 / 2), "(trunca para zero) -> diferente de -7 // 2")

taxa_informada = ""                                  # vazio => usar o padrão
print("'' or 'sem dado':", repr(taxa_informada or "sem dado"), "| 'Brasil' and 'BR':", repr("Brasil" and "BR"), "| 0 or None:", repr(0 or None))
print("2 ** 3 ** 2 =", 2 ** 3 ** 2, "| (2 ** 3) ** 2 =", (2 ** 3) ** 2, "| -2 ** 2 =", -2 ** 2)
```

#atencao[
  O `or` como "valor padrão" tem um efeito colateral: `taxa or 5.0` trata `0.0` como "ausente", porque
  zero é falso. Se zero é um valor #emph[legítimo] (uma taxa de 0%), use `if taxa is None: taxa = 5.0`.
]

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Listas
#teoria("texto, bytes e acentos: Unicode e normalização")[
  Uma `str` é uma sequência de #strong[pontos de código Unicode]; para gravar em arquivo ou transmitir, ela é
  convertida em #strong[bytes] por uma codificação (UTF-8 é o padrão atual). Ler um arquivo com a
  codificação #emph[errada] gera o clássico "mojibake" (`SÃ£o Paulo`). Além disso, um mesmo caractere
  acentuado pode ter duas representações Unicode (composta e decomposta), e `==` as considera #emph[diferentes] ---
  um problema real ao cruzar nomes vindos de sistemas diferentes.
]

```python
import unicodedata
nome = "São Paulo"
bytes_utf8 = nome.encode("utf-8")
print("UTF-8:", bytes_utf8, "| lido como latin-1 (errado):", bytes_utf8.decode("latin-1"))

composta = "ç"                                          # um único ponto de código
decomposta = unicodedata.normalize("NFD", "ç")          # 'c' + acento separado
print(f"len composta = {len(composta)}, len decomposta = {len(decomposta)} | iguais com ==? {composta == decomposta}")
print("Após normalizar (NFC):", unicodedata.normalize("NFC", composta) == unicodedata.normalize("NFC", decomposta))
print("casefold:", "STRASSE".casefold() == "straße".casefold(), "| lower:", "STRASSE".lower() == "straße".lower())
```

#exemplo("extraindo campos com expressões regulares (módulo `re`)")[
  Quando o formato de uma string é regular, mas variável, `split` e fatiamento ficam frágeis. Uma
  #strong[expressão regular] descreve o padrão. Exemplo: datas no formato brasileiro `dd/mm/aaaa`, com
  validação de formato:
]

```python
import re
padrao = re.compile(r"(\d{2})/(\d{2})/(\d{4})")
for texto in ["31/12/2025", "5/1/2026", "01-02-2026"]:
    m = padrao.fullmatch(texto)
    print(f"{texto!r:14} -> {('dia %s, mês %s, ano %s' % m.groups()) if m else 'formato inválido'}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Dicionários
#teoria("o custo das operações em listas e a escolha entre lista e tupla")[
  A lista é um #strong[array dinâmico]: acesso por índice e `append` são rápidos (tempo constante); inserir
  ou remover no #strong[início] exige deslocar todos os elementos (tempo proporcional ao tamanho);
  procurar um valor (`x in lista`) percorre a lista (tempo proporcional). Saber isso explica por que `x in lista` num laço
  sobre milhares de elementos fica lento --- e por que um conjunto (`set`) ou dicionário resolve melhor (capítulo 8).
  A #strong[tupla] é uma lista #strong[imutável]: serve para registros que não devem mudar (`(ano, trimestre)`) e pode
  ser usada como chave de dicionário.
]

```python
import copy
meses = ["jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago"]
print("meses[::2] =", meses[::2], "| meses[::-1] =", meses[::-1][:3], "... | meses[-3:] =", meses[-3:])

base = [["Brasil", 2.2], ["Chile", 3.1]]
rasa = list(base)                  # cópia rasa: copia a lista externa, compartilha as listas internas
funda = copy.deepcopy(base)        # cópia profunda: copia tudo
base[0][1] = 9.9
print("Após alterar base[0][1]:  rasa =", rasa, "| funda =", funda)

paises = [("Brasil", 2.2), ("Chile", 3.1), ("Peru", 2.5), ("México", 1.9)]
print("Ordenado por PIB (decrescente):", sorted(paises, key=lambda par: par[1], reverse=True))
print("A lista original não mudou:", paises[0], "(sorted devolve nova lista; list.sort() altera a original)")
```

#atencao[
  `sort()` devolve `None` (altera no lugar); escrever `lista = lista.sort()` apaga a lista. E a ordenação do
  Python é #strong[estável]: elementos com a mesma chave mantêm a ordem relativa original --- por isso se pode
  ordenar por um critério secundário primeiro e pelo principal depois.
]

%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Condicionais
#teoria("por que o dicionário é rápido: tabela hash e chaves imutáveis")[
  Um dicionário calcula, para cada chave, um #strong[hash] (um número inteiro) que indica em que "gaveta" guardar o
  valor. Buscar uma chave é calcular o hash e ir direto à gaveta: o tempo #strong[não cresce] com o tamanho do dicionário
  (em média). Isso exige que a chave seja #strong[imutável] (strings, números, tuplas): se uma chave mudasse, seu hash
  mudaria e o valor "se perderia". Por isso `{[1, 2]: "x"}` dá `TypeError: unhashable type: 'list'`. Conjuntos (`set`) usam a
  mesma ideia e servem para testar pertencimento e eliminar duplicados.
]

```python
from collections import Counter, defaultdict

classificacoes = ["AAA", "BBB", "BB", "AAA", "A", "BBB", "AAA", "B"]
contagem = Counter(classificacoes)
print("Counter:", contagem, "| mais comum:", contagem.most_common(1))

por_setor = defaultdict(list)                      # valor padrão: lista vazia (não precisa checar se a chave existe)
for empresa, setor in [("Alfa", "Energia"), ("Beta", "Varejo"), ("Gama", "Energia")]:
    por_setor[setor].append(empresa)
print("defaultdict:", dict(por_setor))

pib = {"Brasil": 2.2, "Chile": 3.1}
extra = {"Peru": 2.5, "Chile": 3.3}
print("Mesclando com '|' (o da direita vence):", pib | extra)
print("get com padrão:", pib.get("Argentina", "sem dado"), "| 'Chile' in pib:", "Chile" in pib)
try:
    {[1, 2]: "x"}
except TypeError as erro:
    print("Chave mutável:", erro)
```

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Laços de repetição
#teoria("verdadeiro e falso em Python (truthiness) e o `match`")[
  Em `if x:`, o Python converte `x` em booleano. São #strong[falsos]: `False`, `None`, `0`, `0.0`, `""` (string vazia),
  `[]`, `{}`, `()`, `set()`. Todo o resto é verdadeiro --- inclusive `"0"` e `[0]`. Para decisões em vários
  casos mutuamente exclusivos, o Python 3.10 trouxe o `match`/`case`, mais legível que uma cadeia de `elif` quando se
  comparam #emph[padrões] de um mesmo valor.
]

```python
for valor in [0, 0.0, "", "0", [], [0], None, {}, {"a": 1}]:
    print(f"{valor!r:>8} -> {'verdadeiro' if valor else 'falso'}")

def faixa_de_renda(salarios_minimos):
    if salarios_minimos is None:                       # só None é "dado ausente"; 0 é um valor legítimo
        return "sem informação"
    if salarios_minimos < 2:
        return "baixa"
    if salarios_minimos < 5:
        return "média"
    return "alta"

def descreve_tipo(valor):
    match valor:
        case int() | float():
            return "número"
        case str():
            return "texto"
        case [primeiro, *resto]:
            return f"lista começando em {primeiro!r} (+{len(resto)} itens)"
        case {"pais": nome}:
            return f"registro do país {nome}"
        case _:
            return "outro"

print([faixa_de_renda(x) for x in (None, 0, 3, 12)])
print([descreve_tipo(v) for v in (3.5, "texto", [1, 2, 3], {"pais": "Brasil"}, None)])
```

%%% BEFORE_CHAPTER_END: == Capítulo 11 --- Funções
#teoria("iteradores e geradores: o que `for` faz de verdade")[
  Um laço `for x in colecao` pede à coleção um #strong[iterador] e chama repetidamente `next()` até
  uma exceção `StopIteration`. Qualquer objeto que ofereça essa interface é #strong[iterável]: listas, strings,
  dicionários, arquivos, `range`. Um #strong[gerador] (função com `yield`) produz os valores #emph[sob demanda], um de cada
  vez, sem guardar todos na memória --- essencial para arquivos enormes. Funções como `enumerate`, `zip`,
  `reversed` e `range` são iteradores "preguiçosos" (#emph[lazy]).
]

```python
def metodo_de_newton_sqrt(x, tolerancia=1e-12):
    """Raiz quadrada por Newton: x_{n+1} = (x_n + x/x_n) / 2, e o `while` roda até convergir."""
    estimativa, passos = x, 0
    while abs(estimativa ** 2 - x) > tolerancia:
        estimativa = (estimativa + x / estimativa) / 2
        passos += 1
    return estimativa, passos

raiz, passos = metodo_de_newton_sqrt(2)
print(f"sqrt(2) ≈ {raiz:.12f} em {passos} iterações (math.sqrt: {2 ** 0.5:.12f})")

def meses_do_ano():                  # gerador: entrega um valor por vez, sob demanda
    for numero, nome in enumerate(["jan", "fev", "mar"], start=1):
        yield numero, nome

gerador = meses_do_ano()
print(next(gerador), next(gerador), "| restante:", list(gerador))

anos = [2023, 2024, 2025]
pibs = [2.9, 3.1, 2.2]
for i, (ano, pib) in enumerate(zip(anos, pibs)):
    print(i, ano, pib)
for n in range(10, 0, -3):
    print("n =", n, end="; ")
print()
for tentativa in range(3):
    if tentativa == 5:
        break
else:
    print("o 'else' do for roda quando NÃO houve break")
```

%%% BEFORE_CHAPTER_END: == Capítulo 12 --- List comprehension
#teoria("funções como objetos: argumentos flexíveis, lambda, closures e memoização")[
  Em Python, funções são #strong[objetos]: podem ser guardadas em variáveis, passadas como argumento e retornadas.
  Isso permite padrões poderosos:

  - `*args` e `**kwargs` aceitam um número variável de argumentos posicionais e nomeados; parâmetros depois de `*`
    são #strong[só nomeados], o que torna chamadas mais legíveis.
  - #strong[lambda]: função anônima de uma expressão, útil como `key=` em `sorted`.
  - #strong[closure]: uma função que "lembra" variáveis da função que a criou (`criar_deflator(indice)` devolve uma função).
  - #strong[memoização]: guardar resultados de chamadas já feitas para não recalculá-las (`functools.lru_cache`).
  - #strong[type hints] e #strong[docstrings] documentam intenção e ajudam ferramentas e colegas.
]

```python
from functools import lru_cache

def resumo(*valores, casas=2):
    """Média e extremos de quantos valores forem passados. `casas` só pode ser dado por nome."""
    return round(sum(valores) / len(valores), casas), min(valores), max(valores)

def criar_deflator(indice_acumulado: float):
    def deflacionar(valor_nominal: float) -> float:
        return valor_nominal / indice_acumulado          # 'lembra' o índice (closure)
    return deflacionar

para_reais_de_2020 = criar_deflator(1.35)

@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    return n if n < 2 else fibonacci(n - 1) + fibonacci(n - 2)

print("resumo(3, 5, 10, casas=1):", resumo(3, 5, 10, casas=1))
print("R$ 1.350 nominais em reais de 2020:", round(para_reais_de_2020(1350), 2))
print("fibonacci(80) =", fibonacci(80), "| acertos de cache:", fibonacci.cache_info().hits)
```

#atencao[
  #strong[Argumento padrão mutável.] `def f(x, lista=[])` cria a lista #emph[uma única vez], na definição da
  função; todas as chamadas compartilham a mesma lista (a armadilha da seção 11.5). O padrão correto é
  `lista=None` e criar a lista dentro da função.
]

%%% BEFORE_CHAPTER_END: == Capítulo 13 --- Erros e depuração
#exemplo("dict/set comprehension, expressões geradoras e `any`/`all`")[
  A sintaxe de compreensão vale para #emph[dicionários] e #emph[conjuntos]. Uma #strong[expressão geradora] (parênteses
  em vez de colchetes) não materializa a lista, e funções como `sum`, `any` e `all` a consomem aos poucos:
]

```python
import sys
ipca = {"jan": 0.42, "fev": 0.83, "mar": 0.56, "abr": 0.44}
em_pontos_base = {mes: round(v * 100) for mes, v in ipca.items()}        # dict comprehension
meses_altos = {mes for mes, v in ipca.items() if v > 0.5}               # set comprehension
print(em_pontos_base, meses_altos)
print("Algum mês acima de 0,8?", any(v > 0.8 for v in ipca.values()), "| todos positivos?", all(v > 0 for v in ipca.values()))

lista_grande = [n * n for n in range(100_000)]
gerador_grande = (n * n for n in range(100_000))
print("Gerador ocupa menos memória que a lista:", sys.getsizeof(gerador_grande) < sys.getsizeof(lista_grande))
print("Soma consumindo o gerador:", sum(n * n for n in range(1000)))
```

#atencao[
  Compreensões aninhadas com mais de dois níveis, ou com efeitos colaterais (`print`, alterar variáveis), ficam
  ilegíveis. Se a linha precisar de uma releitura, vire um laço comum: #strong[clareza vence concisão].
]

%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Boas práticas de código
#teoria("hierarquia de exceções, `finally`, exceções próprias e log")[
  As exceções formam uma #strong[hierarquia]: `except ArithmeticError` captura `ZeroDivisionError`, porque este
  é um tipo de `ArithmeticError`. Capturar `Exception` indiscriminadamente (ou, pior, um `except:` vazio) engole
  erros de programação junto com os esperados. O bloco `finally` roda #emph[sempre], com ou sem erro (fechar arquivos,
  liberar recursos). Para sinalizar erros do #emph[seu domínio], defina uma exceção própria e use `raise`.
  Para #strong[diagnóstico], prefira o módulo `logging` a `print`: níveis, horário e destino configuráveis.
]

```python
print("Hierarquia de ZeroDivisionError:", " -> ".join(c.__name__ for c in ZeroDivisionError.__mro__))

class TaxaInvalida(ValueError):
    """Erro do domínio: uma taxa fora do intervalo plausível."""

def converter_percentual(texto: str) -> float:
    """Converte '4,5%' ou ' 4.5 % ' em 0.045; levanta TaxaInvalida se o texto não for uma taxa plausível."""
    limpo = texto.strip().replace("%", "").replace(",", ".").strip()
    try:
        valor = float(limpo) / 100
    except ValueError:
        raise TaxaInvalida(f"não é número: {texto!r}") from None
    if not -0.5 <= valor <= 5:
        raise TaxaInvalida(f"fora do intervalo plausível: {valor:.1%}")
    return valor

for entrada in ["4,5%", " 10 % ", "N/D", "900%"]:
    try:
        print(f"{entrada!r:>9} -> {converter_percentual(entrada):.4f}")
    except TaxaInvalida as erro:
        print(f"{entrada!r:>9} -> TaxaInvalida: {erro}")
    finally:
        pass                                            # o 'finally' sempre roda (aqui só ilustra a estrutura)
```

%%% BEFORE_CHAPTER_END: == Capítulo 15 --- Exercícios para Executar (na mão)
#figure(
  align(center)[#table(
    columns: (30%, 70%),
    align: (left, left),
    table.header([Tema (PEP 8)], [Regra],),
    [Nomes], [`snake_case` para variáveis e funções; `PascalCase` para classes; `MAIÚSCULAS` para constantes],
    [Espaços], [Espaço em torno de operadores (`a + b`) e depois de vírgula; sem espaço antes de `(`],
    [Linhas], [Até 79 a 100 caracteres; quebre dentro de parênteses],
    [Imports], [No topo do arquivo, um por linha: biblioteca padrão, depois terceiros, depois o seu código],
    [Docstrings], [Toda função pública descreve o que faz, os parâmetros e o que devolve],
    [Comentários], [Expliquem o #emph[porquê]; atualizem-se junto com o código],
  )]
  , kind: table
  )

#exemplo("uma função bem escrita")[
  Compare a versão "que funciona" com a versão "que dá para manter":
]

```python
# versão difícil de manter
def f(a, b, c):
    return a*(1+b)**c

# versão legível: nome que diz o que faz, tipos, docstring e validação
def valor_futuro(valor_presente: float, taxa: float, periodos: int) -> float:
    """Valor futuro com juros compostos: VP * (1 + taxa) ** periodos.

    Args:
        valor_presente: capital inicial (> 0).
        taxa: taxa por período, em decimal (0,01 = 1%).
        periodos: número de períodos (inteiro >= 0).
    """
    if valor_presente <= 0 or periodos < 0:
        raise ValueError("valor_presente deve ser positivo e periodos, não negativo")
    return valor_presente * (1 + taxa) ** periodos

print(f"{valor_futuro(2500, 0.015, 8):.2f}")
```

#intuicao[
  #strong[Testar é executar a sua intuição.] A forma mais simples de teste são #emph[assertivas]: afirmações que quebram
  o programa se falsas. Um teste bom cobre o caso comum, o caso de borda e o caso de erro.
]

```python
assert valor_futuro(1000, 0.10, 1) == 1100.0000000000002 or abs(valor_futuro(1000, 0.10, 1) - 1100) < 1e-9   # caso comum
assert valor_futuro(1000, 0.10, 0) == 1000                                                                   # borda: zero períodos
try:
    valor_futuro(-5, 0.1, 1)                                                                                 # caso de erro
except ValueError:
    print("Os três testes passaram: caso comum, borda e erro.")
```

%%% BEFORE_CHAPTER_END: == Próxima apostila
#line()

== Capítulo 18 --- Mini-projeto Resolvido: Lendo e Analisando uma Série do BCB
<capítulo-18-mini-projeto-resolvido>
Este mini-projeto usa os #strong[dados reais] guardados neste repositório (o IPCA acumulado em 12
meses, baixado do Banco Central, em `ipca_12m.json`) para integrar o que a apostila ensinou: ler um
arquivo, converter tipos, usar dicionários e listas, funções, tratamento de erro e formatação. O
formato do arquivo é típico de APIs: uma lista de dicionários com a data (`"dd/mm/aaaa"`) e o valor
como #strong[texto].

=== 18.1. Ler e converter
<ler-e-converter>
```python
import json

def ler_serie(caminho: str) -> dict:
    """Lê uma série do BCB (lista de {"data", "valor"}) e devolve {(ano, mes): valor_float}."""
    with open(caminho, encoding="utf-8") as arquivo:
        registros = json.load(arquivo)
    serie = {}
    for registro in registros:
        dia, mes, ano = registro["data"].split("/")
        serie[(int(ano), int(mes))] = float(registro["valor"])
    return serie

ipca12 = ler_serie("ipca_12m.json")
primeiro, ultimo = min(ipca12), max(ipca12)
print(f"{len(ipca12)} observações | de {primeiro[1]:02d}/{primeiro[0]} a {ultimo[1]:02d}/{ultimo[0]}")
print(f"Último valor: {ipca12[ultimo]:.2f}% em {ultimo[1]:02d}/{ultimo[0]}")
```

#intuicao[
  Repare nas #strong[escolhas de estrutura]: a chave do dicionário é uma #strong[tupla] `(ano, mes)` (imutável,
  logo hashável), o valor é um #strong[float] (convertido do texto), e a data virou algo
  ordenável. Cada decisão aproveita um conceito dos capítulos anteriores.
]

=== 18.2. Analisar
<analisar>
```python
def resumo_serie(serie: dict, teto: float = 4.5) -> dict:
    valores = list(serie.values())
    acima = [chave for chave, v in serie.items() if v > teto]
    return {
        "media": sum(valores) / len(valores),
        "maximo": max(serie.items(), key=lambda par: par[1]),
        "minimo": min(serie.items(), key=lambda par: par[1]),
        "meses_acima_do_teto": acima,
    }

r = resumo_serie(ipca12)
print(f"Média: {r['media']:.2f}%")
print(f"Máximo: {r['maximo'][1]:.2f}% em {r['maximo'][0][1]:02d}/{r['maximo'][0][0]}")
print(f"Mínimo: {r['minimo'][1]:.2f}% em {r['minimo'][0][1]:02d}/{r['minimo'][0][0]}")
print(f"Meses acima do teto da banda (4,5%): {len(r['meses_acima_do_teto'])} de {len(ipca12)}")
```

=== 18.3. Relatório formatado e tratamento de erro
<relatorio-formatado>
```python
def relatorio_por_ano(serie: dict) -> None:
    por_ano = {}
    for (ano, mes), valor in sorted(serie.items()):
        por_ano.setdefault(ano, []).append(valor)           # agrupa valores por ano
    print(f"{'Ano':<6}{'Média':>8}{'Máx':>8}{'Mín':>8}{'N':>4}")
    print("-" * 34)
    for ano, vals in por_ano.items():
        print(f"{ano:<6}{sum(vals) / len(vals):>8.2f}{max(vals):>8.2f}{min(vals):>8.2f}{len(vals):>4}")

relatorio_por_ano(ipca12)

try:
    ler_serie("arquivo_que_nao_existe.json")
except FileNotFoundError as erro:
    print(f"\nErro tratado com clareza: {erro.strerror}: {erro.filename!r}")
```

#strong[Para ir além] (sem solução aqui): acrescente um parâmetro para filtrar um intervalo de anos, e uma função que
devolva o #strong[mês em que a inflação mais variou] em relação ao mês anterior. Na Apostila 2, o
mesmo arquivo vira um `DataFrame` e cada passo deste capítulo vira uma linha de pandas.

== Capítulo 19 --- Erros Comuns e Teste Rápido
<capítulo-19-erros-comuns-e-teste-rapido>
=== 19.1. Os erros mais comuns de quem está começando
<os-erros-mais-comuns>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Usar `=` onde queria `==`], [`=` atribui, `==` compara],
    [2], [Comparar floats com `==`], [`math.isclose` ou diferença com tolerância],
    [3], [Achar que `b = a` copia uma lista], [Use `list(a)`, `a.copy()` ou `copy.deepcopy`],
    [4], [`lista = lista.sort()`], [`sort()` devolve `None`; use `sorted()` ou chame `sort()` sem atribuir],
    [5], [Argumento padrão mutável `def f(x=[])`], [Use `None` e crie dentro da função],
    [6], [`int()` esperando arredondar], [`int` trunca; use `round`],
    [7], [`taxa or padrao` tratando 0 como ausente], [Compare com `is None`],
    [8], [`except:` genérico], [Capture a exceção específica],
    [9], [Misturar tabs e espaços na indentação], [4 espaços, sempre],
    [10], [Esquecer a conversão de tipo ao ler arquivos], [Todo dado de texto precisa de `float()`/`int()` explícito],
  )]
  , kind: table
  )

=== 19.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rapido-verdadeiro-ou-falso>
+ #strong[V ou F:] `0.1 + 0.2 == 0.3` é `True` em Python. #strong[Falso.] Dá `False` por causa da representação binária.
+ #strong[V ou F:] Atribuir uma lista a outra variável cria uma cópia independente. #strong[Falso.] Cria outro rótulo para o mesmo objeto.
+ #strong[V ou F:] Strings são mutáveis. #strong[Falso.] São imutáveis; `texto[0] = "x"` dá `TypeError`.
+ #strong[V ou F:] `-7 // 2` é `-4`. #strong[Verdadeiro.] A divisão inteira arredonda para menos infinito.
+ #strong[V ou F:] Uma lista pode ser chave de dicionário. #strong[Falso.] Não é hashável (mutável); use tupla.
+ #strong[V ou F:] Um erro de sintaxe na linha 50 permite que as linhas 1 a 49 executem. #strong[Falso.] A análise sintática falha antes de qualquer execução.
+ #strong[V ou F:] `sorted(lista)` altera a lista original. #strong[Falso.] Devolve uma nova lista.
+ #strong[V ou F:] Em `[]` e `""`, `if x:` é falso. #strong[Verdadeiro.] Coleções e strings vazias são falsas.
+ #strong[V ou F:] Um gerador guarda todos os seus valores em memória. #strong[Falso.] Produz um por vez, sob demanda.
+ #strong[V ou F:] `round(2.5)` é `3`. #strong[Falso.] É `2`: o arredondamento é "bancário" (para o par).
%%% END
