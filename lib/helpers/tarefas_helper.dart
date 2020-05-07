import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tarefasTable = "tarefasTable";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String statusColumn = "statusColumn";
final String prioridadeColumn = "prioridadeColumn";

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
                  "$prioridadeColumn TEXT)");
      });
    }

    Future<Tarefas> saveTarefa(Tarefas tarefa) async{
        Database dbTarefas = await db;
        tarefa.id = await dbTarefas.insert(tarefasTable, tarefa.toMap());
        return tarefa;
    }

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

    Future<Tarefas> updateTarefa(Tarefas tarefa) async{
      Database dbTarefas = await db;
      dbTarefas.update(tarefasTable, tarefa.toMap(),
        where: "$idColumn = ?", whereArgs: [tarefa.id]);
    }

    Future<List> getAllTarefas() async{
      Database dbTarefas = await db;
      List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable");
      List<Tarefas> listTarefas = List();
      for(Map m in listMap){
        listTarefas.add(Tarefas.fromMap(m));
      }

      return listTarefas;
    }

    Future<List> getAllTarefasConcluidas() async{
      Database dbTarefas = await db;
      List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable "
          "WHERE $statusColumn = CONCLUIDA");
      List<Tarefas> listTarefasConcluidas = List();
      for(Map m in listMap){
        listTarefasConcluidas.add(Tarefas.fromMap(m));
      }

      return listTarefasConcluidas;
    }

    Future<List> getAllTarefasEmAndamento() async{
      Database dbTarefas = await db;
      List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable "
          "WHERE $statusColumn = EM ANDAMENTO");
      List<Tarefas> listTarefasEmAndamento = List();
      for(Map m in listMap){
        listTarefasEmAndamento.add(Tarefas.fromMap(m));
      }

      return listTarefasEmAndamento;
    }

    Future<List> getAllTarefasAFazer() async{
      Database dbTarefas = await db;
      List listMap = await dbTarefas.rawQuery("SELECT * FROM $tarefasTable "
          "WHERE $statusColumn = A FAZER");
      List<Tarefas> listTarefasAFazer = List();
      for(Map m in listMap){
        listTarefasAFazer.add(Tarefas.fromMap(m));
      }

      return listTarefasAFazer;
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

    Tarefas();

    Tarefas.fromMap(Map map){
      id = map[idColumn];
      titulo = map[tituloColumn];
      status = map[statusColumn];
      prioridade = map[prioridadeColumn];
    }

    Map toMap(){
      Map<String, dynamic> map = {
        tituloColumn: titulo,
        statusColumn: status,
        prioridadeColumn: prioridade
      };
      if(id != null){
        map[idColumn] = id;
      }
      return map;
    }

    @override
    String toString() {
      return "Tarefa(id: $id, titulo: $titulo, status: $status, prioridade: $prioridade)";
    }



}