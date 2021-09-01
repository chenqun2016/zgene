// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zgene/constant/color_constant.dart';

// TODO(dragostis): Missing functionality:
//   * mobile horizontal mode with adding/removing steps
//   * alternative labeling
//   * stepper feedback in the case of high-latency interactions

/// The state of a [Step] which is used to control the style of the circle and
/// text.
///
/// See also:
///
///  * [Step]
enum EStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a pencil icon in its circle.
  editing,

  /// A step that displays a tick icon in its circle.
  complete,

  /// A step that is disabled and does not to react to taps.
  disabled,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

/// Defines the [Stepper]'s main axis.
enum EStepperType {
  /// A vertical layout of the steps with their content in-between the titles.
  vertical,

  /// A horizontal layout of the steps with their content below the titles.
  horizontal,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: _kStepFontSize,
  color: ColorConstant.Text_B2BAC6,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0
const double _kStepFontSize = 14.0;

/// A material step used in [Stepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
///
/// See also:
///
///  * [Stepper]
///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class EStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const EStep({
    this.title,
    this.subtitle,
    this.content,
    this.state = EStepState.indexed,
    this.isActive = false,
  })  : assert(content != null),
        assert(state != null);

  ///assert(title != null),

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final EStepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;
}

/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// {@tool sample --template=stateful_widget_scaffold_center}
///
/// ```dart
/// int _index = 0;
///
/// @override
/// Widget build(BuildContext context) {
///   return Stepper(
///     currentStep: _index,
///     onStepCancel: () {
///       if (_index > 0) {
///         setState(() { _index -= 1; });
///       }
///     },
///     onStepContinue: () {
///       if (_index <= 0) {
///         setState(() { _index += 1; });
///       }
///     },
///     onStepTapped: (int index) {
///       setState(() { _index = index; });
///     },
///     steps: <Step>[
///       Step(
///         title: const Text('Step 1 title'),
///         content: Container(
///           alignment: Alignment.centerLeft,
///           child: const Text('Content for Step 1')
///         ),
///       ),
///       const Step(
///         title: Text('Step 2 title'),
///         content: Text('Content for Step 2'),
///       ),
///     ],
///   );
/// }
/// ```
///
/// {@end-tool}
///
/// See also:
///
///  * [Step]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class EStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps], [type], and [currentStep] arguments must not be null.
  const EStepper(
      {Key key,
      this.steps,
      this.physics,
      this.type = EStepperType.vertical,
      this.currentStep = 0,
      this.onStepTapped,
      this.onStepContinue,
      this.onStepCancel,
      this.controlsBuilder,
      this.stepperWidth,
      this.isVerticalAnimatedCrossFade = true,
      this.showEditingIcon = true,
      this.showcompleteIcon = true})
      : assert(steps != null),
        assert(type != null),
        assert(currentStep != null),
        assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  final bool showEditingIcon;

  final bool showcompleteIcon;

  ///垂直模式下，内容是否增加动效
  final bool isVerticalAnimatedCrossFade;

  ///EStepperType.horizontal模式下 顶部step的总宽
  final double stepperWidth;

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<EStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final EStepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int> onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback onStepCancel;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions: [onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  /// For example, keeping track of the [currentStep] within the callback can
  /// change the text of the continue or cancel button depending on which step users are at.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }) {
  ///          return Row(
  ///            children: <Widget>[
  ///              TextButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('NEXT'),
  ///              ),
  ///              TextButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final ControlsWidgetBuilder controlsBuilder;

  @override
  _StepperState createState() => _StepperState();
}

