part of '../custom_drop_down/dropify.dart';

class DropifyText extends StatelessWidget {
  final bool withIcon;
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  const DropifyText(
      this.text, {
        super.key, this.icon,
        this.color, this.withIcon = false,
        this.fontSize,
        this.fontWeight = FontWeight.normal,
        this.overflow,
        this.textAlign = TextAlign.start,
        this.maxLines,
        this.height,
      });

  final Widget? icon;
  const DropifyText.withIcon({
    super.key,
    required this.icon,
    required this.text,
    this.withIcon = true,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.overflow,
    this.maxLines,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    switch(withIcon){
      case true:
        return Row(
          spacing: 5,
          children: [
            icon!,
            Text(
              text,
              textAlign: textAlign,
              overflow: overflow,
              maxLines: maxLines,
              style: TextStyle(
                color: color,
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight,
                height: height,
              ),
            ),
          ],
        );
      default:
        return Text(
          text,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          style: TextStyle(
              color: color,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight,
              height: height,
          ),
        );
    }

  }
}
