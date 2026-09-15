import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator consum combustibil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ConsumPage(),
    );
  }
}

class ConsumPage extends StatefulWidget {
  const ConsumPage({super.key});

  @override
  State<ConsumPage> createState() => _ConsumPageState();
}

class _ConsumPageState extends State<ConsumPage> {
  final TextEditingController _distantaController = TextEditingController();
  final TextEditingController _combustibilController = TextEditingController();

  String _rezultat = '';

  void _calculeazaConsum() {
    final double? distanta = double.tryParse(_distantaController.text);
    final double? combustibil = double.tryParse(_combustibilController.text);

    if (distanta == null || combustibil == null || distanta <= 0) {
      setState(() {
        _rezultat = 'Introduceti valori valide.';
      });
      return;
    }

    final double consumMediu = (combustibil / distanta) * 100;

    setState(() {
      _rezultat = 'Consum mediu: ${consumMediu.toStringAsFixed(2)} litri/100km';
    });
  }

  @override
  void dispose() {
    _distantaController.dispose();
    _combustibilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator consum combustibil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _distantaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Distanta parcursa (km)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _combustibilController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Combustibil consumat (litri)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculeazaConsum,
              child: const Text('Calculeaza'),
            ),
            const SizedBox(height: 24),
            Text(
              _rezultat,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
