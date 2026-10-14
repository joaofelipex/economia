"""Reconstroi a apostila 06 a partir do commit HEAD:
 1) aplica correcoes pontuais (fixes06.py)
 2) insere os fragmentos novos (frag06_*.typ) nos pontos marcados
 3) executa TODOS os blocos python e regrava os blocos de saida com o resultado real
 4) compila o PDF com typst
"""
import contextlib, glob, io, os, re, subprocess, sys, traceback, warnings
import importlib.util

SP = os.path.dirname(os.path.abspath(__file__))  # pasta ferramentas/
ROOT = r"C:\Users\felip\projetos\economia"
CFG = {"06": ("apostila_06_matematica_financeira.typ", "Matemática Financeira — Teoria Completa com Python"), "07": ("apostila_07_financas.typ", "Finanças — Teoria Completa com Python"), "bo": ("apostila_backoffice_wealth.typ", "Back Office Analítico e Wealth Advisory"), "01": ("apostila_01_fundamentos.typ", "Fundamentos de Python para Economia"), "02": ("apostila_02_pandas.typ", "pandas para Economia"), "03": ("apostila_03_visualizacao.typ", "Visualização de Dados Econômicos"), "04": ("apostila_04_econometria.typ", "Econometria com Python"), "05": ("apostila_05_projetos.typ", "Projetos Práticos de Economia"), "li": ("livro_python_economia.typ", "Python para Economia")}
KEY = sys.argv[1]
NAME, TITLE = CFG[KEY]
TYPST = r"C:\Users\felip\AppData\Local\Microsoft\WinGet\Packages\Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe\typst-x86_64-pc-windows-msvc\typst.exe"
MAX_OUT_LINES = 70

")[0].split("@@")[0]
orig = subprocess.check_output(["git", "-C", ROOT, "show", f"HEAD:{NAME}"]).decode("utf-8").replace("\r\n", "\n")

# ---------------------------------------------------------------- 1) correcoes
spec = importlib.util.spec_from_file_location("fixes06", os.path.join(SP, f"fixes{KEY}.py"))
fx = importlib.util.module_from_spec(spec); spec.loader.exec_module(fx)
text = orig
for k, (old, new) in enumerate(fx.REPL):
    c = text.count(old)
    if c != 1:
        sys.exit(f"[fix {k}] esperado 1 ocorrencia, achei {c}:\n{old[:200]}")
    text = text.replace(old, new)
for fn in getattr(fx, "FUNCS", []):
    text = fn(text)

# --------------------------------------------------------------- 2) fragmentos
lines = text.split("\n")
ins = {}  # indice -> lista de textos (inseridos ANTES da linha de indice)
def find_anchor(a):
    idx = [i for i, l in enumerate(lines) if l.strip() == a.strip()]
    if len(idx) != 1:
        sys.exit(f"ancora com {len(idx)} ocorrencias: {a}")
    return idx[0]

order = 0
appended = []
for fp in sorted(glob.glob(os.path.join(SP, f"frag{KEY}_*.typ"))):
    cur = None; buf = []
    def flush():
        global order
        if cur is None:
            return
        kind, anchor = cur
        if kind == "APPEND":
            order += 1
            appended.append((order, "\n".join(buf).strip("\n")))
            return
        i = find_anchor(anchor)
        if kind == "BEFORE":
            pos = i
        elif kind == "AFTER_HEADING":
            pos = i + 2 if lines[i + 1].startswith("<") and lines[i + 1].endswith(">") else i + 1
        elif kind == "BEFORE_CHAPTER_END":
            pos = i - 2 if i >= 2 and lines[i - 2].strip() == "#line()" else i
        else:
            sys.exit("tipo desconhecido " + kind)
        order += 1
        ins.setdefault(pos, []).append((order, "\n".join(buf).strip("\n")))
    for l in open(fp, encoding="utf-8").read().replace("\r\n", "\n").split("\n"):
        m = re.match(r"^%%% (BEFORE|AFTER_HEADING|BEFORE_CHAPTER_END|APPEND): (.*)$", l)
        if m:
            flush(); cur = (m.group(1), m.group(2)); buf = []
        elif l.startswith("%%% END"):
            flush(); cur = None; buf = []
        else:
            buf.append(l)
    flush()

out = []
for i, l in enumerate(lines):
    for _, t in sorted(ins.get(i, [])):
        out.append(t); out.append("")
    out.append(l)
_pf = os.path.join(SP, f"pre_{KEY}.typ")
pre = open(_pf if os.path.exists(_pf) else os.path.join(SP, "pre.typ"), encoding="utf-8").read().replace("@@TITLE@@", TITLE)
text_apps = "\n\n".join(t for _, t in sorted(appended))
text = pre + "\n".join(out) + ("\n\n#line()\n\n" + text_apps + "\n" if text_apps else "")

# ----------------------------------------- 3) normaliza \$ em blocos de codigo
res = []; infence = False
for l in text.split("\n"):
    if l.startswith("```"):
        infence = not infence
    elif infence:
        l = l.replace("\\$", "$")
    res.append(l)
text = "\n".join(res)

# ------------- 3b) virgula decimal dentro de formulas: "1,02" em vez de 1, 02
_NUM = re.compile(r'("[^"]*")|(\d+(?:\.\d{3})*)(?:\\)?,(\d+)')
def _math(s):
    return _NUM.sub(lambda m: m.group(1) or f'"{m.group(2)},{m.group(3)}"', s)

