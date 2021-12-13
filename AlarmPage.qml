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

	Rectangle {
		property var sourceItem: this
		id: idShadow
		width: idAddNew.width * 1.3; height: width
		anchors.centerIn: idAddNew
		anchors.verticalCenterOffset: 10
		radius: idAddNew.radius
		color: "transparent"
		layer.enabled: true
		layer.effect: ElevationEffect {
			elevation: 15
			source: idShadow
		}
	}

	AddButton {
		id: idAddNew
		onReleased: {
			idMainStack.push(idAlrmDlg);
		}
	}
}
