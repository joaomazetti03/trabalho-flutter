import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/CryptoListViewModel.dart';
import '../model/CryptoCurrency.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCryptoDetails(BuildContext context, CryptoCurrency crypto) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nome: ${crypto.nome}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Símbolo: ${crypto.simbolo}'),
              Text('Adicionada em: ${crypto.dataAdicionado.toLocal().toString().split(' ')[0]}'),
              const SizedBox(height: 8),
              Text('Preço USD: \$${crypto.precoUsd.toStringAsFixed(2)}'),
              Text('Preço BRL: R\$${crypto.precoBrl.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text('Fechar'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomoedas'),
      ),
      body: Consumer<CryptoListViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar (ex: BTC,ETH,SOL)',
                    hintText: 'Separe os símbolos por vírgula',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        viewModel.fetchCryptoCurrencies(
                            symbolsSearchQuery: _searchController.text);
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                     viewModel.fetchCryptoCurrencies(
                        symbolsSearchQuery: value);
                  },
                ),
              ),
              if (viewModel.isLoading && viewModel.cryptoList.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (viewModel.errorMessage != null && viewModel.cryptoList.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Erro: ${viewModel.errorMessage}', textAlign: TextAlign.center),
                    )
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => viewModel.fetchCryptoCurrencies(
                        symbolsSearchQuery: _searchController.text.isEmpty ? null : _searchController.text
                    ),
                    child: ListView.builder(
                      itemCount: viewModel.cryptoList.length,
                      itemBuilder: (context, index) {
                        final crypto = viewModel.cryptoList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(crypto.simbolo.isNotEmpty ? crypto.simbolo[0] : '?'),
                          ),
                          title: Text('${crypto.nome} (${crypto.simbolo})'),
                          subtitle: Text(
                              'USD: ${crypto.precoUsd.toStringAsFixed(2)} \nBRL: ${crypto.precoBrl.toStringAsFixed(2)}'
                          ),
                          isThreeLine: true,
                          onTap: () {
                             _showCryptoDetails(context, crypto);
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (viewModel.isLoading && viewModel.cryptoList.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                    ),
            ],
          );
        },
      ),
    );
  }
}