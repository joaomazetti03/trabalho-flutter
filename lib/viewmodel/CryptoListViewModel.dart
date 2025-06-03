import 'package:flutter/foundation.dart';
import '../data/model/CryptoCurrency.dart';
import '../data/repository/CryptoRepository.dart';
import '../data/datasource/CoinMarketCapDataSource.dart';

class CryptoListViewModel extends ChangeNotifier {
  final CryptoRepository _repository = CryptoRepository(CoinMarketCapDataSource());

  final List<String> _defaultSymbols = [
    "BTC", "ETH", "SOL", "BNB", "BCH", "MKR", "AAVE", "DOT", "SUI", "ADA",
    "XRP", "TIA", "NEO", "NEAR", "PENDLE", "RENDER", "LINK", "TON", "XAI",
    "SEI", "IMX", "ETHFI", "UMA", "SUPER", "FET", "USUAL", "GALA", "PAAL", "AERO"
  ];

  List<CryptoCurrency> _cryptoList = [];
  List<CryptoCurrency> get cryptoList => _cryptoList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CryptoListViewModel() {
    fetchCryptoCurrencies();
  }

  Future<void> fetchCryptoCurrencies({String? symbolsSearchQuery}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    List<String> symbolsToFetch;

    if (symbolsSearchQuery != null && symbolsSearchQuery.trim().isNotEmpty) {
      symbolsToFetch = symbolsSearchQuery.split(',').map((s) => s.trim().toUpperCase()).toList();
      symbolsToFetch.removeWhere((s) => s.isEmpty); // Remove entradas vazias se houver
    } else {
      symbolsToFetch = _defaultSymbols;
    }

    if (symbolsToFetch.isEmpty && (symbolsSearchQuery != null && symbolsSearchQuery.trim().isNotEmpty)) {
       _cryptoList = [];
      _isLoading = false;
      _errorMessage = "Nenhum símbolo válido fornecido para pesquisa.";
      notifyListeners();
      return;
    } else if (symbolsToFetch.isEmpty) {
      _cryptoList = [];
      _isLoading = false;
      _errorMessage = "Nenhuma moeda para pesquisar.";
      notifyListeners();
      return;
    }


    try {
      _cryptoList = await _repository.getCryptoCurrencies(symbolsToFetch);
    } catch (e) {
      _errorMessage = e.toString();
      _cryptoList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}