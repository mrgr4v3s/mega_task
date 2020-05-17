
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_task/constantes/app_colors.dart';

class FiltroDropdownButton extends StatelessWidget {
  final Function funcaoOnChange;
  final String dropdownValueFilter;

  const FiltroDropdownButton({Key key, this.funcaoOnChange, this.dropdownValueFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: this.dropdownValueFilter,
      icon: Icon(Icons.filter_list),
      iconSize: 32,
      elevation: 16,
      style: TextStyle(
        color: Color.fromRGBO(81, 12, 75, 0.8),
      ),
      underline: Container(
        height: 2,
        color: AppColors.colorText,
      ),
      onChanged: this.funcaoOnChange,
      items: <String>['Todas as tarefas', 'A fazer', 'Em andamento', 'Concluida']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}