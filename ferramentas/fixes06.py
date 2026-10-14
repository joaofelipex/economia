# Correcoes pontuais no texto/codigo ORIGINAL (cada `old` deve ocorrer exatamente 1 vez).
REPL = []

def fix(old, new):
    REPL.append((old, new))

# 2.2 -- tabela de taxas proporcionais: o '%' saia solto no meio da linha
fix(r'''    print(f"{'Período':<15} {'Taxa Proporcional':<20} {'Cálculo'}")
    print("-" * 55)
    print(f"{'Ano':<15} {i_aa*100:<19.2f}% {i_aa}")
    print(f"{'Semestre':<15} {i_aa/2*100:<19.2f}% {i_aa}/2")
    print(f"{'Trimestre':<15} {i_aa/4*100:<19.2f}% {i_aa}/4")
    print(f"{'Mês':<15} {i_aa/12*100:<19.2f}% {i_aa}/12")
    print(f"{'Dia (comercial)':<15} {i_aa/360*100:<19.4f}% {i_aa}/360")
    print(f"{'Dia (exato)':<15} {i_aa/365*100:<19.4f}% {i_aa}/365")''',
r'''    linhas = [
        ("Ano", i_aa, 2, "0.24"),
        ("Semestre", i_aa / 2, 2, "0.24/2"),
        ("Trimestre", i_aa / 4, 2, "0.24/4"),
        ("Mês", i_aa / 12, 2, "0.24/12"),
        ("Dia (comercial)", i_aa / 360, 4, "0.24/360"),
        ("Dia (exato)", i_aa / 365, 4, "0.24/365"),
    ]
    print(f"{'Período':<16} {'Taxa proporcional':<19} Cálculo")
    print("-" * 52)
    for nome, taxa, casas, calculo in linhas:
        texto = f"{taxa*100:.{casas}f}%"
        print(f"{nome:<16} {texto:<19} {calculo}")''')

# 2.3 -- rotulo incoerente na linha "Relacao"
fix(r'''    print(f"Relação: {j_com/j_exa:.4f} (={360/365:.4f})")''',
    r'''    print(f"Relação J_comercial / J_exato: {j_com/j_exa:.4f} (= 365/360 = {365/360:.4f})")''')

# 2.4 -- '%' solto e rotulo ambiguo (a taxa e do PRAZO, nao ao mes)
fix(r'''    print(f"{'Taxa efetiva':<20} {(d_com/pv_com)*100:<13.2f}% {(d_rac/pv_rac)*100:<.2f}%")''',
    r'''    t_com = f"{d_com / pv_com * 100:.2f}%"
    t_rac = f"{d_rac / pv_rac * 100:.2f}%"
    print(f"{'Taxa efetiva (prazo)':<20} {t_com:<15} {t_rac}")''')

# 3.5 -- afirmacao sobre a pratica do mercado estava invertida
fix('''A convenção linear sempre produz montante #strong[levemente maior], e é
a mais usada no mercado financeiro brasileiro.''',
'''A convenção linear produz montante #strong[levemente maior] (a prova está
no quadro "Aprofundando a teoria" logo abaixo). Na prática do mercado
brasileiro de renda fixa predomina a convenção #strong[exponencial]
(taxa equivalente elevada ao prazo, em dias úteis/252 ou corridos/365);
a linear aparece sobretudo em livros-texto e em cálculos simplificados.''')

# 5.7 -- trecho morto/incorreto no final do bloco do CET
fix(r'''# Comparar com taxa de juros pura
i_puro = (i * (1 + i) ** n) / ((1 + i) ** n - 1)  # taxa que geraria PMT de R$950
taxa_pura = ((pmt * ((1 + 0.02) ** n - 1) / (0.02 * (1 + 0.02) ** n)) / pv) ** (1/n) - 1''',
r'''# Mesmo contrato, mas o banco desconta R$150 (tarifa + IOF) do valor liberado
liberado = pv - 150
cet_liq = calcular_cet(liberado, [pmt] * n, list(range(1, n + 1)))
print(f"CET mensal se o cliente recebe só R\${liberado:,.0f}: {cet_liq*100:.4f}%")
print(f"CET anual: {((1 + cet_liq)**12 - 1)*100:.2f}%")''')

# 6.2 -- rotulo arredondado errado ("13% - 4%")
fix(r'''print(f"Aproximação ({i_nom*100:.0f}% - {pi*100:.0f}%): {aprox*100:.2f}%")''',
    r'''print(f"Aproximação ({i_nom*100:.2f}% - {pi*100:.2f}%): {aprox*100:.2f}%")''')

# 6.4 -- BUG: o spread (anual) era somado como se fosse diario
fix('''    cdi_diario = (1 + cdi_projetado) ** (1/252) - 1
    taxa_pos_diaria = (1 + cdi_diario) * (1 + spread) - 1''',
'''    cdi_diario = (1 + cdi_projetado) ** (1/252) - 1
    spread_diario = (1 + spread) ** (1/252) - 1   # o spread é anual: converter p/ base diária
    taxa_pos_diaria = (1 + cdi_diario) * (1 + spread_diario) - 1''')

