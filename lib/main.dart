import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RaceGame());
  }
}

class RaceGame extends StatefulWidget {
  const RaceGame({Key? key}) : super(key: key);

  @override
  State<RaceGame> createState() => _RaceGameState();
}

class _RaceGameState extends State<RaceGame> with SingleTickerProviderStateMixin {
  // horizontal position in pixels from left
  double carX = 100.0;
  final double moveStep = 30.0;
  final double carWidth = 80.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void moveLeft() {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      carX = (carX - moveStep).clamp(0.0, screenWidth - carWidth);
    });
  }

  void moveRight() {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      carX = (carX + moveStep).clamp(0.0, screenWidth - carWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    // Adjust road layout depending on orientation so the road area makes sense
    final double roadTop = isLandscape ? 40.0 : 80.0;
    final double roadBottomPadding = isLandscape ? 100.0 : 120.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Race')),
      body: SafeArea(
        child: Stack(
          children: [
            // background: grass and road
            Container(color: Colors.green[700]),

            // road base
            Positioned(
              left: 0,
              right: 0,
              top: roadTop,
              bottom: 0,
              child: Container(color: Colors.grey[850]),
            ),

            // moving road markings (animated)
            Positioned(
              left: 0,
              right: 0,
              top: roadTop,
              bottom: roadBottomPadding,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RoadPainter(progress: _controller.value, isLandscape: isLandscape),
                    child: Container(),
                  );
                },
              ),
            ),

            // car image
            Positioned(
              left: carX.clamp(0.0, screenWidth - carWidth),
              bottom: roadBottomPadding,
              child: SizedBox(
                width: carWidth,
                height: carWidth * 2,
                child: Image.asset('assets/martin.png', fit: BoxFit.contain),
              ),
            ),

            // controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: moveLeft, child: const Text('Left')),
                  ElevatedButton(onPressed: moveRight, child: const Text('Right')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter draws road markings that scroll. It supports landscape (horizontal road)
// where markings are horizontal and scroll horizontally, and portrait (vertical road)
// where markings are vertical and scroll vertically.
class RoadPainter extends CustomPainter {
  final double progress; // 0.0 .. 1.0
  final bool isLandscape;
  RoadPainter({required this.progress, required this.isLandscape});

  @override
  void paint(Canvas canvas, Size size) {
    if (isLandscape) {
      _paintHorizontalRoad(canvas, size);
    } else {
      _paintVerticalRoad(canvas, size);
    }
  }

  void _paintHorizontalRoad(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const double dashWidth = 40.0; // horizontal length of each dash
    const double dashHeight = 6.0; // thickness
    const double rowSpacing = 40.0; // vertical spacing between dash rows
    const double horizSpacing = 100.0; // spacing between dashes horizontally

    final double centerY = size.height / 2;

    // Draw several rows (above and below center) so road looks filled
    for (double y = 10.0; y < size.height - 10.0; y += rowSpacing) {
      final double rowOffset = (y / rowSpacing) * 8.0;
      final double shift = (progress * horizSpacing) + rowOffset;

      for (double x = -horizSpacing * 2; x < size.width + horizSpacing * 2; x += horizSpacing) {
        double dx = x + (shift % horizSpacing);
        final rect = Rect.fromLTWH(dx, y, dashWidth, dashHeight);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
        canvas.drawRRect(rrect, paint);
      }
    }

    // optional center longer dashes
    final paintCenter = Paint()..color = Colors.white70;
    const double centerDashW = 24.0;
    const double centerSpacing = 80.0;
    final double centerShift = (progress * centerSpacing);
    for (double x = -centerSpacing; x < size.width + centerSpacing; x += centerSpacing) {
      double dx = x + (centerShift % centerSpacing);
      final rect = Rect.fromLTWH(dx, centerY - 10.0, centerDashW, 20.0);
      canvas.drawRect(rect, paintCenter);
    }
  }

  void _paintVerticalRoad(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const double dashHeight = 30.0; // vertical length of each dash
    const double dashWidth = 6.0; // thickness
    const double colSpacing = 40.0; // horizontal spacing between columns of dashes
    const double vertSpacing = 100.0; // spacing between dashes vertically

    final double centerX = size.width / 2;

    // Draw columns of vertical dashes (centered around centerX) and scroll them downward
    for (double x = 10.0; x < size.width - 10.0; x += colSpacing) {
      final double colOffset = (x / colSpacing) * 8.0;
      final double shift = (progress * vertSpacing) + colOffset;

      for (double y = -vertSpacing * 2; y < size.height + vertSpacing * 2; y += vertSpacing) {
        double dy = y + (shift % vertSpacing);
        final rect = Rect.fromLTWH(x, dy, dashWidth, dashHeight);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
        canvas.drawRRect(rrect, paint);
      }
    }

    // optional center column longer dashes
    final paintCenter = Paint()..color = Colors.white70;
    const double centerDashH = 20.0;
    const double centerSpacing = 60.0;
    final double centerShift = (progress * centerSpacing);
    for (double y = -centerSpacing; y < size.height + centerSpacing; y += centerSpacing) {
      double dy = y + (centerShift % centerSpacing);
      final rect = Rect.fromLTWH(centerX - 6.0, dy, 12.0, centerDashH);
      canvas.drawRect(rect, paintCenter);
    }
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isLandscape != isLandscape;
}
