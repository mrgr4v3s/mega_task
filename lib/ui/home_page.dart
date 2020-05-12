import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TarefasHelper helper = TarefasHelper();

  List<Tarefas> listAllTarefas = List();

  Color _colorText = Color(0xFF545454);
  Color _background = Color(0xFFEFEDED);

  String dropdownValue = 'Todas';

  @override
  void initState() {
    super.initState();

    helper.getAllTarefas().then((list) {
      setState(() {
        listAllTarefas = list;
      });
    });
  }

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