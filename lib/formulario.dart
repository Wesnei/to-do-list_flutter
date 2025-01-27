import 'package:flutter/material.dart';
import 'listaDeTarefas.dart';

class AdicionarTarefaScreen extends StatefulWidget {
  const AdicionarTarefaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdicionarTarefaScreenState createState() => _AdicionarTarefaScreenState();
}

class _AdicionarTarefaScreenState extends State<AdicionarTarefaScreen> {
  final _nomeController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _tempoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Tarefa"),
        backgroundColor: const Color.fromARGB(255, 6, 204, 49),
      ),
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Tarefa',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o nome da tarefa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imagemUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a URL da imagem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tempoController,
                decoration: const InputDecoration(
                  labelText: 'Tempo em minutos',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white12,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o tempo para a tarefa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final novaTarefa = Tarefa(
                      _nomeController.text,
                      _imagemUrlController.text,
                    );
                    novaTarefa.iniciarTemporizador(int.parse(_tempoController.text));
                    Navigator.pop(context, novaTarefa);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 204, 49), // Altere a cor do botão aqui
                ),
                child: const Text('Adicionar Tarefa', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
