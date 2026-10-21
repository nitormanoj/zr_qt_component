# Technical Specification

## 1. Overview

This project is a desktop application built with Qt 6 and QML. It is designed as a modern material-testing dashboard and demo UI for a test management workflow. The application uses a component-based QML architecture, with CMake as the build system and Qt Quick for rendering the user interface.

The project is not a traditional backend-heavy application. Instead, it focuses on desktop UI composition, state management, interactions, reusable components, and visual presentation of test data.

## 2. Architecture

### 2.1 High-level architecture

The application follows a layered structure:

- Application bootstrap layer: C++ entry point (`main.cpp`)
- UI layer: QML screens and reusable components
- Styling/theme layer: inline colors, fonts, spacing, and reusable visual patterns
- Data layer: generated in-memory demo data and property-backed state within QML objects
- Build/package layer: CMake + Qt deployment tooling

### 2.2 UI organization

The root application is defined in `Main.qml`. It acts as the main application shell and organizes navigation between screens:

- `landing`
- `documents`
- `analysis`
- `setup`

The main visual layout is:

- header navigation area
- left vertical navigation rail
- center content pane
- popup dialogs for setup and filtering

This architecture keeps the app modular and makes it easy to swap or extend screen components.

## 3. Technology stack

### 3.1 Qt 6

Qt 6 is the core framework used to build the application. It provides:

- rendering pipeline for UI
- event handling
- Qt Quick scene graph
- cross-platform desktop capabilities
- integration with C++ and QML

The project explicitly uses:

- `QtQuick`
- `QtQuick.Controls`
- `QtQuick.Layouts`
- `QtQuick.Shapes`
- `QtTest` for automated UI tests

### 3.2 QML

QML is used for the user interface. QML is a declarative language designed for Qt applications and is especially well-suited for interactive UI composition.

Common QML features used in this project:

- `ApplicationWindow` as the root window
- `Rectangle`, `RowLayout`, `ColumnLayout`, `GridLayout` for layout
- `Repeater` for list rendering
- `Button`, `ToolButton`, `ComboBox`, `CheckBox`, `Popup` for interaction
- `Image`, `Canvas`, `MouseArea` for visual and interaction logic
- `ListModel` for data-driven UI elements

### 3.3 C++ bootstrap

The application entry point is implemented in `main.cpp` and does the following:

- initializes `QGuiApplication`
- sets a default UI font
- creates `QQmlApplicationEngine`
- loads the module `QTDemoApp` and starts the app

This is the standard Qt Quick startup pattern for a QML-only UI.

### 3.4 CMake build system

The build configuration is defined in `CMakeLists.txt`.

Key CMake features:

- `project(...)` defines the application project
- `find_package(Qt6 REQUIRED COMPONENTS Quick)` finds Qt dependencies
- `qt_standard_project_setup(REQUIRES 6.10)` sets project conventions for Qt 6.10+
- `qt_add_executable(appQTDemoApp ...)` creates the executable target
- `qt_add_qml_module(...)` registers the QML module and resources
- `target_link_libraries(...)` links the Qt Quick library

This provides a modern, Qt-native build process that works well with QML projects.

## 4. UI and component design

### 4.1 Screen-driven navigation

The app uses explicit screen state properties such as:

- `screen`
- `activeMenu`
- `activeSection`
- `activeTab`

These properties decide which QML screen or panel is visible. This is a lightweight state management pattern commonly used in prototype and UI-driven applications.

### 4.2 Component-based design

Each screen is composed of smaller reusable QML components, such as:

- `SetupDialog`
- ` HeaderNav`
- `LeftNav`
- `Documents`
- `Landing`
- `Rotator`
- `AnalysisWorkspace`
- `AnalysisCurveGraph`
- `AnalysisStatistics`
- `GraphSettingsPopup`
- `DateFilterPopup`
- `ProgramFilterPopup`

This keeps the UI maintainable and reduces duplication.

### 4.3 Data-driven UI patterns

Several screens populate their content using inline arrays and objects, for example:

- recent test systems in `Landing.qml`
- specimen records in `Documents.qml`
- sensor definitions in `Main.qml`

The app uses JavaScript-style data structures inside QML, including:

- arrays of custom objects
- `ListModel` entries
- computed properties
- dynamic filter state

## 5. Functional features

### 5.1 Document management UI

`Documents.qml` includes significant logic for a table/listing interface:

- table sorting by column
- row selections
- filter chips
- popup-based filtering
- pagination calculations
- date range filtering
- analysis request to open the analysis workspace

