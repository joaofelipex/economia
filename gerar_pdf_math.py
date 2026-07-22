import subprocess
import os
import re
from weasyprint import HTML

CSS = """
@page {
    size: A4;
    margin: 2.5cm 2.5cm 2.5cm 2.5cm;
    @bottom-center {
        content: counter(page);
        font-size: 9pt;
        color: #555;
        font-family: 'DejaVu Serif', serif;
    }
}
body {
    font-family: 'DejaVu Serif', Georgia, serif;
    font-size: 11pt;
    line-height: 1.7;
    color: #1a1a1a;
    counter-reset: h2;
}
h1:first-of-type {
    text-align: center;
    font-size: 24pt;
    margin-top: 3.5cm;
    margin-bottom: 1.5cm;
    page-break-before: avoid;
    border-bottom: none;
}
h1 {
    font-size: 18pt;
    margin-top: 2cm;
    margin-bottom: 0.5cm;
    page-break-before: always;
    border-bottom: 2px solid #1a1a1a;
    padding-bottom: 0.2cm;
}
h2 {
    font-size: 14pt;
    color: #2c3e50;
    margin-top: 1cm;
    margin-bottom: 0.3cm;
    page-break-after: avoid;
    border-bottom: 1px solid #bdc3c7;
    padding-bottom: 0.1cm;
}
h3 {
    font-size: 12pt;
    color: #34495e;
    margin-top: 0.7cm;
    margin-bottom: 0.2cm;
    page-break-after: avoid;
}
p { text-align: justify; margin: 0.3cm 0; }
pre {
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    border-left: 4px solid #c0392b;
    padding: 0.35cm;
    font-family: 'DejaVu Sans Mono', 'Consolas', monospace;
    font-size: 8.5pt;
    line-height: 1.35;
    white-space: pre-wrap;
    word-break: break-word;
    margin: 0.4cm 0;
}
code {
    font-family: 'DejaVu Sans Mono', 'Consolas', monospace;
    font-size: 9pt;
    background-color: #eee;
    padding: 1px 4px;
}
pre code { background: none; padding: 0; font-size: 8.5pt; }
table { border-collapse: collapse; width: 100%; margin: 0.5cm 0; font-size: 10pt; }
th { background-color: #2c3e50; color: white; padding: 6px 10px; text-align: left; }
td { padding: 5px 10px; border-bottom: 1px solid #ddd; }
tr:nth-child(even) { background-color: #f9f9f9; }
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
"""

MATH_CSS = """
math[display="block"] {
    display: block;
    text-align: center;
    margin: 0.5cm 0;
    overflow-x: auto;
    overflow-y: hidden;
    padding: 0.2cm 0;
}
math {
    font-size: 11pt;
}
"""


def md_to_pdf(md_file, pdf_file, css_extra=""):
    md_file = os.path.abspath(md_file)
    pdf_file = os.path.abspath(pdf_file)

    if not os.path.exists(md_file):
        print(f"ERRO: {md_file} nao encontrado")
        return False

    print(f"Convertendo {os.path.basename(md_file)} -> {os.path.basename(pdf_file)}")

    result = subprocess.run(
        ["pandoc", md_file, "--mathml", "--to", "html5", "--from", "markdown"],
        capture_output=True, text=True, encoding="utf-8"
    )
    if result.returncode != 0:
        print(f"ERRO no pandoc: {result.stderr}")
        return False

    html_body = result.stdout

    body_match = re.search(r'<body>(.*?)</body>', html_body, re.DOTALL)
    if body_match:
        html_body = body_match.group(1)

    html_full = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<style>{CSS}</style>
<style>{MATH_CSS}</style>
<style>{css_extra}</style>
</head>
<body>
{html_body}
</body>
</html>"""

    HTML(string=html_full).write_pdf(pdf_file)

    size = os.path.getsize(pdf_file)
    print(f"  -> OK: {os.path.basename(pdf_file)} ({size:,} bytes)")
    return True


if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    arquivos = [
        ("apostila_01_fundamentos.md", "apostila_01_fundamentos.pdf"),
        ("apostila_02_pandas.md", "apostila_02_pandas.pdf"),
        ("apostila_03_visualizacao.md", "apostila_03_visualizacao.pdf"),
        ("apostila_04_econometria.md", "apostila_04_econometria.pdf"),
        ("apostila_05_projetos.md", "apostila_05_projetos.pdf"),
        ("apostila_06_matematica_financeira.md", "apostila_06_matematica_financeira.pdf"),
        ("apostila_07_financas.md", "apostila_07_financas.pdf"),
        ("livro_python_economia.md", "livro_python_economia.pdf"),
    ]

    for md_file, pdf_file in arquivos:
        md_to_pdf(md_file, pdf_file)

    print("\nTodos os PDFs gerados com formulas matematicas (MathML)!")
