"""
Gera PDFs com formulas matematicas renderizadas via matplotlib.
Cada formula $$..$$ e convertida em SVG vetorial inline.
"""
import re
import os
import base64
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
from matplotlib.mathtext import math_to_image
import io

import markdown
from weasyprint import HTML

def formula_to_svg(formula, fontsize=12, dpi=200):
    """Renderiza formula LaTeX como SVG inline usando mathtext do matplotlib."""
    formula = formula.strip().replace('\n', ' ').replace('\\', '\\')
    formula = formula.replace('displaystyle', '')
    formula = re.sub(r'\s+', ' ', formula)

    try:
        buf = io.BytesIO()
        math_to_image(f'${formula}$', buf, dpi=dpi, format='svg',
                      fontsize=fontsize)
        svg = buf.getvalue().decode('utf-8')
        buf.close()
        # Extrai apenas o elemento svg
        svg_match = re.search(r'<svg[^>]*>.*?</svg>', svg, re.DOTALL)
        if svg_match:
            svg = svg_match.group(0)
            # Ajusta width/height para nao cortar
            svg = svg.replace('height="2.5pt"', 'height="14pt"')
            return f'<div class="formula-svg">{svg}</div>'
        return f'<span class="formula-fallback">[{formula}]</span>'
    except Exception as e:
        return f'<span class="formula-fallback">[{formula}]</span>'


def formula_to_svg_inline(formula, fontsize=11, dpi=200):
    """Renderiza formula inline como SVG."""
    formula = formula.strip().replace('\n', ' ').replace('\\', '\\')
    formula = re.sub(r'\s+', ' ', formula)
    try:
        buf = io.BytesIO()
        math_to_image(f'${formula}$', buf, dpi=dpi, format='svg',
                      fontsize=fontsize)
        svg = buf.getvalue().decode('utf-8')
        buf.close()
        svg_match = re.search(r'<svg[^>]*>.*?</svg>', svg, re.DOTALL)
        if svg_match:
            svg = svg_match.group(0)
            svg = svg.replace('height="2.5pt"', 'height="12pt"')
            return f'<span class="formula-svg-inline">{svg}</span>'
        return f'<i>[{formula}]</i>'
    except Exception as e:
        return f'<i>[{formula}]</i>'


def process_math_in_markdown(text):
    """Processa markdown: converte $$..$$ e $..$ em SVGs."""
    # Protege blocos de codigo
    code_blocks = []
    def save_code(m):
        code_blocks.append(m.group(0))
        return f"__CODEBLOCK_{len(code_blocks)-1}__"
    text = re.sub(r'```[\s\S]*?```', save_code, text)

    # Protege inline codes
    inline_codes = []
    def save_inline(m):
        inline_codes.append(m.group(0))
        return f"__INLINECODE_{len(inline_codes)-1}__"
    text = re.sub(r'`[^`]+`', save_inline, text)

    # Protege \$
    text = text.replace(r'\$', '__ESCDOL__')

    # Processa $$..$$ (display math)
    def proc_display(m):
        return formula_to_svg(m.group(1), fontsize=13)
    text = re.sub(r'\$\$(.*?)\$\$', proc_display, text, flags=re.DOTALL)

    # Processa $..$ (inline math) - mais cuidadoso
    def proc_inline(m):
        content = m.group(1)
        if len(content) > 0 and content[0].isdigit():
            return f'${content}$'
        if len(content) > 3 and '\\' not in content and not any(c in content for c in '_{}^'):
            return f'${content}$'
        return formula_to_svg_inline(content, fontsize=11)
    text = re.sub(r'\$(.+?)\$', proc_inline, text)

    # Restaura
    text = text.replace('__ESCDOL__', '$')
    for i, cb in enumerate(code_blocks):
        text = text.replace(f"__CODEBLOCK_{i}__", cb)
    for i, cb in enumerate(inline_codes):
        text = text.replace(f"__INLINECODE_{i}__", cb)

    return text


