import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/CryptoListViewModel.dart';
import 'view/CryptoListScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CryptoListViewModel(),
      child: MaterialApp(
        title: 'Cripto App MVVM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CryptoListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}