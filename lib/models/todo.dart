import 'package:sqflite/sqflite.dart';

final String tableGuest = 'guest';
final String columnId = 'id';
final String columnName = 'name';
final String columnkm = 'km';
final String columnTotalKm = 'totalKm';
final String columnStep = 'step';
final String columnTotalStep = 'totalStep';
final String columnremainStep = 'remainStep';
final String columntree = 'tree';
final String columnLvl = 'Lvl';

class Guest {

  int _id;
  String _name;
  String _km;
  String _totalKm;
  int _step;
  int _totalStep;
  int _remainStep;
  int _tree;
  int _lvl;


  int get id => this._id;
  String get name => this._name;
  String get km => this._km;
  String get totalKm => this._totalKm;
  int get step => this._step;
  int get total => this._totalStep;
  int get remain => this._remainStep;
  int get tree => this._tree;
  int get lvl => this._lvl;

  set setId(int id) => this._id = id;
  set setName(String name) => this._name = name;
  set setKm(String km) => this._km = km;
  set setTotalKm(String totalkm) => this._totalKm = totalkm;
  set setStep(int step) => this._step = step;
  set setTotalStep(int totalStep) => this._totalStep = totalStep;
  set setRemainStep(int remain) => this._remainStep = remain;
  set setTree(int tree) => this._tree = tree;
  set setLvl(int lvl) => this._lvl = lvl;


  Guest.fromMap(Map<String, dynamic> map) {
    _id  = map[columnId];
    _name  = map[columnName];
    _km  = map[columnkm];
    _totalKm  = map[columnTotalKm];
    _step  = map[columnStep];
    _totalStep  = map[columnTotalStep];
    _remainStep  = map[columnremainStep];
    _tree  = map[columntree];
    _lvl  = map[columnLvl];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId : _id,
      columnName : _name,
      columnkm : _km,
      columnTotalKm : _id,
      columnStep : _step,
      columnTotalStep : _totalStep,
      columnremainStep : _remainStep,
      columntree : _tree,
      columnLvl : _lvl,

    };
   

    return map;
  }
  Guest() {
    this._id = 1;
    this._name = 'Guest';
    this._km = "0.0";
    this._totalKm = "0.0";
    this._step = 0;
    this._totalStep = 0;
    this._remainStep = 0;
    this._tree = 0;
    this._lvl = 0;
  }
}

class guestProvider {
  Database db;
  
  Future open(String path) async {
    print("on open function");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableGuest (
            $columnId integer primary key autoincrement,
            $columnName text not null,
            $columnkm text not null,
            $columnTotalKm text not null,
            $columnStep interger not null,
            $columnTotalStep interger not null,
            $columnremainStep interger not null,
            $columntree interger not null,
            $columnLvl interger not null,
          )
        ''');
    });
  }

  Future<Guest> insert(Guest guest) async{
    guest._id = await db.insert(
      tableGuest,
      guest.toMap()
      );
    return guest;
  }

  Future<Guest> getGuest(int id) async{
    print('getting Guest');
    List<Map> maps = await db.query(
      tableGuest,
      where: "$columnId = ?",
      whereArgs: [id]
    );
    if (maps.length > 0) {
      return Guest.fromMap(maps.first);
    }
    return Guest.fromMap(maps.first);
  }

  Future delete(int id) async{
    print('deleted');
    return await db.delete(
      tableGuest, 
      where: "$columnId = ?", 
      whereArgs: [id]
    );
  }

  Future<int> update(Guest guest) async{
    print("Updating");
    return await db.update(
      tableGuest, guest.toMap(),
      where: "$columnId = ?",
      whereArgs: [guest.id]);
  }
//   //test
//   Future<List<guest>> getto() async{
//     var guest =await db.query(tableguest, where: "$columnid = 0");
//     return guest.map((string) => guest.fromMap(string)).toList();
//   }
//   //test
//   Future deleteAllCompguest() async{
//     await db.delete(tableguest, where: "$columnid = 1");
//   }
//   //test
//   Future<List<guest>> getall() async{
//     await this.open("guest.db");
//     List<Map<String, dynamic>> guest = await db.query(tableguest,where: "$columnid = 0");
//     if(db != null){
//       print('data is null -------------------'+db.rawQuery('SELECT * FROM guest').toString());
//     }
//     // print("pang: =>>"+guest.map((string) =>guest.fromMap(string)).toList().toString());
//     return guest.map((string) =>guest.fromMap(string)).toList();
//   }

  
  Future close() => db.close();
}