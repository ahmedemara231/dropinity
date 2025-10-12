part of '../../custom_drop_down/dropinity.dart';

/// main [DropinityController] class
class DropinityController{
  late _DropinityState _currentState;
  void _init(_DropinityState state){
    _currentState = state;
  }

  /// change list current state to expand state
  void expand(){
    _currentState._openDataList.value = true;
  }

  /// change list current state to collapse state
  void collapse(){
    _currentState._openDataList.value = false;
  }


  /// check if list is expanded
  bool get isExpanded => _currentState._openDataList.value;

  /// check if list is collapsed
  bool get isCollapsed => !_currentState._openDataList.value;
}