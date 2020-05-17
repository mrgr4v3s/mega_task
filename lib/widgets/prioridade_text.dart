
import 'package:flutter/material.dart';
import 'package:mega_task/constantes/app_colors.dart';


class PrioridadeText extends StatelessWidget {
  final String textoPropriedade;

  const PrioridadeText({Key key, this.textoPropriedade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      "$textoPropriedade prioridade",
      style: TextStyle(
        color: AppColors.colorText,
        fontSize: 18,
      ),
    );
  }

}