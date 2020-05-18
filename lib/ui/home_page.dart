import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mega_task/constantes/app_colors.dart';
import 'package:mega_task/helpers/prioridade_tarefa.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';
import 'package:mega_task/ui/cadastroDialog.dart';
import 'package:mega_task/ui/editarDialog.dart';
import 'package:mega_task/widgets/filtro_dropdown_button.dart';
import 'package:mega_task/widgets/listagem_tarefas_item.dart';
import 'package:mega_task/widgets/prioridade_text.dart';

import 'exclusaoDialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TarefasHelper helper = TarefasHelper();

  final _formKey = GlobalKey<FormState>();

  List<Tarefas> listaTarefas = List();

  final _tituloController = TextEditingController();

  String dropdownValueFilter = 'Todas as tarefas';

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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Padding(
                 padding: EdgeInsets.only(left: 28.0),
                 child:  FloatingActionButton(
                   onPressed: () {
                     showDialog(context: context, builder: (context) => CadastroDialog(listaTarefas, () => setState((){})));
                   },
                   child: Icon(Icons.add),
                   backgroundColor: Color.fromRGBO(81, 12, 75, 0.8),
                 ),
               )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: AppColors.background,
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: FiltroDropdownButton(
                          dropdownValueFilter: dropdownValueFilter,
                          funcaoOnChange: (String newValue) {
                            setState(() {
                              dropdownValueFilter = newValue;
                            });
                          }),
                    )
                  ],
                ),
                //Divider(color: _background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child:
                      PrioridadeText(textoPropriedade: PrioridadeTarefa.ALTA),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                    child: _tarefaList(context, PrioridadeTarefa.ALTA)),
                Divider(color: AppColors.background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child:
                      PrioridadeText(textoPropriedade: PrioridadeTarefa.MEDIA),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                    child: _tarefaList(context, PrioridadeTarefa.MEDIA)),
                Divider(color: AppColors.background),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                  child:
                      PrioridadeText(textoPropriedade: PrioridadeTarefa.BAIXA),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                    child: _tarefaList(context, PrioridadeTarefa.BAIXA)),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    //helper.tarefasTeste().then((value) => this._obterTarefas());

    _obterTarefas();

  }

  void _editarTarefa(Tarefas t) {
    //t.titulo = ;
    //t.prioridade = ;
    //t.status = ;
    helper.updateTarefa(t);
  }

  /*void _getUpdt(Tarefas t) {}

  void _postUpdt(Tarefas t) {
    //t.titulo = ;
    //t.prioridade = ;
    //t.status = ;
    helper.updateTarefa(t);
  }*/

  void _obterTarefas() {
    helper.getTodasTarefas().then(
            (lista) => {
              listaTarefas = lista,
              setState(() {})
            });

  }

  Widget _tarefaList(BuildContext context, String prioridade) {
    List<Tarefas> tarefasFiltradasPorPrioridade = listaTarefas
        .where((tarefa) => tarefa.prioridade == prioridade)
        .toList();

    if (dropdownValueFilter != "Todas as tarefas") {
      tarefasFiltradasPorPrioridade = tarefasFiltradasPorPrioridade
          .where((tarefa) => tarefa.status == this.dropdownValueFilter)
          .toList();
    }

    if (tarefasFiltradasPorPrioridade.isEmpty) {
      return Divider();
      //return new Text(("VAZIO"));
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: tarefasFiltradasPorPrioridade
            .map((tarefa) =>
                ListagemTarefasItem(
                  tarefa: tarefa,
                  onDelete: () {
                    showDialog(context: context, builder: (context) => ExclusaoDialog(tarefa, listaTarefas, () {setState(() {});}));
                  } ,
                  onEdit: () {
                    showDialog(context: context, builder: (context) => EditarDialog(tarefa, listaTarefas, () {setState(() {});}));
                    //this._editarTarefa(tarefa);
                  }
                )
        ).toList());
  }
}
