import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinMarketCapDataSource {
  final String _apiKey = 'bff43c75-5344-47ef-902e-0e6511c19181';
  final String _baseUrl = 'pro-api.coinmarketcap.com';
  final String _quotesEndpoint = '/v1/cryptocurrency/quotes/latest';

  Future<Map<String, dynamic>> getCryptoListingsInBRL(List<String> symbols) async {

    final queryParameters = {
      'symbol': symbols.join(','),
      'convert': 'BRL',
    };

    final uri = Uri.https(_baseUrl, _quotesEndpoint, queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accepts': 'application/json',
          'X-CMC_PRO_API_KEY': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Erro da API CoinMarketCap: ${response.statusCode} - ${errorBody['status']?['error_message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Falha ao carregar dados das criptomoedas: $e');
    }
  }

  Future<double> getUsdToBrlRate() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates']['BRL'];
        if (rate != null) {
          return (rate as num).toDouble();
        } else {
          throw Exception('Taxa BRL não encontrada na resposta da API de câmbio.');
        }
      } else {
        throw Exception(
            'Falha ao buscar taxa de câmbio USD->BRL: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar taxa de câmbio USD->BRL: $e. Usando taxa padrão 5.0.');
      return 5.0;
    }
  }
}