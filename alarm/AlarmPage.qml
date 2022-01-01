import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.Material.impl
import '..'
import reminder

ListView {
	property int indx: 0

	function addNewAlarm(tm, repeat) {
		idModel.addNewItem(tm, repeat);
	}

	id: idAlarmList

	spacing: 0
//	model: AlarmModel { id: idModel }
	model: SqlAlarmModel
	highlightFollowsCurrentItem: true
	delegate: AlarmDelegate {}

	CButton {
		id: idAddNew
		Material.background: Material.Orange
		anchors {
			bottom: parent.bottom
			bottomMargin: width / 6
			right: parent.right
			rightMargin: width / 4
		}
		icon.source: "qrc:/assets/plus.png"

		onButtonReleased: {
			idMainStack.push(idNewAlarm);
		}
		Behavior on y {
			NumberAnimation { }
		}

	}

	Component {
		id: idNewAlarm
		NewAlarm {}
	}
}
