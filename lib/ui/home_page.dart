import 'package:flutter/material.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TarefasHelper helper = TarefasHelper();

  List<Tarefas> listAllTarefas = List();


  @override
  void initState() {
    super.initState();

    helper.getAllTarefas().then((list){
      setState(() {
        listAllTarefas = list;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem Vindo.",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Color.fromRGBO(251, 251, 251, 1),
      ),
      backgroundColor: Color.fromRGBO(239, 237, 237, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(81, 12, 75, 0.8),
      ),
      body: Column(
        children: <Widget>[
          Container(padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.add),
                hintText: "Criar Tarefa" ,
                labelStyle: TextStyle(color: Color.fromRGBO(173, 173, 173, 1),
                  fontSize: 55
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
