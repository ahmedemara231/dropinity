part of '../../custom_drop_down/dropinity.dart';


/// main class to [Pagify] data
class DropinityPagifyData<FullResponse, Model>{
  /// pagify controller comes from [Pagify] package
  final PagifyController<Model>? controller;

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

  /// Optional cache key for offline support.
  /// Must be provided together with [cacheToJson], [cacheFromJson], [onSaveCache], and [onReadCache].
  String? cacheKey;

  /// Converts a [Model] item to a JSON map for caching.
  Map<String, dynamic> Function(Model item)? cacheToJson;

  /// Converts a cached JSON map back to a [Model] item.
  Model Function(Map<String, dynamic> json)? cacheFromJson;

  /// Called to persist the fetched items list when a request succeeds.
  void Function(String key, List<Map<String, dynamic>> items)? onSaveCache;

  /// Called to restore items from cache when a request fails.
  /// Return `null` or an empty list if no cache exists.
  List<Map<String, dynamic>>? Function(String key)? onReadCache;


  /// constructor for [DropinityPagifyData]
  DropinityPagifyData({
    required this.asyncCall,
    required this.mapper,
    required this.errorMapper,
    required this.itemBuilder,
    this.controller,
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
    this.cacheKey,
    this.cacheToJson,
    this.cacheFromJson,
    this.onSaveCache,
    this.onReadCache,
  });
}
