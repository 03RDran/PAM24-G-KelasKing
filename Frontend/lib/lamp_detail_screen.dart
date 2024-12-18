import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class LampDetailScreen extends StatefulWidget {
  final int lampId;

  LampDetailScreen({required this.lampId});

  @override
  _LampDetailScreenState createState() => _LampDetailScreenState();
}

class _LampDetailScreenState extends State<LampDetailScreen> {
  Map<String, dynamic> sensorData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestSensorData();
  }

  // Fungsi mengambil data sensor terbaru
  Future<void> fetchLatestSensorData() async {
    final url = Uri.parse('http://192.168.0.105:8080/sensor-data/latest/${widget.lampId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sensorData = data['data'];
          isLoading = false;
        });
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Hitung daya baterai (Watt)
  double calculatePower() {
    double voltage = double.tryParse(sensorData['BATT_VOLTAGE']?['value']?.toString() ?? '0') ?? 0;
    double current = double.tryParse(sensorData['BATT_CURRENT']?['value']?.toString() ?? '0') ?? 0;
    return voltage * current;
  }

  // Widget menampilkan teks sensor data justify
  Widget sensorDataItem(String title, String value) {
    return Container(
      width: double.infinity,
      child: Text(
        "$title: $value",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Lampu ${widget.lampId}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informasi Sensor Terbaru
                  Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Informasi Sensor Terbaru",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 8),
                          sensorDataItem("Baterai Tegangan", "${sensorData['BATT_VOLTAGE']?['value'] ?? '0'} V"),
                          sensorDataItem("Baterai Arus", "${sensorData['BATT_CURRENT']?['value'] ?? '0'} A"),
                          sensorDataItem("Daya Baterai", "${calculatePower().toStringAsFixed(2)} W"),
                          sensorDataItem("Tegangan Solar", "${sensorData['SOLAR_VOLTAGE']?['value'] ?? '0'} V"),
                          sensorDataItem("Arus Solar", "${sensorData['SOLAR_CURRENT']?['value'] ?? '0'} A"),
                          sensorDataItem("Tegangan Lampu", "${sensorData['LAMP_VOLTAGE']?['value'] ?? '0'} V"),
                          sensorDataItem("Arus Lampu", "${sensorData['LAMP_CURRENT']?['value'] ?? '0'} A"),
                        ],
                      ),
                    ),
                  ),

                  // Grafik Kapasitas Baterai
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Grafik Kapasitas Baterai (Daya dalam Watt)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 250,
                    margin: EdgeInsets.all(16),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${(value + 1).toInt()} Menit",
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 22,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${value.toInt()} W",
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 35,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black)),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, calculatePower() * 0.5),
                              FlSpot(1, calculatePower() * 0.75),
                              FlSpot(2, calculatePower() * 0.6),
                              FlSpot(3, calculatePower()),
                            ],
                            isCurved: true,
                            color: Colors.blueAccent,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blueAccent.withOpacity(0.3),
                            ),
                          ),
                        ],
                        minX: 0,
                        maxX: 3,
                        minY: 0,
                        maxY: calculatePower() * 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}