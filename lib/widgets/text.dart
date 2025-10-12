part of '../custom_drop_down/dropinity.dart';

class _DropifyText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;
  const _DropifyText(
      this.text, {
        this.color,
        this.fontSize,
        this.fontWeight = FontWeight.normal,
        this.overflow,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight,
      ),
    );
  }
}
