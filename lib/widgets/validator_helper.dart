part of '../custom_drop_down/dropinity.dart';

class _ValidationHost<T> extends FormField<T> {
  final Widget Function(FormFieldState<T> state) builderWidget;
  final AutovalidateMode? validationMode;

  _ValidationHost({super.key,
    required this.builderWidget,
    required FormFieldValidator<T> super.validator,
    this.validationMode = AutovalidateMode.onUserInteraction,
    super.onSaved,
    super.initialValue,
  }) : super(
    builder: (field) => builderWidget(field),
    autovalidateMode: validationMode,
  );
}
