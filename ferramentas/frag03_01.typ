%%% BEFORE_CHAPTER_END: == Capítulo 1 --- Por que visualizar dados em economia
#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria da percepção, gráficos feitos com dados reais e o que evitar]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
A terceira apostila da série trata de #strong[comunicar dados]. Programar um gráfico é fácil; decidir
#emph[qual gráfico] responde à pergunta, evitar que ele engane e deixá-lo legível para o leitor é a parte
difícil --- e é onde esta apostila gasta seu tempo. Pressupõe as Apostilas 1 e 2.

Ao final de cada capítulo, um bloco de #strong[aprofundamento] traz um gráfico #emph[gerado pelo código mostrado],
com #strong[dados reais deste repositório]: a Selic meta diária (`selic_meta.json`), o IPCA acumulado em 12
meses (`ipca_12m.json`), a abertura do IPCA por grupos (`ipca_abertura_grupos.csv`) e a regra de Taylor
(`taylor_rule_series.csv`). As figuras ficam na pasta `figuras03/`. Caixas coloridas:

#exemplo("modelo")[Um gráfico construído passo a passo, com o código.]

#intuicao[A ideia por trás da regra, sem jargão.]

#teoria("modelo")[O que a ciência da percepção diz sobre o design.]

#atencao[Um erro clássico de design (que engana ou confunde o leitor).]

#mercado[Como a prática profissional de analistas e jornalistas de dados lida com isso.]

```python
import matplotlib.dates as mdates

def ler_bcb(caminho):
    d = pd.read_json(caminho, dtype=False)
    d["data"] = pd.to_datetime(d["data"], format="%d/%m/%Y")
    return d.set_index("data")["valor"].astype(float)

sel3, ip3 = ler_bcb("selic_meta.json"), ler_bcb("ipca_12m.json")
gr3 = pd.read_csv("ipca_abertura_grupos.csv", parse_dates=["data"], index_col="data")
tay3 = pd.read_csv("taylor_rule_series.csv", parse_dates=["data"], index_col="data")
FONTE3 = "Fonte: Banco Central do Brasil (SGS); elaboração própria."
OKABE = ["#E69F00", "#56B4E9", "#009E73", "#D55E00", "#0072B2", "#CC79A7", "#000000"]   # paleta segura para daltônicos
print(f"Selic: {len(sel3)} dias | IPCA 12m: {len(ip3)} meses | grupos: {gr3.shape} | Taylor: {tay3.shape}")
```
%%% END

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- Gráfico de linha e séries temporais
#teoria("tinta de dados, memória visual e o que a figura precisa ter")[
  Edward Tufte propôs o conceito de #strong[razão tinta-dados]: a fração da "tinta" do gráfico que realmente
  representa dados. Grades pesadas, molduras, fundos coloridos e efeitos 3D consomem tinta sem informar: o gráfico
  ideal tem o máximo de dados e o mínimo de enfeite. Mas há um piso: a figura precisa ser #strong[autoexplicativa],
  com #emph[título que diz a conclusão], eixos com unidade, legenda ou rótulos diretos, e fonte dos dados. A figura
  abaixo reúne esses elementos, ao mostrar o IPCA em 12 meses contra o intervalo do regime de metas (3% de meta, com
  tolerância de 1,5 ponto percentual):
]

```python
fig, ax = plt.subplots(figsize=(7.2, 3.6))
ax.axhspan(1.5, 4.5, color="#cfe3f5", alpha=0.6, label="Intervalo de tolerância (1,5% a 4,5%)")
ax.axhline(3.0, color="#1d4f91", linestyle="--", linewidth=1, label="Meta (3,0%)")
ax.plot(ip3.index, ip3.values, color="#a33a1c", linewidth=2.2, label="IPCA acumulado em 12 meses")
ax.set_title("O IPCA permaneceu acima do teto da meta em boa parte de 2025", loc="left", fontweight="bold", fontsize=11)
ax.set_ylabel("% ao ano"); ax.set_ylim(0, 7); ax.grid(axis="y", alpha=0.3)
ax.xaxis.set_major_formatter(mdates.DateFormatter("%m/%y"))
ax.legend(loc="upper right", fontsize=8, frameon=False)
for lado in ("top", "right"):
    ax.spines[lado].set_visible(False)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/anatomia_ipca.png", dpi=160)
plt.close(fig)
print("Meses com IPCA 12m acima do teto:", int((ip3 > 4.5).sum()), "de", len(ip3))
```

#figure(
  image("figuras03/anatomia_ipca.png", width: 92%),
  caption: [Anatomia de uma figura: título com a mensagem, faixa de referência, eixo com unidade, legenda, fonte e eliminação de bordas desnecessárias.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- Comparando múltiplas séries: mesma escala, dois eixos, subplots
#teoria("como o cérebro lê um gráfico de linhas: Gestalt e o problema do espaguete")[
  O sistema visual agrupa elementos por #strong[proximidade, semelhança e continuidade] (princípios da Gestalt). Em um gráfico de linhas,
  a #emph[continuidade] faz com que sigamos cada linha de um lado ao outro --- até o ponto em que várias se cruzam, quando
  a trajetória se perde. Com mais de 4 ou 5 séries coloridas, o gráfico vira um "espaguete". A solução é #strong[hierarquizar]:
  destacar em cor a série que importa e deixar as demais em #strong[cinza] como contexto, ou separar em painéis (#emph[small
  multiples]). A figura mostra as duas versões dos mesmos dados:
]

