class CryptoCurrency {
  final String id;
  final String nome;
  final String simbolo;
  double precoUsd;
  final double precoBrl;
  final DateTime dataAdicionado;

  CryptoCurrency({
    required this.id,
    required this.nome,
    required this.simbolo,
    required this.precoUsd,
    required this.precoBrl,
    required this.dataAdicionado,
  });

factory CryptoCurrency.fromJson(
      Map<String, dynamic> fullJsonResponse, String symbolKey, double brlToUsdRate) {
    final Map<String, dynamic>? dataMap =
        fullJsonResponse['data'] as Map<String, dynamic>?;

    if (dataMap == null) {
      throw Exception("A resposta da API não contém a chave 'data'.");
    }

    final dynamic currencyRawData = dataMap[symbolKey];
    if (currencyRawData == null) {
      throw Exception(
          'Dados não encontrados para o símbolo: $symbolKey na resposta da API.');
    }
    final Map<String, dynamic> currencyData =
        currencyRawData as Map<String, dynamic>;

    final Map<String, dynamic>? quoteData =
        currencyData['quote'] as Map<String, dynamic>?;
    if (quoteData == null) {
      throw Exception(
          'Dados de cotação não encontrados para o símbolo: $symbolKey.');
    }

    final Map<String, dynamic>? brlData =
        quoteData['BRL'] as Map<String, dynamic>?;
    if (brlData == null || !brlData.containsKey('price')) {
      throw Exception(
          'Dados de cotação BRL não encontrados ou preço BRL ausente para o símbolo: $symbolKey.');
    }    
    
    final double precoBrlFromApi = (brlData['price'] as num).toDouble();

    final double calculatedPriceUsd = precoBrlFromApi * brlToUsdRate;

    return CryptoCurrency(
      id: currencyData['id'].toString(),
      nome: currencyData['name'],
      simbolo: currencyData['symbol'],
      precoUsd: calculatedPriceUsd,
      precoBrl: precoBrlFromApi,
      dataAdicionado: DateTime.parse(currencyData['date_added']),
    );
  }

  @override
  String toString() {
    return 'CryptoCurrency{id: $id, name: $nome, symbol: $simbolo, priceUsd: $precoUsd, priceBrl: $precoBrl, dateAdded: $dataAdicionado}';
  }
}