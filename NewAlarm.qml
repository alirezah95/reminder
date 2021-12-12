import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Layouts
import alarmtime

Item {
	GridLayout {
		id: idGrid
		anchors.fill: parent
		columns: 2
		columnSpacing: 0

		Label {
			id: idTimeDis
			Layout.columnSpan: 2
			Layout.fillWidth: true
			Layout.preferredHeight: idRoot.height / 9
			font.pointSize: 20
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			text: AlarmTime.getTimeDiff(idHour.currentIndex(),
											 idMinute.currentIndex());
		}

		ScrollBox {
			id: idHour
			Layout.preferredWidth: idRoot.width / 2
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignTop | Qt.AlignRight
			boxAlignment: Qt.AlignRight
			pointSize: 40
			from: 0; to: 24
		}
		ScrollBox {
			id: idMinute
			Layout.preferredWidth: idRoot.width / 2
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignTop | Qt.AlignLeft
			boxAlignment: Qt.AlignLeft
			pointSize: 40
			from: 0; to: 60
		}
	}
}
