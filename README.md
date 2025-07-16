## Projeto: Coleta das 100 Músicas Mais Ouvidas

Este projeto realiza a coleta diária dos dados das 100 músicas mais ouvidas, utilizando automação com Robot Framework. Os dados coletados incluem informações como título da música, artista, posição no ranking e número de reproduções.

Após a coleta, os dados são exportados automaticamente para arquivos nos formatos **CSV** e **Excel**, facilitando o armazenamento e análise posterior.

### Funcionalidades

- Extração automática dos dados das músicas mais populares.
- Geração de relatórios em CSV e Excel.
- Processo totalmente automatizado e agendável.

### Tecnologias Utilizadas

- Robot Framework
- RPAFramework
- Python

### Exemplos de Uso

Os arquivos gerados podem ser utilizados para análise de tendências, relatórios de desempenho ou integração com outros sistemas de BI.


## Instalação do Robot Framework

1. **Pré-requisitos:**  
    - [Python](https://www.python.org/downloads/) instalado (versão 3.6 ou superior).

2. **Instalação via pip:**
    ```bash
    pip install robotframework
    ```

3. **Verifique a instalação:**
    ```bash
    robot --version
    ```

4. **Instalação do RPAFramework**
    ```bash
    pip install rpaframework
    ```


### Estrutura

- `rpa_genius/` — Scripts de automação e arquivos principais do projeto.
- `rpa_genius/data/` — Diretório contendo os arquivos no formato csv.
- `rpa_genius/excel/` — Diretório contendo os arquivos no formato excel (xlsx).
- `rpa_genius/genius.robot` — Arquivo principal de execução.
- `README.md` — Documentação do projeto.

## Como Executar

Execute o script com o comando:
```bash
robot rpa_genius/genius.robot
```

## Contribuição

Sinta-se à vontade para abrir issues ou enviar pull requests com melhorias e correções.
