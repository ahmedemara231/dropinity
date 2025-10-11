part of '../custom_drop_down/dropinity.dart';

enum _DropdownType{withRequest, none}

extension Check on _DropdownType{
  bool get withApi => this == _DropdownType.withRequest;
}