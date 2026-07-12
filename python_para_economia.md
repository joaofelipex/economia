# Python para Economia — Guia de Aprendizado

## FASE 1 — Fundamentos (1 semana)

### 1. Tipos de dados
```python
# Números
x = 5          # int
y = 3.14       # float

# Texto
nome = "Brasil"

# Booleano
verdadeiro = True
falso = False

# Lista (vetor)
inflacao = [0.25, 0.33, 0.50, 0.70]

# Dicionário (chave -> valor)
pib = {"Brasil": 2.2, "Argentina": -1.8, "Chile": 3.1}
```

### 2. Operadores
```python
+, -, *, /      # básicos
**              # potência (2**3 = 8)
%               # resto (5%2 = 1)
==, !=, <, >    # comparações
and, or, not    # lógicos
```

### 3. Strings
```python
texto = "IPCA foi de " + str(0.70) + "%"
texto2 = f"IPCA foi de {0.70}%"   # mais fácil (f-string)
texto.upper()   # "IPCA" -> "IPCA"
texto.split()   # separa por espaço
", ".join(["a", "b"])  # "a, b"
```

### 4. Listas
```python
dados = [1, 2, 3, 4, 5]
dados[0]        # 1 (primeiro)
dados[-1]       # 5 (último)
dados[1:3]      # [2, 3] (fatiamento)
len(dados)      # 5 (tamanho)
dados.append(6) # adiciona no final
sum(dados)      # 21
```

### 5. Condicionais
```python
if inflacao > 0.5:
    print("Alta")
elif inflacao > 0.3:
    print("Moderada")
else:
    print("Baixa")
```

### 6. Loops
```python
# for com lista
for valor in inflacao:
    print(valor)

# for com range (repetir N vezes)
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

# while
i = 0
while i < len(inflacao):
    print(inflacao[i])
    i += 1
```

### 7. Funções
```python
def calcular_media(dados):
    return sum(dados) / len(dados)

media = calcular_media([1, 2, 3, 4, 5])
print(media)  # 3.0
```

---

## FASE 2 — pandas (2 semanas)

### Abrir dados
```python
import pandas as pd

df = pd.read_csv("dados.csv")
df = pd.read_excel("dados.xlsx")
```

### Explorar
```python
df.head()        # primeiras 5 linhas
df.tail(3)       # últimas 3
df.info()        # tipos e nulos
df.describe()    # estatísticas
df.columns       # nomes das colunas
len(df)          # número de linhas
```

### Selecionar
```python
df["coluna"]          # uma coluna (série)
df[["col1", "col2"]]  # várias colunas (DataFrame)
df.iloc[0]            # primeira linha (por índice)
df.loc[df["ano"] > 2020]  # filtrar linhas
```

### Filtrar
```python
mask = df["pais"] == "Brasil"
df[mask]

# múltiplos filtros
df[(df["ano"] >= 2000) & (df["ano"] <= 2020)]
```

### Criar/modificar colunas
```python
df["pib_per_capita"] = df["pib"] / df["populacao"]
df["log_pib"] = np.log(df["pib"])
```

### Agrupar
```python
df.groupby("pais")["pib"].mean()
df.groupby(["ano", "pais"])["pib"].sum()
```

### Juntar tabelas
```python
pd.merge(df1, df2, on="pais")
pd.merge(df1, df2, on=["ano", "pais"])
```

### Datas
```python
df["data"] = pd.to_datetime(df["data"])
df.set_index("data", inplace=True)
df["2020":"2022"]       # filtrar por período
df.resample("Y").mean() # anualizar

# Atraso (lag)
df["pib_lag1"] = df["pib"].shift(1)
# Variação percentual
df["pib_var"] = df["pib"].pct_change() * 100
```

---

## FASE 3 — matplotlib / seaborn (1 semana)

```python
import matplotlib.pyplot as plt

# Linha
plt.figure(figsize=(10, 4))
plt.plot(df.index, df["ipca"], color="red")
plt.title("IPCA")
plt.ylabel("%")
plt.grid(True)
plt.show()

# Gráfico com dois eixos
fig, ax1 = plt.subplots()
ax1.plot(df["ipca"], color="red")
ax2 = ax1.twinx()
ax2.plot(df["selic"], color="blue")

# Barra
df.groupby("ano")["pib"].sum().plot(kind="bar")
```

---

## FASE 4 — numpy (essencial)

```python
import numpy as np

np.log(x)      # log natural
np.exp(x)      # exponencial
np.sqrt(x)     # raiz quadrada
np.mean(x)     # média
np.std(x)      # desvio padrão
np.corrcoef(x, y)  # correlação
np.array([1, 2, 3])  # criar array
```

---

## FASE 5 — statsmodels (econometria)

```python
import statsmodels.api as sm

# Regressão OLS
X = sm.add_constant(df["renda"])
modelo = sm.OLS(df["consumo"], X).fit()
print(modelo.summary())

# Estatísticas dos resíduos
modelo.resid.mean()
modelo.rsquared  # R²
modelo.params    # coeficientes
modelo.pvalues   # p-valores
```

---

## Ordem de estudo sugerida

| Dia | Tópico | Prática |
|-----|--------|---------|
| 1 | Tipos, variáveis, print | Calcular taxa de câmbio real |
| 2 | Listas, loops | Calcular média móvel manualmente |
| 3 | Condicionais, funções | Classificar países por renda |
| 4 | pandas: abrir, explorar | Ler Excel com dados do BCB |
| 5 | pandas: filtrar, agrupar | PIB médio por década |
| 6 | pandas: merge, datas | Juntar PIB + inflação + SELIC |
| 7 | matplotlib | Plotar séries temporais |
| 8 | numpy + statsmodels | Primeira regressão |

---

## Regra de ouro

> Não decore sintaxe. Entenda o **conceito** e pesquise o **resto**.
>
> `O Python que você vai usar 90% do tempo = pandas + matplotlib + numpy`

Guarde estes atalhos mentais:

| Você quer... | Use... |
|-------------|--------|
| Abrir tabela | `pd.read_csv/Excel` |
| Filtrar linhas | `df[df["x"] > 5]` |
| Criar coluna | `df["nova"] = ...` |
| Agrupar | `df.groupby("x")["y"].mean()` |
| Gráfico simples | `df.plot()` |
| Regressão | `sm.OLS(y, X).fit()` |
| F-string | `f"valor {x}"` |
| Função | `def nome():` |
| Ajuda no Python | `help(nome_da_funcao)` |
