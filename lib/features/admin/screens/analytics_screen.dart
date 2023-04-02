import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  final List<PricePoint> points = [
    PricePoint(x: 10, y: 1.0),
    PricePoint(x: 10, y: 1.0),
    PricePoint(x: 10, y: 1.0),
    PricePoint(x: 10, y: 1.0),
  ];

  int? totalSales;
  List<Sales>? earnings;
  @override
  void initState() {
    getEarnings();
    super.initState();
  }

  getEarnings() async {
    var earningData = await adminServices.getAnalytics(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              // Text('\$${totalSales}'),
              AspectRatio(
                aspectRatio: 2,
                child: BarChart(
                  BarChartData(
                    barGroups: _chartGroups(),
                    borderData: FlBorderData(
                        border: const Border(
                            bottom: BorderSide(), left: BorderSide())),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                      // leftTitles:
                      //     AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      // topTitles:
                      //     AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      // rightTitles:
                      //     AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              )
            ],
          );
  }

  List<BarChartGroupData> _chartGroups() {
    return earnings!
        .map((point) => BarChartGroupData(
            x: int.parse(point.earning),
            barRods: [BarChartRodData(toY: double.parse(point.earning))]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = 'Essentials';
              break;
            case 2:
              text = 'Mobiles';
              break;
            case 4:
              text = 'May';
              break;
            case 6:
              text = 'Jul';
              break;
            case 8:
              text = 'Sep';
              break;
            case 10:
              text = 'Nov';
              break;
          }

          return Text(text);
        },
      );
}

class PricePoint {
  int x;
  dynamic y;
  PricePoint({
    required this.x,
    required this.y,
  });
}
