"""
Corrige o bug de renderizacao Pandoc->Typst: palavras/siglas multi-letra
dentro de formulas LaTeX ($...$ e $$...$$) sao explodidas letra por letra
(ex: "WACC" -> "W A C C") porque o LaTeX nao distingue "palavra" de
"sequencia de variaveis" em modo matematico. A correcao e envolver cada
palavra/sigla (2+ letras) com \\text{...}, que o pandoc converte para uma
string atomica no Typst (upright("...")), preservando a palavra inteira.

Uso: python corrigir_formulas.py arquivo1.md [arquivo2.md ...]
Sem argumentos: roda nas 7 apostilas + livro_python_economia.md.
"""
import re
import sys

LETTERS = "A-Za-zÁÀÂÃÉÊÍÓÔÕÚÇáàâãéêíóôõúçÜü"
WORD_RE = re.compile(rf"[{LETTERS}]{{2,}}")
CMD_RE = re.compile(rf"\\[{LETTERS}]+")
TEXT_RE = re.compile(r"\\text\{[^{}]*\}")
MATHRM_RE = re.compile(r"\\mathrm\{([^{}]*)\}")


def protect(text, pattern, store, lo="\x00", hi="\x01"):
    def _sub(m):
        store.append(m.group(0))
        return f"{lo}{len(store) - 1}{hi}"
    return pattern.sub(_sub, text)


def restore(text, store, lo="\x00", hi="\x01"):
    def _sub(m):
        return store[int(m.group(1))]
    return re.sub(rf"{lo}(\d+){hi}", _sub, text)


def fix_math(content):
    store = []
    # Usa delimitadores distintos dos usados em protect_non_math para nao
    # colidir com marcadores ja presentes no texto (ex: \$ protegido antes).
    lo, hi = "\x04", "\x05"
    # 1. \text{...} ja esta correto -> protege como esta
    content = protect(content, TEXT_RE, store, lo, hi)
    # 2. \mathrm{...} NAO corrige o bug (pandoc ainda explode letras dentro
    #    de upright(...)) -> promove para \text{...} e protege
    content = MATHRM_RE.sub(lambda m: f"\\text{{{m.group(1)}}}", content)
    content = protect(content, TEXT_RE, store, lo, hi)
    # 3. Protege comandos LaTeX genericos (\times, \beta, \frac, \infty...)
    content = protect(content, CMD_RE, store, lo, hi)
    # 4. Envolve palavras/siglas soltas (2+ letras) com \text{}
    content = WORD_RE.sub(lambda m: f"\\text{{{m.group(0)}}}", content)
    # 5. Restaura protegidos
    content = restore(content, store, lo, hi)
    return content


CURRENCY_RE = re.compile(r"(?<!\\)\b(R|US)\$")


def protect_non_math(text):
    store = []
    text = protect(text, re.compile(r"```.*?```", re.DOTALL), store)
    text = protect(text, re.compile(r"`[^`]+`"), store)
    # "R$"/"US$" soltos (prosa) sem \ na frente viram delimitador acidental
    # de math quando ha outro "$" mais adiante na mesma linha/paragrafo
    # (ex: "Converta US$ 1.000 em reais (cambio = R$ 5,45)"). Escapa antes
    # de procurar spans de formula.
    text = CURRENCY_RE.sub(lambda m: f"{m.group(1)}\\$", text)
    text = protect(text, re.compile(r"\\\$"), store)
    return text, store


def process(text):
    text, store = protect_non_math(text)

    def _display(m):
        return "$$" + fix_math(m.group(1)) + "$$"

    def _inline(m):
        return "$" + fix_math(m.group(1)) + "$"

    text = re.sub(r"\$\$(.*?)\$\$", _display, text, flags=re.DOTALL)
    text = re.sub(r"\$(.+?)\$", _inline, text)
    text = restore(text, store)
    return text


if __name__ == "__main__":
    files = sys.argv[1:] or [
        "apostila_01_fundamentos.md",
        "apostila_02_pandas.md",
        "apostila_03_visualizacao.md",
        "apostila_04_econometria.md",
        "apostila_05_projetos.md",
        "apostila_06_matematica_financeira.md",
        "apostila_07_financas.md",
        "livro_python_economia.md",
    ]
    for fname in files:
        with open(fname, encoding="utf-8", newline="") as f:
            original = f.read()
        fixed = process(original)
        if fixed != original:
            with open(fname, "w", encoding="utf-8", newline="") as f:
                f.write(fixed)
            print(f"{fname}: corrigido")
        else:
            print(f"{fname}: sem mudancas")
