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
	readonly property ListView lv: idAlarmList

	function onSelectDeletePressed(selectedIndexes) {
		if (selectedIndexes.length === 1) {
			AlarmModel.remove(selectedIndexes[0]);
		} else {
			AlarmModel.removeMultiple(selectedIndexes);
		}
	}

	ListView {
		anchors.fill: parent

		id: idAlarmList

		spacing: 4
		model: AlarmModel
		highlightFollowsCurrentItem: true
		boundsBehavior: Flickable.StopAtBounds

		delegate: ItemDelegate {
			width: ListView.view.width
			height: 72

			onPressAndHold: {
				if (!idSelectObj.selectEnabled()) {
					idSelectObj.setSelectEnable(true);
					idCheck.toggle();
					idCheck.toggled();
				}
			}

			contentItem: RowLayout {
				AlarmDelegate {
					enabled: !idSelectObj.selectEnabled()
					Layout.fillWidth: true
					Layout.fillHeight: true
				}
				CheckDelegate {
					id: idCheck
					implicitWidth: 32
					implicitHeight: 32
					Layout.preferredWidth: idSelectObj.selectEnabled() ?
											   implicitWidth: 0
					Layout.preferredHeight: implicitWidth
					Layout.alignment: Qt.AlignCenter
					visible: scale > 0.01
					scale: idSelectObj.selectEnabled() ? 1: 0

					function allChanged(selected) {
						idCheck.checked = selected;
					}

					Component.onCompleted: {
						idSelectObj.selectAllChanged.connect(allChanged);
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
							idSelectObj.itemSelected(model.index);
						}
						else {
							idSelectObj.itemDeselected(model.index);
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
		}

		CButton {
			id: idAddNewBtn
			Material.elevation: 6

			anchors {
				bottom: parent.bottom
				bottomMargin: 16
				horizontalCenter: parent.horizontalCenter
			}
			scale: idSelectObj.selectEnabled() ? 0: 1
			button.highlighted: true
			imageIcon.source: "qrc:/assets/plus.png"

			button.onReleased: {
				idMainStack.push(idNewAlarm);
			}
			Behavior on scale {
				NumberAnimation { duration: 200 }
			}
		}

		Component {
			id: idNewAlarm
			NewAlarm {}
		}
	}
}
