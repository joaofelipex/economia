# Apostila 3 — Visualização de Dados Econômicos

## 1. Por que matplotlib?

matplotlib é a biblioteca padrão de gráficos do Python. Com ela você faz desde um gráfico simples até figuras prontas para publicação em revista acadêmica.

```python
import matplotlib.pyplot as plt
import pandas as pd
```

---

## 2. Gráfico de linha (série temporal)

O tipo mais comum em economia.

```python
from bcb import sgs

ipca = sgs.get({"IPCA": 433}, start="2020-01-01")

# Criar figura e eixos
fig, ax = plt.subplots(figsize=(12, 5))

# Plotar
ax.plot(ipca.index, ipca["IPCA"], color="crimson", linewidth=1.5)

# Títulos e labels
ax.set_title("IPCA - Variação Mensal (%)", fontsize=14, fontweight="bold")
ax.set_ylabel("Variação mensal (%)")
ax.set_xlabel("")

# Grade
ax.grid(True, alpha=0.3)

# Ajustar layout
fig.tight_layout()

# Salvar
fig.savefig("ipca_2020.png", dpi=150)
plt.close()
```

### Parâmetros do plot

```python
ax.plot(x, y,
    color="crimson",      # cor: "blue", "red", "green", "#FF5733"
    linewidth=1.5,        # espessura da linha
    linestyle="-",        # "-" sólida, "--" tracejada, ":" pontilhada, "-." traço-ponto
    marker="o",           # "o" círculo, "^" triângulo, "s" quadrado, "D" losango
    markersize=4,
    alpha=0.8,            # transparência (0 a 1)
    label="IPCA"          # legenda
)
```

---

## 3. Vários gráficos na mesma figura

### 3.1. Mesmo eixo Y

```python
fig, ax = plt.subplots(figsize=(12, 5))

ax.plot(ipca.index, ipca["IPCA"], color="crimson", label="IPCA")
ax.plot(selic.index, selic["SELIC"], color="navy", label="SELIC")

ax.legend()  # mostra a legenda
ax.set_title("IPCA vs SELIC")
ax.grid(True, alpha=0.3)
fig.tight_layout()
```

### 3.2. Dois eixos Y (escala diferente)

```python
from bcb import sgs

ipca = sgs.get({"IPCA": 433}, start="2020-01-01")
selic = sgs.get({"SELIC": 11}, start="2020-01-01")

fig, ax1 = plt.subplots(figsize=(12, 5))

ax1.plot(ipca.index, ipca["IPCA"], color="crimson", linewidth=1.5, label="IPCA")
ax1.set_ylabel("IPCA (%)", color="crimson")
ax1.tick_params(axis="y", labelcolor="crimson")

ax2 = ax1.twinx()  # segundo eixo Y
ax2.plot(selic.index, selic["SELIC"], color="navy", linewidth=1.5, label="SELIC")
ax2.set_ylabel("SELIC (%)", color="navy")
ax2.tick_params(axis="y", labelcolor="navy")

ax1.set_title("IPCA e SELIC - 2020 a 2026", fontsize=14)
ax1.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("ipca_selic.png", dpi=150)
plt.close()
```

### 3.3. Subplots (vários gráficos)

```python
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), sharex=True)

ax1.plot(ipca.index, ipca["IPCA"], color="crimson")
ax1.set_title("IPCA")
ax1.grid(True, alpha=0.3)

ax2.plot(selic.index, selic["SELIC"], color="navy")
ax2.set_title("SELIC")
ax2.grid(True, alpha=0.3)

fig.tight_layout()
```

---

## 4. Gráfico de barras

Para comparar categorias.

```python
# Dados
dados = {
    "pais": ["Brasil", "Argentina", "Chile", "Colômbia", "Peru"],
    "pib": [2.2, -1.8, 3.1, 2.8, 2.5]
}
df = pd.DataFrame(dados).sort_values("pib")

fig, ax = plt.subplots(figsize=(10, 5))
cores = ["green" if v > 0 else "red" for v in df["pib"]]

ax.bar(df["pais"], df["pib"], color=cores, edgecolor="black", linewidth=0.5)
ax.axhline(0, color="black", linewidth=0.8)
ax.set_title("Crescimento do PIB - América do Sul", fontsize=14)
ax.set_ylabel("PIB (%)")
ax.grid(axis="y", alpha=0.3)
fig.tight_layout()
```

### Barras horizontais

