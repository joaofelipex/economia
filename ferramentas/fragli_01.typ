%%% BEFORE_CHAPTER_END: = Parte I --- Fundamentos de Python
#align(center)[
  #text(size: 11pt, fill: luma(90))[Livro-texto completo: Python, pandas, visualização, econometria e projetos]
]

#v(0.5em)
#outline(title: [Sumário], depth: 2)

#pagebreak()

= Como Usar Este Livro (Edição Ampliada)
<como-usar-este-livro-ampliada>
Este livro percorre, em um só volume, o caminho do primeiro `print` à análise econométrica de um projeto de TCC. Ele condensa as
cinco apostilas da série (cada uma com tratamento mais extenso): #strong[Parte I] ↔ Apostila 1 (Fundamentos de Python), #strong[Parte II] ↔
Apostila 2 (pandas), #strong[Parte III] ↔ Apostila 3 (Visualização), #strong[Parte IV] ↔ Apostila 4 (Econometria) e #strong[Parte V] ↔
Apostila 5 (Projetos). Use o livro para #strong[consulta e visão de conjunto] e as apostilas para #strong[aprofundar].

Nesta edição, o fim de cada parte traz um #strong[aprofundamento]: teoria adicional e exemplos #emph[executados] --- os resultados
impressos vêm da execução do código, com semente fixa, e usam os dados reais deste repositório (`selic_meta.json`, `ipca_12m.json`,
`ipca_abertura_grupos.csv`, `taylor_rule_series.csv`). Caixas coloridas indicam o tipo de conteúdo:

#exemplo("modelo")[Um exemplo executado e comentado.]

#intuicao[A ideia por trás do conceito, sem jargão.]

#teoria("modelo")[A dedução ou o "por baixo dos panos".]

#atencao[Um erro clássico.]

#mercado[Como o conceito aparece no trabalho de um economista.]

#atencao[
  #strong[Versão do pandas.] Os resultados foram gerados com o #strong[pandas 2.2]. O pandas 3.0 tornou padrão o Copy-on-Write
  (a indexação encadeada deixa de funcionar e o `SettingWithCopyWarning` some), introduziu um tipo `str` dedicado para texto e renomeou
  alguns aliases de frequência (`"M"` → `"ME"`). Se o seu resultado diferir em algum detalhe, confira `pd.__version__`.
]
%%% END

%%% BEFORE_CHAPTER_END: = Parte II --- pandas para Análise de Dados
#teoria("variáveis são rótulos: identidade, igualdade e aliasing")[
  Em `x = [1, 2]`, o Python cria o objeto lista e #strong[amarra o nome] `x` a ele; `y = x` não copia nada, cria #emph[outro rótulo] para o mesmo objeto.
  `a == b` pergunta se os #emph[valores] são iguais; `a is b`, se são o #emph[mesmo objeto]. Com tipos #strong[mutáveis] (listas, dicionários), alterar por um
  rótulo altera "os dois" --- fonte clássica de bugs, e a razão de existirem `.copy()` e `copy.deepcopy`.
]

```python
import copy
a = [1, 2, 3]
b = a                  # outro rótulo para o MESMO objeto
c = list(a)            # cópia: novo objeto com os mesmos valores
b.append(4)
print(f"a = {a} | b = {b} | c = {c} | a is b: {a is b} | a is c: {a is c}")

base = [["Brasil", 2.2], ["Chile", 3.1]]
rasa, funda = list(base), copy.deepcopy(base)
base[0][1] = 9.9
print("Após alterar base[0][1] -> cópia rasa:", rasa, "| cópia profunda:", funda)
```

#teoria("dinheiro em ponto flutuante: Decimal, arredondamento e tolerância")[
  O `float` é binário e aproximado: `0.1 + 0.2` não é exatamente `0.3`. Para valores monetários onde os centavos precisam fechar, use `decimal.Decimal`
  (ou inteiros em centavos). O `round()` do Python usa o #strong[arredondamento bancário] (empates vão ao par), e compara-se `float` com
  tolerância (`math.isclose`), nunca com `==`.
]

