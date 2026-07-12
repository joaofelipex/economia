"""
Gera PDF do livro Python para Economia a partir do markdown.
"""
import markdown
from weasyprint import HTML

MD_FILE = "/home/devimts/economia/livro_python_economia.md"
PDF_FILE = "/home/devimts/economia/livro_python_economia.pdf"

with open(MD_FILE, "r", encoding="utf-8") as f:
    md_content = f.read()

# Extensões: codehilite para blocos de código, fenced_code para ```, toc para sumário
html_body = markdown.markdown(
    md_content,
    extensions=[
        "fenced_code",
        "codehilite",
        "tables",
        "toc",
        "sane_lists",
    ],
    extension_configs={
        "codehilite": {
            "css_class": "highlight",
            "guess_lang": False,
        },
    },
)

CSS = """
@page {
    size: A4;
    margin: 2.5cm 2cm 2.5cm 2cm;
    @bottom-center {
        content: counter(page);
        font-family: 'DejaVu Serif', serif;
        font-size: 9pt;
        color: #555;
    }
}

body {
    font-family: 'DejaVu Serif', Georgia, serif;
    font-size: 11pt;
    line-height: 1.6;
    color: #1a1a1a;
    counter-reset: h2;
}

/* Capa */
h1:first-of-type {
    text-align: center;
    font-size: 26pt;
    margin-top: 4cm;
    margin-bottom: 0.3cm;
    color: #1a1a1a;
    page-break-before: avoid;
}

h1:first-of-type + p {
    text-align: center;
    font-size: 11pt;
    color: #666;
    margin-bottom: 2cm;
}

/* Headers */
h1 {
    font-size: 20pt;
    color: #1a1a1a;
    margin-top: 2cm;
    margin-bottom: 0.5cm;
    page-break-before: always;
    border-bottom: 2px solid #1a1a1a;
    padding-bottom: 0.2cm;
}

h2 {
    font-size: 16pt;
    color: #333;
    margin-top: 1.2cm;
    margin-bottom: 0.3cm;
    page-break-after: avoid;
}

h3 {
    font-size: 13pt;
    color: #444;
    margin-top: 0.8cm;
    margin-bottom: 0.2cm;
    page-break-after: avoid;
}

h4 {
    font-size: 11pt;
    color: #555;
    margin-top: 0.5cm;
    margin-bottom: 0.1cm;
}

p {
    text-align: justify;
    margin: 0.3cm 0;
}

/* Code blocks */
pre {
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    border-left: 3px solid #c0392b;
    padding: 0.4cm;
    font-family: 'DejaVu Sans Mono', 'Courier New', monospace;
    font-size: 8.5pt;
    line-height: 1.3;
    overflow-x: auto;
    white-space: pre-wrap;
    word-break: break-word;
    margin: 0.3cm 0;
}

code {
    font-family: 'DejaVu Sans Mono', 'Courier New', monospace;
    font-size: 9pt;
    background-color: #f0f0f0;
    padding: 1px 4px;
    border-radius: 2px;
}

pre code {
    background: none;
    padding: 0;
    border-radius: 0;
}

/* Tables */
table {
    border-collapse: collapse;
    width: 100%;
    margin: 0.5cm 0;
    font-size: 10pt;
}

th {
    background-color: #2c3e50;
    color: white;
    padding: 6px 10px;
    text-align: left;
    font-weight: bold;
}

td {
    padding: 5px 10px;
    border-bottom: 1px solid #ddd;
}

tr:nth-child(even) {
    background-color: #f9f9f9;
}

/* Lists */
ul, ol {
    margin: 0.2cm 0;
    padding-left: 0.8cm;
}

li {
    margin: 0.1cm 0;
}

/* Blockquote */
blockquote {
    border-left: 3px solid #c0392b;
    margin: 0.5cm 0;
    padding: 0.2cm 0.5cm;
    background: #f9f9f9;
    font-style: italic;
    color: #555;
}

/* Horizontal rules */
hr {
    border: none;
    border-top: 1px solid #ddd;
    margin: 0.5cm 0;
}

/* Details/summary (exercises) */
details {
    margin: 0.2cm 0;
    padding: 0.2cm 0.3cm;
    background: #f9f9f9;
    border: 1px solid #ddd;
}

summary {
    cursor: pointer;
    color: #2980b9;
    font-weight: bold;
}

/* TOC */
.toc {
    margin: 1cm 0;
}

.toc ul {
    list-style: none;
    padding-left: 0;
}

.toc ul li {
    margin: 0.15cm 0;
}
"""

html_full = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<style>{CSS}</style>
</head>
<body>
{html_body}
</body>
</html>
"""

print("Convertendo HTML para PDF...")
HTML(string=html_full).write_pdf(PDF_FILE)
print(f"PDF gerado: {PDF_FILE}")
