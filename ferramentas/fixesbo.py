REPL = []
def fix(old, new):
    REPL.append((old, new))
# erro de digitacao: "=line()" gerava um título com o texto "line()"
fix("=line()\n\n= Checklist final", "#line()\n\n= Checklist final")
