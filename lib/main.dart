import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'screens/fitness_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const FitnessMockupApp());

class FitnessMockupApp extends StatelessWidget {
  const FitnessMockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Mockup',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _DragAnywhereScrollBehavior(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'PlusJakartaSans',
      ),
      home: const MockupGallery(),
    );
  }
}

/// Pe desktop si web, `PageView` si listele orizontale nu raspund la drag cu
/// mouse-ul daca nu sunt declarate explicit aici.
class _DragAnywhereScrollBehavior extends MaterialScrollBehavior {
  const _DragAnywhereScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

class MockupGallery extends StatefulWidget {
  const MockupGallery({super.key});

  @override
  State<MockupGallery> createState() => _MockupGalleryState();
}

class _MockupGalleryState extends State<MockupGallery> {
  static const _screens = <({String label, Widget screen})>[
    (label: 'Home', screen: HomeScreen()),
    (label: 'Fitness', screen: FitnessScreen()),
  ];

  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  static const _frameSize = Size(375, 812);

  @override
  Widget build(BuildContext context) {
    final pages = PageView(
      controller: _controller,
      onPageChanged: (index) => setState(() => _index = index),
      children: [for (final item in _screens) item.screen],
    );

    final switcher = _ScreenSwitcher(
      labels: [for (final item in _screens) item.label],
      selectedIndex: _index,
      onSelected: _goTo,
    );

    final screen = MediaQuery.sizeOf(context);
    final fitsFrame =
        screen.width >= _frameSize.width + 96 &&
        screen.height >= _frameSize.height + 96;

    if (!fitsFrame) {
      return Scaffold(
        body: Stack(
          children: [
            pages,
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(child: switcher),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey25,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _frameSize.width,
              height: _frameSize.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 40,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: _frameSize,
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: pages,
              ),
            ),
            const SizedBox(height: 20),
            switcher,
          ],
        ),
      ),
    );
  }
}

class _ScreenSwitcher extends StatelessWidget {
  const _ScreenSwitcher({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => onSelected(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    labels[i],
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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
