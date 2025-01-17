
import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/settings/db.connection.dart';

class LibrosRespository {
  final String tableName = 'LibrosCampo';  
  
  Future <int> create(Librosdecampo libroCampo) async {
    return await DbConnection.insert(tableName, libroCampo.toMap());
  }
  Future<List<Librosdecampo>> list() async {
    var data = await DbConnection.list(tableName);
    if(data.isEmpty){
      return List.empty();
    }
    return List.generate(data.length, (i) => Librosdecampo.fromMap(data[i]));
  }
  Future<int> delete(int idLibro) async {
    return await DbConnection.delete(tableName, idLibro);
  }
  Future<int> update(int idLibro, Librosdecampo libroCampo) async {
    return await DbConnection.update(tableName, libroCampo.toMap(), idLibro);
  }



}
