# dropinity

A powerful and highly customizable Flutter dropdown widget with built-in search functionality and pagination support. Dropify makes it easy to handle both local and remote data sources with a beautiful, animated interface.

## Features

- 🔍 **Intelligent Search**: Real-time filtering with custom search logic
- 📡 **API Integration**: Seamless pagination support through Pagify package
- 💾 **Dual Mode**: Works with both static lists and dynamic API data
- 🎨 **Fully Customizable**: Complete control over UI, styling, and behavior
- 🎭 **Smooth Animations**: Beautiful expand/collapse transitions
- 🎯 **Type Safe**: Full generic type support for your models

## Dependencies

Dropify depends on the [Pagify](https://pub.dev/packages/pagify) package for pagination functionality.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dropify: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Usage

Dropify has two modes of operation:

### 1. Local Mode (Static Data)

Perfect for predefined lists or data that doesn't require API calls.

```dart
typedef DropifyLocal<Model> = Dropify<void, Model>;

DropifyLocal<Model>(
  dropdownTitle: Text(
    'Select Country',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
  listHeight: 300,
  buttonData: ButtonData(
    buttonWidth: double.infinity,
    buttonHeight: 55,
    hint: Text('Choose a country...'),
    selectedItemWidget: (country) => Text(
      country ?? '',
      style: TextStyle(fontSize: 16),
    ),
    buttonBorderRadius: BorderRadius.circular(12),
    buttonBorderColor: Colors.blue,
  ),
  textFieldData: TextFieldData(
    controller: TextEditingController(),
    title: 'Search',
    prefixIcon: Icon(Icons.search),
    borderRadius: 8,
    onSearch: (pattern, country) {
      if (pattern == null || country == null) return false;
      return country.toLowerCase().contains(pattern.toLowerCase());
    },
  ),
  values: [
    'United States',
    'Canada',
    'Mexico',
    'Brazil',
    'Argentina',
    'United Kingdom',
    'Germany',
    'France',
  ],
  valuesData: ValuesData(
    itemBuilder: (context, index, country) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(country, style: TextStyle(fontSize: 15)),
      );
    },
  ),
  onChanged: (selectedCountry) {
    print('Selected: $selectedCountry');
  },
)
```

### 2. API Mode (Paginated Remote Data)

Ideal for large datasets with server-side pagination and filtering.

```dart
// Create a controller
final controller = PagifyController<User>();

Dropify<ApiResponse, User>.withApiRequest(
  dropdownTitle: Text(
    'Select User',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
  listHeight: 400,
  buttonData: ButtonData(
    buttonWidth: double.infinity,
    buttonHeight: 55,
    hint: Row(
      children: [
        Icon(Icons.person_outline, color: Colors.grey),
        SizedBox(width: 8),
        Text('Search users...'),
      ],
    ),
    selectedItemWidget: (user) => Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(user?.avatarUrl ?? ''),
        ),
        SizedBox(width: 12),
        Text(user?.name ?? ''),
      ],
    ),
    expandedListIcon: Icon(Icons.keyboard_arrow_up, color: Colors.blue),
    collapsedListIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
  ),
  textFieldData: TextFieldData(
    controller: TextEditingController(),
    title: 'Search by name or email',
    prefixIcon: Icon(Icons.search),
    borderRadius: 10,
    fillColor: Colors.grey[100],
    onSearch: (pattern, user) {
      if (pattern == null || user == null) return false;
      return user.name.toLowerCase().contains(pattern.toLowerCase()) ||
             user.email.toLowerCase().contains(pattern.toLowerCase());
    },
  ),
  pagifyData: SearchableDropdownPagifyData(
    controller: controller,
    asyncCall: (context, page) async {
      // Your API call
      final response = await ApiService.getUsers(page: page);
      return response;
    },
    mapper: (response) {
      return PagifyData(
        data: response.users,
        total: response.total,
        totalPages: response.totalPages,
      );
    },
    errorMapper: (response) => response.error,
    itemBuilder: (context, data, index, user) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
    loadingBuilder: Center(
      child: CircularProgressIndicator(),
    ),
    errorBuilder: (error) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: ${error.message}'),
        ],
      ),
    ),
    emptyListView: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No users found'),
        ],
      ),
    ),
    noConnectionText: 'No internet connection',
    padding: EdgeInsets.all(8),
  ),
  onChanged: (selectedUser) {
    print('Selected: ${selectedUser.name}');
  },
)
```

## API Reference

### Constructors

#### `Dropify()` - Local Mode
```dart
const Dropify({
  Key? key,
  Widget? dropdownTitle,
  double? listHeight,
  required ButtonData<Model> buttonData,
  required TextFieldData<Model> textFieldData,
  required List<Model> values,
  required ValuesData<Model> valuesData,
  required FutureOr<void> Function(Model val) onChanged,
})
```

#### `Dropify.withApiRequest()` - API Mode
```dart
const Dropify.withApiRequest({
  Key? key,
  Widget? dropdownTitle,
  double? listHeight,
  required ButtonData<Model> buttonData,
  required TextFieldData<Model> textFieldData,
  required SearchableDropdownPagifyData<FullResponse, Model> pagifyData,
  required FutureOr<void> Function(Model val) onChanged,
})
```

### Configuration Classes

#### ButtonData

Defines the appearance and behavior of the dropdown button.

```dart
ButtonData<Model>({
  required Widget Function(Model? selectedElement) selectedItemWidget,
  Color? buttonBorderColor,
  BorderRadius? buttonBorderRadius,
  Widget? hint,
  Color? color,
  EdgeInsetsGeometry? padding,
  double buttonWidth = double.infinity,
  double buttonHeight = 50,
  Widget? expandedListIcon,
  Widget? collapsedListIcon,
})
```

**Properties:**
- `selectedItemWidget`: Builder for displaying the selected item
- `hint`: Widget shown when no item is selected
- `buttonWidth`: Width of the button (default: `double.infinity`)
- `buttonHeight`: Height of the button (default: `50`)
- `buttonBorderRadius`: Border radius of the button
- `buttonBorderColor`: Color of the button border
- `color`: Background color of the button
- `padding`: Internal padding of the button
- `expandedListIcon`: Icon shown when dropdown is open
- `collapsedListIcon`: Icon shown when dropdown is closed

#### TextFieldData

Configures the search field inside the dropdown.

```dart
TextFieldData<Model>({
  required bool Function(String? pattern, Model? element) onSearch,
  TextEditingController? controller,
  String? title,
  Widget? prefixIcon,
  Widget? suffixIcon,
  double? borderRadius,
  Color? borderColor,
  EdgeInsetsGeometry? contentPadding,
  Color? fillColor,
  int? maxLength,
  TextStyle? style,
})
```

**Properties:**
- `onSearch`: Function that defines search logic (returns `true` if item matches)
- `controller`: Text editing controller for the search field
- `title`: Label/hint text for the search field
- `prefixIcon`: Icon at the start of the search field
- `suffixIcon`: Icon at the end of the search field
- `borderRadius`: Border radius of the search field
- `borderColor`: Color of the search field border
- `contentPadding`: Internal padding of the search field
- `fillColor`: Background color of the search field
- `maxLength`: Maximum character length
- `style`: Text style for the search field

#### ValuesData (Local Mode Only)

Defines how items are displayed in local mode.

```dart
ValuesData<Model>({
  required Widget Function(BuildContext context, int i, Model element) itemBuilder,
})
```

**Properties:**
- `itemBuilder`: Builder function for each list item

#### SearchableDropdownPagifyData (API Mode Only)

Configures pagination and API integration.

```dart
SearchableDropdownPagifyData<FullResponse, Model>({
  required Future<FullResponse> Function(BuildContext context, int page) asyncCall,
  required PagifyData<Model> Function(FullResponse response) mapper,
  required PagifyErrorMapper errorMapper,
  required Widget Function(BuildContext context, List<Model> data, int index, Model element) itemBuilder,
  required PagifyController<Model> controller,
  EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  double? itemExtent,
  FutureOr<void> Function(PagifyAsyncCallStatus)? onUpdateStatus,
  FutureOr<void> Function()? onLoading,
  FutureOr<void> Function(BuildContext, List<dynamic>)? onSuccess,
  FutureOr<void> Function(BuildContext, int, PagifyException)? onError,
  bool ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty = true,
  bool showNoDataAlert = false,
  Widget? loadingBuilder,
  Widget Function(PagifyException)? errorBuilder,
  Widget? emptyListView,
  String? noConnectionText,
})
```

**Properties:**
- `controller`: Pagify controller instance
- `asyncCall`: Function to fetch paginated data
- `mapper`: Maps API response to PagifyData
- `errorMapper`: Maps errors from the response
- `itemBuilder`: Builder for each list item
- `loadingBuilder`: Widget shown while loading
- `errorBuilder`: Widget shown on error
- `emptyListView`: Widget shown when list is empty
- `padding`: Padding around the list
- `itemExtent`: Fixed height for list items
- `noConnectionText`: Message for no internet connection
- `onUpdateStatus`: Callback for status changes
- `onLoading`: Callback when loading starts
- `onSuccess`: Callback on successful load
- `onError`: Callback on error

## Advanced Examples

### Custom Styling Example

```dart
Dropify<dynamic, Product>(
  dropdownTitle: Container(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      'Select Product',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    ),
  ),
  listHeight: 350,
  buttonData: ButtonData(
    buttonWidth: double.infinity,
    buttonHeight: 60,
    color: Colors.blue[50],
    buttonBorderRadius: BorderRadius.circular(16),
    buttonBorderColor: Colors.blue[300],
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    hint: Row(
      children: [
        Icon(Icons.shopping_cart_outlined, color: Colors.blue),
        SizedBox(width: 12),
        Text(
          'Choose a product...',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
    selectedItemWidget: (product) => Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.check, color: Colors.white, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product?.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${product?.price.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
    expandedListIcon: Icon(Icons.expand_less, color: Colors.blue, size: 28),
    collapsedListIcon: Icon(Icons.expand_more, color: Colors.blue, size: 28),
  ),
  textFieldData: TextFieldData(
    controller: TextEditingController(),
    title: 'Search products by name or SKU',
    prefixIcon: Icon(Icons.search, color: Colors.blue),
    suffixIcon: Icon(Icons.filter_list, color: Colors.grey),
    borderRadius: 12,
    borderColor: Colors.blue[200],
    fillColor: Colors.white,
    contentPadding: EdgeInsets.all(16),
    onSearch: (pattern, product) {
      if (pattern == null || product == null) return false;
      return product.name.toLowerCase().contains(pattern.toLowerCase()) ||
             product.sku.toLowerCase().contains(pattern.toLowerCase());
    },
  ),
  values: products, // Your product list
  valuesData: ValuesData(
    itemBuilder: (context, index, product) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.inventory_2, color: Colors.blue),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'SKU: ${product.sku}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    },
  ),
  onChanged: (product) {
    print('Selected: ${product.name}');
  },
)
```

### Form Integration Example

```dart
class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  Country? selectedCountry;
  City? selectedCity;
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Country Dropdown
          Dropify<dynamic, Country>(
            dropdownTitle: Text('Country *'),
            buttonData: ButtonData(
              buttonWidth: double.infinity,
              hint: Text('Select country'),
              selectedItemWidget: (country) => Text(country?.name ?? ''),
            ),
            textFieldData: TextFieldData(
              controller: TextEditingController(),
              onSearch: (pattern, country) =>
                country?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
            ),
            values: countries,
            valuesData: ValuesData(
              itemBuilder: (context, i, country) => ListTile(
                title: Text(country.name),
              ),
            ),
            onChanged: (country) {
              setState(() {
                selectedCountry = country;
                selectedCity = null; // Reset city when country changes
              });
            },
          ),
          
          SizedBox(height: 16),
          
          // City Dropdown (dependent on country)
          if (selectedCountry != null)
            Dropify<dynamic, City>(
              dropdownTitle: Text('City *'),
              buttonData: ButtonData(
                buttonWidth: double.infinity,
                hint: Text('Select city'),
                selectedItemWidget: (city) => Text(city?.name ?? ''),
              ),
              textFieldData: TextFieldData(
                controller: TextEditingController(),
                onSearch: (pattern, city) =>
                  city?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
              ),
              values: selectedCountry!.cities,
              valuesData: ValuesData(
                itemBuilder: (context, i, city) => ListTile(
                  title: Text(city.name),
                ),
              ),
              onChanged: (city) {
                setState(() => selectedCity = city);
              },
            ),
          
          SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              if (selectedCountry != null && selectedCity != null) {
                // Submit form
                print('Country: ${selectedCountry!.name}');
                print('City: ${selectedCity!.name}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select all fields')),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Performance Considerations

1. **For Large Datasets**: Use API mode (`Dropify.withApiRequest`) with pagination
2. **Search Optimization**: Implement efficient `onSearch` logic to avoid performance issues
3. **State Management**: The widget uses `maintainState: true` to preserve state when toggling visibility
4. **Memory Usage**: Local mode keeps all data in memory, so use API mode for very large datasets
5. **Controller Disposal**: Always dispose controllers in `dispose()` method

```dart
@override
void dispose() {
  textController.dispose();
  pagifyController.dispose();
  super.dispose();
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Support

For issues and feature requests, please file an issue on the GitHub repository.

For questions about the Pagify package, refer to the [Pagify documentation](https://pub.dev/packages/pagify).

---

**Made with ❤️ for the Flutter community by Ahmed Emara**
