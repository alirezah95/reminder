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

	spacing: 4
	model: AlarmModel
	highlightFollowsCurrentItem: true
	boundsBehavior: Flickable.StopAtBounds

	delegate: AlarmDelegate {}

//	Button {
//		anchors.bottom: idAddNew.top
//		anchors.bottomMargin: 16
//		anchors.horizontalCenter: parent.horizontalCenter
//		width: 48
//		height: 48 + topPadding
//	}

	CButton {
		id: idAddNew
		Material.elevation: 6

		anchors {
			bottom: parent.bottom
			bottomMargin: 16
			horizontalCenter: parent.horizontalCenter
		}
		button.highlighted: true
		button.icon.source: "qrc:/assets/plus.png"
		button.icon.width: 20
		button.icon.height: 20

		button.onReleased: {
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
