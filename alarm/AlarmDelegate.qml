import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.3

ItemDelegate {
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
				text: model.time
			}
			Label {
				id: idRepeatLbl
				Layout.fillWidth: true
				font.pointSize: 18
				font.weight: Font.Light
				text: model.repeat
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
						idSw.checked ? Material.background:
									   Qt.alpha(Material.background, 0.5)
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
				color: idSw.checked ? Material.accent
									: Material.foreground
				opacity: idSw.checked ? 1: 0.5
			}

			Component.onCompleted: {
				if (model.active)
					idSw.toggle();
			}
			onToggled: {
				model.active = checked;
			}
		}
	}
}
