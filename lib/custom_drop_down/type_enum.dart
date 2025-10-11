part of '../custom_drop_down/dropify.dart';

enum _DropdownType{withRequest, none}

extension Check on _DropdownType{
  bool get withApi => this == _DropdownType.withRequest;
}