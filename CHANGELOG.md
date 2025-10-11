## 0.0.1

#### 🔁 Pagination
- Integrated with the [`pagify`](https://pub.dev/packages/pagify) package for effortless pagination.
- Supports async API calls with loading, success, and error states.
- Includes automatic retry, refresh, and filtering support.

#### 🎨 Customizable UI
- Customizable main button (color, radius, padding, icons, size, etc.).
- Customizable text field for search input with full styling control.
- Animated dropdown with smooth transitions.
- `maintainState` behavior ensures list state persists when toggled.

#### 🔍 Smart Search
- Local search: filter through a predefined list of models.
- Remote search: perform API-based search through `Pagify` controllers.
- Automatically updates the list view based on search pattern.

#### 🌐 Dual Data Modes
- **Local Mode:** Use predefined list of `Model` items.
- **Remote Mode:** Fetch paginated data from API using `Pagify`.

#### 🧩 Developer Friendly
- Simple `SearchableDropdown` API with two constructors:
    - `SearchableDropdown.withApiRequest()` — for remote data.
    - `SearchableDropdown()` — for local data.
- Clear separation of configuration through data classes:
    - `ButtonData`
    - `TextFieldData`
    - `ValuesData`
    - `SearchableDropdownPagifyData`

#### 🧠 Built-In State Management
- Uses `ValueNotifier` to maintain reactive dropdown, initialization, and list updates.
- Efficiently toggles between open/close states with animation.


