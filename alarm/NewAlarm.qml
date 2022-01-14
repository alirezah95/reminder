import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import reminder
import '..'

Item {
	TextMetrics {
		id: idTxM
		font.family: Qt.application.font.family
		font.pixelSize: 44
		text: "00"
	}

	ColumnLayout {
		id: idGrid
		anchors.fill: parent
		anchors.bottomMargin: 16

		ColumnLayout {
			Layout.alignment: Qt.AlignTop

			Label {
				Layout.fillWidth: true
				font.pixelSize: 20
				clip: true
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				text: "Add alarm"
			}
			Label {
				id: idTimeDis
				Layout.fillWidth: true
				font.pixelSize: 16
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
				Layout.preferredHeight: idTxM.height * 5.2
				model: 24
				delegate: Label {
					width: idHour.width
					height: idTxM.height
					text: index
					horizontalAlignment: Qt.AlignHCenter
					font.pixelSize: idTxM.font.pixelSize
					font.bold: opacity > 0.9
					scale: opacity > 0.9 ? opacity
										 : opacity > 0.4 ? opacity : 0.4
					opacity: 1.0 - Math.abs(Tumbler.displacement * 1.3)
							 / (Tumbler.tumbler.visibleItemCount)
				}
			}

			Tumbler {
				id: idMinute
				Layout.preferredWidth: idTxM.width * 1.25
				Layout.preferredHeight: idTxM.height * 5.2
				model: 60
				delegate: Label {
					width: idHour.width
					height: idTxM.height
					text: index
					horizontalAlignment: Qt.AlignHCenter
					font.pixelSize: idTxM.font.pixelSize
					font.bold: opacity > 0.9
					scale: opacity > 0.9 ? opacity
										 : opacity > 0.5 ? opacity : 0.5
					opacity: 1.0 - Math.abs(Tumbler.displacement * 1.3)
							 / (Tumbler.tumbler.visibleItemCount)
				}
			}
		}

		RowLayout {
			Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
			Layout.bottomMargin: 32
			spacing: 32

			CButton {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: width
				Layout.preferredHeight: height

				button.display: Button.IconOnly
				imageIcon.source: "qrc:/assets/close.png"
				button.flat: true
				button.rightPadding: 12
				button.leftPadding: 12
				button.topPadding: 12
				button.bottomPadding: 12
				button.onReleased: {
					idMainStack.pop();
				}
			}


			CButton {
				id: idDone
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: width
				Layout.preferredHeight: height

				Material.background: Material.color(
									 Material.Grey,
									 Material.theme === Material.Dark ?
										 Material.Shade700 :
										 Material.Shade200)

				button.display: Button.IconOnly
				imageIcon.source: "qrc:/assets/done.png"
				iconColor: Material.accent
				button.flat: true
				button.rightPadding: 12
				button.leftPadding: 12
				button.topPadding: 12
				button.bottomPadding: 12
				button.onReleased: {
					AlarmModel.insert(
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
