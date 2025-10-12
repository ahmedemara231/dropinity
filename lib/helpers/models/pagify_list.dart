part of '../../custom_drop_down/dropinity.dart';


/// main class to [Pagify] data
class DropinityPagifyData<FullResponse, Model>{
  /// pagify controller comes from [Pagify] package
  final PagifyController<Model> controller;

  /// pagify main api request comes from [Pagify] package
  Future<FullResponse> Function(BuildContext context, int page) asyncCall;

  /// pagify mapper comes from [Pagify] package
  PagifyData<Model> Function(FullResponse response) mapper;

  /// pagify error mapper comes from [Pagify] package
  PagifyErrorMapper errorMapper;

  /// pagify item builder comes from [Pagify] package
  Widget Function(BuildContext context, List<Model> data, int index, Model element) itemBuilder;

  /// list padding [padding]
  EdgeInsetsGeometry padding = EdgeInsets.zero;

  /// item extent [double] to single element [widget]
  double? itemExtent;

  /// update status callback comes from [Pagify] package to show current state [PagifyAsyncCallStatus]
  FutureOr<void> Function(PagifyAsyncCallStatus)? onUpdateStatus;

  /// on loading call back comes from [Pagify] package
  FutureOr<void> Function()? onLoading;
  /// on success call back comes from [Pagify] package
  FutureOr<void> Function(BuildContext, List<dynamic>)? onSuccess;
  /// on error call back comes from [Pagify] package
  FutureOr<void> Function(BuildContext, int,  PagifyException)? onError;


  /// keep current view when error [bool] comes from [Pagify] package
  bool ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty;

  /// show no data alert when there is no more data [bool] comes from [Pagify] package
  bool showNoDataAlert = false;

  /// custom loader [Widget] comes from [Pagify] package
  Widget? loadingBuilder;

  /// custom error [Widget] comes from [Pagify] package
  Widget Function(PagifyException)? errorBuilder;

  /// custom empty list view [Widget] comes from [Pagify] package
  Widget? emptyListView;

  /// custom text when there is no internet connection [String] comes from [Pagify] package
  String? noConnectionText;


  /// constructor for [DropinityPagifyData]
  DropinityPagifyData({
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
