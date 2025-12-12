import 'package:dropinity/helpers/extensions/object.dart';
import 'package:dropinity/helpers/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'dart:async';
import 'package:pagify/pagify.dart';

part '../helpers/models/main_button.dart';
part '../helpers/models/pagify_list.dart';
part '../helpers/models/text_field.dart';
part '../helpers/models/values_data.dart';
part '../widgets/text_field.dart';
part '../widgets/text.dart';
part '../widgets/validator_helper.dart';
part '../helpers/type_enum.dart';
part '../helpers/controller/controller.dart';


/// main [Dropinity] class
class Dropinity<FullResponse, Model> extends StatefulWidget {

  /// keep state on memory [bool]
  final bool maintainState;

  /// Dropinity custom validator
  final String? Function(Model?)? validator;

  /// error builder [Widget]
  final Widget Function(String errorMsg)? errorWidget;


  /// onCollapse callback [Function]
  final FutureOr<void> Function()? onCollapse;

  /// onExpand callback [Function]
  final FutureOr<void> Function()? onExpand;


  /// validation mode of validator [AutovalidateMode]
  final AutovalidateMode? autoValidateMode;

/// controller of the dropdown [DropinityController]
  final DropinityController controller;

  /// no more data flag [bool]
  final bool showNoDataAlert;

  /// height of the list result [double]
  final double? listHeight;

  /// animation of the list result [Curve]
  final Curve curve;

  /// Background Color of the list result [Color]
  final Color listBackgroundColor;

  /// callback when current element changes
  final FutureOr<void> Function(Model val) onChanged;

  /// title of the dropdown
  final Widget? dropdownTitle;
  final DropdownType _dropdownType;

  /// button data [ButtonData]
  final ButtonData<Model> buttonData;

  /// text field data [TextFieldData]
  final TextFieldData<Model>? textFieldData;

  /// custom pagify data [DropinityPagifyData] comes from [Pagify] package
  final DropinityPagifyData<FullResponse, Model>? pagifyData;

  /// values of the dropdown when local
  final List<Model>? values;

  /// values of the dropdown when local which includes itemBuilder
  final ValuesData<Model>? valuesData;


  /// constructor for api dropdown
  const Dropinity.withApiRequest({
    super.key,
    this.maintainState = false,
    this.showNoDataAlert = false,
    this.validator,
    this.autoValidateMode,
    this.errorWidget,
    this.curve = Curves.linear,
    this.listBackgroundColor = Colors.white,
    this.dropdownTitle,
    this.textFieldData,
    this.listHeight,
    required this.controller,
    required this.buttonData,
    required this.pagifyData,
    required this.onChanged,
    this.onCollapse,
    this.onExpand,
  }) : values = null,
        valuesData = null,
        _dropdownType = DropdownType.withRequest;

  /// normal constructor for local dropdown
  const Dropinity({
    super.key,
    this.curve = Curves.linear,
    this.onCollapse,
    this.onExpand,
    this.autoValidateMode,
    this.errorWidget,
    this.listBackgroundColor = Colors.white,
    this.dropdownTitle,
    this.textFieldData,
    this.validator,
    this.listHeight,
    required this.controller,
    required this.buttonData,
    required this.values,
    required this.valuesData,
    required this.onChanged,
    this.showNoDataAlert = false,
    this.maintainState = false,
  }) : pagifyData = null,
        _dropdownType = DropdownType.none;

  @override
  State<Dropinity<FullResponse, Model>> createState() => _DropinityState<FullResponse, Model>();
}

class _DropinityState<FullResponse, Model> extends State<Dropinity<FullResponse, Model>> {
  Model? _selectedValue;

  void _selectNewElement(Model element){
    _selectedValue = element;
    widget.onChanged.call(element);
    _changePagifyVisibility();
  }


  late List<Model> _fullValuesData;

  late ValueNotifier<List<Model>> _localValues;

  void _init(){
    if(!widget._dropdownType.withApi){
      _fullValuesData = List.from(widget.values!);
      _localValues = ValueNotifier(List.from(widget.values!));
    }
  }

