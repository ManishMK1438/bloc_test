import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveClass {
  init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  Future<Box<dynamic>> openBox({required String boxName}) async {
    return await Hive.openBox(boxName);
  }

  Box<dynamic> getBox({required String boxName}) {
    return Hive.box(boxName);
  }

  closeBox({required String boxName}) {
    Hive.box(boxName).close();
  }

  closeAll() {
    Hive.close();
  }
}
