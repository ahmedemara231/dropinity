import 'package:flutter/material.dart';

import '../custom_drop_down/dropinity.dart';

class ValueHolder<Model> extends StatelessWidget {

  /// multi selection property [bool]
  final bool _enableMultiSelection;

  /// button properties [ButtonData]
  final ButtonData<Model> buttonData;

  /// selected values when enabling multi selection
  final List<Model>? values;

  /// on button tap call back
  final void Function()? onTap;


  /// normal constructor
  const ValueHolder({super.key,
    required this.buttonData,
    this.values,
    required this.onTap,
  }) : _enableMultiSelection = false;

  /// multi selection constructor
  const ValueHolder.multiSelection({super.key,
    required this.buttonData,
    this.values,
    required this.onTap,
  }) : _enableMultiSelection = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: buttonData.buttonBorderRadius?? BorderRadius.circular(12),
          border: Border.all(color: buttonData.buttonBorderColor?? Colors.grey[300]!),
          color: buttonData.color?? Colors.white,
        ),
        padding: buttonData.padding?? const EdgeInsets.all(12),
        width: buttonData.buttonWidth,
        height: buttonData.buttonHeight,
        child: ValueListenableBuilder(
          valueListenable: _openDataList,
          builder: (context, val, child) => Row(
            children: [
              if(_selectedValue.isNull)
                _selectButtonText
              else
                widget.buttonData.selectedItemWidget(_selectedValue),

              const Spacer(),

              if(val)
                buttonData.expandedListIcon?? Icon(Icons.arrow_drop_up, color: Colors.grey[400])
              else
                buttonData.collapsedListIcon?? Icon(Icons.arrow_drop_down, color: Colors.grey[400])
            ],
          ),
        ),
      ),
    );
  }
}
