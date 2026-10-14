# Ferramentas de montagem das apostilas

`python build.py <chave>` (chaves: 06 07 bo 01 02 03 04 05 li) reconstrói a apostila a partir do
`HEAD` do git, aplica `fixes<chave>.py`, insere os fragmentos `frag<chave>_*.typ`, executa os blocos Python,
regrava as saídas e compila o PDF com Typst. Os caminhos de Typst e do repositório no topo do script são da máquina original.

Atenção: os arquivos já commitados contêm o enriquecimento; o script recusa rodar sobre eles (evita duplicar conteúdo).
Para regerar, parta de um commit anterior ao enriquecimento ou edite os `.typ` diretamente.
