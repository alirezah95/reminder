import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

ApplicationWindow {
	id: idRoot
	width: 540
	height: 960
	visible: true
	title: qsTr("Scroll")


	Material.accent: Material.Purple

	SwipeView {
		id: idMainSwipe
		anchors.fill: parent
		currentIndex: idFooter.currentIndex

		AlarmPage {

		}

		Label {
			id: idSecLbl
			text: "Second page"
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.pointSize: 30
		}
		Label {
			id: idThrdLbl
			text: "Third page"
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.pointSize: 30
		}
	}

	header: TabBar {
		id: idFooter
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

	Rectangle {
		property var sourceItem: this
		id: idShadow
		width: idAddNew.width * 1.3; height: width
		anchors.centerIn: idAddNew
		anchors.verticalCenterOffset: 10
		radius: idAddNew.radius
		color: "transparent"
		layer.enabled: true
		layer.effect: ElevationEffect {
			elevation: 15
			source: idShadow
		}
	}

	AddButton {
		id: idAddNew
	}
}
