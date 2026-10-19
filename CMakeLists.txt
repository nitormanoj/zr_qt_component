cmake_minimum_required(VERSION 3.16)

project(QTDemoApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appQTDemoApp
    main.cpp
)

qt_add_qml_module(appQTDemoApp
    URI QTDemoApp
    QML_FILES
        Main.qml Documents.qml ProgramFilterPopup.qml DateFilterPopup.qml
        AnalysisWorkspace.qml AnalysisCurveGraph.qml AnalysisStatistics.qml
        GraphSettingsPopup.qml
        AnalysisInsights.qml
        RESOURCES icons/documents.svg icons/messages.svg icons/tasks.svg icons/testing.svg icons/upload.svg icons/users.svg images/compression.png images/metal.png images/round-specimen.png images/tensile.png images/testing-machine.png
        QML_FILES SetupDialog.qml FlatButton.qml HeaderNav.qml Landing.qml LeftNav.qml MachinePicture.qml NavIcon.qml Rotator.qml
        RESOURCES icons/header-bell.svg icons/header-grid.svg icons/header-settings.svg icons/header-shield-off.svg
        RESOURCES icons/sidebar-toggle.svg
        RESOURCES icons/documents-grid.svg icons/documents-sliders.svg
        RESOURCES icons/filter-saved.svg icons/filter-program.svg icons/filter-material.svg icons/filter-job.svg icons/filter-date.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQTDemoApp PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQTDemoApp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQTDemoApp
    PRIVATE Qt6::Quick
)

install(TARGETS appQTDemoApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
