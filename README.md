# Dropinity

[![pub package](https://img.shields.io/pub/v/dropinity.svg)](https://pub.dev/packages/dropinity)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev)

A powerful and customizable Flutter dropdown widget with built-in search functionality and seamless pagination support for both local and remote data sources.

---

## Table of Contents

- [Features](#features)
- [Demo](#demo)
- [Installation](#installation)
- [Getting Started](#getting-started)
  - [Basic Usage](#basic-usage)
  - [With API Integration](#with-api-integration)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
- [Advanced Features](#advanced-features)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Features

✨ **Core Capabilities**
- 🔍 Real-time search filtering with customizable search logic
- 📡 Seamless API integration with automatic pagination via [Pagify](https://pub.dev/packages/pagify)
- 💾 Dual mode support: local data lists or remote API endpoints
- 🎨 Fully customizable UI components (buttons, text fields, list items)
- 🎭 Smooth animations with customizable curves
- 🎯 Type-safe implementation using generics
- ✅ Built-in form validation support
- 🎮 Programmatic control via `DropinityController`
- 🔄 State persistence when toggling dropdown
- 📱 Platform-agnostic (iOS, Android, Web, Desktop)

---

## Demo

> **Note:** Add screenshots or GIFs of your widget in action here for better visibility on pub.dev

```dart
// See examples below for working code
```

---

## Installation

Add `dropinity` to your `pubspec.yaml`:

```yaml
dependencies:
  dropinity: ^0.0.2
```

Then run:

```bash
flutter pub get
```

Import the package:

```dart
import 'package:dropinity/custom_drop_down/dropinity.dart';
```

---

## Getting Started

### Basic Usage

For simple dropdown with a predefined list of items:

```dart
import 'package:dropinity/custom_drop_down/dropinity.dart';
import 'package:flutter/material.dart';

class SimpleDropdownExample extends StatelessWidget {
  final controller = DropinityController();

  @override
  Widget build(BuildContext context) {
    return Dropinity<void, String>(
      controller: controller,
      buttonData: ButtonData(
        hint: Text('Select a fruit'),
        selectedItemWidget: (fruit) => Text(fruit ?? ''),
      ),
      textFieldData: TextFieldData(
        onSearch: (pattern, fruit) =>
            fruit?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
      ),
      values: ['Apple', 'Banana', 'Orange', 'Mango', 'Grape'],
      valuesData: ValuesData(
        itemBuilder: (context, index, fruit) => ListTile(
          title: Text(fruit),
          leading: Icon(Icons.check_circle_outline),
        ),
      ),
      onChanged: (selectedFruit) {
        print('Selected: $selectedFruit');
      },
    );
  }
}
```

### With API Integration

For dropdown with paginated API data:

```dart
import 'package:dropinity/custom_drop_down/dropinity.dart';
import 'package:pagify/pagify.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class ApiResponse {
  final List<User> users;
  final int totalPages;

  ApiResponse({required this.users, required this.totalPages});
}

class ApiDropdownExample extends StatefulWidget {
  @override
  _ApiDropdownExampleState createState() => _ApiDropdownExampleState();
}

class _ApiDropdownExampleState extends State<ApiDropdownExample> {
  final _dropinityController = DropinityController();
  final _pagifyController = PagifyController<User>();

  @override
  void dispose() {
    _dropinityController.dispose();
    _pagifyController.dispose();
    super.dispose();
  }

  Future<ApiResponse> _fetchUsers(int page) async {
    // Your API call here
    final response = await http.get(Uri.parse('https://api.example.com/users?page=$page'));
    // Parse and return data
    return ApiResponse(users: parsedUsers, totalPages: totalPages);
  }

  @override
  Widget build(BuildContext context) {
    return Dropinity<ApiResponse, User>.withApiRequest(
      controller: _dropinityController,
      buttonData: ButtonData(
        hint: Text('Select a user'),
        selectedItemWidget: (user) => Text(user?.name ?? ''),
      ),
      textFieldData: TextFieldData(
        onSearch: (pattern, user) =>
            user?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
      ),
      pagifyData: DropinityPagifyData(
        controller: _pagifyController,
        asyncCall: (context, page) => _fetchUsers(page),
        mapper: (response) => PagifyData(
          data: response.users,
          paginationData: PaginationData(
            totalPages: response.totalPages,
            perPage: 20,
          ),
        ),
        errorMapper: PagifyErrorMapper(
          // Configure error handling
        ),
        itemBuilder: (context, data, index, user) => ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          leading: CircleAvatar(child: Text(user.name[0])),
        ),
      ),
      onChanged: (user) {
        print('Selected user: ${user.name}');
      },
    );
  }
}
```

---

## Usage Examples

### 1. Custom Styling

Create a beautifully styled dropdown:

```dart
Dropinity<void, String>(
  controller: DropinityController(),
  listHeight: 300,
  curve: Curves.easeInOutCubic,
  listBackgroundColor: Colors.grey[50]!,
  buttonData: ButtonData(
    hint: Row(
      children: [
        Icon(Icons.category, color: Colors.blue),
        SizedBox(width: 8),
        Text('Choose category', style: TextStyle(color: Colors.grey[600])),
      ],
    ),
    selectedItemWidget: (item) => Text(
      item ?? '',
      style: TextStyle(fontWeight: FontWeight.w600),
    ),
    buttonHeight: 56,
    buttonBorderRadius: BorderRadius.circular(16),
    buttonBorderColor: Colors.blue.shade200,
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 16),
    expandedListIcon: Icon(Icons.arrow_drop_up, color: Colors.blue),
    collapsedListIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
  ),
  textFieldData: TextFieldData(
    title: 'Search categories',
    prefixIcon: Icon(Icons.search, color: Colors.blue),
    borderRadius: 12,
    borderColor: Colors.blue.shade100,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    onSearch: (pattern, item) =>
        item?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
  ),
  values: ['Electronics', 'Clothing', 'Food', 'Books', 'Toys'],
  valuesData: ValuesData(
    itemBuilder: (context, index, category) => Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.label, color: Colors.blue.shade300, size: 20),
          SizedBox(width: 12),
          Text(category, style: TextStyle(fontSize: 15)),
        ],
      ),
    ),
  ),
  onChanged: (category) => print('Selected: $category'),
)
```

### 2. Form Validation

Integrate with Flutter forms:

```dart
class ValidatedForm extends StatefulWidget {
  @override
  _ValidatedFormState createState() => _ValidatedFormState();
}

class _ValidatedFormState extends State<ValidatedForm> {
  final _formKey = GlobalKey<FormState>();
  final _dropinityController = DropinityController();
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Dropinity<void, String>(
            controller: _dropinityController,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a country';
              }
              return null;
            },
            errorWidget: (errorMsg) => Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                errorMsg,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            buttonData: ButtonData(
              hint: Text('Select country *'),
              selectedItemWidget: (country) => Text(country ?? ''),
            ),
            textFieldData: TextFieldData(
              onSearch: (pattern, country) =>
                  country?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
            ),
            values: ['USA', 'Canada', 'UK', 'Germany', 'France'],
            valuesData: ValuesData(
              itemBuilder: (context, index, country) => ListTile(
                title: Text(country),
              ),
            ),
            onChanged: (country) {
              setState(() => selectedCountry = country);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Form is valid!');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dropinityController.dispose();
    super.dispose();
  }
}
```

### 3. Programmatic Control

Control dropdown behavior with the controller:

```dart
class ControlledDropdown extends StatefulWidget {
  @override
  _ControlledDropdownState createState() => _ControlledDropdownState();
}

class _ControlledDropdownState extends State<ControlledDropdown> {
  final _controller = DropinityController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dropinity<void, String>(
          controller: _controller,
          buttonData: ButtonData(
            hint: Text('Select option'),
            selectedItemWidget: (item) => Text(item ?? ''),
          ),
          textFieldData: TextFieldData(
            onSearch: (pattern, item) =>
                item?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
          ),
          values: ['Option 1', 'Option 2', 'Option 3'],
          valuesData: ValuesData(
            itemBuilder: (context, index, item) => ListTile(title: Text(item)),
          ),
          onChanged: (item) => print(item),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.expand(),
              child: Text('Open'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _controller.collapse(),
              child: Text('Close'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_controller.isExpanded) {
                  _controller.collapse();
                } else {
                  _controller.expand();
                }
              },
              child: Text('Toggle'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 4. Dependent Dropdowns

Create cascading dropdowns:

```dart
class Country {
  final String name;
  final List<String> cities;

  Country({required this.name, required this.cities});
}

class DependentDropdowns extends StatefulWidget {
  @override
  _DependentDropdownsState createState() => _DependentDropdownsState();
}

class _DependentDropdownsState extends State<DependentDropdowns> {
  final _countryController = DropinityController();
  final _cityController = DropinityController();

  final countries = [
    Country(name: 'USA', cities: ['New York', 'Los Angeles', 'Chicago']),
    Country(name: 'Canada', cities: ['Toronto', 'Vancouver', 'Montreal']),
    Country(name: 'UK', cities: ['London', 'Manchester', 'Birmingham']),
  ];

  Country? selectedCountry;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Country', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Dropinity<void, Country>(
          controller: _countryController,
          buttonData: ButtonData(
            hint: Text('Choose a country'),
            selectedItemWidget: (country) => Text(country?.name ?? ''),
          ),
          textFieldData: TextFieldData(
            onSearch: (pattern, country) =>
                country?.name.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
          ),
          values: countries,
          valuesData: ValuesData(
            itemBuilder: (context, index, country) => ListTile(
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
        SizedBox(height: 20),
        if (selectedCountry != null) ...[
          Text('Select City', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Dropinity<void, String>(
            controller: _cityController,
            buttonData: ButtonData(
              hint: Text('Choose a city'),
              selectedItemWidget: (city) => Text(city ?? ''),
            ),
            textFieldData: TextFieldData(
              onSearch: (pattern, city) =>
                  city?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false,
            ),
            values: selectedCountry!.cities,
            valuesData: ValuesData(
              itemBuilder: (context, index, city) => ListTile(
                title: Text(city),
              ),
            ),
            onChanged: (city) {
              setState(() => selectedCity = city);
            },
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
```

### 5. Type-safe with Custom Models

Use your own data models:

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });
}

// Usage
Dropinity<void, Product>(
  controller: DropinityController(),
  buttonData: ButtonData(
    hint: Text('Select product'),
    selectedItemWidget: (product) => Text(product?.name ?? ''),
    initialValue: products.first, // Set initial value
  ),
  textFieldData: TextFieldData(
    title: 'Search products',
    prefixIcon: Icon(Icons.search),
    onSearch: (pattern, product) {
      if (pattern == null || pattern.isEmpty) return true;
      final query = pattern.toLowerCase();
      return product?.name.toLowerCase().contains(query) ??
          false || product?.category.toLowerCase().contains(query) ?? false;
    },
  ),
  values: products,
  valuesData: ValuesData(
    itemBuilder: (context, index, product) => ListTile(
      title: Text(product.name),
      subtitle: Text('${product.category} - \$${product.price}'),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    ),
  ),
  onChanged: (product) {
    print('Selected: ${product.name} - \$${product.price}');
  },
)
```

---

## API Reference

### Dropinity Widget

#### Constructors

**Default Constructor (Local Mode)**
```dart
Dropinity<void, Model>({
  required DropinityController controller,
  required ButtonData<Model> buttonData,
  required List<Model> values,
  required ValuesData<Model> valuesData,
  required Function(Model) onChanged,
  TextFieldData<Model>? textFieldData,
  String? Function(Model?)? validator,
  AutovalidateMode? autoValidateMode,
  Widget Function(String)? errorWidget,
  Widget? dropdownTitle,
  double? listHeight,
  Curve curve = Curves.linear,
  Color listBackgroundColor = Colors.white,
})
```

**API Constructor (Remote Mode)**
```dart
Dropinity<FullResponse, Model>.withApiRequest({
  required DropinityController controller,
  required ButtonData<Model> buttonData,
  required DropinityPagifyData<FullResponse, Model> pagifyData,
  required Function(Model) onChanged,
  TextFieldData<Model>? textFieldData,
  String? Function(Model?)? validator,
  AutovalidateMode? autoValidateMode,
  Widget Function(String)? errorWidget,
  Widget? dropdownTitle,
  double? listHeight,
  Curve curve = Curves.linear,
  Color listBackgroundColor = Colors.white,
})
```

### ButtonData

Configuration for the dropdown button:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `selectedItemWidget` | `Widget Function(Model?)` | **required** | Builder for selected item display |
| `hint` | `Widget?` | `null` | Placeholder widget when nothing is selected |
| `initialValue` | `Model?` | `null` | Pre-selected value |
| `buttonWidth` | `double` | `double.infinity` | Button width |
| `buttonHeight` | `double` | `50` | Button height |
| `color` | `Color?` | `Colors.white` | Background color |
| `buttonBorderColor` | `Color?` | `Colors.grey[300]` | Border color |
| `buttonBorderRadius` | `BorderRadius?` | `BorderRadius.circular(12)` | Border radius |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(12)` | Internal padding |
| `expandedListIcon` | `Widget?` | `Icon(Icons.arrow_drop_up)` | Icon when dropdown is open |
| `collapsedListIcon` | `Widget?` | `Icon(Icons.arrow_drop_down)` | Icon when dropdown is closed |

### TextFieldData

Configuration for the search text field:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onSearch` | `bool Function(String?, Model)` | **required** | Search filter logic |
| `controller` | `TextEditingController?` | `null` | Text field controller |
| `title` | `String?` | `null` | Label/hint text |
| `prefixIcon` | `Widget?` | `null` | Leading icon |
| `suffixIcon` | `Widget?` | `null` | Trailing icon |
| `borderRadius` | `double?` | `null` | Border radius |
| `borderColor` | `Color?` | `null` | Border color |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Internal padding |
| `fillColor` | `Color?` | `null` | Background color |
| `maxLength` | `int?` | `null` | Maximum character length |
| `style` | `TextStyle?` | `null` | Text style |

### ValuesData

Configuration for local data list:

| Parameter | Type | Description |
|-----------|------|-------------|
| `itemBuilder` | `Widget Function(BuildContext, int, Model)` | Builder for list items |

### DropinityPagifyData

Configuration for API-based pagination:

| Parameter | Type | Description |
|-----------|------|-------------|
| `controller` | `PagifyController<Model>` | Pagination controller from Pagify |
| `asyncCall` | `Future<FullResponse> Function(BuildContext, int)` | API call function |
| `mapper` | `PagifyData<Model> Function(FullResponse)` | Response to data mapper |
| `errorMapper` | `PagifyErrorMapper` | Error handling mapper |
| `itemBuilder` | `Widget Function(BuildContext, PagifyData, int, Model)` | List item builder |
| `padding` | `EdgeInsetsGeometry` | List padding |
| `itemExtent` | `double?` | Fixed item height |
| `loadingBuilder` | `Widget?` | Custom loading indicator |
| `errorBuilder` | `Widget Function(String)?` | Custom error widget |
| `emptyListView` | `Widget?` | Widget when list is empty |
| `noConnectionText` | `String?` | No connection message |
| `onUpdateStatus` | `void Function(PagifyStatus)?` | Status change callback |
| `onLoading` | `void Function()?` | Loading state callback |
| `onSuccess` | `void Function(BuildContext, PagifyData)?` | Success callback |
| `onError` | `void Function(BuildContext, int?, String)?` | Error callback |

### DropinityController

Methods to programmatically control the dropdown:

```dart
final controller = DropinityController();

// Methods
controller.expand();      // Open the dropdown
controller.collapse();    // Close the dropdown
controller.dispose();     // Clean up resources

// Properties
controller.isExpanded;    // Returns true if dropdown is open
controller.isCollapsed;   // Returns true if dropdown is closed
```

---

## Advanced Features

### Using TypeDefs for Cleaner Code

For local-only dropdowns, use a typedef to simplify the syntax:

```dart
typedef DropinityLocal<Model> = Dropinity<void, Model>;

// Now you can use:
DropinityLocal<String>(
  // ... configuration
)

// Instead of:
Dropinity<void, String>(
  // ... configuration
)
```

### Custom Search Logic

Implement complex search patterns:

```dart
TextFieldData<Product>(
  onSearch: (pattern, product) {
    if (pattern == null || pattern.isEmpty) return true;

    final query = pattern.toLowerCase();

    // Search across multiple fields
    return product?.name.toLowerCase().contains(query) ??
        false ||
        product?.category.toLowerCase().contains(query) ??
        false ||
        product?.id.contains(query) ??
        false;
  },
)
```

### Error Handling in API Mode

Comprehensive error handling with Pagify:

```dart
DropinityPagifyData<ApiResponse, User>(
  // ... other configuration
  errorMapper: PagifyErrorMapper(
    errorWhenDio: (dioError) {
      // Handle Dio errors
      return PagifyApiRequestException(
        dioError.message ?? 'Unknown error',
        pagifyFailure: RequestFailureData(
          statusCode: dioError.response?.statusCode,
          statusMsg: dioError.response?.statusMessage,
        ),
      );
    },
  ),
  errorBuilder: (error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red),
        SizedBox(height: 16),
        Text(error, style: TextStyle(color: Colors.red)),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _pagifyController.refresh(),
          child: Text('Retry'),
        ),
      ],
    ),
  ),
  onError: (context, statusCode, error) {
    // Log errors, show snackbar, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  },
)
```

---

## Best Practices

### 1. Controller Lifecycle Management

Always dispose controllers to prevent memory leaks:

```dart
@override
void dispose() {
  _dropinityController.dispose();
  _pagifyController?.dispose(); // If using API mode
  super.dispose();
}
```

### 2. Choose the Right Mode

- **Local Mode**: For < 1000 items, simple static lists, or client-side filtering
- **API Mode**: For large datasets, server-side pagination, or dynamic data

### 3. Optimize Search Performance

```dart
// ✅ Good - Case-insensitive, null-safe
onSearch: (pattern, item) =>
    item?.toLowerCase().contains(pattern?.toLowerCase() ?? '') ?? false

// ❌ Avoid - Missing null checks, complex operations
onSearch: (pattern, item) =>
    item.toUpperCase().split('').reversed.join().contains(pattern)
```

### 4. Use Type Aliases

```dart
typedef DropinityLocal<T> = Dropinity<void, T>;

// Cleaner syntax for local dropdowns
DropinityLocal<String>(...)
```

### 5. Set Appropriate List Height

```dart
// Prevent overflow on smaller screens
listHeight: MediaQuery.of(context).size.height * 0.3

// Or use fixed height for consistent UI
listHeight: 250
```

### 6. Handle Empty States

```dart
valuesData: ValuesData(
  itemBuilder: (context, index, item) {
    if (items.isEmpty) {
      return Center(
        child: Text('No items found'),
      );
    }
    return ListTile(title: Text(item));
  },
)
```

---

## Troubleshooting

### Common Issues

**1. Dropdown not showing items**
- Ensure `values` list is not empty in local mode
- Check that `asyncCall` is returning data in API mode
- Verify `itemBuilder` is returning a valid widget

**2. Search not working**
- Confirm `onSearch` callback is implemented correctly
- Check for null safety in search logic
- Ensure pattern comparison logic matches your data

**3. Validation errors not showing**
- Set `autoValidateMode` to `AutovalidateMode.onUserInteraction`
- Provide `validator` function that returns error strings
- Optionally customize with `errorWidget`

**4. Memory leaks**
- Always call `dispose()` on controllers in the widget's `dispose` method
- Don't forget to dispose both `DropinityController` and `PagifyController`

**5. API pagination not loading**
- Verify `mapper` correctly extracts data from API response
- Check `PaginationData` has correct `totalPages` value
- Ensure `asyncCall` returns properly formatted response

### Debug Mode

Enable debug logging:

```dart
// In your API calls
asyncCall: (context, page) async {
  print('Fetching page: $page');
  final response = await yourApiCall(page);
  print('Received ${response.data.length} items');
  return response;
}
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
git clone https://github.com/ahmedemara231/dropinity.git
cd dropinity
flutter pub get
flutter test
```

### Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Add tests for new features
- Update documentation for API changes
- Run `flutter analyze` before committing

---

## Related Packages

- **[Pagify](https://pub.dev/packages/pagify)** - Pagination helper used for API mode
- **[dropdown_button2](https://pub.dev/packages/dropdown_button2)** - Alternative dropdown implementation
- **[searchable_dropdown](https://pub.dev/packages/searchable_dropdown)** - Another searchable dropdown package

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Ahmed Emara

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## Author

**Ahmed Emara**

- LinkedIn: [Ahmed Emara](https://www.linkedin.com/in/ahmed-emara-11550526a/)
- GitHub: [@ahmedemara231](https://github.com/ahmedemara231)
- Email: Contact via GitHub

---

## Support

If you find this package useful, please consider:

- ⭐ Starring the repository
- 🐛 Reporting bugs via [GitHub Issues](https://github.com/ahmedemara231/dropinity/issues)
- 💡 Suggesting features
- 📖 Improving documentation
- 👍 Liking on [pub.dev](https://pub.dev/packages/dropinity)

---

**Made with ❤️ for the Flutter community**
