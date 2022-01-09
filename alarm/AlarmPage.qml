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

		function itemSelected(row) {
			selectedIndexes.push(row);
			print(selectedIndexes);
		}

		function itemDeselected(row) {
			var indexOfRow = selectedIndexes.indexOf(row);
			if (indexOfRow != -1) {
				selectedIndexes.splice(indexOfRow, 1);
				print(selectedIndexes);
			} else {
				print("row not found: ", row);
			}
		}
	}

	state: "idle"
	states: [
		State {
			name: "idle"
			PropertyChanges {
				target: idHeader
				height: 0
				visible: false
			}
		},
		State {
			name: "select"
			PropertyChanges {
				target: idHeader
				height: 56
				visible: true
			}
		}
	]

	header: ToolBar {
		id: idHeader
		width: parent.width
		RowLayout {
			anchors.fill: parent
			ToolButton {
				icon.source: "qrc:/assets/close.png"
				onReleased: idPage.state = "idle";
			}
			Label {
				id: idSelectLbl
				Layout.fillWidth: true
			}
			ToolButton {
				icon.source: "qrc:/assets/selectall.png"
				icon.color:
					(d.selectedIndexes.length === d.maxIndexed) ?
						Material.color(Material.Pink):
						Material.foreground
			}
		}
	}

	ListView {
		anchors.fill: parent
		anchors.leftMargin: 16
		anchors.rightMargin: 16

		id: idList

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
				enabled: (idPage.state === "select") ? false: true
				onPressAndHold: {
					idPage.state = "select";
				}
			}
			CheckDelegate {
				id: idCheck
				implicitWidth: 40
				implicitHeight: 40
				Layout.preferredWidth: (idPage.state === "select")?
										   implicitWidth: 0
				Layout.preferredHeight: implicitWidth
				Layout.alignment: Qt.AlignCenter
				visible: scale > 0.01
				scale: (idPage.state === "select") ? 1: 0

				leftPadding: 8; rightPadding: 8
				topPadding: 8; bottomPadding: 8

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
						print("se")
						d.itemSelected(model.index)
					}
					else {
						print("de")
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
}
