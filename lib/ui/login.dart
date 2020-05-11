import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_task/ui/cadastrar.dart';
import 'package:mega_task/ui/home_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "E-mail"
              ),
              keyboardType: TextInputType.emailAddress,
              validator: validarEmail,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _senhaController,
              decoration: InputDecoration(
                  hintText: "Senha"
              ),
              obscureText: true,
              validator: validarSenha,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: (){},
                child: Text("Esqueci minha senha",
                  textAlign: TextAlign.right,),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 55.0,
              child: RaisedButton(
                child: Text("Entrar",
                  style: TextStyle(
                      fontSize: 24.0
                  ),
                ),
                textColor: Colors.white,
                color: Color.fromRGBO(81, 12, 75, 0.8),
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    cadastrar(email: _emailController.text,
                        senha: _senhaController.text,
                        onSucess: _onSucess,
                        onFail: _onFail);
                  }
                },
              ),
            ),
            FlatButton(
              child: Text("Cadastre-se",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromRGBO(0, 0, 0, 1),
                    decoration: TextDecoration.underline
                ),
              ),
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>Cadastrar())
                );
              },
            )

          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  String validarEmail(String text){
    if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
  }

  // ignore: missing_return
  String validarSenha(String text){
    if(text.isEmpty || text.length < 6 ) return "Senha inválida";
  }

  void cadastrar({@required String email,@required  String senha,
    @required VoidCallback onSucess, @required  VoidCallback onFail}) async{

    await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha
    ).then((user){
      onSucess();
    }).catchError((e){
      onFail();
    });
  }

  void _onSucess(){
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>HomePage())
    );
  }

  void _onFail(){
    print("fail");
  }
}
