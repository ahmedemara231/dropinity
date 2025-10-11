part of '../dropify.dart';

class ButtonData<Model>{
  final double buttonHeight;
  final double buttonWidth;
  final BorderRadius? buttonBorderRadius;
  final Color? buttonBorderColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Widget? hint;
  final Widget Function(Model? selectedElement) selectedItemWidget;
  final Widget? expandedListIcon;
  final Widget? collapsedListIcon;

  ButtonData({
    required this.selectedItemWidget,
    this.buttonBorderColor,
    this.buttonBorderRadius,
    this.hint,
    this.color,
    this.padding,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 50,
    this.expandedListIcon,
    this.collapsedListIcon,
  });
}