CSS = """
@page {
    size: A4;
    margin: 2.5cm 2.5cm 2.5cm 2.5cm;
    @bottom-center {
        content: counter(page);
        font-size: 9pt;
        color: #555;
    }
}
body {
    font-family: 'Segoe UI', 'DejaVu Sans', Arial, sans-serif;
    font-size: 10.5pt;
    line-height: 1.7;
    color: #1a1a1a;
}
h1 {
    font-family: 'Georgia', 'DejaVu Serif', serif;
    font-size: 18pt;
    color: #1a1a1a;
    margin-top: 2cm;
    margin-bottom: 0.6cm;
    page-break-before: always;
    border-bottom: 2px solid #2c3e50;
    padding-bottom: 0.3cm;
}
h1:first-of-type {
    text-align: center;
    font-size: 26pt;
    margin-top: 3.5cm;
    margin-bottom: 1cm;
    page-break-before: avoid;
    border-bottom: none;
}
h2 {
    font-family: 'Georgia', 'DejaVu Serif', serif;
    font-size: 14pt;
    color: #2c3e50;
    margin-top: 1cm;
    margin-bottom: 0.4cm;
    page-break-after: avoid;
    border-bottom: 1px solid #bdc3c7;
    padding-bottom: 0.15cm;
}
h3 {
    font-size: 12pt;
    color: #34495e;
    margin-top: 0.7cm;
    margin-bottom: 0.3cm;
    page-break-after: avoid;
}
p { text-align: justify; margin: 0.3cm 0; }
pre {
    background-color: #f4f4f4;
    border: 1px solid #d5d5d5;
    border-left: 4px solid #c0392b;
    padding: 0.35cm;
    font-family: 'Consolas', 'DejaVu Sans Mono', monospace;
    font-size: 8pt;
    line-height: 1.35;
    white-space: pre-wrap;
    margin: 0.4cm 0;
}
code {
    font-family: 'Consolas', 'DejaVu Sans Mono', monospace;
    font-size: 9pt;
    background-color: #eee;
    padding: 1px 4px;
}
pre code { background: none; padding: 0; font-size: 8pt; }
table { border-collapse: collapse; width: 100%; margin: 0.5cm 0; font-size: 9.5pt; }
th { background-color: #2c3e50; color: white; padding: 7px 10px; text-align: left; }
td { padding: 5px 10px; border-bottom: 1px solid #ddd; }
tr:nth-child(even) { background-color: #f8f9fa; }
ul, ol { margin: 0.2cm 0; padding-left: 0.8cm; }
blockquote {
    border-left: 4px solid #2980b9;
    margin: 0.5cm 0;
    padding: 0.2cm 0.6cm;
    background: #f0f4f8;
    font-style: italic;
    color: #2c3e50;
}
hr { border: none; border-top: 1px solid #ddd; margin: 0.6cm 0; }
.formula-svg {
    display: block;
    text-align: center;
    margin: 0.5cm 0;
    padding: 0.3cm;
    background: #fafafa;
    border: 1px solid #eee;
    border-radius: 3px;
}
.formula-svg svg { max-width: 100%; height: auto; }
.formula-svg-inline { white-space: nowrap; }
.formula-svg-inline svg { vertical-align: middle; }
.formula-fallback { font-style: italic; color: #666; }
"""


os.chdir(os.path.dirname(os.path.abspath(__file__)))

arquivos = [
    ("apostila_06_matematica_financeira.md", "apostila_06_matematica_financeira.pdf"),
    ("apostila_07_financas.md", "apostila_07_financas.pdf")
]

for md_file, pdf_file in arquivos:
    print(f"Processando {md_file}...")

    with open(md_file, "r", encoding="utf-8") as f:
        md_content = f.read()

    md_content = process_math_in_markdown(md_content)

    html_body = markdown.markdown(
        md_content,
        extensions=["fenced_code", "codehilite", "tables", "sane_lists"],
        extension_configs={"codehilite": {"css_class": "highlight", "guess_lang": False}},
    )

    html_full = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<style>{CSS}</style>
</head>
<body>
{html_body}
</body>
</html>"""

    HTML(string=html_full).write_pdf(pdf_file)
    size = os.path.getsize(pdf_file)
    print(f"  -> {pdf_file} gerado ({size:,} bytes)")

print("Concluido!")