```python
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9.5, 3.6), sharey=True)
cores_todas = dict(zip(gr3.columns, OKABE))
for col in gr3.columns:
    ax1.plot(gr3.index, gr3[col], label=col, linewidth=1.6, color=cores_todas[col])
ax1.set_title("Espaguete: seis cores competem pela atenção", loc="left", fontsize=10, fontweight="bold")
ax1.legend(fontsize=7, frameon=False, ncol=2, loc="lower left")

for col in gr3.columns:
    destaque = col in ("Servicos", "IPCA cheio")
    ax2.plot(gr3.index, gr3[col], linewidth=2.4 if destaque else 1.0,
             color={"Servicos": "#D55E00", "IPCA cheio": "#000000"}.get(col, "#bbbbbb"), zorder=3 if destaque else 1)
ax2.text(gr3.index[-1], gr3["Servicos"].iloc[-1] + 0.25, "Serviços", color="#D55E00", fontsize=8, ha="right", fontweight="bold")
ax2.text(gr3.index[-1], gr3["IPCA cheio"].iloc[-1] - 0.7, "IPCA cheio", color="#000000", fontsize=8, ha="right", fontweight="bold")
ax2.set_title("Hierarquia: duas séries em destaque, o resto é contexto", loc="left", fontsize=10, fontweight="bold")
for ax in (ax1, ax2):
    ax.xaxis.set_major_locator(mdates.YearLocator()); ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y")); ax.grid(axis="y", alpha=0.25)
    ax.spines[["top", "right"]].set_visible(False)
ax1.set_ylabel("% acumulado em 12 meses")
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/espaguete_vs_destaque.png", dpi=160)
plt.close(fig)
print("Séries no gráfico:", len(gr3.columns), "| em destaque na versão 2:", 2)
```

#figure(
  image("figuras03/espaguete_vs_destaque.png", width: 100%),
  caption: [À esquerda, o "espaguete"; à direita, a mesma informação com hierarquia visual (cor para o que importa, cinza para o contexto) e rótulos diretos no lugar de legenda.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Gráfico de barras: comparação de categorias
#teoria("dois eixos Y: por que a correlação visual é uma ilusão controlável")[
  Com `twinx`, o autor escolhe #strong[duas escalas independentes] --- e, ao variar os limites dos eixos, consegue fazer
  duas séries "andarem juntas" ou "se descolarem" à vontade. O cruzamento das linhas, que o olho interpreta como evento
  relevante, é um #strong[artefato] da escolha de escala. A alternativa honesta: painéis empilhados com o mesmo eixo
  de tempo (#emph[subplots]), ou as duas séries na mesma escala quando têm a mesma unidade, ou ainda índices base 100.
  A figura usa a Selic e o IPCA em 12 meses --- ambos em % ao ano, logo comparáveis na #emph[mesma escala]:
]

```python
fig = plt.figure(figsize=(9.5, 4.2))
gs = fig.add_gridspec(2, 2, width_ratios=[1.1, 1])
ax_dual = fig.add_subplot(gs[:, 0])
ax_dual.plot(sel3.index, sel3.values, color="#0072B2", linewidth=2)
ax_dual.set_ylabel("Selic (% a.a.)", color="#0072B2")
ax_b = ax_dual.twinx()
ax_b.plot(ip3.index, ip3.values, color="#D55E00", linewidth=2)
ax_b.set_ylabel("IPCA 12m (% a.a.)", color="#D55E00")
ax_dual.set_ylim(10, 16); ax_b.set_ylim(0, 12)                         # escolhas arbitrárias que 'colam' as séries
ax_dual.set_title("Dois eixos: as linhas parecem se mover juntas?", loc="left", fontsize=10, fontweight="bold")

ax_same = fig.add_subplot(gs[0, 1])
ax_same.plot(sel3.index, sel3.values, color="#0072B2", label="Selic meta")
ax_same.plot(ip3.index, ip3.values, color="#D55E00", label="IPCA 12m")
ax_same.set_ylim(0, 16); ax_same.legend(frameon=False, fontsize=8)
ax_same.set_title("Mesma escala (0 a 16%): a distância real", loc="left", fontsize=10, fontweight="bold")
ax_gap = fig.add_subplot(gs[1, 1], sharex=ax_same)
juro_real = ((1 + sel3.resample("MS").last() / 100) / (1 + ip3 / 100) - 1).dropna()
ax_gap.bar(juro_real.index, juro_real.values * 100, width=20, color="#009E73")
ax_gap.set_title("Juro real ex-post (Fisher), % a.a.", loc="left", fontsize=10, fontweight="bold")
for ax in (ax_dual, ax_b, ax_same, ax_gap):
    ax.spines[["top"]].set_visible(False); ax.xaxis.set_major_locator(mdates.YearLocator()); ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/dois_eixos_vs_subplots.png", dpi=160)
plt.close(fig)
print(f"Juro real ex-post: mínimo {juro_real.min() * 100:.1f}% | máximo {juro_real.max() * 100:.1f}% | último {juro_real.iloc[-1] * 100:.1f}%")
```

#figure(
  image("figuras03/dois_eixos_vs_subplots.png", width: 100%),
  caption: [À esquerda, o eixo duplo sugere uma relação que a escala própria de cada eixo cria; à direita, mesma escala e o diferencial (juro real) explícito.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Dispersão (scatter): relação entre variáveis
#teoria("barras codificam por comprimento: a hierarquia de Cleveland-McGill e a ordenação")[
  Estudos de percepção (Cleveland e McGill, 1984) ordenaram as tarefas visuais por #strong[precisão do julgamento]: o
  mais preciso é comparar #emph[posições ao longo de uma escala comum] (pontos, barras com base comum), depois
  comprimentos, depois ângulos e inclinações, depois áreas, e por último cores e volumes. Barras funcionam porque usam
  comprimento a partir de uma #strong[base comum] (zero); pizzas e bolhas usam ângulo e área, bem menos precisos. Duas
  regras práticas decorrem: #strong[ordene as barras] (por valor, não alfabeticamente) e use #strong[barras
  horizontais] quando os rótulos forem longos. A figura mostra o IPCA por grupo em julho de 2026:
]

