import 'package:flutter/material.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TarefasHelper helper = TarefasHelper();
  final _formKey = GlobalKey<FormState>();
  List<Tarefas> listTarefasAltaPrioridade = List();
  List<Tarefas> listTarefasMediaPrioridade = List();
  List<Tarefas> listTarefasBaixaPrioridade = List();
  final _tituloController = TextEditingController();
  //final _statusController = TextEditingController();
  //final _prioridadeController = TextEditingController();

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
        onPressed: (){
          if(_formKey.currentState.validate()){
            _addToDo();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(81, 12, 75, 0.8),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 40.0, 1.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                    icon: Icon(Icons.add),
                    hintText: "Criar Tarefa" ,
                    labelStyle: TextStyle(color: Color.fromRGBO(173, 173, 173, 1),
                        fontSize: 55
                    )
                ),
                // ignore: missing_return
                validator: (String text){
                  if(text.isEmpty) return "Título inválido";
                },
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 40.0, 1.0),
            child: Row(
              children: <Widget>[
                Text("Alta Prioridade", style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    child: Icon(Icons.filter_1, color: Colors.white, size: 25.0,),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount:listTarefasAltaPrioridade.length,
                itemBuilder: (context, index){
                  return _tarefaList(context, index, "Alta");
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 40.0, 1.0),
            child: Row(
              children: <Widget>[
                Text("Media Prioridade", style: TextStyle(
                    fontSize: 18.0
                ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    child: Icon(Icons.filter_1, color: Colors.white, size: 25.0,),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount:listTarefasMediaPrioridade.length,
                itemBuilder: (context, index){
                  return _tarefaList(context, index, "Media");
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 40.0, 1.0),
            child: Row(
              children: <Widget>[
                Text("Baixa Prioridade", style: TextStyle(
                    fontSize: 18.0
                ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    child: Icon(Icons.filter_1, color: Colors.white, size: 25.0,),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount:listTarefasBaixaPrioridade.length,
                itemBuilder: (context, index){
                  return _tarefaList(context, index, "Baixa");
                }
            ),
          )

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _obterTarefasPrioridade("Todas", "");
  }

  void _addToDo(){
    setState(() {
      Tarefas t = new Tarefas();

      t.titulo = _tituloController.text;
      _tituloController.text = "";

      //t.status = _statusController.text;
      //_statusController.text = "";

      //t.prioridade = _prioridadeController.text;
      //_prioridadeController.text = "";

      helper.saveTarefa(t);

      switch(t.prioridade){
        case "Alta":{
          listTarefasAltaPrioridade.add(t);
          break;
        }
        case "Media":{
          listTarefasMediaPrioridade.add(t);
          break;
        }
        case "Baixa":{
          listTarefasBaixaPrioridade.add(t);
          break;
        }
      }
    });
  }

  void _obterTarefasPrioridade(String status, String prioridade){

    if(status == "Todas" && prioridade.isEmpty){
      setState(() {
        helper.getTarefas(status, "Alta").then((list){
          listTarefasAltaPrioridade = list;
        });
        helper.getTarefas(status, "Media").then((list){
          listTarefasMediaPrioridade = list;
        });
        helper.getTarefas(status, "Baixa").then((list){
          listTarefasBaixaPrioridade = list;
        });
      });
    }

    else if(prioridade == "Alta"){
      helper.getTarefas(status, prioridade).then((list){
        setState(() {
          listTarefasAltaPrioridade = list;
        });
      });
    }

    else if(prioridade == "Media"){
      helper.getTarefas(status, prioridade).then((list){
        setState(() {
          listTarefasMediaPrioridade = list;
        });
      });
    }

    else if(prioridade == "Baixa"){
      helper.getTarefas(status, prioridade).then((list){
        setState(() {
          listTarefasBaixaPrioridade = list;
        });
      });
    }
  }

  // ignore: missing_return
  Widget _tarefaList(BuildContext context, int index, String prioridade){
    if(prioridade == "Alta"){
      if(listTarefasAltaPrioridade.length > 0){
        return ListTile(
            title: Text(
              listTarefasAltaPrioridade[index].titulo,
            ),
          onTap: (){
              _excluirTarefa(listTarefasAltaPrioridade[index]);
          },
        );
      }
      return ListTile(
          title: Text(
            "VAZIO"
          )
      );
    }

    else if(prioridade == "Media"){
      if(listTarefasMediaPrioridade.length > 0){
        return ListTile(
            title: Text(
              listTarefasMediaPrioridade[index].titulo,
            ),
          onTap: (){
            _excluirTarefa(listTarefasMediaPrioridade[index]);
          },
        );
      }
      return ListTile(
          title: Text(
              "VAZIO"
          )
      );
    }

    else if(prioridade == "Baixa"){
      if(listTarefasBaixaPrioridade.length > 0){
        return ListTile(
            title: Text(
              listTarefasBaixaPrioridade[index].titulo,
            ),
          onTap: (){
            _excluirTarefa(listTarefasBaixaPrioridade[index]);
          },
        );
      }
      return ListTile(
          title: Text(
              "VAZIO"
          )
      );
    }
  }

  void _excluirTarefa(Tarefas t){
    helper.deleteTarefa(t.id);
    setState(() {
      switch(t.prioridade){
        case "Alta":{
          listTarefasAltaPrioridade.remove(t);
          break;
        }
        case "Media":{
          listTarefasMediaPrioridade.remove(t);
          break;
        }
        case "Baixa":{
          listTarefasBaixaPrioridade.remove(t);
          break;
        }
      }
    });
  }
}
