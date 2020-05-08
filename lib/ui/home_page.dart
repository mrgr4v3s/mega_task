import 'package:flutter/material.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TarefasHelper helper = TarefasHelper();


  @override
  void initState() {
    super.initState();

    /*Tarefas t = Tarefas();
    t.titulo = "Tarefa Teste";
    t.status = "A FAZER";
    t.prioridade = "ALTA";

    helper.saveTarefa(t);

    helper.getAllTarefas().then((list){
      print(list);
    });TESTE DE CRIAÇÃO DE TAREFA*/
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