class _StepperState extends State<EStepper> with TickerProviderStateMixin {
  List<GlobalKey> _keys;
  final Map<int, EStepState> _oldStates = <int, EStepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1)
      _oldStates[i] = widget.steps[i].state;
  }

  @override
  void didUpdateWidget(EStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1)
      _oldStates[i] = oldWidget.steps[i].state;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildLine(bool visible, int index) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 20.0,
      color: _getLineColor(index),
    );
    // return Expanded(
    //   flex: 1,
    //   child: Container(
    //     width: visible ? 1.0 : 0.0,
    //     color: _getLineColor(index),
    //   ),
    // );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final EStepState state =
        oldState ? _oldStates[index] : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    assert(state != null);
    switch (state) {
      case EStepState.indexed:
      case EStepState.disabled:
        return Text(
          '${index + 1}',
          // style: isDarkActive
          //     ? _kStepStyle.copyWith(color: Colors.black87)
          //     : _kStepStyle,
          style: _kStepStyle,
        );
      case EStepState.editing:
        if (widget.showEditingIcon) {
          return Icon(
            Icons.edit,
            color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
            size: 18.0,
          );
        }
        if (widget.showcompleteIcon) {
          return Icon(
            Icons.check,
            color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
            size: 18.0,
          );
        }
        return Text(
          '${index + 1}',
          style: _kStepStyle.copyWith(color: Colors.white),
        );

      case EStepState.complete:
        if (widget.showcompleteIcon) {
          return Icon(
            Icons.check,
            color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
            size: 18.0,
          );
        }
        return Text(
          '${index + 1}',
          style: _kStepStyle.copyWith(color: Colors.white),
        );

      case EStepState.error:
        return const Text('!',
            style: TextStyle(
              fontSize: _kStepFontSize,
              color: Colors.white,
            ));
    }
  }

  Color _circleColor(int index) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // if (!_isDark()) {
    //   return widget.steps[index].isActive
    //       ? colorScheme.primary
    //       : colorScheme.onSurface.withOpacity(0.38);
    // } else {
    //   return widget.steps[index].isActive
    //       ? colorScheme.secondary
    //       : colorScheme.background;
    // }
    return widget.steps[index].state == EStepState.indexed
        ? Colors.white
        : ColorConstant.TextMainColor;
  }

  Widget _buildCircle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(
              index, oldState && widget.steps[index].state == EStepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height: _kTriangleHeight,
          // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(0.0, 0.8),
              // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(index,
                  oldState && widget.steps[index].state != EStepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == EStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != EStepState.error)
        return _buildCircle(index, false);
      else
        return _buildTriangle(index, false);
    }
  }

  Widget _buildVerticalControls() {
    if (widget.controlsBuilder != null)
      return widget.controlsBuilder(context,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel);

    Color cancelColor;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            TextButton(
              onPressed: widget.onStepContinue,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : (_isDark()
                          ? colorScheme.onSurface
                          : colorScheme.onPrimary);
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return _isDark() || states.contains(MaterialState.disabled)
                      ? null
                      : colorScheme.primary;
                }),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    buttonPadding),
                shape: MaterialStateProperty.all<OutlinedBorder>(buttonShape),
              ),
              child: Text(localizations.continueButtonLabel),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(
                  primary: cancelColor,
                  padding: buttonPadding,
                  shape: buttonShape,
                ),
                child: Text(localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case EStepState.indexed:
      case EStepState.editing:
      case EStepState.complete:
        return textTheme.bodyText1;
      case EStepState.disabled:
        return textTheme.bodyText1.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case EStepState.error:
        return textTheme.bodyText1.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case EStepState.indexed:
      case EStepState.editing:
      case EStepState.complete:
        return textTheme.caption;
      case EStepState.disabled:
        return textTheme.caption.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case EStepState.error:
        return textTheme.caption.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.steps[index].subtitle,
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                // Line parts are always added in order for the ink splash to
                // flood the tips of the connector lines.
                _buildLine(!_isFirst(index), index),
                _buildIcon(index),
                Expanded(child: _buildLine(!_isLast(index), index + 1)),
              ],
            ),
            if (widget.steps[index].title != null)
              Expanded(
                child: Container(
                  margin: const EdgeInsetsDirectional.only(start: 12.0),
                  child: _buildHeaderText(index),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: _getLineColor(index + 1),
                ),
              ),
            ),
          ),
        ),
        widget.isVerticalAnimatedCrossFade
            ? AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: _buildVerticalBodyContent(index),
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isCurrent(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: kThemeAnimationDuration,
              )
            : _buildVerticalBodyContent(index),
      ],
    );
  }

  Widget _buildVerticalBodyContent(int index) {
    return Container(
      margin: const EdgeInsetsDirectional.only(
        start: 60.0,
        end: 24.0,
        bottom: 4.0,
      ),
      child: Column(
        children: <Widget>[
          widget.steps[index].content,
          _buildVerticalControls(),
        ],
      ),
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.steps[i].state != EStepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        widget.onStepTapped?.call(i);
                      }
                    : null,
                canRequestFocus: widget.steps[i].state != EStepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  _getLineColor(int index) {
    if (index >= widget.steps.length || index < 0) {
      return Colors.white;
    }
    return widget.steps[index].state == EStepState.indexed
        ? Colors.white
        : ColorConstant.TextMainColor;
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        if (!_isFirst(i))
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              height: 1.0,
              color: _getLineColor(i),
            ),
          ),
        InkResponse(
          onTap: widget.steps[i].state != EStepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != EStepState.disabled,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 72.0,
                child: Center(
                  child: _buildIcon(i),
                ),
              ),
              if (widget.steps[i].title != null)
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 12.0),
                  child: _buildHeaderText(i),
                ),
            ],
          ),
        ),
      ],
    ];

    return Column(
      children: <Widget>[
        Container(
          width: widget.stepperWidth,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: children,
          ),
        ),
        Column(
          children: <Widget>[
            AnimatedSize(
              curve: Curves.fastOutSlowIn,
              duration: kThemeAnimationDuration,
              vsync: this,
              child: widget.steps[widget.currentStep].content,
            ),
            _buildVerticalControls(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null)
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      return true;
    }());
    assert(widget.type != null);
    switch (widget.type) {
      case EStepperType.vertical:
        return _buildVertical();
      case EStepperType.horizontal:
        return _buildHorizontal();
    }
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}
