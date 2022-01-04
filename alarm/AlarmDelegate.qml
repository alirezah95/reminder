import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.3

ItemDelegate {
	id: idAlarm
	width: ListView.view.width
	height: 72

	hoverEnabled: false
	leftPadding: 16; rightPadding: 16
	focus: false

	contentItem: RowLayout {
		id: idLayout

		ColumnLayout {
			spacing: 8
			Label {
				id: idTimeLbl
				Layout.fillWidth: true
				font.pixelSize: 20
				text: model.time
			}
			Label {
				id: idRepeatLbl
				Layout.fillWidth: true
				font.pixelSize: 14
				font.weight: Font.Light
				text: model.repeat
			}
		}
		Switch {
			id: idSw
			Layout.preferredWidth: 50
			Layout.preferredHeight: 26

			indicator: Rectangle {
					readonly property int offset: 4
					width: idSw.height / 2.5; height: width
					x: idSw.checked ? idSw.width - width - offset
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

				radius: height / 2
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
