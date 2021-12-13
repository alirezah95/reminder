import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.Material.impl

ListView {
	property int indx: 0

	function addNewAlarm() {
	}

	id: idAlarmList

	spacing: 0
	model: AlarmModel {}
	highlightFollowsCurrentItem: true
	delegate: AlarmDelegate {
		timeText: index + ": " + time; dayText: day
	}


	CButton {
		id: idAddNew
		anchors {
			bottom: parent.bottom
			bottomMargin: width / 2.5
			horizontalCenter: parent.horizontalCenter
		}
		icon.source: "qrc:/assets/plus.png"

		onButtonReleased: {
			idMainStack.push(idAlrmDlg);
		}
	}
}
