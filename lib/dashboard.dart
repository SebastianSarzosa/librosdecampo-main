import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:libroscampo/settings/db.connection.dart';
import 'package:libroscampo/views/variables/variable_list.dart';

class Dashboard extends StatefulWidget {
  final String userRole; // Añade el campo userRole
  final String userName; // Añade el campo userName

  const Dashboard({Key? key, required this.userRole, required this.userName}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? selectedProject;
  String? selectedPlant;
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> plants = [];
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final data = await DbConnection.list('Proyectos');
    setState(() {
      projects = data;
    });
  }

  Future<void> _loadPlants(int projectId) async {
    final data = await DbConnection.filter('Plantas', 'fkid_proyecto = ?', [projectId]);
    setState(() {
      plants = data;
      selectedPlant = null;
      chartData = [];
    });
  }

  Future<void> _loadChartData(int plantId) async {
    final data = await DbConnection.selectSql('''
      SELECT c.fecha_control, v.valor_numerico
      FROM Controles c
      JOIN Variables v ON c.id_control = v.fkid_control
      WHERE c.fkid_planta = ? AND v.nombre_variable = 'Altura'
      ORDER BY c.fecha_control
    ''', [plantId]);
    setState(() {
      chartData = data.map<FlSpot>((row) {
        final date = DateTime.parse(row['fecha_control']);
        final value = row['valor_numerico'] != null ? row['valor_numerico'].toDouble() : 0.0;
        return FlSpot(date.millisecondsSinceEpoch.toDouble(), value);
      }).toList();
    });
  }

  void _refreshChartData() async {
    if (selectedPlant != null) {
      final data = await DbConnection.selectSql('''
        SELECT c.fecha_control, v.valor_numerico
        FROM Controles c
        JOIN Variables v ON c.id_control = v.fkid_control
        WHERE c.fkid_planta = ? AND v.nombre_variable = 'Altura'
        ORDER BY c.fecha_control
      ''', [int.parse(selectedPlant!)]);
  
      setState(() {
        chartData = data.map<FlSpot>((row) {
          final date = DateTime.parse(row['fecha_control']);
          final value = row['valor_numerico'] != null ? row['valor_numerico'].toDouble() : 0.0;
          return FlSpot(date.millisecondsSinceEpoch.toDouble(), value);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/bienvenido', 
            arguments: {'userRole': widget.userRole, 'userName': widget.userName}
            ); // Regresar a la pantalla de bienvenida
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshChartData, // Botón para actualizar los datos y la gráfica
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Selecciona un proyecto'),
                    value: selectedProject,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProject = newValue;
                        _loadPlants(int.parse(newValue!));
                      });
                    },
                    items: projects.map<DropdownMenuItem<String>>((Map<String, dynamic> project) {
                      return DropdownMenuItem<String>(
                        value: project['id_pro'].toString(),
                        child: Text(project['nombre_pro']),
                      );
                    }).toList(),
                  ),
                ),
                if (plants.isNotEmpty)
                  const SizedBox(width: 16), // Espaciado entre los dropdowns
                if (plants.isNotEmpty)
                  Flexible(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Selecciona una planta'),
                      value: selectedPlant,
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedPlant = newValue;
                        });
                        _refreshChartData();
                      },
                      items: plants.map<DropdownMenuItem<String>>((Map<String, dynamic> plant) {
                        return DropdownMenuItem<String>(
                          value: plant['id_planta'].toString(),
                          child: Text(plant['nombre_planta']),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16), 
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: true,
                            color: Colors.green,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.green,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text('Altura (cm)', style: TextStyle(fontSize: 12)),
                            axisNameSize: 15,
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                                final style = const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                );
                                return SideTitleWidget(
                                  space: 4.0,
                                  meta: meta,
                                  child: Text('${date.day}/${date.month}', style: style),
                                );
                              },
                            ),
                            axisNameWidget: const Text('Fecha', style: TextStyle(fontSize: 12)),
                            axisNameSize: 15,
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((barSpot) {
                                final flSpot = barSpot;
                                return LineTooltipItem(
                                  '${flSpot.y}',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
