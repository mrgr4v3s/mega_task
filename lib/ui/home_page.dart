import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  
  Color _colorText = Color(0xFF545454);
  Color _background = Color(0xFFEFEDED);

  String dropdownValue = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Image.asset(
                "assets/mega.png",
              )),
          backgroundColor: Color.fromRGBO(251, 251, 251, 1),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, right: 8.0),
              child: Text(
                "Bem-Vindo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Color.fromRGBO(239, 237, 237, 1),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(81, 12, 75, 0.8),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: _background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*Container(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.add),
                    hintText: "Criar Tarefa",
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(173, 173, 173, 1), fontSize: 55)),
              ),
            ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: _filtro_dropdownButton(),
                    )
                  ],
                ),
                //Divider(color: _background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child: _prioridadeText("Alta"),
                ),
                /*
                * Jefferson
                * Aqui você pode inserir o seu Expanded com a listagem das
                * tarefas que depois eu arrumo
                * */
                Divider(color: _background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child: _prioridadeText("Média"),
                ),
                /*
                * Jefferson
                * Aqui você pode inserir o seu Expanded com a listagem das
                * tarefas que depois eu arrumo
                * */
                Divider(color: _background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child: _prioridadeText("Baixa"),
                )
                /*
                * Jefferson
                * Aqui você pode inserir o seu Expanded com a listagem das
                * tarefas que depois eu arrumo
                * */
              ],
            ),
          ),
        ));
  }

  Widget _filtro_dropdownButton() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.filter_list),
      iconSize: 32,
      elevation: 16,
      style: TextStyle(
        color: Color.fromRGBO(81, 12, 75, 0.8),
      ),
      underline: Container(
        height: 2,
        color: _colorText,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Todas', 'A fazer', 'Em andamento', 'Concluida']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _addToDo(){
    setState(() {
      Tarefas t = new Tarefas();
      t.titulo = _tituloController.text;
      //t.status = "Concluida";
      //t.status = "A fazer";
      t.status = "Em andamento";
      t.prioridade = "Baixa";
      //t.prioridade = "Alta";
      //t.prioridade = "Baixa";
      helper.saveTarefa(t);
      _tituloController.text = "";
      if(t.prioridade == "Alta") listTarefasAltaPrioridade.add(t);
      else if(t.prioridade == "Media") listTarefasMediaPrioridade.add(t);
      else if(t.prioridade == "Baixa") listTarefasBaixaPrioridade.add(t);
    });
  }

  @override
  void initState() {
    super.initState();
    _obterTarefasPrioridade("Todas", "");
  }

  // ignore: missing_return
  String validarTarefa(String text){
    if(text.isEmpty) return "Título inválido";
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
            )
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
            )
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
            )
        );
      }
      return ListTile(
          title: Text(
              "VAZIO"
          )
      );
    }
  }
}
  
  Widget _prioridadeText(String p) {
    return Text(
      "$p prioridade",
      style: TextStyle(
        color: _colorText,
        fontSize: 18,
      ),
    );
  }
}