# 7.4 -- BUG: fracao do periodo no payback (interpolacao errada)
fix('''                fracao = -acum_anterior / (fl_descontado - acum_anterior) if fl_descontado != 0 else 1''',
    '''                fracao = -acum_anterior / fl_descontado if fl_descontado != 0 else 1''')

# 7.6 -- linhas mortas que calculavam VPLA de fluxos inventados
fix('''vpla_x = vpla(taxa, [0, 0, 0, 10000], 3)  # simplificado
vpla_y = vpla(taxa, [0, 0, 0, 0, 0, 14000], 5)

# Na verdade VPL já calculado:''',
    '''# Os VPLs de cada projeto já são conhecidos; basta anualizá-los:''')

# 7.7 -- BUG: a variacao da TMA era somada em pontos (10% - 30% = -20%)
fix('''                tma_mod = tma_base + delta''',
    '''                tma_mod = tma_base * (1 + delta)   # variação relativa da TMA''')

# E7 -- "110% do CDI" incide sobre a taxa DIARIA, nao sobre a anual
fix(r'''taxa_aplicada = cdi * percentual
vf = pv * (1 + taxa_aplicada)
print(f"Taxa aplicada: {taxa_aplicada*100:.2f}% a.a.")
print(f"Valor de resgate: R\${vf:.2f}")''',
r'''cdi_diario = (1 + cdi) ** (1/252) - 1        # CDI diário (base 252 dias úteis)
fator_diario = 1 + cdi_diario * percentual   # 110% do CDI incide sobre a taxa DIÁRIA
vf = pv * fator_diario ** 252
taxa_efetiva = fator_diario ** 252 - 1
print(f"Taxa efetiva no período: {taxa_efetiva*100:.2f}% (e não {cdi*percentual*100:.2f}%, que seria 1,10 x 13,25%)")
print(f"Valor de resgate: R\${vf:.2f}")''')

# Figuras geradas pelo proprio codigo
fix(r'''    plt.title(f'Capitalização Simples vs Composta — PV = R\${pv:,.0f}, i = {i*100:.0f}%')
    plt.legend()
    plt.grid(alpha=0.3)
    plt.show()
```''',
r'''    plt.title(f'Capitalização Simples vs Composta — PV = R\${pv:,.0f}, i = {i*100:.0f}%')
    plt.legend()
    plt.grid(alpha=0.3)
    plt.savefig("figuras06/regimes.png", dpi=170, bbox_inches="tight")
    plt.show()

regime_comparativo()
```

#figure(
  image("figuras06/regimes.png", width: 88%),
  caption: [Montante em juros simples (reta) e compostos (curva) para o mesmo capital e a mesma taxa. A área sombreada é o ganho do "juros sobre juros".],
)''')

fix('''    plt.tight_layout()
    plt.show()

comparar_sistemas(50000, 0.02, 12)
```''',
'''    plt.tight_layout()
    plt.savefig("figuras06/price_vs_sac.png", dpi=170, bbox_inches="tight")
    plt.show()

comparar_sistemas(50000, 0.02, 12)
```

#figure(
  image("figuras06/price_vs_sac.png", width: 100%),
  caption: [Price (azul) × SAC (vermelho) para R\\$ 50.000 em 12 parcelas a 2% a.m.: o SAC começa com prestação maior e reduz o saldo mais depressa.],
)''')


# ---------------------------------------------------------------- funcoes
def troca_glossario(text):
    antiga = "== Capítulo 12 --- Glossário\n<capítulo-12-glossário>\n"
    marca = "== Capítulo 14 --- Glossário\n<capítulo-14-glossário>\n"
    assert text.count(antiga) == 1
    text = text.replace(antiga, marca)   # os capítulos 12 e 13 (aplicações, erros) entram antes
    i = text.index(marca) + len(marca)
    novo = open(__file__.replace("fixes06.py", "glossario06.typ"), encoding="utf-8").read()
    return text[:i] + novo.strip("\n") + "\n"

FUNCS = [troca_glossario]


# --- Evita revelar a resposta dos Exercicios 4 (cap. 10 e 11): outros dados nos exemplos
fix('''for taxa_nominal in [0.12, 0.18, 0.24, 0.30]:''',
    '''for taxa_nominal in [0.12, 0.15]:''')
fix(r'''i_nom = 0.24
print(f"24% a.a. com capitalização contínua: {capitalizacao_continua(i_nom)*100:.4f}% a.a.")
print(f"24% a.a. com capitalização mensal: {nominal_para_efetiva(i_nom, 12)*100:.2f}% a.a.")
print(f"24% a.a. com capitalização diária: {nominal_para_efetiva(i_nom, 360)*100:.4f}% a.a.")''',
    r'''i_nom = 0.20
print(f"20% a.a. com capitalização contínua: {capitalizacao_continua(i_nom)*100:.4f}% a.a.")
print(f"20% a.a. com capitalização mensal: {nominal_para_efetiva(i_nom, 12)*100:.2f}% a.a.")
print(f"20% a.a. com capitalização diária: {nominal_para_efetiva(i_nom, 360)*100:.4f}% a.a.")''')
