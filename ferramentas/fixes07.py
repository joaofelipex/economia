REPL = []
def fix(old, new):
    REPL.append((old, new))

# 2.3 -- formula de diversificacao inconsistente (nao reproduzia 40% para N=1)
fix('''            risco_total = np.sqrt(risco_sistematico**2 + risco_nao_sistematico**2)''',
    '''            # variância = σ²/N + (1 - 1/N)·ρ·σ²  (o termo sistemático só pesa 1 - 1/N)
            risco_total = np.sqrt(risco_nao_sistematico**2 + (1 - 1 / n_ativos) * risco_sistematico**2)''')

# 5.5 -- placeholder "Margem Bruta = 100" imprimia 10000%
fix("        'Margem Bruta': 100,  # precisaria de CPV\n", "")

# 12.1 -- comentario no estilo C quebrava o Python (SyntaxError)
fix("j_usa = 0.05  // Fed Funds", "j_usa = 0.05  # Fed Funds")

# 2.4 -- Selic e nominal, nao real
fix("rf = 0.105      # 10.5% (Selic real)", "rf = 0.105      # 10.5% (Selic nominal)")


def troca_glossario(text):
    ini = "== Capítulo 15 --- Glossário\n<capítulo-15-glossário>\n"
    fim = "\n#line()\n\n== Capítulo 16"
    a = text.index(ini) + len(ini)
    b = text.index(fim, a)
    novo = open(__file__.replace("fixes07.py", "glossario07.typ"), encoding="utf-8").read().strip("\n")
    return text[:a] + novo + "\n" + text[b:]

FUNCS = [troca_glossario]
