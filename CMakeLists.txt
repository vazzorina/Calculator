cmake_minimum_required(VERSION 3.16)

project(CalculatorAndroid VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCalculatorAndroid
    main.cpp
)

qt_add_qml_module(appCalculatorAndroid
    URI CalculatorAndroid
    VERSION 1.0
    QML_FILES
        Main.qml
        ButtonNumber.qml
        ButtonSign.qml
    RESOURCES
        rsc/fonts/OpenSans-SemiBold.ttf
        rsc/icons/bkt.svg
        rsc/icons/plus_minus.svg
        rsc/icons/percent.svg
        rsc/icons/division.svg
        rsc/icons/multiplication.svg
        rsc/icons/minus.svg
        rsc/icons/plus.svg
        rsc/icons/equal.svg
        android/AndroidManifest.xml
        android/build.gradle
        android/res/values/libs.xml
        android/res/xml/qtprovider_paths.xml
        android/res/values/styles.xml
    SOURCES
        backend.h
        backend.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCalculatorAndroid PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCalculatorAndroid
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCalculatorAndroid
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appCalculatorAndroid
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
