import 'package:browniesuppermall/main.dart';
import 'package:browniesuppermall/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'mushroomsupermall.db';
  final int versionDatabase = 1;
  final String tableDatabase = 'product';
  final String columnId = 'id';
  final String columnIdShop = 'idShop';
  final String columnNameShop = 'nameShop';
  final String columnIdProduct = 'idProduct';
  final String columnNameProduct = 'nameProduct';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLiteHelper() {
    initialData();
  }

  Future<Null> initialData() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      version: versionDatabase,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnIdShop TEXT, $columnNameShop TEXT, $columnIdProduct TEXT, $columnNameProduct TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT)',
      ),
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertValueToSQLite(SQLiteModel sqLiteModel) async {
    try {
      Database database = await connectedDatabase();
      database.insert(
        tableDatabase,
        sqLiteModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('### insert value SQLite Success');
    } catch (e) {}
  }

  Future<List<SQLiteModel>> readAllData() async {
    try {
      Database database = await connectedDatabase();
      List<SQLiteModel> models = [];
      var maps = await database.query(tableDatabase);
      for (var item in maps) {
        SQLiteModel model = SQLiteModel.fromMap(item);
        models.add(model);
      }
      return models;
    } catch (e) {
      return null;
    }
  }

  Future<Null> deleteSQLiteById(int id) async {
    try {
      Database database = await connectedDatabase();
      await database.delete(tableDatabase, where: '$columnId = $id');
    } catch (e) {}
  }
}
