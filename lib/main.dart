import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaContador(),
    );
  }
}

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  int contador = 0;
  int capacidade = 10;
  String mensagem = '';
  final TextEditingController controlador = TextEditingController();

  // Regra de negócio: não passa da capacidade máxima
  void incrementar() {
    if (contador < capacidade) {
      setState(() {
        contador++;
        mensagem = '';
      });
    } else {
      setState(() {
        mensagem = 'Capacidade máxima atingida!';
      });
    }
  }

  // Regra de negócio: não permite valor negativo
  void decrementar() {
    if (contador > 0) {
      setState(() {
        contador--;
        mensagem = '';
      });
    } else {
      setState(() {
        mensagem = 'O ambiente já está vazio!';
      });
    }
  }

  // Lê o valor digitado pelo usuário e define a capacidade
  void definirCapacidade() {
    int? valor = int.tryParse(controlador.text);

    if (valor == null || valor <= 0) {
      setState(() {
        mensagem = 'Digite um número válido!';
      });
    } else if (valor < contador) {
      setState(() {
        mensagem = 'Capacidade menor que o número de pessoas!';
      });
    } else {
      setState(() {
        capacidade = valor;
        mensagem = '';
      });
      controlador.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Pessoas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$contador',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            Text('Capacidade máxima: $capacidade',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              contador >= capacidade ? 'LOTADO' : 'Disponível',
              style: TextStyle(
                fontSize: 20,
                color: contador >= capacidade ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(mensagem, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: decrementar,
                  child: const Text('Saída (-)'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: incrementar,
                  child: const Text('Entrada (+)'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: controlador,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nova capacidade máxima',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: definirCapacidade,
              child: const Text('Definir capacidade'),
            ),
          ],
        ),
      ),
    );
  }
}
