part of '../../custom_drop_down/dropinity.dart';

/// type of the dropdown [DropdownType]
enum DropdownType{
  /// with api request (remote data)
  withRequest,

  /// with local data
  none
}

/// Check extension to check if the dropdown type is with request
extension Check on DropdownType{

  /// Check if the dropdown type is with request
  bool get withApi => this == DropdownType.withRequest;
}