This is one of the most technically rich screens in the project.

### 5.2 Analysis workspace

`AnalysisWorkspace.qml` implements the decision structure for a test-data analysis flow:

- tab system for curve graph and insights
- specimen list panel
- graph plotting area
- graph settings popup
- summary statistics panel

This component represents the main analytical view of the application.

### 5.3 Setup workflow

The app includes a multi-step setup style flow with properties such as:

- `targetType`
- `selectedStandard`
- `testingLabel`
- `activeSection`
- `sensorIndex`

This supports a UI flow where the user can configure a testing target, choose a sensor, and continue through setup steps.

## 6. Interaction logic

### 6.1 JavaScript functions in QML

The QML files use embedded JavaScript functions to manage behavior. Examples include:

- `startSetup()`
- `chooseSensor(i)`
- `previousSection()`
- `nextSection()`
- `sortBy(column)`
- `toggleRow(n)`
- `removeChip(index)`
- `clearFilters()`
- `analyseSelection()`

These functions perform operations such as:

- state transitions
- filter updates
- sorting logic
- selection management
- popup behavior

### 6.2 Signals

The project uses Qt signal-driven communication between components.

Examples:

- `analyseRequested(var specimens)` in `Documents.qml`
- `backRequested()` in `AnalysisWorkspace.qml`
- `onApplied` callback from `GraphSettingsPopup`

This is a Qt-native mechanism for event communication between parent and child components without tightly coupling them.

## 7. Styling and theming

The project uses inline styling rather than a full external theme engine.

Common patterns:

- fixed colors such as `#1a8080`, `#202a31`, `#d9dee2`
- `Segoe UI` as the default font
- radius values for card and control styling
- custom borders and backgrounds for selected states
- hover states through `MouseArea` and `Button` properties

This is typical for a quick design-to-code prototype where visual polish is more important than a large theming system.

## 8. Input and event handling

Qt Quick uses mouse, hover, and click events extensively:

- `MouseArea` for clickable cards and controls
- `onClicked` for button actions
- `hoverEnabled` for hover styling
- `ToolTip` for helper text
- `Accessible.name` for accessibility labeling

The app is designed for interactive desktop use and relies on Qt’s event model for smooth user interaction.

## 9. Testing strategy

The application includes Qt Test cases for behavior validation.

### 9.1 Testing framework

Files:

- `tests/tst_Documents.qml`
- `tests/tst_Analysis.qml`

These use `QtTest` to run UI-level assertions and verify state transitions, including:

- filter behavior
- sort ordering
- pagination sizing
- sticky header behavior
- popup open/close behavior
- row selection logic

### 9.2 Validation model

The tests validate real UI behavior rather than isolated mock behavior. This is a good testing approach for QML because many interactions are tied directly to visual state and user input.

## 10. Packaging and deployment

The repository includes a packaging script:

- `build-and-package.ps1`

This script performs the following actions:

1. validates the project path and CMake configuration
2. checks that the current build type is `Release`
3. locates the Qt deployment tools (`windeployqt`)
4. builds the project using CMake/Ninja
5. verifies the generated executable exists
6. copies the app to a portable directory
7. deploys Qt runtime binaries into the folder
8. creates a zip archive for distribution

This is a Windows-specific packaging flow for portable deployment.

## 11. Resource management

Resources are organized into separate folders:

- `icons/` – SVG icons for navigation, filters, and actions
- `images/` – test-machine and specimen visual assets
- `importedcontent/` – imported content from a design source

The QML project registers many of these assets using `qt_add_qml_module` and resource declarations in the QML module setup.

## 12. Strengths of the implementation

- Modular screen structure
- Reusable QML component approach
- Good visual polish for a prototype
- Qt-native bindings and state handling
- Suitable for rapid UI prototyping and design validation
- Good separation between the app shell and feature screens

## 13. Limitations and technical considerations

- The app uses in-memory demo data instead of persistent backend storage.
- There is no real API integration or database layer.
- State is kept inside QML properties; this is fine for prototyping but not ideal for larger app complexity.
- Styling is embedded directly in components, which can become harder to maintain as the app grows.
- No explicit MVVM or business-layer architecture is implemented yet.

## 14. Summary

This project is a Qt 6/QML desktop application with a well-structured UI prototype focusing on material testing workflows. It uses CMake for build automation, QML for declarative interface design, JavaScript in QML for interaction logic, and Qt Test for UI validation. The project demonstrates how to build a modern desktop application prototype with reusable components, dynamic screen navigation, and polished visual design.
