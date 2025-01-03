import 'package:flutter/material.dart';

class ThreePageScroller extends StatefulWidget {
  final Widget? next;
  final Widget current;
  final Widget? previous;
  final Function(int) onPageChanged;

  const ThreePageScroller({
    super.key,
    this.next,
    required this.current,
    this.previous,
    required this.onPageChanged,
  });

  @override
  State<ThreePageScroller> createState() => _ThreePageScrollerState();
}

class _ThreePageScrollerState extends State<ThreePageScroller> {
  late PageController _pageController;

  double? _currentItemHeight;
  late int currentPage;

  @override
  void initState() {
    super.initState();

    currentPage = widget.previous == null ? 0 : 1;
    _pageController = PageController(initialPage: currentPage);

    _pageController.addListener(() {
      final newPage = _pageController.page?.toInt();
      // Wait for page scroll to finish
      if (newPage == null || newPage.toDouble() != _pageController.page) return;

      if (newPage == currentPage) {
        return;
      }

      _pageController.jumpToPage(1);
      widget.onPageChanged(newPage > currentPage ? 1 : -1);
      currentPage = 1;
    });
  }

  @override
  void didUpdateWidget(covariant ThreePageScroller oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.previous != oldWidget.previous) {
      final newPage = widget.previous == null ? 0 : 1;
      if (newPage != currentPage) {
        currentPage = newPage;
        _pageController.jumpToPage(newPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: SizeReportingWidget(
            child: widget.current,
            onSizeChange: (size) {
              setState(() {
                _currentItemHeight = size.height;
              });
            },
          ),
        ),
        SizedBox(
          height: _currentItemHeight ?? 0,
          child: PageView(
            controller: _pageController,
            physics: const FastPageViewScrollPhysics(),
            children: [
              if (widget.previous != null) widget.previous!,
              widget.current,
              if (widget.next != null) widget.next!,
            ],
          ),
        ),
      ],
    );
  }
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    final size = context.size;
    if (size != null && _oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}

class FastPageViewScrollPhysics extends ScrollPhysics {
  const FastPageViewScrollPhysics({super.parent});

  @override
  FastPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}