```python
ultimo = gr3.iloc[-1].sort_values()
fig, ax = plt.subplots(figsize=(7, 3.4))
cores = ["#D55E00" if v < 0 else "#0072B2" for v in ultimo.values]
ax.barh(ultimo.index, ultimo.values, color=cores)
ax.axvline(0, color="black", linewidth=0.8)                              # base comum: o zero está sempre visível
for y_, v_ in enumerate(ultimo.values):
    ax.text(v_ + (0.1 if v_ >= 0 else -0.1), y_, f"{v_:.2f}%".replace(".", ","), va="center", ha="left" if v_ >= 0 else "right", fontsize=8)
ax.set_title(f"Serviços e não comercializáveis puxam o IPCA ({gr3.index[-1]:%m/%Y}, acumulado em 12 meses)", loc="left", fontsize=10, fontweight="bold")
ax.set_xlim(0, 7); ax.spines[["top", "right"]].set_visible(False); ax.grid(axis="x", alpha=0.25)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/barras_horizontais.png", dpi=160)
plt.close(fig)
print("Ordem das barras (menor -> maior):", list(ultimo.index))
```

#figure(
  image("figuras03/barras_horizontais.png", width: 85%),
  caption: [Barras horizontais, ordenadas e com rótulos diretos; a base comum (zero) é sempre visível.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Histograma: a forma da distribuição
#teoria("scatter, correlação e o gráfico de dispersão como instrumento exploratório")[
  O scatter é a ferramenta natural para duas variáveis #emph[contínuas]: mostra a #strong[direção] da relação (sinal), sua
  #strong[forma] (linear, curva, em grupos), a #strong[dispersão] ao redor da tendência e os #strong[outliers]. O coeficiente de
  correlação $r$ resume só a parte linear --- por isso se olha o gráfico #emph[antes] de confiar no $r$ (o "quarteto de
  Anscombe" mostra quatro conjuntos com o mesmo $r$ e formas completamente diferentes). A linha de tendência é uma
  descrição, #strong[não] uma prova de causalidade. Na figura, a Selic contra o IPCA em 12 meses, mês a mês, com ponto final anotado:
]

```python
x_s, y_s = tay3["ipca12m"], tay3["selic"]
coef = np.polyfit(x_s, y_s, 1)
r_s = np.corrcoef(x_s, y_s)[0, 1]
fig, ax = plt.subplots(figsize=(6.4, 3.8))
ax.scatter(x_s, y_s, c=np.arange(len(x_s)), cmap="viridis", s=38, edgecolor="white", linewidth=0.6)
xx = np.linspace(x_s.min(), x_s.max(), 50)
ax.plot(xx, np.polyval(coef, xx), color="#D55E00", linewidth=1.6, linestyle="--", label=f"Tendência linear (r = {r_s:.2f})")
ax.annotate(f"{tay3.index[-1]:%m/%Y}", (x_s.iloc[-1], y_s.iloc[-1]), xytext=(10, -22), textcoords="offset points",
            arrowprops=dict(arrowstyle="->", color="gray"), fontsize=8)
ax.set_xlabel("IPCA acumulado em 12 meses (% a.a.)"); ax.set_ylabel("Selic meta (% a.a.)")
ax.set_title("Selic × inflação: a cor mostra o tempo (do mais antigo ao mais recente)", loc="left", fontsize=10, fontweight="bold")
ax.legend(frameon=False, fontsize=8); ax.spines[["top", "right"]].set_visible(False)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/scatter_selic_ipca.png", dpi=160)
plt.close(fig)
print(f"Correlação (nível) Selic x IPCA 12m: {r_s:+.2f} | inclinação: {coef[0]:+.2f} p.p. de Selic por p.p. de IPCA")
```

