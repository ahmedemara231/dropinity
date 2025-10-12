# Dropinity

A customizable Flutter dropdown widget with search functionality and pagination support for both local and remote data.

## Features

- 🔍 Real-time search filtering
- 📡 API integration with pagination (via Pagify)
- 💾 Local and remote data support
- 🎨 Fully customizable UI
- 🎭 Smooth animations
- 🎯 Type-safe generics

## Installation

```yaml
dependencies:
  dropinity: ^0.0.2
```

## Quick Start

### Local Mode

```dart
typedef DropinityLocal<Model> = Dropinity<void, Model>;

DropinityLocal<String>(
  controller: DropinityController(),
  buttonData: ButtonData(
    hint: Text('Select country'),
    selectedItemWidget: (country) => Text(country ?? ''),
  ),
  textFieldData: TextFieldData(
    onSearch: (pattern, country) =>
      country?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
  ),
  values: ['USA', 'Canada', 'Mexico'],
  valuesData: ValuesData(
    itemBuilder: (context, i, country) => ListTile(title: Text(country)),
  ),
  onChanged: (country) => print('Selected: $country'),
)
```

### API Mode

```dart
final controller = PagifyController<User>();

Dropinity<ApiResponse, User>.withApiRequest(
  controller: DropinityController(),
  buttonData: ButtonData(
    hint: Text('Select user'),
    selectedItemWidget: (user) => Text(user?.name ?? ''),
  ),
  textFieldData: TextFieldData(
    onSearch: (pattern, user) =>
      user?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
  ),
  pagifyData: DropinityPagifyData(
    controller: controller,
    asyncCall: (context, page) => ApiService.getUsers(page: page),
    mapper: (response) => PagifyData(
      data: response.users,
      total: response.total,
      totalPages: response.totalPages,
    ),
    errorMapper: (response) => response.error,
    itemBuilder: (context, data, index, user) => ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    ),
  ),
  onChanged: (user) => print('Selected: ${user.name}'),
)
```

## Controller

Control the dropdown programmatically:

```dart
final controller = DropinityController();

// Methods
controller.expand();      // Open dropdown
controller.collapse();    // Close dropdown

// Properties
controller.isExpanded;    // Check if open
controller.isCollapsed;   // Check if closed

// Example usage
ElevatedButton(
  onPressed: () {
    if (controller.isExpanded) {
      controller.collapse();
    } else {
      controller.expand();
    }
  },
  child: Text('Toggle'),
)

// Don't forget to dispose
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## Configuration

### ButtonData
```dart
ButtonData<Model>(
  required selectedItemWidget: (item) => Widget,
  hint: Widget?,                    // Placeholder text
  buttonWidth: double,              // Default: double.infinity
  buttonHeight: double,             // Default: 50
  color: Color?,                    // Background color
  buttonBorderColor: Color?,
  buttonBorderRadius: BorderRadius?,
  padding: EdgeInsetsGeometry?,
  expandedListIcon: Widget?,        // Icon when open
  collapsedListIcon: Widget?,       // Icon when closed
)
```

### TextFieldData
```dart
TextFieldData<Model>(
  required onSearch: (pattern, item) => bool,
  controller: TextEditingController?,
  title: String?,                   // Label text
  prefixIcon: Widget?,
  suffixIcon: Widget?,
  borderRadius: double?,
  borderColor: Color?,
  contentPadding: EdgeInsetsGeometry?,
  fillColor: Color?,
  maxLength: int?,
  style: TextStyle?,
)
```

### ValuesData (Local Mode)
```dart
ValuesData<Model>(
  required itemBuilder: (context, index, item) => Widget,
)
```

### DropinityPagifyData (API Mode)
```dart
DropinityPagifyData<FullResponse, Model>(
  required controller: PagifyController<Model>,
  required asyncCall: (context, page) => Future<FullResponse>,
  required mapper: (response) => PagifyData<Model>,
  required errorMapper: PagifyErrorMapper,
  required itemBuilder: (context, data, index, item) => Widget,
  padding: EdgeInsetsGeometry,      // Default: EdgeInsets.zero
  itemExtent: double?,
  loadingBuilder: Widget?,
  errorBuilder: (error) => Widget?,
  emptyListView: Widget?,
  noConnectionText: String?,
  // Callbacks
  onUpdateStatus: (status) => void,
  onLoading: () => void,
  onSuccess: (context, data) => void,
  onError: (context, code, error) => void,
)
```

## Styling Example

```dart
Dropinity<void, Product>(
  controller: DropinityController(),
  listHeight: 350,
  curve: Curves.easeInOut,
  listBackgroundColor: Colors.grey[50]!,
  buttonData: ButtonData(
    buttonHeight: 60,
    color: Colors.blue[50],
    buttonBorderRadius: BorderRadius.circular(16),
    buttonBorderColor: Colors.blue,
    padding: EdgeInsets.all(16),
    hint: Row(
      children: [
        Icon(Icons.shopping_cart, color: Colors.blue),
        SizedBox(width: 8),
        Text('Select product'),
      ],
    ),
    selectedItemWidget: (product) => Text(product?.name ?? ''),
  ),
  textFieldData: TextFieldData(
    title: 'Search products',
    prefixIcon: Icon(Icons.search),
    borderRadius: 12,
    fillColor: Colors.white,
    onSearch: (pattern, product) =>
      product?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
  ),
  values: products,
  valuesData: ValuesData(
    itemBuilder: (context, i, product) => Container(
      padding: EdgeInsets.all(12),
      child: Text(product.name),
    ),
  ),
  onChanged: (product) => print(product.name),
)
```

## Form Integration

```dart
class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  Country? selectedCountry;
  City? selectedCity;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dropinity<void, Country>(
          controller: DropinityController(),
          buttonData: ButtonData(
            hint: Text('Select country'),
            selectedItemWidget: (c) => Text(c?.name ?? ''),
          ),
          textFieldData: TextFieldData(
            onSearch: (p, c) => c?.name.contains(p ?? '') ?? false,
          ),
          values: countries,
          valuesData: ValuesData(
            itemBuilder: (ctx, i, c) => ListTile(title: Text(c.name)),
          ),
          onChanged: (country) {
            setState(() {
              selectedCountry = country;
              selectedCity = null;
            });
          },
        ),
        
        if (selectedCountry != null)
          Dropinity<void, City>(
            controller: DropinityController(),
            buttonData: ButtonData(
              hint: Text('Select city'),
              selectedItemWidget: (c) => Text(c?.name ?? ''),
            ),
            textFieldData: TextFieldData(
              onSearch: (p, c) => c?.name.contains(p ?? '') ?? false,
            ),
            values: selectedCountry!.cities,
            valuesData: ValuesData(
              itemBuilder: (ctx, i, c) => ListTile(title: Text(c.name)),
            ),
            onChanged: (city) => setState(() => selectedCity = city),
          ),
      ],
    );
  }
}
```

## Best Practices

- Use API mode for datasets > 1000 items
- Always dispose controllers
- Use `typedef DropinityLocal<T> = Dropinity<void, T>` for cleaner local mode syntax
- Implement efficient `onSearch` logic
- Use `listHeight` to prevent overflow

```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## Links

- **Pagify Package**: [pub.dev/packages/pagify](https://pub.dev/packages/pagify)
- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)

---

**Made with ❤️ by Ahmed Emara**  
[LinkedIn](https://www.linkedin.com/in/ahmed-emara-11550526a/)
