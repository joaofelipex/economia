import subprocess, os, sys

TYPST = r"C:\Users\Infraestrutura-IMTS\AppData\Local\Microsoft\WinGet\Links\typst.exe"


def gerar_pdf(md, pdf):
    md, pdf = os.path.abspath(md), os.path.abspath(pdf)
    print(f"{os.path.basename(md)}")

    r = subprocess.run(
        ['pandoc', md, '-o', pdf.replace('.pdf', '.typ'), '--to', 'typst'],
        capture_output=True, text=True, encoding='utf-8'
    )
    if r.returncode != 0:
        print(f"  ERRO pandoc: {r.stderr[:200]}"); return

    typ_file = pdf.replace('.pdf', '.typ')
    with open(typ_file, encoding='utf-8') as f:
        c = f.read()
    c = c.replace('#horizontalrule', '#line()')
    with open(typ_file, 'w', encoding='utf-8') as f:
        f.write(c)

    r = subprocess.run([TYPST, 'compile', typ_file, pdf],
                       capture_output=True, timeout=120)
    if r.returncode != 0:
        e = r.stderr.decode('utf-8', errors='replace')[:400]
        safe = ''.join(ch if 32 <= ord(ch) < 127 else '?' for ch in e)
        print(f"  ERRO: {safe}")
        return

    print(f"  -> {os.path.getsize(pdf):,} bytes")


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    pares = []
    if len(sys.argv) > 1:
        pares = [(sys.argv[1], sys.argv[1].replace('.md', '.pdf'))]
    else:
        for i, n in enumerate(
            ["fundamentos", "pandas", "visualizacao", "econometria",
             "projetos", "matematica_financeira", "financas"], 1
        ):
            pares.append((f"apostila_0{i}_{n}.md", f"apostila_0{i}_{n}.pdf"))

    for md, pdf in pares:
        if os.path.exists(md):
            gerar_pdf(md, pdf)
