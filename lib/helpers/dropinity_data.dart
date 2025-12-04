part of '../custom_drop_down/dropinity.dart';

class DropinityData<Model>{
  static final ValueNotifier<bool> _openDataList = ValueNotifier(false);
  Model? _selectedValue;

  List<Model> _selectedValues = [];
  void _addValue(Model newVal){
    _selectedValues.add(newVal);
  }

  void _removeValue(int index){
    _selectedValues.removeAt(index);
  }
}