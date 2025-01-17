import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/repositories/librosdecampo_repository.dart';

class LibroListView extends StatefulWidget {
  const LibroListView({super.key});

  @override
  State<LibroListView> createState() => _LibroListViewState();
}

class _LibroListViewState extends State<LibroListView> {
  final LibrosRespository _librosRespository  =LibrosRespository();
  List<Librosdecampo> _libros = [];

  @override
  void initState() {
    super.initState();
    _cargarLibro();
  }
  Future<void> _cargarLibro() async { 
    final data = await _librosRespository.list();
    setState(() {
      _libros = data;
    });
  }

  Future<void> _eliminarLibro(int idLibro) async {
    await _librosRespository.delete(idLibro);
    _cargarLibro();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista libro",
            style: TextStyle(
            color: Colors.white
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/menu'));
          },
        ),
      ),
      body: _libros.isEmpty ?
        Center(
          child: Text('No hay datos'),
        ) :
        ListView.builder(
          itemCount: _libros.length,
          itemBuilder: (context, i) {
            final libro  = _libros[i];
            return Card(
              child: ListTile(
                title: Text('${libro.nombreLibro} '),
                subtitle:Column(
                  children: [
                    Text('descripcion: ${libro.descripcionLibro}')
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(
                        Icons.edit, 
                        color: Color.fromARGB(255, 6, 94, 9)
                      )
                    ),
                    IconButton(
                      onPressed: () async{
                        final mensaje = await showDialog<bool>(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Eliminar libro'),
                              content: Text('¿Está seguro de eliminar el libro?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  }, 
                                  child: Text('No')
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  }, 
                                  child: Text('Si')
                                )
                              ],
                            );
                          },
                        );
                        if(mensaje == true){
                          _eliminarLibro(libro.idLibro!);
                          SnackBar(content:Text(' ${libro.nombreLibro} eliminado exitosamente'));
                          setState(() {
                            _cargarLibro();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )
                    )                  
                  ],
                ), 
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){  
            Navigator.pushNamed(context, '/libro/form');
          },
          backgroundColor: Color.fromARGB(255, 6, 67, 146) ,
          child: Icon(
            color: const Color.fromARGB(255, 250, 250, 250),
            Icons.add
          ),
        ), 
        bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Paciente'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'libro'
          )
        ],
        currentIndex: 2,
        selectedItemColor: Color.fromARGB(255, 6, 67, 146),
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/menu')); 
          } else if (index == 1) {
            Navigator.pushNamed(context, '/paciente/index'); 
          } else if (index == 2) {
            Navigator.pushNamed(context, '/libro/index'); 
          }
        },
      ), 
    );
  }
}