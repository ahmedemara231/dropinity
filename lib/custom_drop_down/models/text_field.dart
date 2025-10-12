part of '../dropinity.dart';

/// [TextFieldData] data class
class TextFieldData<Model>{

  /// title of the text field [String]
  final String? title;

  /// prefix icon of the text field [Widget]
  final Widget? prefixIcon;

  /// suffix icon of the text field [Widget]
  final Widget? suffixIcon;

  /// border radius of the text field [double]
  final double? borderRadius;

  /// border color of the text field [Color]
  final Color? borderColor;

  /// content padding of the text field [EdgeInsetsGeometry]
  final EdgeInsetsGeometry? contentPadding;

  /// controller of the text field [TextEditingController]
  final TextEditingController? controller;

  /// fill color of the text field [Color]
  final Color? fillColor;

  /// max length of the text field [int]
  final int? maxLength;

  /// style of the text field [TextStyle]
  final TextStyle? style;

  /// on search callback uses when filtering
  final bool Function(String? pattern, Model? element) onSearch;


  /// main constructor for [TextFieldData]
  TextFieldData({
    required this.onSearch,
    this.controller,
    this.title,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.borderColor,
    this.contentPadding,
    this.fillColor,
    this.maxLength,
    this.style,
  });
}