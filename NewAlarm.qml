import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Layouts
import alarmtime

Item {
	ColumnLayout {
		id: idGrid
		anchors.fill: parent
		spacing: 50

		RowLayout {
			Layout.fillWidth: true
			Layout.fillHeight: false
			Layout.rightMargin: 10
			Layout.leftMargin: 10
			Layout.preferredHeight: idRoot.height / 16
			Layout.alignment: Qt.AlignTop

			Button {
				Layout.fillHeight: true
				background: Rectangle { color: "transparent" }
				display: Button.IconOnly
				icon.source: "qrc:/assets/close.png"
				onPressed: print(width, ", ", height);
			}

			ColumnLayout {
				Layout.fillWidth: true
				Layout.fillHeight: true

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
					text: AlarmTime.getTimeDiff(idHour.currentIndex(),
												idMinute.currentIndex());
				}
			}

			Button {
				Layout.fillHeight: true
				background: Rectangle { color: "transparent" }
				display: Button.IconOnly
				icon.source: "qrc:/assets/done.png"
				icon.color: Material.accent
				onPressed: print(width, ", ", height);
			}
		}

		RowLayout {
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignHCenter
			spacing: idHour.viewWidth / 2.0

			ScrollBox {
				id: idHour
				Layout.fillHeight: true
				Layout.preferredWidth: viewWidth
				pointSize: 40
				from: 0; to: 24
			}
			ScrollBox {
				id: idMinute
				Layout.fillHeight: true
				Layout.preferredWidth: viewWidth
				pointSize: 40
				from: 0; to: 60
			}
		}
	}
}
