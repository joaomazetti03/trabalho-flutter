class CryptoCurrency {
  final String id;
  final String nome;
  final String simbolo;
  final double precoUsd;
  final DateTime dataAdicionado;
  double? priceBrl; 

  CryptoCurrency({
    required this.id,
    required this.nome,
    required this.simbolo,
    required this.precoUsd,
    required this.dataAdicionado,
    this.priceBrl,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> fullJsonResponse, String symbolKey) {
    final Map<String, dynamic>? dataMap = fullJsonResponse['data'] as Map<String, dynamic>?;
    if (dataMap == null) {
      throw Exception("A resposta da API não contém a chave 'data'.");
    }

    final dynamic currencyRawData = dataMap[symbolKey];
    if (currencyRawData == null) {
      throw Exception('Dados não encontrados para o símbolo: $symbolKey na resposta da API.');
    }

    final Map<String, dynamic> currencyData = currencyRawData as Map<String, dynamic>;

    final Map<String, dynamic>? quoteData = currencyData['quote'] as Map<String, dynamic>?;
    if (quoteData == null) {
      throw Exception('Dados de cotação não encontrados para o símbolo: $symbolKey.');
    }

    final Map<String, dynamic>? usdData = quoteData['BRL'] as Map<String, dynamic>?;
    if (usdData == null) {
      throw Exception('Dados de cotação USD não encontrados para o símbolo: $symbolKey.');
    }

    return CryptoCurrency(
      id: currencyData['id'].toString(),
      nome: currencyData['name'],
      simbolo: currencyData['symbol'],
      precoUsd: (currencyData['quote']['BRL']['price'] as num).toDouble(),
      dataAdicionado: DateTime.parse(currencyData['date_added']),
    );
  }

  @override
  String toString() {
    return 'CryptoCurrency{id: $id, name: $nome, symbol: $simbolo, priceUsd: $precoUsd, dateAdded: $dataAdicionado, priceBrl: $priceBrl}';
  }
}