#figure(
  image("figuras03/scatter_selic_ipca.png", width: 78%),
  caption: [Scatter com cor para o tempo, linha de tendência e anotação do último ponto.],
)

#atencao[
  A correlação acima é calculada sobre #strong[níveis] de duas séries que variam lentamente e com tendência. Em séries
  temporais, isso tende a superestimar a relação (correlação espúria). E a causalidade, aqui, é #emph[bidirecional]: a Selic reage à
  inflação (regra de Taylor) e afeta a inflação futura, com defasagem. O gráfico mostra a associação; não responde "quem causa quem".
]

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Boxplot: resumo estatístico visual
#teoria("a escolha dos bins e a regra de Freedman-Diaconis")[
  O histograma depende da largura das caixas (#emph[bins]). Poucos bins escondem a forma; muitos criam ruído. Regras práticas: a de
  #strong[Sturges] ($k approx 1 + log_2 n$, adequada para amostras pequenas e distribuições próximas da normal) e a de
  #strong[Freedman-Diaconis] (largura $= 2 dot "IQR"/n^(1\/3)$, robusta a outliers). A figura compara bins demais e de menos para
  a mesma série e marca a média e a mediana (a distância entre elas denuncia assimetria):
]

```python
serv = gr3["Servicos"]
largura_fd = 2 * (serv.quantile(0.75) - serv.quantile(0.25)) / len(serv) ** (1 / 3)
bins_fd = int(np.ceil((serv.max() - serv.min()) / largura_fd))
fig, axs = plt.subplots(1, 3, figsize=(10, 3.1), sharey=True)
for ax, n_bins, titulo in zip(axs, (3, bins_fd, 25), ("Poucos bins (3)", f"Freedman-Diaconis ({bins_fd})", "Bins demais (25)")):
    ax.hist(serv, bins=n_bins, color="#56B4E9", edgecolor="white")
    ax.axvline(serv.mean(), color="#D55E00", linestyle="--", linewidth=1.4, label=f"média {serv.mean():.2f}".replace(".", ","))
    ax.axvline(serv.median(), color="#000000", linestyle=":", linewidth=1.4, label=f"mediana {serv.median():.2f}".replace(".", ","))
    ax.set_title(titulo, loc="left", fontsize=10, fontweight="bold"); ax.spines[["top", "right"]].set_visible(False)
    ax.legend(frameon=False, fontsize=7)
axs[0].set_ylabel("Nº de meses")
fig.text(0.01, 0.01, "Serviços, acumulado em 12 meses (% a.a.). " + FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.05, 1, 1))
fig.savefig("figuras03/histograma_bins.png", dpi=160)
plt.close(fig)
print(f"n = {len(serv)} | assimetria = {serv.skew():.2f} | bins pela regra de Freedman-Diaconis: {bins_fd}")
```

#figure(
  image("figuras03/histograma_bins.png", width: 100%),
  caption: [A mesma série em três escolhas de bins: a forma da distribuição só "aparece" no meio.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Heatmap e matrizes de correlação
#teoria("anatomia do boxplot e comparação entre grupos")[
  O boxplot (Tukey) resume uma distribuição em cinco números: mínimo (do bigode), primeiro quartil, #strong[mediana], terceiro
  quartil e máximo do bigode; os pontos além de $1,5 times "IQR"$ são marcados como #emph[outliers]. Ele #emph[comprime] a forma
  (não mostra bimodalidade) mas é imbatível para #strong[comparar muitos grupos] lado a lado --- por exemplo, os seis componentes
  do IPCA. Sobrepor os pontos individuais (#emph[strip plot]) devolve a informação que a caixa esconde:
]

```python
fig, ax = plt.subplots(figsize=(8, 3.6))
ordem = gr3.median().sort_values().index
ax.boxplot([gr3[c] for c in ordem], vert=False, tick_labels=ordem, widths=0.5, patch_artist=True,
           boxprops=dict(facecolor="#d6eaf8", edgecolor="#1d4f91"), medianprops=dict(color="#D55E00", linewidth=2),
           flierprops=dict(marker="o", markerfacecolor="#a33a1c", markersize=4, markeredgecolor="none"))
rng_b = np.random.default_rng(1)
for i_, c in enumerate(ordem, start=1):
    ax.scatter(gr3[c], rng_b.normal(i_, 0.07, len(gr3)), s=10, color="#1d4f91", alpha=0.35, zorder=3)
ax.set_xlabel("Variação acumulada em 12 meses (% a.a.)")
ax.set_title("Os preços administrados são os mais dispersos; serviços, os mais altos e estáveis", loc="left", fontsize=10, fontweight="bold")
ax.spines[["top", "right"]].set_visible(False); ax.grid(axis="x", alpha=0.25)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/boxplot_grupos.png", dpi=160)
plt.close(fig)
print("Mediana por grupo:", gr3.median().round(2).to_dict())
print("Amplitude interquartil:", (gr3.quantile(0.75) - gr3.quantile(0.25)).round(2).to_dict())
```

#figure(
  image("figuras03/boxplot_grupos.png", width: 92%),
  caption: [Boxplots horizontais ordenados pela mediana, com os pontos individuais sobrepostos.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Teoria da percepção visual e escolha de cor
#teoria("mapa de calor: escala sequencial para magnitude, divergente para sinal")[
  A cor de um heatmap codifica o #emph[valor]. Duas famílias de escalas: a #strong[sequencial] (um matiz que vai do claro ao
  escuro) serve para magnitudes que só crescem; a #strong[divergente] (duas cores nas pontas, neutra no centro) serve quando
  há um #emph[ponto de referência] com significado --- como $r = 0$ numa correlação. Para uma matriz de correlação, a escala
  deve ser divergente, #strong[simétrica] ($-1$ a $+1$) e com o centro no branco. O arco-íris (`jet`) é desaconselhado: não é
  perceptualmente uniforme (aparecem "faixas" falsas) e é ilegível para daltônicos. A figura contrasta a escolha errada e a certa:
]