```python
from decimal import Decimal, ROUND_HALF_UP
import math
acum_f, acum_d = 0.0, Decimal("0")
for _ in range(10):
    acum_f += 0.1; acum_d += Decimal("0.1")
print("Dez vezes +0,10 -> float:", acum_f, "| Decimal:", acum_d)
print("round(0.5), round(1.5), round(2.5):", round(0.5), round(1.5), round(2.5), "| round(2.675, 2) =", round(2.675, 2))
print("Decimal('2.675') arredondado (ROUND_HALF_UP):", Decimal("2.675").quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))
print("math.isclose(0.1 + 0.2, 0.3):", math.isclose(0.1 + 0.2, 0.3))
print("-7 // 2 =", -7 // 2, "| -7 % 2 =", -7 % 2, "| int(-7 / 2) =", int(-7 / 2), "| '' or 'padrão' ->", repr("" or "padrão"))
```

#atencao[
  `taxa or padrao` trata `0.0` como "ausente", porque zero é falso. Se zero é um valor legítimo (taxa de 0%), compare com `None`:
  `if taxa is None: taxa = padrao`. E `lista = lista.sort()` apaga a lista (`sort()` devolve `None`).
]

%%% BEFORE_CHAPTER_END: = Parte III --- Visualização de Dados
#teoria("por que pandas é rápido, e como ler um arquivo \"à brasileira\"")[
  Um array NumPy guarda valores #strong[contíguos] e de #strong[um único tipo]; a operação sobre o array inteiro (#strong[vetorização]) delega o laço a código
  compilado. O pandas constrói tabelas sobre esses arrays. Para ler arquivos brasileiros (separador `;`, vírgula decimal, ponto de milhar, datas
  `dd/mm/aaaa`, `N/D` como ausente), cada convenção tem um parâmetro de `read_csv`:
]

```python
from io import StringIO
csv_br = """Data;Estado;PIB (R$ mi);Obs
31/03/2025;SP;"2.345,6";ok
31/03/2025;RJ;"1.020,5";
30/06/2025;SP;"2.401,0";revisado
30/06/2025;RJ;N/D;ok"""
lido = pd.read_csv(StringIO(csv_br), sep=";", decimal=",", thousands=".", parse_dates=["Data"], dayfirst=True, na_values=["N/D"])
print(lido.to_string(), lido.dtypes.to_dict(), sep="\n")

def ler_bcb(caminho):
    d = pd.read_json(caminho, dtype=False)
    d["data"] = pd.to_datetime(d["data"], format="%d/%m/%Y")
    return d.set_index("data")["valor"].astype(float)

sel_l, ip_l = ler_bcb("selic_meta.json"), ler_bcb("ipca_12m.json")
gr_l = pd.read_csv("ipca_abertura_grupos.csv", parse_dates=["data"], index_col="data")
tay_l = pd.read_csv("taylor_rule_series.csv", parse_dates=["data"], index_col="data")
print(f"\nSelic diária: {len(sel_l)} dias até {sel_l.index.max():%d/%m/%Y} | IPCA 12m: {len(ip_l)} meses (último {ip_l.iloc[-1]:.2f}%)")
```

#exemplo("merge: a explosão de linhas e o `merge_asof` entre frequências diferentes")[
  O `merge` cria uma linha para #emph[cada combinação] de linhas com a mesma chave: com chaves repetidas nas duas tabelas, o total #strong[multiplica] --- um dos
  erros silenciosos mais graves em análise de dados. E para unir uma série diária a uma mensal, o `merge_asof` associa a observação #emph[mais recente
  anterior]:
]

```python
tab_a = pd.DataFrame({"pais": ["BR", "BR", "CL"], "pib": [3.1, 2.2, 3.1]})
tab_b = pd.DataFrame({"pais": ["BR", "BR", "CL"], "evento": ["eleição", "chuvas", "plebiscito"]})
print(f"a tem {len(tab_a)} linhas, b tem {len(tab_b)}, merge tem {len(tab_a.merge(tab_b, on='pais'))} (BR aparece 2 x 2 = 4 vezes)")

casado = pd.merge_asof(sel_l.rename("selic").reset_index(), ip_l.rename("ipca_12m").reset_index(), on="data", direction="backward")
ex_post = (1 + casado["selic"] / 100) / (1 + casado["ipca_12m"] / 100) - 1
print(casado.dropna().tail(2).to_string(index=False))
print(f"Juro real ex-post (Fisher) no último dia: {ex_post.iloc[-1] * 100:.2f}% a.a.")
```

