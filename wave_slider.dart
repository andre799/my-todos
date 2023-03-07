import 'package:flutter/material.dart';
import 'package:suitup/suitup.dart';

typedef CallbackSelection = void Function(double duration);

class WaveSlider extends StatefulWidget {
  final double widthWaveSlider;
  final double heightWaveSlider;
  final Color wavActiveColor;
  final Color wavDeactiveColor;
  final Color sliderColor;
  final Color backgroundColor;
  final Color positionTextColor;
  final double duration;
  final double currentPlayingPosition;
  final CallbackSelection callbackStart;
  final CallbackSelection callbackEnd;
  final CallbackSelection onBarClick;
  const WaveSlider({
    Key? key,
    required this.duration,
    required this.currentPlayingPosition,
    required this.callbackStart,
    required this.callbackEnd,
    required this.onBarClick,
    this.widthWaveSlider = 0,
    this.heightWaveSlider = 0,
    this.wavActiveColor = Colors.deepPurple,
    this.wavDeactiveColor = Colors.blueGrey,
    this.sliderColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.positionTextColor = Colors.black,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double widthSlider = 300;
  double heightSlider = 80;
  static const barWidth = 5.0;
  static const selectBarWidth = 20.0;
  double barStartPosition = 0.0;
  double barEndPosition = 50;
  final bars = <int>[];
  final musicDurationChunks = <double>[];
  final double timeIndicatorHeight = 18;
  final double timeIndicatorWidth = 44;

  final scrollController = ScrollController();

  // Time strings
  var startTime = '0:00';
  var endTime = '';

  bool barInsideReprodution(int index) => musicDurationChunks[index] <= widget.currentPlayingPosition;

  @override
  void initState() {
    super.initState();

    final width = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide;

    final durationSplitted = (widget.duration / 60) - 2;
    final pixelsToExpand = durationSplitted < 0 ? 0 : (durationSplitted * (width / 2));

    var shortSize = width + pixelsToExpand;

    widthSlider = (widget.widthWaveSlider < 50) ? (shortSize - 2 - 40) : widget.widthWaveSlider;
    heightSlider = (widget.heightWaveSlider < 50) ? 80 : widget.heightWaveSlider;
    barEndPosition = (widthSlider - selectBarWidth);

    final range = widthSlider / barWidth;
    final chunkSize = widget.duration / range;

    musicDurationChunks.insert(0, 0);

    for (var i = 0; i < range; i++) {
      if (i % 2 == 0) {
        bars.add(i % 4 == 0 ? 12 : 18);
        if (i != 0) musicDurationChunks.add(chunkSize * i);
      }
    }

    while (_getEndTime() > 60) {
      barEndPosition -= 1;
    }

    endTime = _timeFormatter(_getEndTime());

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final startScrolll = scrollController.position.pixels;
    final finalScroll = startScrolll + MediaQuery.of(context).size.width;

    final initialStartBar = barStartPosition;
    final initialEndBar = barEndPosition;

    if (startScrolll > barStartPosition) {
      var pixelsToScroll = 0;
      var barStartPosition = this.barStartPosition;

      // Adding 8 to padding
      while (barStartPosition < (startScrolll + 8)) {
        barStartPosition++;
        pixelsToScroll++;
      }

      setState(() {
        this.barStartPosition = barStartPosition;
        startTime = _timeFormatter(_getStartTime());
        endTime = _timeFormatter(_getEndTime());
        if (barEndPosition + pixelsToScroll <= widthSlider) barEndPosition += pixelsToScroll;
      });
    } else if (barEndPosition + barWidth + 32 > finalScroll) {
      var pixelsToScroll = 0;
      var barEndPosition = this.barEndPosition;

      // Subtracting 8 from padding
      while (barEndPosition + barWidth + 32 > (finalScroll - 8)) {
        barEndPosition--;
        pixelsToScroll++;
      }

      setState(() {
        this.barEndPosition = barEndPosition;
        startTime = _timeFormatter(_getStartTime());
        endTime = _timeFormatter(_getEndTime());
        if (barStartPosition - pixelsToScroll >= 0) barStartPosition -= pixelsToScroll;
      });
    }

    while ((_getEndTime() - _getStartTime()) > 60) {
      barEndPosition -= 1;
    }

    if (initialStartBar != barStartPosition || initialEndBar != barEndPosition) {
      widget.callbackEnd(_getEndTime().toDouble());
      widget.callbackStart(_getStartTime().toDouble());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double _getBarStartPosition() {
    return ((barEndPosition) < barStartPosition) ? barEndPosition : barStartPosition;
  }

  double _getBarEndPosition() {
    return ((barStartPosition + selectBarWidth) > barEndPosition)
        ? (barStartPosition + selectBarWidth)
        : barEndPosition;
  }

  int _getStartTime() {
    return _getBarStartPosition() ~/ (widthSlider / widget.duration);
  }

  int _getEndTime() {
    return ((_getBarEndPosition() + selectBarWidth) / (widthSlider / widget.duration)).ceilToDouble().toInt();
  }

  String _timeFormatter(int second) {
    Duration duration = Duration(seconds: second);

    List<int> durations = [];
    if (duration.inHours > 0) {
      durations.add(duration.inHours);
    }
    durations.add(duration.inMinutes);
    durations.add(duration.inSeconds);

    var minInserted = false;

    return durations.map((seg) {
      final value = seg.remainder(60).toString().padLeft(!minInserted ? 1 : 2, '0');
      minInserted = true;
      return value;
    }).join(':');
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: widthSlider,
          height: heightSlider,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: _getBarStartPosition() >= 0.0 ? _getBarStartPosition() : 0.0,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: timeIndicatorHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: timeIndicatorHeight,
                            maxWidth: timeIndicatorWidth,
                          ),
                          decoration: BoxDecoration(
                            color: Suitup.colors.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_left_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                      startTime,
                                      style: Suitup.text.body1Bold.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: widget.backgroundColor,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      // Decoration CenterBar (White)
                      CenterBar(
                        decoration: true,
                        position: _getBarStartPosition() + selectBarWidth,
                        width: _getBarEndPosition() - _getBarStartPosition() - selectBarWidth,
                        callback: (details) {
                          var tmp1 = barStartPosition + details.delta.dx;
                          var tmp2 = barEndPosition + details.delta.dx;
                          if ((tmp1 > 0) && ((tmp2 + selectBarWidth) < widthSlider)) {
                            setState(() {
                              barStartPosition += details.delta.dx;
                              barEndPosition += details.delta.dx;
                              startTime = _timeFormatter(_getStartTime());
                              endTime = _timeFormatter(_getEndTime());
                            });
                          }
                        },
                        callbackEnd: (details) {
                          widget.callbackStart(_getStartTime().toDouble());
                          widget.callbackEnd(_getEndTime().toDouble());
                        },
                      ),

                      // Waves
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: bars.map((int height) {
                          Color color = barInsideReprodution(i) ? widget.wavActiveColor : Suitup.colors.secondary[50]!;

                          final currentIndex = i;
                          i++;

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: InkWell(
                              key: ValueKey<String>('$currentIndex-${barInsideReprodution(currentIndex)}'),
                              onTap: () => widget.onBarClick(musicDurationChunks[currentIndex]),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  height: (height.toDouble() < 12 ? 12 : height.toDouble()),
                                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                                  width: 5.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // CenterBar to drag
                      CenterBar(
                        position: _getBarStartPosition() + selectBarWidth,
                        width: _getBarEndPosition() - _getBarStartPosition() - selectBarWidth,
                        onTap: () => widget.callbackStart(_getStartTime().toDouble()),
                        callback: (details) {
                          var tmp1 = barStartPosition + details.delta.dx;
                          var tmp2 = barEndPosition + details.delta.dx;
                          if ((tmp1 > 0) && ((tmp2 + selectBarWidth) < widthSlider)) {
                            setState(() {
                              barStartPosition += details.delta.dx;
                              barEndPosition += details.delta.dx;
                              startTime = _timeFormatter(_getStartTime());
                              endTime = _timeFormatter(_getEndTime());
                            });
                          }
                        },
                        callbackEnd: (details) {
                          while ((_getEndTime() - _getStartTime()) > 60) {
                            barEndPosition -= 1;
                          }

                          setState(() {
                            startTime = _timeFormatter(_getStartTime());
                            endTime = _timeFormatter(_getEndTime());
                          });

                          widget.callbackStart(_getStartTime().toDouble());
                          widget.callbackEnd(_getEndTime().toDouble());
                        },
                      ),

                      // Left Bar
                      Bar(
                        position: _getBarStartPosition(),
                        colorBG: widget.sliderColor,
                        width: selectBarWidth,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                        ),
                        callback: (DragUpdateDetails details) {
                          var tmp = barStartPosition + details.delta.dx;
                          if ((barEndPosition - selectBarWidth) > tmp && (tmp >= 0)) {
                            final barStartPosition = this.barStartPosition + details.delta.dx;
                            final startTime = _timeFormatter(_getStartTime());

                            if ((_getEndTime() - _getStartTime()) < 60 || barStartPosition > this.barStartPosition) {
                              while ((_getEndTime() - _getStartTime()) > 60) {
                                barEndPosition -= 1;
                              }

                              setState(() {
                                this.barStartPosition = barStartPosition;
                                this.startTime = startTime;
                              });
                            }
                          }
                        },
                        callbackEnd: (details) {
                          widget.callbackStart(_getStartTime().toDouble());
                        },
                      ),

                      // Right Bar
                      Bar(
                        position: _getBarEndPosition(),
                        colorBG: widget.sliderColor,
                        width: selectBarWidth,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                        ),
                        callback: (DragUpdateDetails details) {
                          var tmp = barEndPosition + details.delta.dx;
                          if ((barStartPosition + selectBarWidth) < tmp && (tmp + selectBarWidth) <= widthSlider) {
                            final barEndPosition = this.barEndPosition + details.delta.dx;

                            if ((_getEndTime() - _getStartTime()) < 60 || barEndPosition < this.barEndPosition) {
                              while ((_getEndTime() - _getStartTime()) > 60) {
                                this.barEndPosition -= 1;
                              }

                              setState(() {
                                this.barEndPosition = barEndPosition;
                                endTime = _timeFormatter(_getEndTime());
                              });
                            }
                          }
                        },
                        callbackEnd: (details) {
                          widget.callbackEnd(_getEndTime().toDouble());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: (_getBarEndPosition() + (barWidth * 4) - timeIndicatorWidth) < 0
                        ? 0
                        : _getBarEndPosition() + (barWidth * 4) - timeIndicatorWidth,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: timeIndicatorHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: timeIndicatorHeight,
                            maxWidth: (_getBarEndPosition() + (barWidth * 2) - timeIndicatorWidth) < 0
                                ? timeIndicatorWidth + (_getBarEndPosition() + (barWidth * 2) - timeIndicatorWidth)
                                : timeIndicatorWidth,
                          ),
                          decoration: BoxDecoration(
                            color: Suitup.colors.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                      endTime,
                                      style: Suitup.text.body1Bold.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CenterBar extends StatelessWidget {
  final double position;
  final double width;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback? callbackEnd;
  final VoidCallback? onTap;
  final bool decoration;

  const CenterBar(
      {Key? key,
      required this.position,
      required this.width,
      required this.callback,
      required this.callbackEnd,
      this.onTap,
      this.decoration = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: position >= 0.0 ? position : 0.0),
      child: decoration
          ? Container(
              color: Colors.white,
              // height: 200.0,
              width: width,
              child: Column(
                children: [
                  Container(height: 4, color: Suitup.colors.primary),
                  Expanded(child: Container()),
                  Container(height: 4, color: Suitup.colors.primary),
                ],
              ),
            )
          : GestureDetector(
              onHorizontalDragUpdate: callback,
              onHorizontalDragEnd: callbackEnd,
              onTap: onTap,
              child: Container(
                color: Colors.transparent,
                // height: 200.0,
                width: width,
                child: Column(
                  children: [
                    Container(height: 4, color: Suitup.colors.primary),
                    Expanded(child: Container()),
                    Container(height: 4, color: Suitup.colors.primary),
                  ],
                ),
              ),
            ),
    );
  }
}

class Bar extends StatelessWidget {
  final double position;
  final Color? colorBG;
  final double width;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback? callbackEnd;
  final BorderRadiusGeometry borderRadius;

  const Bar(
      {Key? key,
      required this.position,
      required this.width,
      required this.callback,
      required this.callbackEnd,
      required this.borderRadius,
      this.colorBG})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: position >= 0.0 ? position : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          decoration: BoxDecoration(
            color: colorBG ?? Colors.red,
            borderRadius: borderRadius,
          ),
          height: double.infinity,
          width: width,
          child: Center(
            child: Container(
              width: 2.5,
              height: 15,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
      ),
    );
  }
}