  void _executeSearchLogicToLocalData(String pattern) {
    if(pattern.isEmpty){
      _localValues.value = List.from(_fullValuesData);

    }else{
      _localValues.value = _fullValuesData.where(
              (e) => widget.textFieldData!.onSearch.call(pattern, e)
      ).toList();
    }
  }

  late final ValueNotifier<bool> _openDataList = ValueNotifier(false)
    ..addListener(_openingListener);

  void _openingListener(){
    if(_openDataList.value){
      widget.onExpand?.call();

    }else{
      widget.onCollapse?.call();
    }
  }

  void _changePagifyVisibility() => _openDataList.value = !_openDataList.value;

  void _initController(){
    widget.controller._init(this);
  }

  Widget get _selectButtonText{
    if(widget.buttonData.initialValue.isNotNull){
      return
        widget.buttonData.selectedItemWidget(widget.buttonData.initialValue);

    }else{
      return widget.buttonData.hint??
          const _DropifyText('select item', color: Colors.grey, maxLines: 2, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500, fontSize: 12,);
    }
  }

  @override
  void initState() {
    _init();
    _initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ValidationHost<Model>(
      validator: (val) => widget.validator?.call(val),
      initialValue: widget.buttonData.initialValue,
      validationMode: widget.autoValidateMode,
      builderWidget: (FormFieldState<dynamic> state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                    onTap: () => _changePagifyVisibility(),
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
                              _selectButtonText
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
                  valueListenable: _openDataList,
                  builder: (context, isOpen, child) => Visibility(
                    visible: isOpen,
                    maintainState: widget.maintainState,
                    replacement: const SizedBox.shrink(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: widget.curve,
                      color: widget.listBackgroundColor,
                      child: Column(
                        spacing: 7,
                        children: [
                          if(widget.textFieldData.isNotNull)
                            _DefaultTextField(
                                title: widget.textFieldData!.title,
                                prefixIcon: widget.textFieldData!.prefixIcon,
                                suffixIcon: widget.textFieldData!.suffixIcon,
                                borderRadius: widget.textFieldData!.borderRadius,
                                borderColor: widget.textFieldData!.borderColor,
                                contentPadding: widget.textFieldData!.contentPadding,
                                controller: widget.textFieldData!.controller,
                                fillColor: widget.textFieldData!.fillColor,
                                maxLength: widget.textFieldData!.maxLength,
                                style: widget.textFieldData!.style,
                                onChanged: (v) {
                                  if(!widget._dropdownType.withApi){
                                    _executeSearchLogicToLocalData(v ?? '');
                                    return;
                                  }

                                  if(v.isNull || v!.isEmpty){
                                    widget.pagifyData!.controller?.assignToFullData();
                                    return;
                                  }

                                  widget.pagifyData!.controller?.filterAndUpdate(
                                          (e) => widget.textFieldData!.onSearch.call(v, e)
                                  );
                                }
                            ),
                          SizedBox(
                            height: widget.listHeight?? 250,
                            child: !widget._dropdownType.withApi?
                            ValueListenableBuilder(
                              valueListenable: _localValues,
                              builder: (context, val, child) => ListView(
                                children: List.generate(
                                  val.length,
                                      (i) => InkWell(
                                      onTap: () {
                                        _selectNewElement(val[i]);
                                        state.didChange(val[i]);
                                      },
                                      child: widget.valuesData!.itemBuilder.call(context, i, val[i])
                                  ),
                                ),
                              ).paddingAll(10),
                            ) :
                            Pagify<FullResponse, Model>.listView(
                              shrinkWrap: true,
                              controller: widget.pagifyData?.controller ?? PagifyController(),
                              asyncCall: widget.pagifyData!.asyncCall,
                              mapper: widget.pagifyData!.mapper,
                              errorMapper: widget.pagifyData!.errorMapper,
                              itemBuilder: (context, data, index, element) => InkWell(
                                  onTap: () {
                                    _selectNewElement(element);
                                    state.didChange(element);
                                  },
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
                              showNoDataAlert: widget.showNoDataAlert,
                              ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty: true,
                              noConnectionText: widget.pagifyData!.noConnectionText,
                            ).paddingAll(10),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
          if(state.hasError)
            widget.errorWidget?.call(state.errorText??'') ??
                _DropifyText(state.errorText??'', color: Colors.red),
        ],
      ),
    );
  }
}