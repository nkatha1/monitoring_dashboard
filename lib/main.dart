import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MonitoringApp());
}

/// Root widget
class MonitoringApp extends StatelessWidget {
  const MonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

/// Dashboard page with live metrics
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late IO.Socket socket;

  // Current metrics
  int cpuUsage = 0;
  int memoryUsage = 0;
  int requestRate = 0;

  // Historical metrics for charts (last 30 points)
  final List<MetricPoint> cpuHistory = [];
  final List<MetricPoint> memoryHistory = [];
  final List<MetricPoint> requestHistory = [];

  @override
  void initState() {
    super.initState();

    // Connect to backend WebSocket
    socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    // Listen for metrics
    socket.on('metrics', (data) {
      final now = DateTime.now();
      setState(() {
        cpuUsage = data['cpu'];
        memoryUsage = data['memory'];
        requestRate = data['requests'];

        // Add to historical data
        cpuHistory.add(MetricPoint(time: now, value: cpuUsage.toDouble()));
        memoryHistory.add(MetricPoint(time: now, value: memoryUsage.toDouble()));
        requestHistory.add(MetricPoint(time: now, value: requestRate.toDouble()));

        // Keep last 30 points
        if (cpuHistory.length > 30) cpuHistory.removeAt(0);
        if (memoryHistory.length > 30) memoryHistory.removeAt(0);
        if (requestHistory.length > 30) requestHistory.removeAt(0);
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  /// Widget for a colored metric card
  Widget metricCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 12),
              Text(value,
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget to draw line chart for historical metrics
  Widget metricChart(String title, List<MetricPoint> data, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 10)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      // show only last 6 points labels
                      return Text('');
                    },
                  )),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length,
                        (index) => FlSpot(index.toDouble(), data[index].value)),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
                minY: 0,
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Monitoring Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Row of cards
            Row(
              children: [
                metricCard('CPU Usage', '$cpuUsage %', Colors.red),
                metricCard('Memory Usage', '$memoryUsage %', Colors.green),
                metricCard('Requests/sec', '$requestRate', Colors.blue),
              ],
            ),

            // Charts for historical metrics
            metricChart('CPU Usage (last 30s)', cpuHistory, Colors.red),
            metricChart('Memory Usage (last 30s)', memoryHistory, Colors.green),
            metricChart('Requests/sec (last 30s)', requestHistory, Colors.blue),
          ],
        ),
      ),
    );
  }
}

/// Class to store a metric value at a specific time
class MetricPoint {
  final DateTime time;
  final double value;
  MetricPoint({required this.time, required this.value});
}