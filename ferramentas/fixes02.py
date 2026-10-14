REPL = []
fix = lambda o, n: REPL.append((o, n))
fix("""pais
Chile        9.294...
Argentina    10.312...
Brasil       4.114...
Name: pib, dtype: float64""", """pais
Argentina    10.232790
Chile         8.974594
Brasil        4.058325
Name: pib, dtype: float64""")
