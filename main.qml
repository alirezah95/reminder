import QtQuick
import QtQuick.Controls 2.5
import QtQuick.Layouts
import QtQuick.Controls.Material
import reminder

ApplicationWindow {
	id: idRoot
	width: (Qt.platform.os === "android" || Qt.platform.os === "ios")
		   ? Screen.desktopAvailableWidth : 393
	height: (Qt.platform.os === "android" || Qt.platform.os === "ios")
			? Screen.desktopAvailableHeight : 823
	visible: true
	title: qsTr("Reminder")
	font: Qt.application.font

	Material.theme: (Qt.platform.os === "android") ?
						(androidNightMode ? Material.Dark: Material.Light):
						Material.Light
	Material.accent: Material.Blue
	Material.primary: Qt.darker(Material.background, 1.1)

	onClosing: function(close) {
		close.accepted = true;
	}

	StatusBar {
		color: idRoot.Material.background
		theme: idRoot.Material.theme === Material.Light ? StatusBar.Light
														: StatusBar.Dark
	}

	StackView {
		id: idMainStack
		initialItem: "MainSwipePage.qml"
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
			NumberAnimation { property: "x"; from: 0; to: idMainStack.width }
		}
	}
}