#teoria("dados faltantes: a causa decide o tratamento (MCAR, MAR, MNAR) e a natureza da série também")[
  Os dados podem faltar #strong[ao acaso] (MCAR), #strong[por motivo observável] (MAR) ou #strong[por motivo ligado ao próprio valor] (MNAR; o viés é inevitável).
  Em séries temporais, importa se a série é um #strong[fluxo suave] (câmbio: interpolar faz sentido) ou um #strong[degrau] (meta da Selic: repetir o último valor é o certo):
]

```python
rng_l = np.random.default_rng(3)
verdadeira = sel_l.loc["2025-01-01":"2025-12-31"]
com_buracos = verdadeira.copy()
com_buracos[rng_l.random(len(com_buracos)) < 0.2] = np.nan
for nome_m, serie_m in {"ffill": com_buracos.ffill(), "interpolate": com_buracos.interpolate()}.items():
    print(f"{nome_m:<12} erro absoluto médio por dia = {(serie_m - verdadeira).abs().mean():.4f}")
print(f"Buracos: {com_buracos.isna().sum()} de {len(com_buracos)} dias")

base_cow = pd.DataFrame({"pais": ["Brasil", "Chile", "Peru"], "pib": [2.2, 3.1, 2.5]})
with pd.option_context("mode.copy_on_write", True):
    base2 = base_cow.copy()
    base2.loc[base2["pib"] > 2.3, "pib"] = 99                           # atribuição em UMA chamada, com .loc
print("Atribuição segura com .loc:", base2["pib"].tolist())
```

%%% BEFORE_CHAPTER_END: = Parte IV --- Econometria
#teoria("tinta de dados, hierarquia visual e a ciência da percepção")[
  Edward Tufte propôs a #strong[razão tinta-dados]: o gráfico ideal tem o máximo de dados e o mínimo de enfeite. Estudos de Cleveland e McGill ordenaram as
  tarefas visuais por precisão (posição em escala comum > comprimento > ângulo > área > cor), o que explica por que barras superam pizzas. Duas regras de ouro:
  #strong[barras sempre a partir de zero] (o comprimento codifica o valor) e #strong[nunca dependa só da cor] (acrescente traço, marcador e rótulo direto).
  A figura abaixo reúne os elementos de uma boa figura e o contraste entre eixo cortado e eixo honesto:
]

```python
import matplotlib.dates as mdates
fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(11, 3.3))
ax1.axhspan(1.5, 4.5, color="#cfe3f5", alpha=0.6, label="Tolerância (1,5% a 4,5%)")
ax1.axhline(3.0, color="#1d4f91", linestyle="--", linewidth=1, label="Meta (3%)")
ax1.plot(ip_l.index, ip_l.values, color="#a33a1c", linewidth=2, label="IPCA 12m")
ax1.set_title("Título que informa", loc="left", fontsize=10, fontweight="bold"); ax1.legend(fontsize=7, frameon=False); ax1.set_ylim(0, 7)
anual = sel_l.groupby(sel_l.index.year).mean().loc[2025:2026]
for ax, lim, tit in ((ax2, (14.3, 14.6), "Eixo cortado"), (ax3, (0, 16), "Eixo a partir de zero")):
    ax.bar(anual.index.astype(str), anual.values, color="#56B4E9", width=0.5); ax.set_ylim(*lim)
    ax.set_title(tit, loc="left", fontsize=10, fontweight="bold")
for ax in (ax1, ax2, ax3):
    ax.spines[["top", "right"]].set_visible(False)
ax1.xaxis.set_major_locator(mdates.YearLocator()); ax1.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
fig.text(0.01, 0.01, "Fonte: Banco Central do Brasil (SGS); elaboração própria.", fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1)); fig.savefig("figurasli/boas_figuras.png", dpi=160); plt.close(fig)
efeito = (anual.iloc[-1] / anual.iloc[0] - 1) * 100
cortado = ((anual.iloc[-1] - 14.3) / (anual.iloc[0] - 14.3) - 1) * 100
print(f"Selic média {anual.round(2).to_dict()} | diferença real {efeito:+.1f}% | no eixo cortado parece {cortado:+.0f}%")
```

