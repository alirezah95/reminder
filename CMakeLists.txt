cmake_minimum_required(VERSION 3.14)

project(reminder VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick Sql REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick Sql REQUIRED)

if (ANDROID)
	set(STATUSBAR_PLATFORM_SOURCES
		qtstatusbar/src/statusbar.h qtstatusbar/src/statusbar.cpp
		qtstatusbar/src/statusbar_android.cpp)
elseif (CMAKE_SYSTEM_NAME STREQUAL iOS)
	set(STATUSBAR_PLATFORM_SOURCES
		qtstatusbar/src/statusbar.h qtstatusbar/src/statusbar.cpp
		qtstatusbar/src/statusbar_ios.cpp)
else()
	set(STATUSBAR_PLATFORM_SOURCES
		qtstatusbar/src/statusbar.h qtstatusbar/src/statusbar.cpp
		qtstatusbar/src/statusbar_dummy.cpp)
endif()

set(PROJECT_SOURCES
        main.cpp
		alarm/alarmtime.hpp alarm/alarmtime.cpp
		alarm/sqlalarmmodel.hpp alarm/sqlalarmmodel.cpp
		alarm/alarmproxymodel.hpp alarm/alarmproxymodel.cpp
		${STATUSBAR_PLATFORM_SOURCES}
        qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(reminder
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET reminder APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(reminder SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(reminder
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(reminder
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(reminder
	PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick
	Qt${QT_VERSION_MAJOR}::Sql)

set_target_properties(reminder PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(reminder)
    qt_finalize_executable(reminder)
endif()
