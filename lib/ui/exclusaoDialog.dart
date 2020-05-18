import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class ExclusaoDialog extends StatefulWidget {

  Tarefas tarefa;

  List<Tarefas> listaTarefas;

  final VoidCallback onDialogClosed;

  ExclusaoDialog(this.tarefa, this.listaTarefas,this.onDialogClosed);

  @override
  State<StatefulWidget> createState() => _ExclusaoDialogState(this.tarefa,
      this.listaTarefas, this.onDialogClosed);

}

class _ExclusaoDialogState extends State<ExclusaoDialog> {

  Tarefas tarefa;

  List<Tarefas> listaTarefas;

  final VoidCallback onDialogClosed;

  TarefasHelper helper = TarefasHelper();

  _ExclusaoDialogState(this.tarefa, this.listaTarefas, this.onDialogClosed);

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
                  "Excluir Tarefa",
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
                    child: Text(
                      'Tem certeza que deseja excluir a tarefa?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic
                      ),
                    )
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
                        "Sim",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        this._excluirTarefa(tarefa);
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

  void _excluirTarefa(Tarefas tarefa) {
    helper.deleteTarefa(tarefa.id);
    setState(() {
      listaTarefas.remove(tarefa);
    });
  }

}