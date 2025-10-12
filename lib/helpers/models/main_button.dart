part of '../../custom_drop_down/dropinity.dart';

/// [ButtonData] data class
class ButtonData<Model>{
  /// the height of the main button [double]
  final double buttonHeight;

  /// the width of the main button [double]
  final double buttonWidth;

  /// the border radius of the main button [BorderRadius]
  final BorderRadius? buttonBorderRadius;

  /// the border color of the main button [Color]
  final Color? buttonBorderColor;

  /// the color of the main button [Color]
  final Color? color;

  /// the padding of the main button [EdgeInsetsGeometry]
  final EdgeInsetsGeometry? padding;

  /// the hint of the main button [Widget]
  final Widget? hint;

  /// the initial Value of the main button [String]
  final String? initialValue;

  /// the selected item widget of the main button [Widget]
  final Widget Function(Model? selectedElement) selectedItemWidget;

  /// the expanded list icon of the main button [Widget]
  final Widget? expandedListIcon;

  /// the collapsed list icon of the main button [Widget]
  final Widget? collapsedListIcon;


  /// main constructor for [ButtonData]
  ButtonData({
    required this.selectedItemWidget,
    this.buttonBorderColor,
    this.buttonBorderRadius,
    this.hint,
    this.initialValue,
    this.color,
    this.padding,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 50,
    this.expandedListIcon,
    this.collapsedListIcon,
  });
}
