import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.Material.impl
import '..'
import reminder

Page {
	id: idPage
	QtObject {
		id: d
		property var selectedIndexes: []
		signal selectAllChanged(bool allSelected);

		function itemSelected(row) {
			selectedIndexes.push(row);
			updateSelectLbl();
		}

		function itemDeselected(row) {
			var indexOfRow = selectedIndexes.indexOf(row);
			if (indexOfRow != -1) {
				selectedIndexes.splice(indexOfRow, 1);
				updateSelectLbl();
			}
		}

		function updateSelectLbl() {
			idSelectLbl.text = selectedIndexes.length +
					(selectedIndexes.length > 1 ? " items": " item")
					+ " selected";
			if (d.selectedIndexes.length === idAlarmList.count)
				idCheckAll.checked = true;
			else
				idCheckAll.checked = false;
		}

		function selectAll() {
			selectedIndexes = [];
			for (var i = 0; i < idAlarmList.count; i++) {
				selectedIndexes.push(i);
			}
			selectAllChanged(true)
			updateSelectLbl();
		}

		function deselectAll() {
			selectedIndexes = [];
			selectAllChanged(false);
			updateSelectLbl();
		}

		function deleteSelectedItems() {
			if (d.selectedIndexes.length === 1) {
				AlarmModel.remove(selectedIndexes[0]);
			} else {
				AlarmModel.removeMultiple(selectedIndexes);
			}
		}
	}

	state: "select"
	states: [
		State {
			name: "idle"
			PropertyChanges {
				target: idSrchBar
				implicitHeight: 0
			}
			PropertyChanges {
				target: idPageButtons
				implicitHeight: 48
			}
			PropertyChanges {
				target: idDelLoader
				sourceComponent: undefined
			}
			PropertyChanges {
				target: idAddNewBtn
				scale: 1
			}
			PropertyChanges {
				target: idMainSwipe
				interactive: true
			}
		},
		State {
			name: "select"
			PropertyChanges {
				target: idSrchBar
				implicitHeight: 48
			}
			PropertyChanges {
				target: idPageButtons
				implicitHeight: 0
			}
			PropertyChanges {
				target: idDelLoader
				sourceComponent: idDeleteBtn
			}
			PropertyChanges {
				target: idAddNewBtn
				scale: 0
			}
			PropertyChanges {
				target: idMainSwipe
				interactive: false
			}
		}
	]
	transitions: [
		Transition {
			from: "*"; to: "*"
			NumberAnimation {
				target: idSrchBar
				duration: 150
				property: "anchors.topMargin"
			}
		}

	]

	footer: ToolBar {
		id: idSrchBar
		implicitHeight: 52

		Loader {
			id: idDelLoader
			width: 56
			height: 56
			anchors.bottom: parent.top
			anchors.bottomMargin: 16
			anchors.horizontalCenter: parent.horizontalCenter
		}

		RowLayout {
			anchors.fill: parent
			anchors.leftMargin: 16
			ToolButton {
				id: idClose
				icon.source: "qrc:/assets/close.png"
				onReleased: {
					d.selectedIndexes = [];
					idPage.state = "idle";
				}
			}
			Label {
				id: idSelectLbl
				Layout.fillWidth: true
				horizontalAlignment: Qt.AlignHCenter
				verticalAlignment: Qt.AlignVCenter
			}
			CheckBox {
				id: idCheckAll
				implicitWidth: idClose.width
				implicitHeight: idClose.height
				hoverEnabled: false
				rightPadding: 24
				checked: (d.selectedIndexes.length === idAlarmList.count)

				onToggled: {
					if (d.selectedIndexes.length === idAlarmList.count) {
						d.deselectAll();
					} else {
						d.selectAll();
					}
				}
			}
		}
	}

	Component {
		id: idDeleteBtn
		RoundButton {
			width: 56
			height: 56
			Material.background: Material.BlueGrey
			icon.source: "qrc:/assets/delete.png"
			icon.color: Material.foreground
			onReleased: {
				idPage.state = "idle";
				d.deleteSelectedItems();
				d.selectedIndexes = [];
			}
		}
	}

	ListView {
		anchors.fill: parent
		anchors.leftMargin: 16
		anchors.rightMargin: 16

		id: idAlarmList

		spacing: 4
		model: AlarmModel
		highlightFollowsCurrentItem: true
		boundsBehavior: Flickable.StopAtBounds

		delegate: RowLayout {
			width: ListView.view.width
			height: 72

			AlarmDelegate {
				Layout.fillWidth: true
				Layout.fillHeight: true
				enabled: (idPage.state === "idle")
				onPressAndHold: {
					idCheck.toggle();
					idCheck.toggled();
					idPage.state = "select";
				}
			}
			CheckDelegate {
				id: idCheck
				implicitWidth: 32
				implicitHeight: 32
				Layout.preferredWidth: (idPage.state === "select")?
										   implicitWidth: 0
				Layout.preferredHeight: implicitWidth
				Layout.alignment: Qt.AlignCenter
				visible: scale > 0.01
				scale: (idPage.state === "select") ? 1: 0

				Component.onCompleted: {
					d.selectAllChanged.connect(function (selected) {
						idCheck.checked = selected;
					});
				}

				onVisibleChanged: {
					if (!visible) checked = false;
				}

				indicator: Rectangle {
					implicitWidth: 20
					implicitHeight: 20
					anchors.centerIn: parent
					radius: 10
					color: "transparent"
					border.width: 2
					border.color:
						idCheck.checked ? Qt.alpha(Material.accent, 0.76)
										: Qt.alpha(Material.foreground, 0.56)

					Rectangle {
						width: parent.width / 2
						height: parent.height / 2
						anchors.centerIn: parent
						radius: width / 2
						color: Material.accent
						visible: idCheck.checked
					}
				}

				background: Rectangle {
					implicitWidth: 24
					implicitHeight: 24
					visible: idCheck.down || idCheck.hovered
					color: Qt.alpha(Material.foreground, 0.12)
				}

				onToggled: {
					if (checked) {
						d.itemSelected(model.index)
					}
					else {
						d.itemDeselected(model.index)
					}
				}

				Behavior on scale {
					NumberAnimation { duration: 150 }
				}
				Behavior on Layout.preferredWidth {
					NumberAnimation { duration: 150 }
				}
			}
		}

		CButton {
			id: idAddNewBtn
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
}
