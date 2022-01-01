import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import reminder

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
		anchors.bottomMargin: 20

		ColumnLayout {
			Layout.alignment: Qt.AlignTop

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

		RowLayout {
			Layout.fillHeight: false
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			spacing: idHour.width

			Tumbler {
				id: idHour
				Layout.preferredWidth: idTxM.width * 1.25
				Layout.preferredHeight: idTxM.height * 6
				model: 24
				delegate: Label {
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
				delegate: Label {
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

		RowLayout {
			Layout.fillWidth: true
			Layout.rightMargin: 10
			Layout.leftMargin: 10
			Layout.preferredHeight: idRoot.height / 16
			Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
			spacing: 30

			Button {
				Layout.alignment: Qt.AlignHCenter
				background: Rectangle {
					color: "transparent"
					border.width: 2
					border.color: Qt.alpha(Material.foreground, 0.6)
					radius: width / 2
				}
				display: Button.IconOnly
				icon.source: "qrc:/assets/close.png"
				icon.width: 50; icon.height: 50
				onReleased: {
					idMainStack.pop();
				}
			}


			Button {
				Layout.fillHeight: false
				Layout.alignment: Qt.AlignHCenter
				background: Rectangle {
					color: "transparent"
					border.width: 2
					border.color: Qt.alpha(Material.foreground, 0.6)
					radius: width / 2
				}
				display: Button.IconOnly
				icon.source: "qrc:/assets/done.png"
				icon.color: Material.accent
				icon.width: 50; icon.height: 50
				onReleased: {
					SqlAlarmModel.insert(
								(idHour.currentIndex < 10 ? "0" : "")
								+ idHour.currentIndex
								+ (idMinute.currentIndex < 10 ? ":0" : ":")
								+ idMinute.currentIndex,
								"Once",
								true
								)
					idMainStack.pop();
				}
			}
		}
	}
}
