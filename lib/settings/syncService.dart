

import 'package:libroscampo/settings/db.connection.dart';
import 'package:libroscampo/settings/supabase.dart';

class SyncService {
  Future<void> syncLibroCampo() async {
    final libros = await DbConnection.list('LibrosCampo');
    for (var libro in libros) {
      try {
        final response = await SupabaseHelper.client.from('LibrosCampo').insert(libro);
        if (response != null && response.error == null) {
          await DbConnection.delete('LibrosCampo', libro['id']);
        } else {
          print('Error al subir LibrosCampo: ${response?.error?.message ?? 'Error desconocido'}');
        }
      } catch (e) {
        print('Excepción al subir LibrosCampo: $e');
      }
    }
  }
  Future<void> syncProyectos() async {
    final proyectos = await DbConnection.list('Proyectos');
    for (var proyecto in proyectos) {
      try {
        final response = await SupabaseHelper.client
            .from('Proyectos')
            .insert(proyecto);
       if (response != null && response.error == null) {
          await DbConnection.delete('Proyectos', proyecto['id_pro']);
        } else {
          print('Error al insertar id_pro: ${response?.error?.message ?? 'Error desconocido'}');
        }
      } catch (e) {
        print('Excepción al subir id_pro: $e');
      }
    }
  }

  Future<void> syncData() async {
    print('Iniciando sincronización de datos...');
    await syncLibroCampo();
    await syncProyectos();
  }
}
