part of '../custom_drop_down/dropinity.dart';

class _DefaultTextField extends StatefulWidget {
  final double? borderRadius;
  final String? title;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final void Function(String?)? onChanged;
  final TextStyle? style;
  final TextEditingController? controller;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;

  const _DefaultTextField({
    this.title,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.style,
    this.controller,
    this.maxLength,
    this.contentPadding
  });

  @override
  State<_DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<_DefaultTextField> {
  void _debounce(String val){
    // EasyDebounce.debounce(
    //     'debouncer',
    //     const Duration(milliseconds: 250),
    //         () => widget.onChanged?.call(val)
    // );
    widget.onChanged?.call(val);
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: _debounce,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      keyboardType: TextInputType.text,
      style: widget.style,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: widget.contentPadding,
        counterText: '',
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        fillColor: widget.fillColor ?? Colors.white,
        hintText: widget.title,
        hintStyle: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?? 12),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

// List<String> _getAutoFillHints(TextInputType inputType) {
//   if (inputType == TextInputType.emailAddress) {
//     return [AutofillHints.email];
//   } else if (inputType == TextInputType.datetime) {
//     return [AutofillHints.birthday];
//   } else if (inputType == TextInputType.phone) {
//     return [AutofillHints.telephoneNumber];
//   } else if (inputType == TextInputType.url) {
//     return [AutofillHints.url];
//   }
//   return [AutofillHints.name, AutofillHints.username];
// }