```python
corr = gr3.corr()
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4.2))
im1 = ax1.imshow(corr, cmap="jet", vmin=-1, vmax=1)
ax1.set_title("Errado: jet (arco-íris)", loc="left", fontsize=10, fontweight="bold")
im2 = ax2.imshow(corr, cmap="RdBu_r", vmin=-1, vmax=1)
ax2.set_title("Certo: divergente, simétrica, centro em zero", loc="left", fontsize=10, fontweight="bold")
for ax, im in ((ax1, im1), (ax2, im2)):
    ax.set_xticks(range(len(corr))); ax.set_xticklabels(corr.columns, rotation=40, ha="right", fontsize=7)
    ax.set_yticks(range(len(corr))); ax.set_yticklabels(corr.columns, fontsize=7)
    for i_ in range(len(corr)):
        for j_ in range(len(corr)):
            ax.text(j_, i_, f"{corr.iloc[i_, j_]:.2f}", ha="center", va="center", fontsize=6.5,
                    color="white" if abs(corr.iloc[i_, j_]) > 0.6 and ax is ax2 else "black")
    fig.colorbar(im, ax=ax, fraction=0.046)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/heatmap_jet_vs_divergente.png", dpi=160)
plt.close(fig)
mais_alta = corr.where(np.triu(np.ones(corr.shape), 1).astype(bool)).stack().sort_values()
print(f"Maior correlação entre grupos: {mais_alta.index[-1]} = {mais_alta.iloc[-1]:.2f} | menor: {mais_alta.index[0]} = {mais_alta.iloc[0]:.2f}")
```

#figure(
  image("figuras03/heatmap_jet_vs_divergente.png", width: 100%),
  caption: [A mesma matriz de correlação: à esquerda o arco-íris, à direita a escala divergente centrada em zero.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Gráficos enganosos ("lying with charts")
#teoria("luminância, daltonismo e redundância: o que a paleta precisa garantir")[
  Cerca de 8% dos homens têm alguma forma de daltonismo (mais comum, a confusão vermelho--verde). Uma paleta acessível
  precisa que as cores se distingam #emph[por luminosidade] mesmo em escala de cinza, e que o gráfico #strong[nunca dependa só
  da cor]: use também #strong[estilo de linha, marcador e rótulos diretos]. A paleta de Okabe-Ito (usada aqui) foi
  desenhada para ser distinguível por quase todos. A figura codifica cada série com cor, traço e marcador --- e o título e
  os rótulos diretos dispensam a legenda:
]

```python
fig, ax = plt.subplots(figsize=(7.2, 3.6))
estilos = {"Servicos": ("#D55E00", "-", "o"), "Livres": ("#0072B2", "--", "s"), "Administrados": ("#009E73", "-.", "^")}
for col, (cor, traco, marc) in estilos.items():
    ax.plot(gr3.index, gr3[col], color=cor, linestyle=traco, marker=marc, markevery=6, linewidth=1.8, markersize=5)
    ax.text(gr3.index[-1] + pd.Timedelta(days=15), gr3[col].iloc[-1], col.replace("Servicos", "Serviços"), color=cor, fontsize=8, va="center", fontweight="bold")
ax.set_xlim(gr3.index[0], gr3.index[-1] + pd.Timedelta(days=170))
ax.set_title("Cor, traço e marcador: cada série é identificável de três formas", loc="left", fontsize=10, fontweight="bold")
ax.set_ylabel("% acumulado em 12 meses"); ax.spines[["top", "right"]].set_visible(False); ax.grid(axis="y", alpha=0.25)
ax.xaxis.set_major_formatter(mdates.DateFormatter("%m/%y"))
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/redundancia_codificacao.png", dpi=160)
plt.close(fig)
print("Paleta Okabe-Ito:", OKABE)
```

