part of '../dropinity.dart';

class SearchableDropdownPagifyData<FullResponse, Model>{
  final PagifyController<Model> controller;
  Future<FullResponse> Function(BuildContext context, int page) asyncCall;
  PagifyData<Model> Function(FullResponse response) mapper;
  PagifyErrorMapper errorMapper;
  Widget Function(BuildContext context, List<Model> data, int index, Model element) itemBuilder;
  EdgeInsetsGeometry padding = EdgeInsets.zero;
  double? itemExtent;
  FutureOr<void> Function(PagifyAsyncCallStatus)? onUpdateStatus;
  FutureOr<void> Function()? onLoading;
  FutureOr<void> Function(BuildContext, List<dynamic>)? onSuccess;
  FutureOr<void> Function(BuildContext, int,  PagifyException)? onError;

  bool ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty;
  bool showNoDataAlert = false;
  Widget? loadingBuilder;
  Widget Function(PagifyException)? errorBuilder;
  Widget? emptyListView;
  String? noConnectionText;

  SearchableDropdownPagifyData({
    required this.asyncCall,
    required this.mapper,
    required this.errorMapper,
    required this.itemBuilder,
    required this.controller,
    this.padding = const EdgeInsets.all(0),
    this.itemExtent,
    this.onUpdateStatus,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty = true,
    this.showNoDataAlert = false,
    this.loadingBuilder,
    this.errorBuilder,
  });
}
