import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tarefasTable = "tarefasTable";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String statusColumn = "statusColumn";
final String prioridadeColumn = "prioridadeColumn";
final String usuarioColumn = "usuarioColumn";

class TarefasHelper{
    static final TarefasHelper _instance = TarefasHelper.internal();

    factory TarefasHelper() => _instance;

    TarefasHelper.internal();

    Database _db;

    Future<Database> get db async {
      if(_db != null) return _db;
      else{
        _db = await initDb();
        return _db;
      }
    }

    Future<Database> initDb() async{
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, "tarefas.db");

      return await openDatabase(path, version: 1, onCreate:
          (Database db, int newerVersion) async{
            await db.execute("CREATE TABLE "
                "$tarefasTable($idColumn INTEGER PRIMARY KEY, "
                  "$tituloColumn TEXT,"
                  "$statusColumn TEXT,"
                  "$prioridadeColumn TEXT,"
                  "$usuarioColumn TEXT)");
      });
    }

    Future<Tarefas> saveTarefa(Tarefas tarefa) async{
        Database dbTarefas = await db;
        tarefa.id = await dbTarefas.insert(tarefasTable, tarefa.toMap());
        return tarefa;
    }

    Future tarefasTeste() async{
      Database dbTarefas = await db;
      Tarefas tarefa = new Tarefas();
      for(int i = 0; i < 3; i++){
        tarefa.id = i;
        tarefa.titulo = "Programação";
        tarefa.prioridade = "Media";
        tarefa.status = "A fazer";

        FirebaseUser usuario = await FirebaseAuth.instance.currentUser();
        tarefa.usuario = usuario.email;

        await dbTarefas.insert(tarefasTable, tarefa.toMap());
      }

      for(int i = 3; i < 6; i++){
        tarefa.id = i;
        tarefa.titulo = "Protótipo";
        tarefa.prioridade = "Alta";
        tarefa.status = "Em andamento";

        FirebaseUser usuario = await FirebaseAuth.instance.currentUser();
        tarefa.usuario = usuario.email;

        await dbTarefas.insert(tarefasTable, tarefa.toMap());
      }
      for(int i = 6; i < 9; i++){
        tarefa.id = i;
        tarefa.titulo = "Requisitos";
        tarefa.prioridade = "Baixa";
        tarefa.status = "Concluida";

        FirebaseUser usuario = await FirebaseAuth.instance.currentUser();
        tarefa.usuario = usuario.email;

        await dbTarefas.insert(tarefasTable, tarefa.toMap());
      }


    }

    // ignore: missing_return
    Future<Tarefas> getTarefa(int id) async{
      Database dbTarefas = await db;
      List<Map> maps = await dbTarefas.query(tarefasTable, columns: [idColumn,
        tituloColumn, statusColumn, prioridadeColumn],
        where: "$idColumn = ?", whereArgs: [id]);
      
      if(maps.length > 0){
        return Tarefas.fromMap(maps.first);
      }
    }
    
    Future<int> deleteTarefa(int id) async{
      Database dbTarefas = await db;
      return await dbTarefas.delete(tarefasTable,
          where: "$idColumn = ?", whereArgs: [id]);
    }

    // ignore: missing_return
    Future<Tarefas> updateTarefa(Tarefas tarefa) async{
      Database dbTarefas = await db;
      dbTarefas.update(tarefasTable, tarefa.toMap(),
        where: "$idColumn = ?", whereArgs: [tarefa.id]);
    }

    Future<List<Tarefas>> getTodasTarefas() async {
      Database dbTarefas = await db;

      FirebaseUser usuario = await FirebaseAuth.instance.currentUser();
      String emailUsuario = usuario.email;

      List resultado = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable WHERE $usuarioColumn = '$emailUsuario'");

      return resultado.map((item) => Tarefas.fromMap(item)).toList();
    }

    // ignore: missing_return
    Future<List> getTarefas(String sts, String priority) async{
      Database dbTarefas = await db;
      List<Tarefas> listTarefas = List<Tarefas>();

      if(sts == "Todas"){
        try{
          List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable"
              " WHERE $prioridadeColumn = '$priority'");
          for(Map m in listMap)
            listTarefas.add(Tarefas.fromMap(m));
        } catch (e){
          e.toString();
        }
        return listTarefas;
      }
      else if(sts.isNotEmpty){
        try{
          List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable"
              " WHERE $prioridadeColumn = '$priority' "
              "AND $statusColumn = '$sts'");
          for(Map m in listMap) listTarefas.add(Tarefas.fromMap(m));
        } catch (e){
          e.toString();
        }
        return listTarefas;
      }
    }

    Future close() async{
      Database dbTarefas = await db;
      dbTarefas.close();
    }
}

class Tarefas {
    int id;
    String titulo;
    String status;
    String prioridade;
    String usuario;

    Tarefas();

    Tarefas.fromMap(Map map){
      id = map[idColumn];
      titulo = map[tituloColumn];
      status = map[statusColumn];
      prioridade = map[prioridadeColumn];
      usuario = map[usuarioColumn];
    }

    Map toMap(){
      Map<String, dynamic> map = {
        tituloColumn: titulo,
        statusColumn: status,
        prioridadeColumn: prioridade,
        usuarioColumn: usuario
      };
      if(id != null){
        map[idColumn] = id;
      }
      return map;
    }

    @override
    String toString() {
      return "Tarefa(id: $id, titulo: $titulo, status: $status, prioridade: $prioridade, usuario: $usuario)";
    }



}