#figure(
  image("figuras03/redundancia_codificacao.png", width: 90%),
  caption: [Redundância de codificação: cor, estilo de traço, marcador e rótulo direto.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 11 --- Anotações, texto e storytelling com dados econômicos
#teoria("eixo cortado: a inflação visual de uma diferença")[
  Em gráficos de #strong[barras], o comprimento codifica o valor; cortar o eixo (começar em 14,3, em vez de 0) faz o
  #emph[comprimento] deixar de ser proporcional ao valor: uma diferença de 1% pode parecer mais que o dobro. O "fator de mentira"
  (Tufte) é a razão entre o tamanho do efeito #emph[no gráfico] e o efeito #emph[nos dados]; o ideal é 1. Em #emph[linhas], cortar o eixo é
  aceitável (a posição é o que importa), desde que o corte seja evidente. Veja a Selic média de 2025 e de 2026 nos dois desenhos:
]

```python
anual = sel3.groupby(sel3.index.year).mean().loc[2025:2026]
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 3.4))
for ax, (limites, titulo) in zip((ax1, ax2), (((14.3, 14.6), "Eixo cortado: a diferença parece enorme"), ((0, 16), "Eixo a partir de zero: a diferença real"))):
    ax.bar(anual.index.astype(str), anual.values, color="#56B4E9", width=0.55)
    ax.set_ylim(*limites); ax.set_title(titulo, loc="left", fontsize=10, fontweight="bold")
    for x_, v_ in zip(anual.index.astype(str), anual.values):
        ax.text(x_, v_ + (limites[1] - limites[0]) * 0.015, f"{v_:.1f}%".replace(".", ","), ha="center", fontsize=8)
    ax.spines[["top", "right"]].set_visible(False)
ax1.set_ylabel("Selic meta média (% a.a.)")
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/eixo_cortado.png", dpi=160)
plt.close(fig)
efeito_dados = (anual.iloc[-1] / anual.iloc[0] - 1) * 100
altura1, altura2 = anual.iloc[0] - 14.3, anual.iloc[-1] - 14.3                      # alturas visíveis no gráfico cortado
efeito_visual = (altura2 / altura1 - 1) * 100
print(f"Selic média: {anual.round(2).to_dict()} (2026: jan a set)")
print(f"Diferença real: {efeito_dados:+.1f}% | diferença que o gráfico cortado sugere: {efeito_visual:+.0f}% | fator de mentira: {efeito_visual / efeito_dados:.0f}")
```

#figure(
  image("figuras03/eixo_cortado.png", width: 92%),
  caption: [As mesmas três barras: o corte do eixo multiplica visualmente uma diferença pequena.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 12 --- Personalização avançada e gráficos publication-ready
#teoria("storytelling: título como conclusão, anotação como contexto")[
  Um bom gráfico econômico conta #emph[uma história]: o título afirma a conclusão ("a queda dos juros começou em março de 2026"), não
  descreve o eixo ("Selic ao longo do tempo"). As anotações (`axvline` + `annotate`) apontam os eventos que explicam o formato da
  curva, dispensando o leitor de procurar a causa no texto. A estrutura recomendada: #strong[(1)] título-conclusão, #strong[(2)]
  subtítulo com o recorte, #strong[(3)] dados, #strong[(4)] anotações em poucos pontos-chave, #strong[(5)] fonte. A figura anota os dois marcos do ciclo da Selic nos dados:
]

```python
mudancas = sel3[sel3.diff().fillna(0) != 0]
pico_data = sel3.idxmax()
primeiro_corte = mudancas[(mudancas.index > pico_data)].index[0]
fig, ax = plt.subplots(figsize=(7.4, 3.8))
ax.step(sel3.index, sel3.values, where="post", color="#0072B2", linewidth=2)
ax.axvline(pico_data, color="gray", linestyle=":", linewidth=1)
ax.annotate(f"Pico: {sel3.max():.2f}%".replace(".", ",") + f"\n({pico_data:%d/%m/%Y})", (pico_data, sel3.max()), xytext=(-110, -38),
            textcoords="offset points", arrowprops=dict(arrowstyle="->", color="gray"), fontsize=8)
ax.annotate(f"Primeiro corte: {sel3.loc[primeiro_corte]:.2f}%".replace(".", ",") + f"\n({primeiro_corte:%d/%m/%Y})",
            (primeiro_corte, sel3.loc[primeiro_corte]), xytext=(-40, -60), textcoords="offset points",
            arrowprops=dict(arrowstyle="->", color="gray"), fontsize=8)
ax.set_ylim(9.5, 16)
ax.set_title("A Selic encerrou o ciclo de alta em 2025 e iniciou a redução em 2026", loc="left", fontsize=11, fontweight="bold")
ax.set_ylabel("Meta da Selic (% a.a.)"); ax.spines[["top", "right"]].set_visible(False); ax.grid(axis="y", alpha=0.25)
ax.xaxis.set_major_formatter(mdates.DateFormatter("%m/%y"))
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/selic_storytelling.png", dpi=160)
plt.close(fig)
print(f"Pico em {pico_data:%d/%m/%Y} ({sel3.max()}%) | primeiro corte em {primeiro_corte:%d/%m/%Y} (para {sel3.loc[primeiro_corte]}%)")
```

#figure(
  image("figuras03/selic_storytelling.png", width: 88%),
  caption: [Título que afirma a conclusão e duas anotações que explicam a curva (os valores vêm dos próprios dados).],
)

