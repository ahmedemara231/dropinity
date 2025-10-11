part of '../dropinity.dart';

class TextFieldData<Model>{
  final String? title;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final Color? fillColor;
  final int? maxLength;
  final TextStyle? style;
  final bool Function(String? pattern, Model? element) onSearch;

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