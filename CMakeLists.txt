cmake_minimum_required(VERSION 3.16)

project(Map_ VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMap_
    main.cpp
)

qt_add_qml_module(appMap_
    URI Map_
    VERSION 1.0
    QML_FILES
        src/Main.qml
        components/PortMarker.qml
        components/ShipMarker.qml
        components/Dialogs.qml
        components/Sidebar.qml
        models/PortModel.qml
        models/ShipModel.qml
)

# qt_add_resources(RESOURCES resources.qrc)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMap_ PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMap_
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMap_
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appMap_
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