%%% BEFORE_CHAPTER_END: == Capítulo 13 --- seaborn: gráficos estatísticos de alto nível
#teoria("de gráfico de exploração a gráfico de publicação: o checklist")[
  Um gráfico para #strong[você] (exploratório) pode ser rápido e feio; um gráfico para #strong[publicar] precisa passar pelo checklist:
  título-conclusão; eixos com unidade; escala honesta; poucas cores com função; rótulos diretos; fonte e data; sem moldura
  desnecessária; fontes legíveis no tamanho final de impressão (8 a 10 pontos); resolução ou formato vetorial adequado. A
  figura final aplica os passos --- `rcParams` para o estilo, remoção de bordas, formatação de data e eixo,
  rótulos diretos e fonte --- sobre a Selic e a Selic implícita da regra de Taylor:
]

```python
estilo = {"font.size": 9, "axes.spines.top": False, "axes.spines.right": False, "axes.grid": True, "grid.alpha": 0.25,
          "axes.titleweight": "bold", "axes.titlelocation": "left"}
with plt.rc_context(estilo):
    fig, ax = plt.subplots(figsize=(7.4, 3.8))
    ax.plot(tay3.index, tay3["selic"], color="#0072B2", linewidth=2.2)
    ax.plot(tay3.index, tay3["taylor_selic"], color="#D55E00", linewidth=2.2)
    ax.fill_between(tay3.index, tay3["selic"], tay3["taylor_selic"], where=tay3["selic"] >= tay3["taylor_selic"], color="#0072B2", alpha=0.12)
    ax.text(tay3.index[-1], tay3["selic"].iloc[-1] + 0.35, "Selic meta", color="#0072B2", ha="right", fontweight="bold", fontsize=9)
    ax.text(tay3.index[-1], tay3["taylor_selic"].iloc[-1] - 0.75, "Regra de Taylor", color="#D55E00", ha="right", fontweight="bold", fontsize=9)
    ax.set_title("A Selic ficou sistematicamente acima do que a regra de Taylor sugeria")
    ax.set_ylabel("% ao ano"); ax.set_ylim(7, 16)
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%m/%y"))
    fig.text(0.01, 0.01, "Taylor: r* = BCB (RPM), π* = meta CMN, π = IPCA 12m, sem hiato. " + FONTE3, fontsize=7, color="gray")
    fig.tight_layout(rect=(0, 0.04, 1, 1))
    fig.savefig("figuras03/publicacao_taylor.png", dpi=160)
    fig.savefig("figuras03/publicacao_taylor.pdf")
    plt.close(fig)
print(f"Gap médio (Selic - Taylor): {tay3['gap_pp'].mean():+.2f} p.p. | meses com Selic acima da regra: {(tay3['gap_pp'] > 0).mean():.0%}")
```

#figure(
  image("figuras03/publicacao_taylor.png", width: 88%),
  caption: [Gráfico "pronto para publicar": estilo configurado uma vez (`rc_context`), rótulos diretos e fonte indicada. Um PDF vetorial foi gerado ao lado do PNG.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Salvando e exportando gráficos
#exemplo("seaborn: o mesmo gráfico com menos código")[
  O `seaborn` constrói sobre o matplotlib gráficos estatísticos completos (regressão com intervalo de confiança, distribuições
  por grupo) em uma linha, com estilos agradáveis por padrão:
]

```python
import seaborn as sns
longo = gr3[["Servicos", "Administrados", "Livres"]].rename(columns={"Servicos": "Serviços"}).melt(var_name="grupo", value_name="variação 12m")
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9.5, 3.6))
sns.regplot(x=tay3["ipca12m"], y=tay3["selic"], ax=ax1, scatter_kws=dict(s=22, alpha=0.7), line_kws=dict(color="#D55E00"))
ax1.set_title("regplot: reta e intervalo de confiança", loc="left", fontsize=10, fontweight="bold")
ax1.set_xlabel("IPCA 12m (%)"); ax1.set_ylabel("Selic (%)")
sns.violinplot(data=longo, x="grupo", y="variação 12m", ax=ax2, inner="quartile", cut=0, palette=["#D55E00", "#009E73", "#0072B2"], hue="grupo", legend=False)
ax2.set_title("violinplot: forma e quartis por grupo", loc="left", fontsize=10, fontweight="bold")
for ax in (ax1, ax2):
    ax.spines[["top", "right"]].set_visible(False)
fig.text(0.01, 0.01, FONTE3, fontsize=7, color="gray")
fig.tight_layout(rect=(0, 0.04, 1, 1))
fig.savefig("figuras03/seaborn_exemplos.png", dpi=160)
plt.close(fig)
print("seaborn", sns.__version__, "| observações no formato longo:", len(longo))
```

#figure(
  image("figuras03/seaborn_exemplos.png", width: 100%),
  caption: [`regplot` e `violinplot` do seaborn sobre os mesmos dados reais.],
)