```python
ax.barh(df["pais"], df["pib"], color=cores)
ax.set_xlabel("PIB (%)")
```

---

## 5. Gráfico de dispersão (scatter)

Para ver relação entre duas variáveis.

```python
# Dados de exemplo
df = pd.DataFrame({
    "educacao": [5.2, 6.1, 7.8, 8.3, 9.5, 10.2, 11.0, 12.1],
    "pib_per_capita": [3000, 4500, 5800, 7200, 8500, 10200, 12500, 15000]
})

fig, ax = plt.subplots(figsize=(8, 6))
ax.scatter(df["educacao"], df["pib_per_capita"],
           color="steelblue", s=80, alpha=0.7, edgecolor="black")

ax.set_title("Educação vs PIB per capita")
ax.set_xlabel("Anos de estudo (média)")
ax.set_ylabel("PIB per capita (US$)")

# Adicionar linha de tendência
import numpy as np
z = np.polyfit(df["educacao"], df["pib_per_capita"], 1)
p = np.poly1d(z)
ax.plot(df["educacao"], p(df["educacao"]), "r--", alpha=0.6)

# Anotar ponto específico
ax.annotate("Brasil", xy=(7.8, 5800), fontsize=10)

fig.tight_layout()
```

---

## 6. Histograma

Para ver distribuição dos dados.

```python
fig, ax = plt.subplots(figsize=(10, 5))
ax.hist(ipca["IPCA"], bins=30, color="steelblue", edgecolor="black", alpha=0.7)
ax.axvline(ipca["IPCA"].mean(), color="red", linestyle="--", label=f"Média = {ipca.mean().iloc[0]:.2f}")
ax.axvline(ipca["IPCA"].median(), color="green", linestyle=":", label=f"Mediana = {ipca.median().iloc[0]:.2f}")
ax.legend()
ax.set_title("Distribuição do IPCA mensal (1995-2026)")
ax.set_xlabel("Variação mensal (%)")
ax.set_ylabel("Frequência")
fig.tight_layout()
```

---

## 7. Boxplot

Resumo visual da distribuição (mediana, quartis, outliers).

```python
# Comparar distribuições
df = pd.DataFrame({
    "Brasil": np.random.normal(4.5, 1.5, 100),
    "Chile": np.random.normal(3.0, 1.0, 100),
    "Argentina": np.random.normal(50, 20, 100),
})

fig, ax = plt.subplots(figsize=(8, 5))
df.boxplot(ax=ax)
ax.set_title("Distribuição da Inflação - Simulação")
ax.set_ylabel("Inflação (%)")
ax.grid(axis="y", alpha=0.3)
fig.tight_layout()
```

---

## 8. Heatmap (correlação)

```python
corr = df.corr(numeric_only=True)

fig, ax = plt.subplots(figsize=(8, 6))
im = ax.imshow(corr, cmap="RdYlBu", vmin=-1, vmax=1)

# Rótulos
ax.set_xticks(range(len(corr.columns)))
ax.set_yticks(range(len(corr.columns)))
ax.set_xticklabels(corr.columns, rotation=45, ha="right")
ax.set_yticklabels(corr.columns)

# Valores dentro dos quadrados
for i in range(len(corr.columns)):
    for j in range(len(corr.columns)):
        ax.text(j, i, f"{corr.iloc[i, j]:.2f}",
                ha="center", va="center", fontsize=9)

fig.colorbar(im)
fig.tight_layout()
```

---

## 9. Personalização completa (gráfico publication-ready)

```python
from bcb import sgs
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

ipca = sgs.get({"IPCA": 433}, start="2000-01-01")
selic = sgs.get({"SELIC": 11}, start="2000-01-01")

fig, ax = plt.subplots(figsize=(12, 5.5))

ax.fill_between(ipca.index, ipca["IPCA"], 0, alpha=0.1, color="crimson")
ax.plot(ipca.index, ipca["IPCA"], color="crimson", linewidth=1.2, label="IPCA")
ax.plot(selic.index, selic["SELIC"], color="navy", linewidth=1.2, label="SELIC")

ax.axhline(0, color="gray", linewidth=0.5)

ax.set_title("Brasil: Taxa SELIC e IPCA (2000-2026)", fontsize=14, fontweight="bold")
ax.set_ylabel("Percentual (%)")
ax.legend(frameon=True, fancybox=True, shadow=True)

ax.grid(True, alpha=0.3, linestyle=":")
ax.set_axisbelow(True)  # grade atrás dos dados

# Formatar eixo X com anos
ax.xaxis.set_major_locator(ticker.MultipleLocator(2))  # label a cada 2 anos
ax.xaxis.set_major_formatter(ticker.DateFormatter("%Y"))

fig.tight_layout()
fig.savefig("publication_ready.png", dpi=300, bbox_inches="tight")
plt.close()
```

