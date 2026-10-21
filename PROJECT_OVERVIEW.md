# QTDemoApp Overview

This repository contains a Qt Quick desktop application prototype for a material-testing workflow. The app is implemented primarily in QML and built with CMake using the Qt 6 Quick module.

## 1. Project purpose

The application presents an industrial dashboard for test-system setup and specimen analysis. It includes:

- landing screen with recent test systems
- left navigation sidebar
- documents table with filters and pagination
- analysis workspace with curve graph and statistics
- setup wizard and sensor configuration UI
- status popups and small reusable widgets

This feels like a design-demo application or UI mockup, with interactive QML behavior but no real device/backend integration.

## 2. Technology stack

- C++ entry point: `main.cpp`
- UI framework: Qt 6 / Qt Quick
- Build system: CMake
- QML components: multiple `.qml` files
- Testing: Qt Test (`tests/tst_Documents.qml` and `tests/tst_Analysis.qml`)
- Packaging: Windows deployment script using `windeployqt`

## 3. Main application entry points

### `CMakeLists.txt`

This is the project root build definition. It:

- requires CMake 3.16+
- enables C++ project setup
- finds the Qt 6 Quick package
- creates the `appQTDemoApp` target
- registers QML modules via `qt_add_qml_module`
- links the app to `Qt6::Quick`

### `main.cpp`

This is the runtime bootstrap for the Qt app. It:

- creates a `QGuiApplication`
- sets the default font to Segoe UI
- loads the QML module via `engine.loadFromModule("QTDemoApp", "Main")`

## 4. Core UI structure

### `Main.qml`

This is the root application window. It defines:

- app size and minimum dimensions
- theme colors and common properties
- screen navigation state (`landing`, `documents`, `analysis`, `setup`)
- sidebar and main content container
- popup dialogs

The main app switches between screens through a few state variables, including:

- `screen`
- `activeMenu`
- `analysisSpecimens`
- `selectedStandard`

### `Landing.qml`

This is the first/default screen. It shows:

- a “Create A New Testing System” CTA
- a grid of recent systems cards
- image previews for specimen/test assets
- interactions that open the setup flow or navigate to the setup screen

### `LeftNav.qml`

This file renders the left navigation rail with icons for:

- testing
- users
- tasks
- documents
- upload
- messages

### `Documents.qml`

This is the documents table screen, and it is the richest QML screen in the app. It includes:

- filter chips and dropdown-based filters
- column sorting
- draggable/reordered table columns
- pagination
- row selection behavior
- data generation for specimen records
- analysis request signal to open the Analysis Workspace

It also includes reusable QML components such as:

- `StyledComboBox`
- `PageButton`
- `Action`
- `TableIconButton`
- `SelectionBox`

### `AnalysisWorkspace.qml`

This screen is for viewing selected test data and produces the analysis workflow. It includes:

- back navigation to the documents screen
- tabs for “Curve Graph And Statistics” and “Insights”
- specimen legend panel
- graph area with settings button
- statistics panel
- integration with `AnalysisCurveGraph.qml` and `AnalysisStatistics.qml`

### `AnalysisCurveGraph.qml`

This component renders the plotted specimen curves and graph styling, likely for material-testing curves.

### `AnalysisStatistics.qml`

This component is used for summary statistics and likely displays computed metrics from selected specimens.

### `AnalysisInsights.qml`

This component appears to hold the insights tab content for deeper analysis output.

## 5. Supporting UI and widgets

The project contains several reusable QML files.

- `SetupDialog.qml` – modal setup dialog for creating a new test system
- `ProgramFilterPopup.qml` – filter popup for program selection
- `DateFilterPopup.qml` – date range popup logic
- `GraphSettingsPopup.qml` – graph customization popup
- `HeaderNav.qml` – header/navigation toolbar
- `FlatButton.qml` – common button style helper
- `NavIcon.qml` – icon-style navigation item
- `Rotator.qml` – rotary or section-transition display screen for setup flow
- `MachinePicture.qml` – standard machine card image component

## 6. Resources

Static assets are organized in these folders:

- `icons/` – SVG icons for navigation, filters, and actions
- `images/` – specimen and machine visuals
- `importedcontent/` – imported design content, including a `README.md` describing downloaded Figma-like design assets

## 7. Tests

The project includes Qt Quick tests in the `tests` folder.

- `tests/tst_Documents.qml`
- `tests/tst_Analysis.qml`

The document tests validate:

- filter panel behavior
- chip/filter removal
- date range logic
- pagination
- sticky headers
- column sorting and drag interactions

This shows the project is structured to test UI state transitions and QML interaction logic.

## 8. Build and run

### Standard CMake build

From the project root:

```bash
cmake -S . -B build
cmake --build build
```

The project already contains a configured `build/` directory in the workspace and an executable target named `appQTDemoApp`.

### Release packaging

There is a PowerShell script:

- `build-and-package.ps1`

This script checks for a Release configuration, builds the app, and packages it using `windeployqt`. It creates:

- `portable-app/`
- `appQTDemoApp-Windows-Release.zip`

It validates that the build is using a `Release` CMake configuration before packaging.

## 9. Current state of the repository

Based on the workspace contents, the project appears to be in a working state with:

- generated CMake build outputs under `build/`
- packaged output files already created in the repo root
- a windowed Qt Quick desktop prototype ready to run

## 10. Suggested next steps

1. Add a real README for project setup and contributor workflow.
2. Create a proper architecture map for each QML screen and reusable component.
3. Add data-model separation if this app evolves into a complete product.
4. Connect the UI to real backend/test-system data instead of demo data.
5. Expand automated tests beyond UI state and into graph/statistics behavior.

## 11. Summary

This codebase is a Qt 6 QML demo application focused on industrial testing workflows. It combines a modern dark/light dashboard UI, specimen analysis views, and a functional QML-based document table with sorting and filtering logic. The design is strongly UI-centric and intended as a prototype or frontend mockup rather than a backend-connected product.