#figure(
  image("figurasli/boas_figuras.png", width: 100%),
  caption: [Elementos de uma boa figura (esquerda) e a mesma diferença de 1% com eixo cortado (centro) e honesto (direita).],
)

#exemplo("heatmap: escala divergente para correlações")[
  Para uma matriz de correlação, a escala de cor deve ser #strong[divergente], #strong[simétrica] ($-1$ a $+1$) e centrada em zero; o arco-íris (`jet`)
  cria faixas falsas e é ilegível para daltônicos.
]

```python
corr = gr_l.corr()
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9.5, 3.8))
for ax, cmap, tit in ((ax1, "jet", "Errado: jet"), (ax2, "RdBu_r", "Certo: divergente, centrada em zero")):
    im = ax.imshow(corr, cmap=cmap, vmin=-1, vmax=1)
    ax.set_title(tit, loc="left", fontsize=10, fontweight="bold")
    ax.set_xticks(range(len(corr))); ax.set_xticklabels(corr.columns, rotation=40, ha="right", fontsize=7)
    ax.set_yticks(range(len(corr))); ax.set_yticklabels(corr.columns, fontsize=7)
    fig.colorbar(im, ax=ax, fraction=0.046)
fig.tight_layout(); fig.savefig("figurasli/heatmap.png", dpi=160); plt.close(fig)
pares = corr.where(np.triu(np.ones(corr.shape), 1).astype(bool)).stack().sort_values()
print(f"Maior correlação entre grupos do IPCA: {pares.index[-1]} = {pares.iloc[-1]:.2f} | menor: {pares.index[0]} = {pares.iloc[0]:.2f}")
```

#figure(
  image("figurasli/heatmap.png", width: 92%),
  caption: [A mesma matriz de correlação (grupos do IPCA): arco-íris à esquerda, escala divergente à direita.],
)

%%% BEFORE_CHAPTER_END: = Parte V --- Projetos
#teoria("o que significa \"não viesado\" e o que acontece quando as premissas falham")[
  O estimador OLS $hat(beta) = (X^T X)^(-1) X^T y$ é uma variável aleatória: outra amostra, outro valor. "Não viesado" significa que, na média sobre
  infinitas amostras, $E[hat(beta)] = beta$. Simulamos para #emph[ver]: (1) o OLS acerta em média e o erro-padrão reproduz a dispersão real; (2) omitir uma
  variável correlacionada com o regressor gera viés $beta_2 dot "Cov"(x, z)/"Var"(x)$; (3) regredir passeios aleatórios independentes produz
  "significância" espúria; (4) com heterocedasticidade, o erro-padrão clássico perde cobertura.
]

```python
import statsmodels.api as sm
rng_o = np.random.default_rng(1)
b_hat = []
for _ in range(2000):
    x = rng_o.uniform(2, 20, 60); y = 1.5 + 0.8 * x + rng_o.normal(0, 1.2, 60)
    b_hat.append(np.polyfit(x, y, 1)[0])
print(f"(1) Verdadeiro 0.8 | média de 2000 estimativas: {np.mean(b_hat):.4f} | desvio padrão real: {np.std(b_hat, ddof=1):.4f}")

rng_v = np.random.default_rng(4)
z = rng_v.normal(size=5000); x = 0.6 * z + rng_v.normal(scale=0.8, size=5000); y = 1 + 2 * x + 3 * z + rng_v.normal(size=5000)
curta = sm.OLS(y, sm.add_constant(x)).fit()
delta = np.cov(x, z)[0, 1] / np.var(x, ddof=1)
print(f"(2) Modelo curto: b1 = {curta.params[1]:.3f} (verdadeiro 2) | viés previsto = {3 * delta:.3f} | observado = {curta.params[1] - 2:.3f}")

rng_r = np.random.default_rng(50)
sig = 0
for _ in range(1000):
    a_ = np.cumsum(rng_r.normal(size=200)); b_ = np.cumsum(rng_r.normal(size=200))
    sig += sm.OLS(a_, sm.add_constant(b_)).fit().pvalues[1] < 0.05
print(f"(3) Passeios aleatórios independentes 'significativos' a 5%: {sig / 1000:.0%} (esperado 5%)")

rng_h = np.random.default_rng(12)
cob_c = cob_r = 0
for _ in range(2000):
    x = rng_h.uniform(1, 10, 100); y = 1 + x + rng_h.normal(0, 0.5 * x)
    aj = sm.OLS(y, sm.add_constant(x)).fit()
    cob_c += aj.conf_int()[1, 0] <= 1 <= aj.conf_int()[1, 1]
    rb = aj.get_robustcov_results(cov_type="HC3")
    cob_r += rb.conf_int()[1, 0] <= 1 <= rb.conf_int()[1, 1]
print(f"(4) Cobertura do IC de 95%: clássico = {cob_c / 2000:.1%} | robusto HC3 = {cob_r / 2000:.1%}")
```

