import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';
import 'package:mega_task/ui/cadastroDialog.dart';

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

  String dropdownValueFilter = 'Todas';


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
          onPressed: () {
            showDialog(context: context, builder: (context) => CadastroDialog());
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(81, 12, 75, 0.8),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: _background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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

  // ignore: non_constant_identifier_names
  Widget _filtro_dropdownButton() {
    return DropdownButton<String>(
      value: dropdownValueFilter,
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
          dropdownValueFilter = newValue;
        });
        _obterTarefasPrioridade(newValue, "Todas");
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

  Widget _prioridadeText(String p) {
    return Text(
      "$p prioridade",
      style: TextStyle(
        color: _colorText,
        fontSize: 18,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _obterTarefasPrioridade("Todas", "");

    //helper.tarefasTeste();
  }

  void _addToDo() {
    setState(() {
      Tarefas t = new Tarefas();

      t.titulo = _tituloController.text;
      _tituloController.text = "";

      t.status = "A fazer";
      t.prioridade = "Alta";

      //t.status = _statusController.text;
      //_statusController.text = "";

      //t.prioridade = _prioridadeController.text;
      //_prioridadeController.text = "";

      helper.saveTarefa(t);

      switch (t.prioridade) {
        case "Alta":
          {
            listTarefasAltaPrioridade.add(t);
            break;
          }
        case "Media":
          {
            listTarefasMediaPrioridade.add(t);
            break;
          }
        case "Baixa":
          {
            listTarefasBaixaPrioridade.add(t);
            break;
          }
      }
    });
  }

  void _excluirTarefa(Tarefas t) {
    helper.deleteTarefa(t.id);
    setState(() {
      switch (t.prioridade) {
        case "Alta":
          {
            listTarefasAltaPrioridade.remove(t);
            break;
          }
        case "Media":
          {
            listTarefasMediaPrioridade.remove(t);
            break;
          }
        case "Baixa":
          {
            listTarefasBaixaPrioridade.remove(t);
            break;
          }
      }
    });
  }

  void _getUpdt(Tarefas t) {}

  void _postUpdt(Tarefas t) {
    //t.titulo = ;
    //t.prioridade = ;
    //t.status = ;
    helper.updateTarefa(t);
  }

  void _obterTarefasPrioridade(String status, String prioridade) {
    if (status == "Todas" && prioridade.isEmpty) {
      setState(() {
        helper.getTarefas(status, "Alta").then((list) {
          listTarefasAltaPrioridade = list;
        });
        helper.getTarefas(status, "Media").then((list) {
          listTarefasMediaPrioridade = list;
        });
        helper.getTarefas(status, "Baixa").then((list) {
          listTarefasBaixaPrioridade = list;
        });
      });
    } else if (status.isNotEmpty && prioridade == "Todas") {
      setState(() {
        helper.getTarefas(status, "Alta").then((list) {
          listTarefasAltaPrioridade = list;
        });
        helper.getTarefas(status, "Media").then((list) {
          listTarefasMediaPrioridade = list;
        });
        helper.getTarefas(status, "Baixa").then((list) {
          listTarefasBaixaPrioridade = list;
        });
      });
    } else if (prioridade == "Alta") {
      helper.getTarefas(status, prioridade).then((list) {
        setState(() {
          listTarefasAltaPrioridade = list;
        });
      });
    } else if (prioridade == "Media") {
      helper.getTarefas(status, prioridade).then((list) {
        setState(() {
          listTarefasMediaPrioridade = list;
        });
      });
    } else if (prioridade == "Baixa") {
      helper.getTarefas(status, prioridade).then((list) {
        setState(() {
          listTarefasBaixaPrioridade = list;
        });
      });
    }
  }

  // ignore: missing_return
  Widget _tarefaList(BuildContext context, int index, String prioridade) {
    if (prioridade == "Alta") {
      if (listTarefasAltaPrioridade.length > 0) {
        return ListTile(
          title: Text(
            listTarefasAltaPrioridade[index].titulo,
          ),
          onTap: () {
            _excluirTarefa(listTarefasAltaPrioridade[index]);
          },
        );
      }
      return ListTile(title: Text("VAZIO"));
    } else if (prioridade == "Media") {
      if (listTarefasMediaPrioridade.length > 0) {
        return ListTile(
          title: Text(
            listTarefasMediaPrioridade[index].titulo,
          ),
          onTap: () {
            _excluirTarefa(listTarefasMediaPrioridade[index]);
          },
        );
      }
      return ListTile(title: Text("VAZIO"));
    } else if (prioridade == "Baixa") {
      if (listTarefasBaixaPrioridade.length > 0) {
        return ListTile(
          title: Text(
            listTarefasBaixaPrioridade[index].titulo,
          ),
          onTap: () {
            _excluirTarefa(listTarefasBaixaPrioridade[index]);
          },
        );
      }
      return ListTile(title: Text("VAZIO"));
    }
  }
}
