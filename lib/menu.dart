import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENU DE OPCIONES',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/bienvenido'));
          },
        ),
      ),      
      body: Column(
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, '/libro/index'); 
                    },  
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 107, 170, 241)),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                         Icon(
                          Icons.people_alt,
                            color: Colors.black,                                  
                        ),
                        SizedBox(height: 10,),
                        Text('Caracterizacion',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 0, 0, 0)
                          ),
                        ),
                      ],
                    )
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, '/libro/index'); 
                    },  
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 159, 165, 219)),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                         Icon(
                          Icons.book,
                            color: Colors.black,                                  
                        ),
                        SizedBox(height: 15,),
                        Text('Ferilizacion',
                          style: TextStyle(
                           fontSize: 12, 
                           color: const Color.fromARGB(255, 0, 0, 0)
                          ),
                        ),
                      ],
                    )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
