import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// TODO: Add a builder constructor. to avoid accessing non existing keys in the
// cache map.
//
// If you open the gallery screen without seeing all the items in the media
// screen, the cache will not conatin all the items in the paths list and thus
// the list will call methods on null.

/// A widget that shows a list of widgets and lets you navigate through them.
///
/// Touch events on individual items will make the list animate to show that
/// parituclar item in the center of the screen.
class Carousel extends StatefulWidget {
  /// The default spacing between items.
  static const kDefaultSeparatorSize = 10.0;

  /// The default size of the individual items in the carousel.
  static const kDefaultItemSize = 100.0;

  /// The size of the individual items to be shown.
  final double itemSize;

  /// The spacing between every item.
  final double spacing;

  /// The index of the item to be shown in the center.
  final int initialItem;

  /// The amount of items to be shown in the carousel.
  final int itemCount;

  /// Widgets to be shown in the carousel.
  final List<Widget> children;

  /// Function to the be called when the widget on the center of the screen]
  /// changes.
  final Function(int) onChanged;

  Carousel({
    this.itemSize = kDefaultItemSize,
    this.spacing = kDefaultSeparatorSize,
    this.initialItem = 0,
    this.itemCount,
    @required this.children,
    this.onChanged,
  }) {
    assert(children != null);
    assert(children.length > 0);
    if (itemCount != null) {
      assert(children.length == itemCount);
    }
    if (initialItem != 0) {
      assert(itemCount != null);
      assert(initialItem < itemCount);
    }
  }

  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  /// Spacing necessary to show the first and last items on the center of the
  /// screen.
  double _edgeSpacing;

  /// The space between each item of the carousel
  double _spaceBetweenItems;

  /// The controller for the underlaying [ListView].
  ScrollController _controller;

  /// Subject of the index of the center widget.
  BehaviorSubject<int> _widgetIndex;

  /// The current subscription to the BehaviorSubject.
  StreamSubscription<int> _subscription;

  initState() {
    super.initState();
    _spaceBetweenItems = widget.itemSize + widget.spacing;
    _widgetIndex = BehaviorSubject<int>(seedValue: widget.initialItem);
    _controller = ScrollController(
      initialScrollOffset: getOffsetFromIndex(widget.initialItem),
    );
    _controller.addListener(updateCurrentWidgetIndex);
  }

  void didUpdateWidget(Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSubscription();
  }

  Future<void> updateSubscription() async {
    if (_subscription != null) {
      await _subscription.cancel();
    }
    _subscription = _widgetIndex
        .debounce(Duration(milliseconds: 400))
        .listen((int index) => widget.onChanged(index));
  }

  /// Moves the item in index [itemIndex] to the center of the screen.
  void scrollToItem(int itemIndex) {
    final position = _spaceBetweenItems * itemIndex;
    _controller.animateTo(
      position,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
  }

  /// Gets the offset from the left of the screen necessary to center the item
  /// on [index] on the middle of the screen.
  double getOffsetFromIndex(int index) => _spaceBetweenItems * index;

  /// Adds a new item to the [_widgetIndex] subject if the the item on the
  /// center of the screen changes.
  void updateCurrentWidgetIndex() {
    int newWidgetIndex = getIndexFromScrollOffset(_controller.offset);
    if (newWidgetIndex != _widgetIndex.value) {
      _widgetIndex.sink.add(newWidgetIndex);
    }
  }

  /// Gets the index of the item in the middle of the screen from a given
  /// scroll offset.
  int getIndexFromScrollOffset(double scrollOffset) {
    int widgetIndex;
    if (scrollOffset < 0) {
      widgetIndex = 0;
    } else {
      // get the distance to the closest multiple of the
      final distanceFromLower = scrollOffset % _spaceBetweenItems;
      widgetIndex = scrollOffset ~/ _spaceBetweenItems;
      if (distanceFromLower > _spaceBetweenItems / 2) {
        widgetIndex += 1;
      }
    }
    return widgetIndex;
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _edgeSpacing = width / 2 - 50;

    List<Widget> listChildren = [];
    listChildren.add(SizedBox(width: _edgeSpacing));

    for (int i = 0; i < widget.children.length; i++) {
      listChildren.add(
        GestureDetector(
          onTap: () => scrollToItem(i),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: widget.itemSize,
            child: widget.children[i],
          ),
        ),
      );
      if (i != widget.children.length - 1) {
        listChildren.add(SizedBox(width: widget.spacing));
      }
    }

    listChildren.add(SizedBox(width: _edgeSpacing));

    return Container(
      height: widget.itemSize,
      child: ListView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: listChildren,
      ),
    );
  }
}
