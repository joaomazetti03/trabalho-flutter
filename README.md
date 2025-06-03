# Aplicativo Flutter - Cotação de Criptomoedas (CoinMarketCap API)

## Descrição do Projeto

Acadêmico: João Lucas Pereira Françoso Mazetti

RA: 23268463-2

Este é um aplicativo desenvolvido em Flutter que consome a API da CoinMarketCap para listar cotações de criptomoedas. O projeto foi desenvolvido como atividade prática para a disciplina de Programação para Dispositivos Móveis, do curso de Análise e Desenvolvimento de Sistemas.

O aplicativo permite ao usuário visualizar uma lista de criptomoedas, pesquisar por moedas específicas e ver detalhes como nome, sigla e cotações em USD e BRL.

## Arquitetura

O projeto segue o padrão arquitetural **MVVM (Model-View-ViewModel)**, conforme as boas práticas discutidas em aula. A estrutura de pastas é organizada da seguinte forma:

* **`data/`**:
    * `models/`: Contém as entidades (models) que mapeiam o retorno da API[cite: 20].
    * `datasources/`: Responsável pela comunicação direta com a API CoinMarketCap[cite: 12].
    * `repositories/`: Faz a ponte entre o ViewModel e o DataSource, retornando uma lista de entidades para o ViewModel[cite: 11, 21].
* **`view/`**:
    * `screens/`: Contém as telas de exibição e interação do usuário[cite: 10].
* **`viewmodel/`**:
    * Contém os ViewModels, que gerenciam o estado da UI e a lógica de apresentação.
* **`utils/`**: (Opcional) Para classes utilitárias, como formatação de moeda.

## Funcionalidades Implementadas

* **Listagem de Criptomoedas**: Exibe uma lista de criptomoedas com:
    * Sigla (Símbolo).
    * Nome da moeda.
    * Cotação atual em USD e BRL (BRL é obtido da API CoinMarketCap ou calculado a partir do USD com taxa de câmbio).
* **Atualização de Dados**:
    * Botão para requisitar/atualizar os dados.
    * Funcionalidade "Puxar para atualizar" (Pull-to-refresh) na lista.
* **Pesquisa**:
    * Campo de pesquisa para buscar múltiplas criptomoedas, separadas por vírgula.
* **Valores Padrão**:
    * Se nenhum símbolo for informado na pesquisa, uma lista de moedas padrão é utilizada:
        `BTC, ETH, SOL, BNB, BCH, MKR, AAVE, DOT, SUI, ADA, XRP, TIA, NEO, NEAR, PENDLE, RENDER, LINK, TON, XAI, SEI, IMX, ETHFI, UMA, SUPER, FET, USUAL, GALA, PAAL, AERO`.
* **Feedback Visual**:
    * Exibe um indicador de progresso (`Progressing Indicator`) enquanto as informações são buscadas na API.
* **Detalhes da Criptomoeda**:
    * Ao clicar em uma criptomoeda na lista, exibe um BottomSheet com detalhes adicionais:
        * Nome (Name)
        * Símbolo (Symbol)
        * Data de Adição (Data Added)
        * Preço atual em USD e BRL formatado.
* **Conectividade**:
    * Assume-se que o usuário deve estar conectado à internet para o funcionamento correto.

## Pré-requisitos

* Flutter SDK instalado (versão utilizada no desenvolvimento ou mais recente compatível).
* Um editor de código (VS Code, Android Studio, IntelliJ).
* Uma chave de API (API Key) da [CoinMarketCap Pro](https://pro.coinmarketcap.com/signup). O plano gratuito ("Basic" ou "Hobbyist") é suficiente.

## Configuração e Instalação

1.  **Clone o Repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO_GITHUB>
    cd <NOME_DA_PASTA_DO_PROJETO>
    ```

2.  **Obtenha as Dependências:**
    Execute o comando abaixo na raiz do projeto para instalar todas as dependências listadas no `pubspec.yaml`:
    ```bash
    flutter pub get
    ```

3.  **Insira sua API Key da CoinMarketCap:**
    * Abra o arquivo `lib/data/datasources/CoinMarketCapDataSource.dart`.
    * Localize a variável `_apiKey`.
    * Substitua o valor placeholder pela sua chave de API real:
        ```dart
        // Exemplo dentro de CoinMarketCapDataSource.dart
        final String _apiKey = 'SUA_CHAVE_DE_API_AQUI';
        ```
    * **Endpoint Utilizado**: O aplicativo utiliza o endpoint `v1/cryptocurrency/quotes/latest` da API CoinMarketCap para buscar as cotações por símbolo.

## Executando o Aplicativo

1.  **Dispositivo/Emulador:**
    Certifique-se de que um emulador esteja rodando ou um dispositivo físico esteja conectado e reconhecido pelo Flutter (`flutter devices`).

2.  **Execute o Aplicativo:**
    Na raiz do projeto, execute:
    ```bash
    flutter run
    ```

3.  **Executando no Navegador (Flutter Web) - Atenção ao CORS:**
    Se você estiver executando o aplicativo no Chrome (Flutter Web) e encontrar erros como `ClientException: Failed to fetch`, isso geralmente é devido a restrições de CORS. Para contornar isso **apenas durante o desenvolvimento local**, você pode usar a seguinte flag:
    ```bash
    flutter run -d chrome --web-browser-flag "--disable-web-security"
    ```
    **Aviso:** Use esta flag com cautela e apenas para desenvolvimento. Não navegue em outros sites com a segurança web desabilitada.

## Considerações

* **Formatação de Moeda**: Para uma melhor experiência do usuário, os valores em USD e BRL devem ser formatados adequadamente (ex: R$ 1.234,56). Uma classe utilitária para formatação de moeda pode ser implementada em `lib/utils/`.
* **Tratamento de Erros**: O aplicativo possui tratamento básico de erros, mas pode ser expandido para oferecer feedback mais detalhado ao usuário em diferentes cenários de falha.

---
*Professor: Christiano Santos F. Santana*
*Curso: Análise e Desenvolvimento de Sistemas, 5º Semestre*
