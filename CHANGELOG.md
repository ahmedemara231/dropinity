## 0.0.3

#### 💾 Offline Caching
- Added offline caching support via `cacheKey`, `cacheToJson`, `cacheFromJson`, `onSaveCache`, and `onReadCache` properties in `DropinityPagifyData`.
- Enables persisting and restoring paginated data between sessions.

#### 🔔 Expand / Collapse Callbacks
- New `onExpand` callback fired when the dropdown opens.
- New `onCollapse` callback fired when the dropdown closes.

#### 🔁 State Persistence
- Added `maintainState` flag to preserve the list scroll position and state when toggling the dropdown.

#### 📣 Immediate `onChanged` Trigger
- `onChanged` is now triggered on initialization when an `initialValue` is set, so the parent widget always reflects the current selection.

#### ✅ Multi-Selection Support
- Added `enableMultiSelection` flag to support selecting multiple items.
- New `initialValues` list to pre-populate a multi-selection.
- New `onListChanged` callback that returns the full list of selected items.

#### 🚫 No-Data Alert
- Added `showNoDataAlert` to `DropinityPagifyData` to control whether an alert is shown when the API returns an empty list.

#### ⚙️ Improved Error Handling
- `errorBuilder` now receives a typed `PagifyException` instead of a plain `String`.
- New `ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty` flag: when `true`, suppresses the error widget if the list already has data loaded.
- `onError` callback signature updated to `(BuildContext, int, PagifyException)`.

---

## 0.0.2

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
- Simple `Dropinity` API with two constructors:
    - `Dropinity.withApiRequest()` — for remote data.
    - `Dropinity()` — for local data.
- Clear separation of configuration through data classes:
    - `ButtonData`
    - `TextFieldData`
    - `ValuesData`
    - `DropinityPagifyData`

#### 🧠 Built-In State Management
- Uses `ValueNotifier` to maintain reactive dropdown, initialization, and list updates.
- Efficiently toggles between open/close states with animation.