%%% BEFORE_CHAPTER_END: = Apêndices
#exemplo("laboratório de projeto: decompondo a Selic implícita da regra de Taylor com dados reais")[
  A regra do repositório é $i^* = r^* + pi + 0,5 (pi - pi^*)$: juro neutro mais compensação da inflação mais reação ao desvio da meta. O
  #strong[princípio de Taylor] exige coeficiente total sobre a inflação maior que 1 (aqui, 1,5), para que o juro real suba com a inflação.
]

```python
ult = tay_l.iloc[-1]
print(f"{tay_l.index[-1]:%m/%Y}: Selic implícita {ult['taylor_selic']:.2f}% = neutro {ult['r_star']:.2f} + inflação {ult['ipca12m']:.2f} + reação {0.5 * (ult['ipca12m'] - ult['meta']):.2f}")
print(f"Selic efetiva {ult['selic']:.2f}% | gap {ult['gap_pp']:+.2f} p.p. | gap médio da série: {tay_l['gap_pp'].mean():+.2f} p.p.")
import sys, platform
print(f"Ambiente: Python {sys.version.split()[0]} | pandas {pd.__version__} | numpy {np.__version__} | statsmodels {sm.__version__}")
```

#atencao[
  A regra de Taylor "simples" é uma #strong[referência de calibragem], não um veredito: o Copom também olha o hiato do produto, as expectativas e
  o cenário externo, e a taxa neutra $r^*$ é inobservável. Um gap positivo persistente indica política mais apertada que a regra sugere, mas não prova erro.
]

%%% APPEND: apendice
= Apêndice D --- Erros Comuns e Teste Rápido

#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Comparar floats com `==`], [`math.isclose` ou tolerância],
    [2], [Achar que `b = a` copia uma lista], [`.copy()` ou `copy.deepcopy`],
    [3], [Usar `and`/`or` em máscaras do pandas], [`&`, `|`, `~` com parênteses],
    [4], [Atribuição encadeada `df[m]["x"] = 0`], [`df.loc[m, "x"] = 0`],
    [5], [Merge sem checar a chave], [`is_unique`, `validate=`, contar linhas],
    [6], [Barras com eixo cortado; arco-íris (`jet`)], [Zero na base; escala divergente centrada em zero],
    [7], [Interpretar correlação como causalidade], [Mecanismo, confundidores, causalidade reversa],
    [8], [Regredir séries em nível sem testar raiz unitária], [ADF; diferenciar ou testar cointegração],
    [9], [Erro-padrão clássico "por padrão"], [Robusto (HC3) ou HAC],
    [10], [Previsão sem intervalo nem avaliação fora da amostra], [Intervalo e treino/teste no tempo],
  )]
  , kind: table
  )

#strong[Teste rápido (V ou F, com gabarito).]

+ `0.1 + 0.2 == 0.3` é `True`. #strong[Falso.] Use tolerância.
+ Uma cópia rasa de uma lista de listas protege as listas internas. #strong[Falso.] Só `deepcopy` copia tudo.
+ `merge` com chave duplicada nas duas tabelas preserva o número de linhas. #strong[Falso.] Multiplica.
+ `ffill` é adequado para a meta da Selic. #strong[Verdadeiro.] É uma série em degraus.
+ A multicolinearidade viesa os coeficientes. #strong[Falso.] Infla os erros-padrão.
+ Duas séries independentes com raiz unitária podem dar regressão "significativa". #strong[Verdadeiro.] É a regressão espúria.
+ Em um gráfico de barras, o eixo Y pode começar em qualquer valor. #strong[Falso.] Deve partir de zero.
+ Uma regra de Taylor com gap positivo prova que o Banco Central errou. #strong[Falso.] É referência, com incerteza sobre $r^*$.
%%% END
