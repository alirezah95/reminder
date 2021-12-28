import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.Material.impl
import '..'

ListView {
	property int indx: 0

	function addNewAlarm(tm, repeat) {
		idModel.addNewItem(tm, repeat);
	}

	id: idAlarmList

	spacing: 0
	model: AlarmModel { id: idModel }
	highlightFollowsCurrentItem: true
	delegate: AlarmDelegate {
		timeText: time; repeatText: day
	}


	CButton {
		id: idAddNew
		Material.background: Material.Orange
		anchors {
			bottom: parent.bottom
			bottomMargin: width / 4
			horizontalCenter: parent.horizontalCenter
		}
		icon.source: "qrc:/assets/plus.png"

		onButtonReleased: {
			idMainStack.push(idNewAlarm);
		}
	}

	Component {
		id: idNewAlarm
		NewAlarm {}
	}
}
