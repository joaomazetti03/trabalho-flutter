import '../datasource/CoinMarketCapDataSource.dart';
import '../model/CryptoCurrency.dart';

class CryptoRepository {
  final CoinMarketCapDataSource _dataSource;

  CryptoRepository(this._dataSource);

  Future<List<CryptoCurrency>> getCryptoCurrencies(List<String> symbols) async {
    try {
      final rawData = await _dataSource.getCryptoListingsInBRL(symbols);

      double usdToBrlRate = 5.0;
      try {
        usdToBrlRate = await _dataSource.getUsdToBrlRate();
      } catch (e) {
        print("Aviso: Não foi possível buscar a taxa USD->BRL. Usando taxa de fallback $usdToBrlRate. Erro: $e");
      }

      if (usdToBrlRate == 0) {
          print("Aviso: Taxa USD->BRL é zero. Não é possível calcular a taxa BRL->USD. Preços em USD podem ser zerados.");
      }
      final double brlToUsdRate = (usdToBrlRate == 0) ? 0 : 1 / usdToBrlRate;

      final List<CryptoCurrency> cryptoList = [];

      if (rawData.containsKey('data')) {
        final Map<String, dynamic> dataMap = rawData['data'];

        for (String symbol in symbols) {
          if (dataMap.containsKey(symbol)) {
            CryptoCurrency crypto = CryptoCurrency.fromJson(rawData, symbol, brlToUsdRate);
            cryptoList.add(crypto);
          } else {
            print("Aviso: Dados para o símbolo $symbol não encontrados na resposta da API.");
          }
        }
      } else {
        throw Exception("Formato de dados inesperado da API: chave 'data' não encontrada.");
      }
      return cryptoList;
    } catch (e) {
      print('Erro no CryptoRepository: $e');
      rethrow;
    }
  }
}