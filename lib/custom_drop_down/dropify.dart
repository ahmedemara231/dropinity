import 'package:dropify/custom_drop_down/extensions/object.dart';
import 'package:dropify/custom_drop_down/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'dart:async';
import 'package:pagify/pagify.dart';
import 'package:flutter/services.dart';

part 'models/main_button.dart';
part 'models/pagify_list.dart';
part 'models/text_field.dart';
part 'models/values_data.dart';
part '../widgets/text_field.dart';
part '../widgets/text.dart';


enum _DropdownType{withRequest, none}
class Dropify<FullResponse, Model> extends StatefulWidget {
  final double? listHeight;
  final FutureOr<void> Function(Model val) onChanged;
  final Widget? dropdownTitle;

  final _DropdownType _dropdownType;
  final ButtonData<Model> buttonData;
  final TextFieldData<Model> textFieldData;

  final SearchableDropdownPagifyData<FullResponse, Model>? pagifyData;

  final List<Model>? values;
  final ValuesData<Model>? valuesData;

  const Dropify.withApiRequest({
    super.key,
    this.dropdownTitle,
    this.listHeight,
    required this.buttonData,
    required this.textFieldData,
    required this.pagifyData,
    required this.onChanged
  }) : values = null,
        valuesData = null,
        _dropdownType = _DropdownType.withRequest;

  const Dropify({
    super.key,
    this.dropdownTitle,
    this.listHeight,
    required this.buttonData,
    required this.textFieldData,
    required this.values,
    required this.valuesData,
    required this.onChanged
  }) : pagifyData = null,
        _dropdownType = _DropdownType.none;

  @override
  State<Dropify<FullResponse, Model>> createState() => _DropifyState<FullResponse, Model>();
}

class _DropifyState<FullResponse, Model> extends State<Dropify<FullResponse, Model>> {
  Model? _selectedValue;

  void _selectNewElement(Model element){
    _selectedValue = element;
    widget.onChanged.call(element);
    _changePagifyVisibility();
  }

  late List<Model> _fullValuesData;

  late ValueNotifier<List<Model>> _localValues;

  void _init(){
    if(widget._dropdownType == _DropdownType.none){
      _fullValuesData = List.from(widget.values!);
      _localValues = ValueNotifier(List.from(widget.values!));
    }
  }

  void _executeSearchLogic(String pattern) {
    if(pattern.isEmpty){
      _localValues.value = List.from(_fullValuesData);

    }else{
      _localValues.value = _fullValuesData.where(
              (e) => widget.textFieldData.onSearch.call(pattern, e)
      ).toList();
    }
  }

  final ValueNotifier<bool> _openDataList = ValueNotifier(false);

  void _changePagifyVisibility() => _openDataList.value = !_openDataList.value;

  final ValueNotifier<bool> _isInitialized = ValueNotifier(false);

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.dropdownTitle.isNotNull)
              widget.dropdownTitle!,

            InkWell(
              onTap: (){
                _isInitialized.value = true;
                _changePagifyVisibility();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.buttonData.buttonBorderRadius?? BorderRadius.circular(12),
                  border: Border.all(color: widget.buttonData.buttonBorderColor?? Colors.grey[300]!),
                  color: widget.buttonData.color?? Colors.white,
                ),
                padding: widget.buttonData.padding?? const EdgeInsets.all(12),
                width: widget.buttonData.buttonWidth,
                height: widget.buttonData.buttonHeight,
                child: ValueListenableBuilder(
                  valueListenable: _openDataList,
                  builder: (context, val, child) => Row(
                    children: [
                      if(_selectedValue.isNull)
                        widget.buttonData.hint?? const DropifyText('select item', color: Colors.grey)
                      else
                        widget.buttonData.selectedItemWidget(_selectedValue),

                      const Spacer(),

                      if(val)
                        widget.buttonData.expandedListIcon?? Icon(Icons.arrow_drop_up, color: Colors.grey[400])
                      else
                        widget.buttonData.collapsedListIcon?? Icon(Icons.arrow_drop_down, color: Colors.grey[400])
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: _isInitialized,
          builder: (context, val, child) => val? ValueListenableBuilder(
              valueListenable: _openDataList,
              builder: (context, isOpen, child) => Visibility(
                visible: isOpen,
                maintainState: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  color: Colors.white,
                  child: Column(
                    spacing: 7,
                    children: [
                      DefaultTextField(
                          title: widget.textFieldData.title,
                          prefixIcon: widget.textFieldData.prefixIcon,
                          suffixIcon: widget.textFieldData.suffixIcon,
                          borderRadius: widget.textFieldData.borderRadius,
                          borderColor: widget.textFieldData.borderColor,
                          contentPadding: widget.textFieldData.contentPadding,
                          controller: widget.textFieldData.controller,
                          fillColor: widget.textFieldData.fillColor,
                          maxLength: widget.textFieldData.maxLength,
                          style: widget.textFieldData.style,
                          onChanged: (v) {
                            if(widget._dropdownType == _DropdownType.none){
                              _executeSearchLogic(v ?? '');
                              return;
                            }

                            if(v.isNull || v!.isEmpty){
                              widget.pagifyData!.controller.assignToFullData();
                              return;
                            }

                            widget.pagifyData!.controller.filterAndUpdate(
                                    (e) => widget.textFieldData.onSearch.call(v, e)
                            );
                          }
                      ),

                      SizedBox(
                        height: widget.listHeight?? 250,
                        child: widget._dropdownType == _DropdownType.none?
                        ValueListenableBuilder(
                          valueListenable: _localValues,
                          builder: (context, val, child) => ListView(
                            children: List.generate(
                              val.length,
                                  (i) => InkWell(
                                  onTap: () => _selectNewElement(val[i]),
                                  child: widget.valuesData!.itemBuilder.call(context, i, val[i])
                              ),
                            ),
                          ).paddingAll(10),
                        ) :
                        Pagify<FullResponse, Model>.listView(
                          shrinkWrap: true,
                          controller: widget.pagifyData!.controller,
                          asyncCall: widget.pagifyData!.asyncCall,
                          mapper: widget.pagifyData!.mapper,
                          errorMapper: widget.pagifyData!.errorMapper,
                          itemBuilder: (context, data, index, element) => InkWell(
                              onTap: () => _selectNewElement(element),
                              child: widget.pagifyData!.itemBuilder(context, data, index, element)
                          ),
                          errorBuilder: widget.pagifyData!.errorBuilder,
                          loadingBuilder: widget.pagifyData!.loadingBuilder,
                          padding: widget.pagifyData!.padding,
                          itemExtent: widget.pagifyData!.itemExtent,
                          onUpdateStatus: widget.pagifyData!.onUpdateStatus,
                          onLoading: widget.pagifyData!.onLoading,
                          onSuccess: widget.pagifyData!.onSuccess,
                          onError: widget.pagifyData!.onError,
                          emptyListView: widget.pagifyData!.emptyListView,
                          showNoDataAlert: true,
                          ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty: true,
                          noConnectionText: widget.pagifyData!.noConnectionText,
                        ).paddingAll(10),
                      ),
                    ],
                  ),
                ),
              )
          ) : const SizedBox.shrink(),
        )
      ],
    );
  }
}