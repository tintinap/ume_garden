import 'package:sqflite/sqflite.dart';

final String tableGuest = 'Guest';
final String columnId = 'id';
final String columnName = 'name';
final String columnkm = 'km';
final String columnTotalKm = 'totalKm';
final String columnStep = 'step';
final String columnTotalStep = 'totalStep';
final String columnremainStep = 'remainStep';
final String columntree = 'tree';
final String columnLvl = 'lvl';

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


  int get getid => this._id;
  String get getname => this._name;
  String get getkm => this._km;
  String get gettotalKm => this._totalKm;
  int get getstep => this._step;
  int get gettotalStep => this._totalStep;
  int get getremain => this._remainStep;
  int get gettree => this._tree;
  int get getlvl => this._lvl;

  set id(int id) => this._id = id;
  set name(String name) => this._name = name;
  set km(String km) => this._km = km;
  set totalKm(String totalkm) => this._totalKm = totalkm;
  set step(int step) => this._step = step;
  set totalStep(int totalStep) => this._totalStep = totalStep;
  set remainStep(int remain) => this._remainStep = remain;
  set tree(int tree) => this._tree = tree;
  set lvl(int lvl) => this._lvl = lvl;


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
      columnTotalKm : _totalKm,
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
  
  Guest.fromUpdate(int id, String name, String km, String totalKm, int step, int totalStep, int remainStep, int tree, int lvl) {
    this._id = id;
    this._name = name;
    this._km = km;
    this._totalKm = totalKm;
    this._step = step;
    this._totalStep = totalStep;
    this._remainStep = remainStep;
    this._tree = tree;
    this._lvl = lvl;
  }
}

class GuestProvider {
  Database db;
  
  Future open(String path) async {
    print("on open function");
    Guest a = Guest();
    db = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE $tableGuest (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnName TEXT NOT NULL,
              $columnkm TEXT NOT NULL,
              $columnTotalKm TEXT NOT NULL,
              $columnStep INTEGER NOT NULL,
              $columnTotalStep INTEGER NOT NULL,
              $columnremainStep INTEGER NOT NULL,
              $columntree INTEGER NOT NULL,
              $columnLvl INTEGER NOT NULL
            )
        ''');
    });
    List<Map> dbLenList = await this.db.rawQuery("select count(*) from Guest");
    int db_len = dbLenList[0]['count(*)'];
    if (db == null || db_len == 0) {
      this.insert(a);
      print('inserted');
    } else {
      print("db not null");
      print(db);
      print(db_len);
    };
    print("Created table $tableGuest.");
  }


  Future<Guest> insert(Guest guest) async {
    print("inserting");
    print(guest.getkm);
    guest._id = await db.insert(
      tableGuest,
      guest.toMap()
      );
    print("${guest.getkm} inserted.");
    return guest;
  }

  Future<List<Map>> getGuest(int id) async{
    print('getting Guest');
      List<Map> maps = await db.query(
        tableGuest,
        where: "$columnId = ?",
        whereArgs: [id]
      );

    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
    // print(maps);
    if (maps.length > 0) {
      print("maps not nullllllllll");
      return maps;
    }
    print("maps null");
    return null;
  }

  Future<int> update(Guest guest) async{
    print("Updating");
    return await db.update(
      tableGuest, guest.toMap(),
      where: "$columnId = ?",
      whereArgs: [guest._id]);
  }

  Future deleting(int id) async{
    print('Deleting');
    return await db.delete(
      tableGuest, 
      where: "$columnId = ?", 
      whereArgs: [id]
    );
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