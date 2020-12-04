import 'package:flutter/material.dart';

import 'slidable.dart';

/// Signature for [CustomSlidableAction.onPressed].
typedef SlidableActionCallback = void Function(BuildContext context);

const int _kFlex = 1;
const Color _kBackgroundColor = Colors.white;
const bool _kAutoClose = true;

/// Represents an action of an [ActionPane].
class CustomSlidableAction extends StatelessWidget {
  /// Creates a [CustomSlidableAction].
  ///
  /// The [flex], [backgroundColor], [foregroundColor] and [autoClose] arguments
  /// must not be null.
  ///
  /// The [flex] argument must also be greater than 0.
  const CustomSlidableAction({
    Key key,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    @required this.onPressed,
    @required this.child,
  })  : assert(flex != null && flex > 0),
        assert(backgroundColor != null),
        assert(autoClose != null),
        assert(child != null),
        super(key: key);

  /// {@template slidable.actions.flex}
  /// The flex factor to use for this child.
  ///
  /// The amount of space the child's can occupy in the main axis is
  /// determined by dividing the free space according to the flex factors of the
  /// other [CustomSlidableAction]s.
  /// {@endtemplate}
  final int flex;

  /// {@template slidable.actions.backgroundColor}
  /// The background color of this action.
  ///
  /// Defaults to [Colors.white].
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template slidable.actions.foregroundColor}
  /// The foreground color of this action.
  ///
  /// Defaults to [Colors.black] if [background]'s brightness is
  /// [Brightness.light], or to [Colors.white] if [background]'s brightness is
  /// [Brightness.dark].
  /// {@endtemplate}
  final Color foregroundColor;

  /// {@template slidable.actions.autoClose}
  /// Whether the enclosing [Slidable] will be closed after [onPressed]
  /// occurred.
  /// {@endtemplate}
  final bool autoClose;

  /// {@template slidable.actions.onPressed}
  /// Called when the action is tapped or otherwise activated.
  ///
  /// If this callback is null, then the action will be disabled.
  /// {@endtemplate}
  final SlidableActionCallback onPressed;

  /// Typically the action's icon or label.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveForegroundColor = foregroundColor ??
        (ThemeData.estimateBrightnessForColor(backgroundColor) ==
                Brightness.light
            ? Colors.black
            : Colors.white);

    return Expanded(
      flex: flex,
      child: SizedBox.expand(
        child: OutlinedButton(
          onPressed: () => _handleTap(context),
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            primary: effectiveForegroundColor,
            onSurface: effectiveForegroundColor,
            shape: const RoundedRectangleBorder(),
            side: BorderSide.none,
          ),
          child: child,
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    onPressed?.call(context);
    if (autoClose) {
      Slidable.of(context)?.close();
    }
  }
}

class SlidableAction extends StatelessWidget {
  const SlidableAction({
    Key key,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    @required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label,
  })  : assert(flex != null && flex > 0),
        assert(backgroundColor != null),
        assert(autoClose != null),
        assert(icon != null || label != null),
        assert(spacing != null),
        super(key: key);

  /// {@macro slidable.actions.flex}
  final int flex;

  /// {@macro slidable.actions.backgroundColor}
  final Color backgroundColor;

  /// {@macro slidable.actions.foregroundColor}
  final Color foregroundColor;

  /// {@macro slidable.actions.autoClose}
  final bool autoClose;

  /// {@macro slidable.actions.onPressed}
  final SlidableActionCallback onPressed;

  final IconData icon;

  final double spacing;

  final String label;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (icon != null) {
      children.add(
        Icon(icon),
      );
    }

    if (label != null) {
      if (children.isNotEmpty) {
        children.add(
          SizedBox(height: spacing),
        );
      }

      children.add(
        Text(
          label,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    final child = children.length == 1
        ? children.first
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...children.map(
                (child) => Flexible(
                  child: child,
                ),
              )
            ],
          );

    return CustomSlidableAction(
      onPressed: onPressed,
      autoClose: autoClose,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      flex: flex,
      child: child,
    );
  }
}
