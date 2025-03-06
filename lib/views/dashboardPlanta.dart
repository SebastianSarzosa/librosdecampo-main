import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:libroscampo/settings/db.connection.dart';

class DashboardPlantaView extends StatefulWidget {
  final int plantaId;
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;

  const DashboardPlantaView({
    Key? key,
    required this.plantaId,
    required this.proyectoId,
    required this.proyectoNombre,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
  }) : super(key: key);

  @override
  _DashboardPlantaViewState createState() => _DashboardPlantaViewState();
}

class _DashboardPlantaViewState extends State<DashboardPlantaView> {
  List<FlSpot> chartData = [];
  String? plantaNombre;

  @override
  void initState() {
    super.initState();
    _loadPlantaNombre();
    _loadChartData();
  }

  Future<void> _loadPlantaNombre() async {
    final data = await DbConnection.selectSql('''
      SELECT nombre_planta
      FROM Plantas
      WHERE id_planta = ?
    ''', [widget.plantaId]);
    setState(() {
      plantaNombre = data.isNotEmpty ? data.first['nombre_planta'] : 'Desconocida';
    });
  }

  Future<void> _loadChartData() async {
    final data = await DbConnection.selectSql('''
      SELECT c.fecha_control, v.valor_numerico
      FROM Controles c
      JOIN Variables v ON c.id_control = v.fkid_control
      WHERE c.fkid_planta = ? AND v.nombre_variable = 'Altura'
      ORDER BY c.fecha_control
    ''', [widget.plantaId]);
    setState(() {
      chartData = data.map<FlSpot>((row) {
        final date = DateTime.parse(row['fecha_control']);
        final value = row['valor_numerico'] != null ? row['valor_numerico'].toDouble() : 0.0;
        return FlSpot(date.millisecondsSinceEpoch.toDouble(), value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Planta'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Planta: $plantaNombre'),
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
