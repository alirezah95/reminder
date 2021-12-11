import QtQuick 2.0
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
		}
	}
}
