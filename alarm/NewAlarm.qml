import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import alarmtime

Item {
	TextMetrics {
		id: idTxM
		font.family: idFont.name
		font.pointSize: 40
		text: "00"
	}

	ColumnLayout {
		id: idGrid
		anchors.fill: parent

		RowLayout {
			Layout.fillWidth: true
			Layout.fillHeight: false
			Layout.rightMargin: 10
			Layout.leftMargin: 10
			Layout.preferredHeight: idRoot.height / 16
			Layout.alignment: Qt.AlignTop

			Button {
				background: Rectangle { color: "transparent" }
				display: Button.IconOnly
				icon.source: "qrc:/assets/close.png"
				onReleased: {
					idMainStack.pop();
				}
			}

			ColumnLayout {
				Label {
					Layout.fillWidth: true
					font.pointSize: 20
					clip: true
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					text: "Add alarm"
				}
				Label {
					id: idTimeDis
					Layout.fillWidth: true
					font.pointSize: 16
					clip: true
					opacity: 0.6
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					text: AlarmTime.getTimeDiff(idHour.currentIndex,
												idMinute.currentIndex);
				}
			}

			Button {
				Layout.fillHeight: false
				background: Rectangle { color: "transparent" }
				display: Button.IconOnly
				icon.source: "qrc:/assets/done.png"
				icon.color: Material.accent
				onReleased: {
					idAlarmPage.addNewAlarm(
								(idHour.currentIndex < 10 ? "0" : "")
								+ idHour.currentIndex
								+ (idMinute.currentIndex < 10 ? ":0" : ":")
								+ idMinute.currentIndex,
								"Once")
					idMainStack.pop();
				}
			}
		}

		RowLayout {
			Layout.fillHeight: false
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			spacing: idHour.width

			Tumbler {
				id: idHour
				Layout.preferredWidth: idTxM.width * 1.25
				Layout.preferredHeight: idTxM.height * 6
				model: 24
				delegate: Text {
					width: idHour.width
					text: index
					horizontalAlignment: Qt.AlignHCenter
					font.pointSize: 40
					font.bold: opacity > 0.95
					opacity: 1.0 - Math.abs(Tumbler.displacement * 1.1)
							 / (Tumbler.tumbler.visibleItemCount / 2)
				}
			}

			Tumbler {
				id: idMinute
				Layout.preferredWidth: idTxM.width * 1.25
				Layout.preferredHeight: idTxM.height * 6
				model: 60
				delegate: Text {
					width: idHour.width
					text: index
					horizontalAlignment: Qt.AlignHCenter
					font.pointSize: 40
					font.bold: opacity > 0.9
					opacity: 1.0 - Math.abs(Tumbler.displacement * 1.1)
							 / (Tumbler.tumbler.visibleItemCount / 2)
				}
			}
		}
	}
}
