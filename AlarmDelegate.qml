import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.3

ItemDelegate {
	property alias timeText: idTimeLbl.text
	property alias dayText: idDayLbl.text

	id: idAlarm
	width: idRoot.width
	height: implicitContentHeight + implicitContentHeight * 0.2

	hoverEnabled: true
	leftPadding: 13; rightPadding: 5
	leftInset: 8; rightInset: leftInset
	focus: false

	contentItem: RowLayout {
		id: idLayout
		ColumnLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			Label {
				id: idTimeLbl
				Layout.fillWidth: true
			}
			Label {
				id: idDayLbl
				Layout.fillWidth: true
			}
		}
		Switch {
			id: idSw

			indicator: Rectangle {
				id: idIndic
				implicitWidth: 48
				implicitHeight: 26
				x: idSw.width - width - idSw.rightPadding
				y: parent.height / 2 - height / 2
				radius: 13
				color: idSw.checked ? "#17a81a" : "transparent"
				border.color: idSw.checked ? "#17a81a" : "#cccccc"

				Rectangle {
					readonly property int offset: 4
					width: 16; height: width
					x: idSw.checked ? parent.width - width - offset: 0 + offset
					anchors.verticalCenter: idIndic.verticalCenter
					radius: 10
					color: idSw.down ? "#cccccc" : "#ffffff"
					border.color: idSw.checked ? (idSw.down ? "#17a81a" : "#21be2b") : "#999999"
				}
			}
		}
	}
}
