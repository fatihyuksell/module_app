import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:module_app/common/widgets/reusable_app_bar.dart';

class DetailsView extends StatefulWidget {
  final String? id;
  const DetailsView({super.key, this.id});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final List<FlSpot> spots = [];
  Timer? _timer;
  final int maxDataPoints = 30;
  double lastX = 0;
  int updateCount = 0;
  int updatesPerSecond = 0;
  int _tempUpdateCount = 0;
  final List<double> recentValues = [];
  final int maxRecentValues = 5;
  final List<Color> gradientColors = [
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.green,
  ];
  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _startDataStream();
    _startUpdateCounter();
  }

  void _startUpdateCounter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          updatesPerSecond = _tempUpdateCount;
          _tempUpdateCount = 0;
        });
      }
    });
  }

  void _startDataStream() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          double newValue = spots.isEmpty
              ? Random().nextDouble() * 10
              : (spots.last.y + Random().nextDouble() * 2 - 1).clamp(0, 10);

          spots.add(FlSpot(lastX, newValue));
          lastX += 0.5;

          // Son değerleri kaydet
          recentValues.insert(0, newValue);
          if (recentValues.length > maxRecentValues) {
            recentValues.removeLast();
          }

          if (spots.length > maxDataPoints) {
            spots.removeAt(0);
            for (int i = 0; i < spots.length; i++) {
              spots[i] = FlSpot(i * 0.5, spots[i].y);
            }
            lastX = spots.last.x;
          }

          // Her 20 güncelleme de bir renk değişimi
          if (updateCount % 20 == 0) {
            currentColorIndex = (currentColorIndex + 1) % gradientColors.length;
          }

          updateCount++;
          _tempUpdateCount++;
        });
      }
    });
  }

  List<Color> _getCurrentGradientColors() {
    final firstColor = gradientColors[currentColorIndex];
    final secondColor =
        gradientColors[(currentColorIndex + 1) % gradientColors.length];
    return [firstColor, secondColor];
  }

  @override
  Widget build(BuildContext context) {
    final currentColors = _getCurrentGradientColors();

    return Scaffold(
      appBar: const ReusableAppBar(title: 'Live Data Stream'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Üst bilgi kartları
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Total Updates',
                      '$updateCount',
                      Icons.update,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      'Updates/s',
                      '$updatesPerSecond',
                      Icons.speed,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      'Last Value',
                      spots.isNotEmpty ? spots.last.y.toStringAsFixed(2) : '0',
                      Icons.show_chart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Son değerler listesi
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentValues.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: _getColorForValue(recentValues[index]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recentValues[index].toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Ana grafik
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 40,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        gradient: LinearGradient(
                          colors: currentColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        barWidth: 2.5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              currentColors[0].withOpacity(0.2),
                              currentColors[1].withOpacity(0.2),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        isStrokeCapRound: true,
                      ),
                    ],
                    minX: spots.isEmpty ? 0 : spots.first.x,
                    maxX: spots.isEmpty ? 0 : spots.last.x,
                    minY: 0,
                    maxY: 10,
                    clipData: const FlClipData.all(),
                    lineTouchData: const LineTouchData(enabled: false),
                  ),
                  duration: const Duration(milliseconds: 0),
                ),
              ),

              // Bilgilendirme widget'ı
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The data in this graph is generated for real-time simulation purposes. The values ​​shown are randomly generated and do not reflect actual data.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForValue(double value) {
    if (value < 3.33) return Colors.red;
    if (value < 6.66) return Colors.orange;
    return Colors.green;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
