import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InteractivePieChart extends StatefulWidget {
  final Map<String, double> paymentData;
  const InteractivePieChart({super.key, required this.paymentData});

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final filteredData = widget.paymentData.entries.where((entry) => entry.value > 0).toMap();
    double total = filteredData.values.fold(0, (sum, value) => sum + value);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          width: 300,
          child: PieChart(
            PieChartData(
              sections: _buildSections(filteredData, total),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    touchedIndex = response?.touchedSection?.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(filteredData),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(Map<String, double> data, double total) {
    return data.entries.mapIndexed((index, entry) {
      double percentage = (entry.value / total) * 100;
      bool isTouched = index == touchedIndex;
      double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value,
        title: '',
        radius: radius,
        badgeWidget: _buildPercentageBadge('${percentage.toStringAsFixed(1)}%'),
        badgePositionPercentageOffset: 1.5,
      );
    }).toList();
  }

  Widget _buildPercentageBadge(String percentage) {
    return Text(
      percentage,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLegend(Map<String, double> data) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: data.keys.map((key) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: _getColor(key),
            ),
            const SizedBox(width: 8),
            Text(key),
          ],
        );
      }).toList(),
    );
  }

  Color _getColor(String label) {
    switch (label) {
      case "Tiền mặt":
        return Colors.teal;
      case "Chuyển khoản":
        return Colors.indigoAccent.shade400;
      case "Momo":
        return Colors.purple.shade700;
      case "Visa/Master":
        return Colors.orange.shade800;
      case "ZaloPay":
        return Colors.blueAccent.shade400;
      case "VNPay":
        return Colors.deepOrangeAccent.shade400;
      default:
        return Colors.grey;
    }
  }
}

extension MapExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() {
    return {for (var entry in this) entry.key: entry.value};
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}
