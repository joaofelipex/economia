import markdown
from weasyprint import HTML

CSS = """
@page { size: A4; margin: 2.5cm 2cm; @bottom-center { content: counter(page); font-family: 'DejaVu Serif', serif; font-size: 9pt; color: #555; } }
body { font-family: 'DejaVu Serif', Georgia, serif; font-size: 11pt; line-height: 1.6; color: #1a1a1a; }
h1 { font-size: 20pt; color: #1a1a1a; margin-top: 2cm; margin-bottom: 0.5cm; page-break-before: always; border-bottom: 2px solid #1a1a1a; padding-bottom: 0.2cm; }
h1:first-of-type { text-align: center; font-size: 26pt; margin-top: 4cm; page-break-before: avoid; border-bottom: none; }
h2 { font-size: 16pt; color: #333; margin-top: 1.2cm; page-break-after: avoid; }
h3 { font-size: 13pt; color: #444; margin-top: 0.8cm; page-break-after: avoid; }
p { text-align: justify; margin: 0.3cm 0; }
pre { background-color: #f5f5f5; border: 1px solid #ddd; border-left: 3px solid #c0392b; padding: 0.4cm; font-family: 'DejaVu Sans Mono', 'Courier New', monospace; font-size: 8.5pt; line-height: 1.3; overflow-x: auto; white-space: pre-wrap; word-break: break-word; margin: 0.3cm 0; }
code { font-family: 'DejaVu Sans Mono', 'Courier New', monospace; font-size: 9pt; background-color: #f0f0f0; padding: 1px 4px; border-radius: 2px; }
pre code { background: none; padding: 0; }
table { border-collapse: collapse; width: 100%; margin: 0.5cm 0; font-size: 10pt; }
th { background-color: #2c3e50; color: white; padding: 6px 10px; text-align: left; }
td { padding: 5px 10px; border-bottom: 1px solid #ddd; }
tr:nth-child(even) { background-color: #f9f9f9; }
ul, ol { margin: 0.2cm 0; padding-left: 0.8cm; }
blockquote { border-left: 3px solid #c0392b; margin: 0.5cm 0; padding: 0.2cm 0.5cm; background: #f9f9f9; font-style: italic; color: #555; }
hr { border: none; border-top: 1px solid #ddd; margin: 0.5cm 0; }
"""

arquivos = [
    ("apostila_06_matematica_financeira.md", "apostila_06_matematica_financeira.pdf"),
    ("apostila_07_financas.md", "apostila_07_financas.pdf")
]

for md_file, pdf_file in arquivos:
    print("Convertendo " + md_file + "...")
    with open(md_file, "r", encoding="utf-8") as f:
        md_content = f.read()
    html_body = markdown.markdown(
        md_content,
        extensions=["fenced_code", "codehilite", "tables", "toc", "sane_lists"],
        extension_configs={"codehilite": {"css_class": "highlight", "guess_lang": False}}
    )
    html_full = (
        '<!DOCTYPE html><html lang="pt-BR"><head><meta charset="utf-8">'
        "<style>" + CSS + "</style></head><body>" + html_body + "</body></html>"
    )
    HTML(string=html_full).write_pdf(pdf_file)
    print("  -> " + pdf_file + " gerado")

print("Concluido!")
