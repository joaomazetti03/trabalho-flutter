import '../datasource/CoinMarketCapDataSource.dart';
import '../model/CryptoCurrency.dart';

class CryptoRepository {
  final CoinMarketCapDataSource _dataSource;

  CryptoRepository(this._dataSource);

  Future<List<CryptoCurrency>> getCryptoCurrencies(List<String> symbols) async {
    try {
      final rawData = await _dataSource.getCryptoListings(symbols);
      final List<CryptoCurrency> cryptoList = [];

      if (rawData.containsKey('data')) {
        final Map<String, dynamic> dataMap = rawData['data'];
        double? brlRate;

        // Tenta obter a cotação em BRL se a API do CoinMarketCap permitir
        // Ou busca a taxa de conversão separadamente
        // Verifique a estrutura da resposta da API CoinMarketCap.
        // Se ela já fornecer 'BRL' dentro de 'quote', use-o diretamente.
        // Exemplo: currencyData['quote']['BRL']['price']

        // Se a API não fornecer BRL diretamente, buscamos a taxa de conversão.
        // É mais eficiente buscar uma vez só do que para cada moeda.
        // Porém, se a API do CoinMarketCap já tiver o parâmetro `convert=BRL`,
        // a lógica de conversão abaixo pode não ser necessária ou ser diferente.
        // Vamos assumir que precisamos converter USD para BRL.
        try {
          brlRate = await _dataSource.getUsdToBrlRate();
        } catch (e) {
          print("Aviso: Não foi possível buscar a taxa BRL. O preço em BRL não será calculado. Erro: $e");
        }


        for (String symbol in symbols) {
          if (dataMap.containsKey(symbol)) {
            CryptoCurrency crypto = CryptoCurrency.fromJson(rawData, symbol);

            if (brlRate != null) {
              crypto.priceBrl = crypto.precoUsd * brlRate;
            }
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