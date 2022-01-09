import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.3

ItemDelegate {
	id: idAlarm

	hoverEnabled: false
	leftPadding: 0; rightPadding: 0

	state: "idle"
	states: [
		State {
			name: "hold"
			PropertyChanges {
				target: idAlarm
				highlighted: true
			}
			PropertyChanges {
				target: idSw
				opacity: 0
				enabled: false
			}
			PropertyChanges {
				target: idDelBtn
				opacity: 1
				enabled: true
			}
		},

		State {
			name: "idle"
			PropertyChanges {
				target: idAlarm
				highlighted: false
			}
			PropertyChanges {
				target: idSw
				opacity: 1
				enabled: true
			}
			PropertyChanges {
				target: idDelBtn
				opacity: 0
				enabled: false
			}
		}
	]

	transitions: [
		Transition {
			from: "*"; to: "*"
			NumberAnimation { property: "opacity"; duration: 250 }
		}
	]

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

		Item {
			Layout.preferredWidth: 48
			Layout.preferredHeight: 48

			Switch {
				id: idSw
				width: 48
				height: 24
				anchors.centerIn: parent

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

			RoundButton {
				id: idDelBtn
				anchors.fill: parent
				icon.source: "qrc:/assets/delete.png"

				onReleased: {

				}
			}
		}
	}
}
