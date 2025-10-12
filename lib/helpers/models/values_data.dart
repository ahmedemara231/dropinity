part of '../../custom_drop_down/dropinity.dart';

/// [ValuesData] data class
class ValuesData<Model>{

  /// item builder of the values data [Widget]
  final Widget Function(BuildContext context, int i, Model element) itemBuilder;

  /// main constructor for [ValuesData]
  ValuesData({
    required this.itemBuilder,
  });
}