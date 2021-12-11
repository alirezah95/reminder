import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls

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
}
