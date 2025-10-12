import 'package:dropinity/custom_drop_down/dropinity.dart';
import 'package:flutter/material.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';

void main() {
  runApp(const DropinityExample());
}

class ExampleModel{
  List<String> items;
  int totalPages;

  ExampleModel({
    required this.items,
    required this.totalPages
  });
}


class DropinityExample extends StatefulWidget {

  const DropinityExample({super.key});

  @override
  State<DropinityExample> createState() => _DropinityExampleState();
}

class _DropinityExampleState extends State<DropinityExample> {
  Future<ExampleModel> _fetchData(int currentPage) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate api call with current page
    final items = List.generate(25, (index) => 'Item $index');
    return ExampleModel(items: items, totalPages: 4);
  }

  //
  late PagifyController<String> _pagifyController;

  @override
  void initState() {
    _pagifyController = PagifyController<String>();
    super.initState();
  }

  @override
  void dispose() {
    _pagifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dropinity<ExampleModel, String>(
              controller: DropinityController(),
              listHeight: 250,
              buttonData: ButtonData(selectedItemWidget: (e) => Text(e??'')),
              textFieldData: TextFieldData(
                onSearch: (pattern, e) => e!.contains(pattern??''),
              ),
              values: const ['item1', 'item2', 'item3', 'item4', 'item5', 'item6', 'item7', 'item8', 'item9', 'item10'],
              valuesData: ValuesData(itemBuilder: (context, index, element) => Text(element)),
              onChanged: (String val) {},
            ),

            Dropinity<ExampleModel, String>.withApiRequest(
              controller: DropinityController(),
              listHeight: 250,
              buttonData: ButtonData(
                selectedItemWidget: (e) => Text(e??''),
              ),
              textFieldData: TextFieldData(
                onSearch: (pattern, e) => e!.contains(pattern??''),
              ),
              pagifyData: DropinityPagifyData(
                controller: _pagifyController,
                asyncCall: (context, page)async => await _fetchData(page),
                mapper: (response) => PagifyData(
                    data: response.items,
                    paginationData: PaginationData(
                      totalPages: response.totalPages,
                      perPage: 10,
                    )
                ),
                errorMapper: PagifyErrorMapper(
                    errorWhenDio: (e) {
                      String? msg = e.type.name;

                      return PagifyApiRequestException(
                        msg,
                        pagifyFailure: RequestFailureData(
                          statusCode: e.response?.statusCode,
                          statusMsg: e.response?.statusMessage,
                        ),
                      );
                    } // if you using Dio

                ),
                itemBuilder: (context, data, index, element) => Text(element, textAlign: TextAlign.start),
              ), onChanged: (String val) {},
            ),
          ],
        )
    );
  }
}