%%% BEFORE_CHAPTER_END: == Capítulo 15 --- Boas práticas: checklist final de um gráfico econômico
#teoria("o tamanho do arquivo em cada formato: a prova numérica")[
  Formatos #strong[raster] (PNG, JPG) guardam pixels: o tamanho cresce com a resolução (DPI) e perde nitidez ao ampliar. Formatos
  #strong[vetoriais] (SVG, PDF) guardam instruções de desenho: escalam sem perda e costumam ser menores em gráficos simples. Para web e
  apresentações, PNG a 100--150 DPI; para impressão e artigos, PDF/SVG ou PNG a 300 DPI; fotos, JPG. O código mede:
]

```python
import tempfile, os
fig, ax = plt.subplots(figsize=(6, 3))
ax.plot(ip3.index, ip3.values); ax.set_title("IPCA 12m")
with tempfile.TemporaryDirectory() as pasta:
    for nome, kw in (("png_72dpi", dict(dpi=72, format="png")), ("png_150dpi", dict(dpi=150, format="png")),
                     ("png_300dpi", dict(dpi=300, format="png")), ("svg", dict(format="svg")), ("pdf", dict(format="pdf"))):
        caminho = os.path.join(pasta, "figura." + kw["format"])
        fig.savefig(caminho, **{k: v for k, v in kw.items() if k != "format"}, format=kw["format"])
        print(f"{nome:<11}: {os.path.getsize(caminho) / 1024:7.1f} KB")
plt.close(fig)
```

%%% BEFORE_CHAPTER_END: == Capítulo 16 --- Exercícios para Executar (na mão)
#figure(
  align(center)[#table(
    columns: (38%, 62%),
    align: (left, left),
    table.header([Pergunta do leitor], [Gráfico adequado],),
    [Como o valor evoluiu no tempo?], [Linha (poucas séries) ou linhas pequenas múltiplas],
    [Qual categoria é maior?], [Barras ordenadas, a partir de zero],
    [Como se distribui?], [Histograma (uma variável) ou boxplot/violino (vários grupos)],
    [Duas variáveis se relacionam?], [Scatter (com tendência, sem inferir causa)],
    [Como se compõe o total?], [Barras empilhadas 100% (poucas categorias); evite pizza],
    [Quais pares de variáveis se correlacionam?], [Heatmap divergente centrado em zero, ou `pairplot`],
    [Qual a diferença entre dois momentos?], [Barras lado a lado ou #emph[slope chart]],
  )]
  , kind: table
  )

%%% BEFORE_CHAPTER_END: == Próxima apostila
#line()

== Capítulo 18 --- Erros Comuns e Teste Rápido
<capítulo-18-erros-comuns-e-teste-rapido>
=== 18.1. Os erros de design que mais prejudicam um gráfico econômico
<os-erros-de-design>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Barras com eixo Y cortado], [Comece em zero; se for linha, deixe o corte evidente],
    [2], [Dois eixos Y com escalas arbitrárias], [Mesma escala, índice base 100 ou subplots],
    [3], [Mais de 5 séries coloridas em um painel], [Destaque uma e deixe as outras em cinza; ou small multiples],
    [4], [Pizza com muitas fatias], [Barras ordenadas],
    [5], [Colormap arco-íris (`jet`)], [Sequencial (magnitude) ou divergente simétrica (sinal)],
    [6], [Depender só da cor], [Traço, marcador e rótulo direto],
    [7], [Título que descreve em vez de concluir], [Título-conclusão],
    [8], [Esquecer unidades, fonte e período], [Rótulo de eixo com unidade e nota de fonte],
    [9], [Barras em ordem alfabética], [Ordene por valor],
    [10], [Salvar como JPG ou em baixa resolução], [PNG ≥ 150 DPI ou PDF/SVG],
  )]
  , kind: table
  )

=== 18.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rapido-verdadeiro-ou-falso-viz>
+ #strong[V ou F:] Em um gráfico de barras, o eixo Y pode começar em qualquer valor. #strong[Falso.] O comprimento codifica o valor; deve partir de zero.
+ #strong[V ou F:] Um eixo Y duplo permite comparar duas séries de unidades diferentes sem distorcer. #strong[Falso.] A escala de cada eixo é arbitrária.
+ #strong[V ou F:] Para uma matriz de correlação, a escala de cor ideal é divergente e simétrica. #strong[Verdadeiro.]
+ #strong[V ou F:] Mais bins sempre dão um histograma mais fiel. #strong[Falso.] Bins demais criam ruído.
+ #strong[V ou F:] O boxplot mostra se a distribuição é bimodal. #strong[Falso.] Comprime a forma; use histograma ou violino.
+ #strong[V ou F:] Uma linha de tendência no scatter prova causalidade. #strong[Falso.] Descreve associação.
+ #strong[V ou F:] Cor, sozinha, deve ser a única forma de distinguir as séries. #strong[Falso.] Acrescente traço, marcador e rótulo.
+ #strong[V ou F:] Um PDF vetorial perde nitidez ao ampliar. #strong[Falso.] Escala sem perda.
+ #strong[V ou F:] Ordenar barras por valor facilita a comparação. #strong[Verdadeiro.]
+ #strong[V ou F:] `jet` é uma boa escolha para dados que devem ser lidos por daltônicos. #strong[Falso.]
%%% END