def fix_math_decimals(t):
    out = []; i = 0; n = len(t); in_math = False; start = 0
    while i < n:
        c = t[i]
        if not in_math and c == "`":
            if t.startswith("```", i):
                j = t.index("```", i + 3) + 3
            else:
                j = t.index("`", i + 1) + 1
            out.append(t[i:j]); i = j; continue
        if c == "\\":
            (out if not in_math else out).append(t[i:i + 2]); i += 2; continue
        if c == "$":
            if in_math:
                seg = "".join(out[mstart:]); del out[mstart:]
                out.append(_math(seg)); out.append("$"); in_math = False
            else:
                out.append("$"); in_math = True; mstart = len(out)
            i += 1; continue
        out.append(c); i += 1
    return "".join(out)

text = fix_math_decimals(text)

# -------------------------------- 4) executa python e regrava blocos de saida
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
plt.show = lambda *a, **k: None
warnings.simplefilter("ignore")
os.chdir(ROOT)
os.makedirs(os.path.join(ROOT, f"figuras{KEY}"), exist_ok=True)

L = text.split("\n")
blocks = []  # (ini, fim, lang) indices da linha ``` de abertura e fechamento
i = 0
while i < len(L):
    m = re.match(r"^```(\w*)\s*$", L[i])
    if m and not (i > 0 and False):
        j = i + 1
        while not L[j].startswith("```"):
            j += 1
        blocks.append((i, j, m.group(1)))
        i = j + 1
    else:
        i += 1

import numpy as np, scipy.stats as stats, math
import pandas as pd
ns = {"__name__": "__main__", "np": np, "stats": stats, "math": math, "pd": pd, "plt": plt}
repl = {}  # indice do bloco de saida existente -> novo conteudo / ou insercao apos bloco
stats = {"ok": 0, "atualizado": 0, "novo": 0, "erro": 0}
edits = []  # (start_line, end_line_exclusive, new_lines)
ex_ranges = []   # capitulos de exercicios para o leitor: nao gerar saidas (revelariam respostas)
_ini = None
for _i, _l in enumerate(L):
    if _l.startswith("== "):
        if _ini is not None:
            ex_ranges.append((_ini, _i)); _ini = None
        if re.match(r"^== Capítulo \d+ --- Exercícios (para Executar|Propostos)", _l):
            _ini = _i
if _ini is not None:
    ex_ranges.append((_ini, len(L)))
def em_exercicios(linha):
    return any(x <= linha < y for x, y in ex_ranges)
ONLY_NEW = KEY in ("02", "03", "04", "05", "li")      # apostilas com blocos dependentes de estado: so os blocos NOVOS recebem saida
_mine = set()
for _fp in glob.glob(os.path.join(SP, f"frag{KEY}_*.typ")):
    _txt = open(_fp, encoding="utf-8").read().replace("\r\n", "\n")
    for _m in re.finditer(r"^```python\n(.*?)\n```", _txt, re.S | re.M):
        _mine.add(_m.group(1))
print("blocos novos (fragmentos):", len(_mine), "| ONLY_NEW =", ONLY_NEW)
for k, (a, b, lang) in enumerate(blocks):
    if lang != "python":
        continue
    code = "\n".join(L[a + 1:b])
    if ONLY_NEW and code not in _mine:
        continue            # blocos originais nao sao executados (evita efeitos colaterais e arquivos soltos)
    buf = io.StringIO(); err = None
    try:
        with contextlib.redirect_stdout(buf):
            exec(compile(code, f"<bloco linha {a+1}>", "exec"), ns)
    except BaseException:
        try:
            err = traceback.format_exc(limit=3)
        except BaseException:
            err = "erro (traceback indisponivel): " + repr(sys.exc_info()[1])[:200]
    if err:
        stats["erro"] += 1
        print(f"ERRO no bloco da linha {a+1} [{code.strip().split(chr(10))[0][:60]}]:\n{err}")
        continue
    real = "\n".join(s.rstrip() for s in buf.getvalue().rstrip().split("\n")) if buf.getvalue().strip() else ""
    if em_exercicios(a):
        continue
    if ONLY_NEW and code not in _mine:
        continue
    nxt = blocks[k + 1] if k + 1 < len(blocks) else None
    _entre = L[b + 1:nxt[0]] if nxt is not None else []
    has_out = nxt is not None and nxt[2] == "" and all(
        x.strip() == "" or re.match(r"^\W*(Sa[ií]da|Resultado)[^\n]{0,40}:\W*$", x.strip(), re.I) for x in _entre)
    if has_out:
        cur = "\n".join(s.rstrip() for s in L[nxt[0] + 1:nxt[1]])
        if real and cur != real:
            edits.append((nxt[0] + 1, nxt[1], real.split("\n"))); stats["atualizado"] += 1
        elif real:
            stats["ok"] += 1
    elif real and len(real.split("\n")) <= MAX_OUT_LINES:
        edits.append((b + 1, b + 1, ["", "```"] + real.split("\n") + ["```"])); stats["novo"] += 1

for s, e, new in sorted(edits, key=lambda x: -x[0]):
    L[s:e] = new
text = "\n".join(L)

open(os.path.join(ROOT, NAME), "w", encoding="utf-8", newline="\n").write(text)
print("blocos:", stats)

# ----------------------------------------------------------------- 5) compila
pdf = os.path.join(ROOT, NAME.replace(".typ", ".pdf"))
r = subprocess.run([TYPST, "compile", os.path.join(ROOT, NAME), pdf], capture_output=True, text=True, encoding="utf-8")
print("typst rc =", r.returncode)
print((r.stderr or "")[:3500])
if r.returncode == 0:
    print("PDF:", os.path.getsize(pdf), "bytes")
