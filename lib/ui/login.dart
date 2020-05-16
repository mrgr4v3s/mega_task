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
        backgroundColor: Color(0xFFEFEDED),
      body: Column (
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Image.asset(
              "assets/mega.png",
              height: 200.0,
              width: 200.0,
            ),
          ),
          Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0)
                        )
                      )
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validarEmail,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                        hintText: "Senha",
                        prefixIcon: Icon(Icons.enhanced_encryption),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0)
                            )
                        )
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
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
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 55.0,
                    child: OutlineButton(
                      child: Text("Cadastre-se",
                        style: TextStyle(
                            fontSize: 20.0,
                          color: Color.fromRGBO(81, 12, 75, 0.8),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      onPressed: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context)=>Cadastrar())
                        );
                      },
                    )
                  ),
                ],
              ),
            ),
          )
        ],
      )
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
