import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mega_task/helpers/prioridade_tarefa.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';
import 'package:mega_task/ui/home_page.dart';

class CadastroDialog extends StatefulWidget {

  List<Tarefas> listaTarefas;
  final VoidCallback onDialogClosed;

  CadastroDialog (this.listaTarefas, this.onDialogClosed);

  @override
  State<StatefulWidget> createState() => _CadastroDialogState(this.listaTarefas, this.onDialogClosed);

}

class _CadastroDialogState extends State<CadastroDialog> {

  String dropdownValueStatus = 'A fazer';
  String dropdownValuePrioridade = PrioridadeTarefa.MEDIA;

  TarefasHelper helper = TarefasHelper();

  List<Tarefas> _listaTarefas;
  final VoidCallback onDialogClosed;

  final _tituloController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Color _colorText = Color(0xFF545454);

  _CadastroDialogState(this._listaTarefas, this.onDialogClosed);

  @override
  void iniState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Criar Tarefa",
                  style: TextStyle(
                      color: Color.fromRGBO(81, 12, 75, 0.8),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _tituloController,
                          decoration: InputDecoration(
                              hintText: "Título" ,
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(173, 173, 173, 1),
                                  fontSize: 55
                              )
                          ),
                          // ignore: missing_return
                          validator: (String text){
                            if(text.isEmpty) return "Título inválido";
                          },
                        ),
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: _cadastro_dropdownButtonStatus(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: _cadastro_dropdownButtonPrioridade(),
                          )
                        ],
                      ),
                    ],
                  ),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(81, 12, 75, 0.8),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: MaterialButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        _adicionarTarefa();
                        onDialogClosed();
                        Navigator.pop(context);
                      },
                    )),
              ),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cadastro_dropdownButtonStatus() {
    return DropdownButton<String>(
      value: dropdownValueStatus,
      icon: Icon(Icons.arrow_drop_down),
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
          dropdownValueStatus = newValue;
        });
      },
      items: <String>['A fazer', 'Em andamento', 'Concluida']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _cadastro_dropdownButtonPrioridade() {
    return DropdownButton<String>(
      value: dropdownValuePrioridade,
      icon: Icon(Icons.arrow_drop_down),
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
          dropdownValuePrioridade = newValue;
        });
      },
      items: <String>[PrioridadeTarefa.ALTA, PrioridadeTarefa.MEDIA, PrioridadeTarefa.BAIXA]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _adicionarTarefa() {
    setState(() {
      Tarefas t = new Tarefas();

      t.titulo = _tituloController.text;
      _tituloController.text = "";

      t.status = dropdownValueStatus;
      dropdownValueStatus = "A fazer";

      t.prioridade = dropdownValuePrioridade;
      dropdownValuePrioridade = PrioridadeTarefa.MEDIA;

      //t.status = _statusController.text;
      //_statusController.text = "";

      //t.prioridade = _prioridadeController.text;
      //_prioridadeController.text = "";

      helper.saveTarefa(t);

      _listaTarefas.add(t);

    });
  }

}