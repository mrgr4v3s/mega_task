import 'package:flutter/material.dart';
import 'package:mega_task/constantes/app_colors.dart';
import 'package:mega_task/helpers/prioridade_tarefa.dart';
import 'package:mega_task/helpers/tarefas_helper.dart';

class ListagemTarefasItem extends StatelessWidget {
  final Tarefas tarefa;
  final Function onDelete;
  final Function onEdit;

  const ListagemTarefasItem(
      {Key key,
      @required this.tarefa,
      @required this.onDelete,
      @required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color corDoIcone = definirCorDoIcone();

    return Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: 50,
            minWidth: 0,
            minHeight: 0
        ),
        margin:EdgeInsets.only(
            top:5,
            bottom: 5
        ) ,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background_item),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
                child: Icon(Icons.adjust, size: 25, color: corDoIcone),
                flex: 1,
            ),
            Expanded(
              flex: 4,
                child: Text(tarefa.titulo,
                    style: TextStyle(
                        color: AppColors.colorText,
                        fontSize: 16,
                        fontFamily: "Roboto"))),
            Flexible(
              flex: 1,
                child: IconButton(
              icon: Icon(Icons.edit, color: AppColors.icons),
              onPressed: this.onEdit,
            )),
            Flexible(
              flex: 1,
                child: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.icons),
                    onPressed: this.onDelete))
          ],
        ));
  }

  Color definirCorDoIcone() {
    if (this.tarefa.prioridade == PrioridadeTarefa.ALTA) {
      return Colors.red;
    }

    if (this.tarefa.prioridade == PrioridadeTarefa.MEDIA) {
      return Colors.yellow;
    }

    if (this.tarefa.prioridade == PrioridadeTarefa.BAIXA) {
      return Colors.green;
    }

    return Colors.grey;
  }
}