---

## 10. seaborn (gráficos estatísticos mais bonitos)

```python
import seaborn as sns

sns.set_theme(style="whitegrid")  # tema padrão

# Mesmo gráfico do matplotlib, mas mais bonito
fig, ax = plt.subplots(figsize=(12, 5))
sns.lineplot(data=ipca, x=ipca.index, y="IPCA", color="crimson", ax=ax)
sns.lineplot(data=selic, x=selic.index, y="SELIC", color="navy", ax=ax)
fig.tight_layout()

# Regressão com intervalo de confiança
sns.regplot(data=df, x="educacao", y="pib_per_capita")

# Pairplot (todas as correlações de uma vez)
sns.pairplot(df[["pib", "inflacao", "desemprego", "populacao"]])

# Boxplot com seaborn (mais bonito)
sns.boxplot(data=df)
```

---

## 11. Salvando gráficos

```python
fig.savefig("grafico.png")                    # PNG (padrão)
fig.savefig("grafico.pdf")                    # PDF (vetorial, melhor para artigos)
fig.savefig("grafico.png", dpi=300)           # Alta resolução
fig.savefig("grafico.png", bbox_inches="tight")  # Sem cortar bordas
fig.savefig("grafico.svg")                    # SVG (vetorial para web)
```

---

## 12. Dicas profissionais

```python
# Cores para daltônicos (use sempre que possível)
cores_seguras = ["#0077BB", "#33BBEE", "#EE7733", "#CC3311", "#009988", "#BBBBBB"]

# Tamanhos de fonte
plt.rcParams.update({
    "font.size": 12,
    "axes.titlesize": 14,
    "axes.labelsize": 12,
    "legend.fontsize": 10,
    "figure.dpi": 100
})

# Grid
ax.grid(True, alpha=0.3, linestyle=":")

# Remover bordas desnecessárias
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

# Inverter eixo Y (útil para curvas de renda)
ax.invert_yaxis()
```

---

## 13. Exercícios

### Exercício 1
Baixe IPCA (433) e SELIC (11) de 2015 a 2026 e plote os dois com dois eixos Y.

### Exercício 2
Crie um gráfico de barras comparando o PIB de 10 países em 2025. Destaque em vermelho os que tiveram PIB negativo.

### Exercício 3
Gere um scatter plot de inflação vs desemprego (Curva de Phillips) com linha de tendência.

### Exercício 4
Baixe o IPCA de 1995-2026 e faça um histograma + boxplot lado a lado (use `subplots(1, 2)`).

### Exercício 5
Recrie o gráfico "publication-ready" da seção 9, mas adicionando uma terceira série (câmbio, código 1).

<details>
<summary>Solução Exercício 4</summary>

```python
from bcb import sgs
import matplotlib.pyplot as plt

ipca = sgs.get({"IPCA": 433}, start="1995-01-01")

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

ax1.hist(ipca["IPCA"], bins=30, color="steelblue", edgecolor="black")
ax1.set_title("Histograma")
ax1.set_xlabel("IPCA mensal (%)")

ax2.boxplot(ipca["IPCA"], vert=False)
ax2.set_title("Boxplot")
ax2.set_xlabel("IPCA mensal (%)")

fig.tight_layout()
fig.savefig("distribuicao_ipca.png", dpi=150)
```
</details>

---

## 14. Resumo — gráficos

| Tipo | Código | Uso |
|------|--------|-----|
| Linha | `ax.plot(x, y)` | Séries temporais |
| Barra | `ax.bar(x, y)` | Comparar categorias |
| Dispersão | `ax.scatter(x, y)` | Relação entre variáveis |
| Histograma | `ax.hist(x)` | Distribuição |
| Boxplot | `ax.boxplot(x)` | Resumo estatístico |
| Dois eixos | `ax.twinx()` | Escalas diferentes |
| Subplots | `subplots(n_rows, n_cols)` | Múltiplos gráficos |
| Seaborn | `sns.lineplot()`, `sns.regplot()` | Gráficos mais bonitos |
