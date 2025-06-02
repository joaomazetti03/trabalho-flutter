class CryptoCurrency {
  final String id;
  final String nome;
  final String simbolo;
  final double precoUsd;
  final DateTime dataAdicionado;
  // Adicionaremos priceBrl posteriormente, após a conversão.
  double? priceBrl; // Nullable, pois calcularemos depois

  CryptoCurrency({
    required this.id,
    required this.nome,
    required this.simbolo,
    required this.precoUsd,
    required this.dataAdicionado,
    this.priceBrl,
  });

  // Fábrica para criar uma instância a partir de um JSON
  // A estrutura exata do JSON dependerá da resposta da API CoinMarketCap.
  // Você precisará ajustar isso com base na documentação da API e no retorno real.
  factory CryptoCurrency.fromJson(Map<String, dynamic> json, String symbolKey) {
    // A API da CoinMarketCap pode retornar os dados de várias moedas em um map
    // onde a chave é o símbolo da moeda.
    // Exemplo de estrutura esperada (pode variar):
    // {
    //   "data": {
    //     "BTC": {
    //       "id": 1,
    //       "name": "Bitcoin",
    //       "symbol": "BTC",
    //       "date_added": "2013-04-28T00:00:00.000Z",
    //       "quote": {
    //         "USD": {
    //           "price": 60000.00,
    //           // ... outros dados de quote
    //         }
    //       }
    //     },
    //     "ETH": { ... }
    //   },
    //   "status": { ... }
    // }
    final currencyData = json['data'][symbolKey];
    if (currencyData == null) {
      throw Exception('Dados não encontrados para o símbolo: $symbolKey');
    }

    return CryptoCurrency(
      id: currencyData['id'].toString(),
      nome: currencyData['name'],
      simbolo: currencyData['symbol'],
      precoUsd: (currencyData['quote']['USD']['price'] as num).toDouble(),
      dataAdicionado: DateTime.parse(currencyData['date_added']),
    );
  }

  @override
  String toString() {
    return 'CryptoCurrency{id: $id, name: $nome, symbol: $simbolo, priceUsd: $precoUsd, dateAdded: $dataAdicionado, priceBrl: $priceBrl}';
  }
}