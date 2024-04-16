import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample1 extends StatefulWidget {
  final int allTasks;
  final int doneTasks;

  const PieChartSample1({
    super.key,
    required this.allTasks,
    required this.doneTasks,
  });

  @override
  State<StatefulWidget> createState() =>
      PieChartSample1State(allTasks, doneTasks);
}

class PieChartSample1State extends State<PieChartSample1> {
  int allTasks;
  int doneTasks;
  int touchedIndex = -1;

  PieChartSample1State(this.allTasks, this.doneTasks);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections:
                      showingSections(allTasks: allTasks, doneTasks: doneTasks),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      {required int allTasks, required int doneTasks}) {
    return List.generate(
      2,
      (i) {
        const color0 = Colors.green;
        const color1 = Color(0xFF3787EB);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: doneTasks.toDouble(),
              // title: '$doneTasks',
              title: '',
              radius: 80,
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: (allTasks - doneTasks).toDouble(),
              // title: '${allTasks - doneTasks}',
              title: '',
              radius: 65,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }
}
