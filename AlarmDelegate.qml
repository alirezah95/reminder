import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.3

ItemDelegate {
	property alias timeText: idTimeLbl.text
	property alias repeatText: idRepeatLbl.text

	id: idAlarm
	width: idRoot.width
	height: implicitContentHeight + implicitContentHeight * 0.2

	hoverEnabled: false
	leftPadding: 13; rightPadding: 5
	focus: false

	contentItem: RowLayout {
		id: idLayout
		anchors.fill: parent
		anchors.rightMargin: parent.width / 30
		anchors.leftMargin: parent.width / 30
		ColumnLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			Label {
				id: idTimeLbl
				Layout.fillWidth: true
				font.pointSize: 25
			}
			Label {
				id: idRepeatLbl
				Layout.fillWidth: true
				font.pointSize: 18
				font.weight: Font.Light
			}
		}
		Switch {
			id: idSw

			indicator: Rectangle {
					readonly property int offset: 4
					width: idIndic.implicitHeight / 2; height: width
					x: idSw.checked ? idIndic.implicitWidth - width - offset
									: 0 + offset
					anchors.verticalCenter: idIndic.verticalCenter
					radius: width / 2.0
					color:
						idSw.checked ? Material.color(
										   Material.Orange,
										   idSw.down ? Material.Shade600
													 : Material.Shade400)
						  : Material.foreground
					Behavior on x {
						NumberAnimation { duration: 180 }
					}
			}
			background: Rectangle {
				id: idIndic
				anchors.fill: idSw
				implicitWidth: idRoot.width / 9
				implicitHeight: idRoot.width / 18
				radius: implicitWidth / 3
				color: idSw.checked ? idSw.Material.accent
									: idSw.Material.foreground
				opacity: idSw.checked ? 0.9: 0.5
				border.color: idSw.checked ? Material.color(Material.Grey)
										   : Material.foreground
			}
		}
	}
}
