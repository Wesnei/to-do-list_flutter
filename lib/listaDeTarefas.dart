// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'formulario.dart';

class Tarefa {
  final String nome;
  final String imagemUrl;
  final DateTime dataCriacao;
  bool feita;
  int tempoRestante;
  Timer? _timer;

  Tarefa(this.nome, this.imagemUrl)
      : dataCriacao = DateTime.now(),
        feita = false,
        tempoRestante = 0;

  String get dataCriacaoFormatada =>
      "${dataCriacao.day}/${dataCriacao.month}/${dataCriacao.year}";

  String get tempoRestanteFormatado {
    final minutes = (tempoRestante / 60).floor();
    final seconds = tempoRestante % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  void iniciarTemporizador(int minutos) {
    tempoRestante = minutos * 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (tempoRestante > 0) {
        tempoRestante--;
      } else {
        _timer?.cancel();
        feita = true;
      }
    });
  }

  void cancelarTemporizador() {
    _timer?.cancel();
  }
}

class TarefasListScreen extends StatefulWidget {
  const TarefasListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TarefasListScreenState createState() => _TarefasListScreenState();
}

class _TarefasListScreenState extends State<TarefasListScreen> {
  List<Tarefa> tarefas = [
    Tarefa('Sair para buscar conhecimentos', 'https://picsum.photos/200?1'),
    Tarefa('Tomar uma com os mestres', 'https://picsum.photos/200?2'),
    Tarefa('Jogar com o Messi', 'https://picsum.photos/200?3'),
  ];

  void _adicionarTarefa(Tarefa novaTarefa) {
    setState(() {
      tarefas.add(novaTarefa);
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  void _marcarComoFeita(int index) {
    setState(() {
      tarefas[index].feita = !tarefas[index].feita;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        centerTitle: true,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 6, 204, 49),
      ),
      backgroundColor: Colors.grey[850],
      body: ReorderableListView(
        children: tarefas
            .asMap()
            .map((index, tarefa) {
          return MapEntry(
            index,
            TarefasWidget(
              key: ValueKey(tarefa.hashCode),
              tarefa: tarefa,
              onRemove: () => _removerTarefa(index),
              onMarkAsDone: () => _marcarComoFeita(index),
            ),
          );
        })
            .values
            .toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final Tarefa tarefa = tarefas.removeAt(oldIndex);
            tarefas.insert(newIndex, tarefa);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaTarefa = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdicionarTarefaScreen(),
            ),
          );
          if (novaTarefa != null) {
            _adicionarTarefa(novaTarefa);
          }
        },
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 6, 204, 49),
      ),
    );
  }
}

class TarefasWidget extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onRemove;
  final VoidCallback onMarkAsDone;

  const TarefasWidget({
    required this.tarefa,
    required this.onRemove,
    required this.onMarkAsDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tarefa.feita ? Colors.green[200] : Colors.white12,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color:  const Color.fromARGB(255, 6, 204, 49),
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white10,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    tarefa.imagemUrl,
                    width: 90,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tarefa.nome,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: tarefa.feita ? Colors.black54 : Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onMarkAsDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // cor transparente
                    shadowColor: Colors.transparent, // sem sombra
                  ),
                  child: tarefa.feita
                      ? const Icon(Icons.check, color: Colors.white)
                      : const Icon(Icons.check_box_outline_blank, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tarefa.dataCriacaoFormatada,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  tarefa.tempoRestanteFormatado,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
