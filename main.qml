import QtQuick
import QtQuick.Controls 2.5
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import reminder
import 'alarm'
import 'time'
import 'chrono'

ApplicationWindow {
	id: idRoot
	width: (Qt.platform.os === "android" || Qt.platform.os === "ios")
		   ? Screen.desktopAvailableWidth : 393
	height: (Qt.platform.os === "android" || Qt.platform.os === "ios")
			? Screen.desktopAvailableHeight : 823
	visible: true
	title: qsTr("Reminder")

	Material.accent: Material.Blue
	Material.background: Material.color(Material.Grey,
										Material.theme === Material.Dark
										? Material.Shade900:
										  Material.Shade50);
	font: Qt.application.font

	StatusBar {
		color: Qt.darker(Material.primary, 1.2)
	}

	onClosing: function(close) {
		close.accepted = true;
	}

	StackView {
		id: idMainStack
		initialItem: idMainPage
		anchors.fill: parent
		focus: true

		Keys.onBackPressed: function(event) {
			if (idMainStack.depth > 1) {
				idMainStack.pop();
			} else {
				event.accepted = false;
			}
		}
		pushEnter: Transition {
			NumberAnimation { property: "x"; from: idMainStack.width; to: 0 }
		}
		pushExit: Transition {
			NumberAnimation { property: "opacity"; from: 1; to: 0 }
		}

		popEnter: Transition {
			NumberAnimation { property: "opacity"; from: 0; to: 1 }
		}
		popExit: Transition {
			NumberAnimation { property: "x"; from: 0; to:idMainStack.width }
		}
	}

	Component {
		id: idMainPage
		Page {
			SwipeView {
				id: idMainSwipe
				anchors.fill: parent
				currentIndex: idHeader.currentIndex

				AlarmPage {
					id: idAlarmPage
				}

				TimePage {}

				ChronoPage {}
			}

			footer: TabBar {
				id: idHeader
				implicitHeight: 48
				currentIndex: idMainSwipe.currentIndex

				TabButton {
					text: qsTr("Alarms")
				}
				TabButton {
					text: qsTr("Time")
				}
				TabButton {
					text: qsTr("Chrono")
				}
			}
		}
	}
}
