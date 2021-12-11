import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

ApplicationWindow {
	id: idRoot
	width: 540
	height: 960
	visible: true
	title: qsTr("Scroll")

	Material.accent: Material.Purple

	onClosing: function(close) {
		close.accepted = true;
	}

	StackView {
		id: idMainStack
		initialItem: idMainPage
		anchors.fill: parent
		focus: true

		Keys.onBackPressed: function(event) {
			if (idMainStack.depth > 1) {
				idMainStack.pop();
			} else {
				event.accepted = false;
			}
		}
		pushEnter: Transition {
			NumberAnimation { property: "x"; from: idMainStack.width; to: 0 }
		}
		pushExit: Transition {
			NumberAnimation { property: "opacity"; from: 1; to: 0 }
		}

		popEnter: Transition {
			NumberAnimation { property: "opacity"; from: 0; to: 1 }
		}
		popExit: Transition {
			NumberAnimation { property: "x"; from: 0; to:idMainStack.width }
		}
	}

	Component {
		id: idMainPage
		Page {
			SwipeView {
				id: idMainSwipe
				anchors.fill: parent
				currentIndex: idHeader.currentIndex

				AlarmPage {
					id: idAlPage
				}

				Label {
					id: idSecLbl
					text: "Second page"
					color: "purple"
					background: Rectangle {
						anchors.fill: parent
						color: "gray"
					}

					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					font.pointSize: 30
				}
				Label {
					id: idThrdLbl
					text: "Third page"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					font.pointSize: 30
				}
			}

			header: TabBar {
				id: idHeader
				currentIndex: idMainSwipe.currentIndex

				TabButton {
					text: qsTr("Alarms")
				}
				TabButton {
					text: qsTr("Time")
				}
				TabButton {
					text: qsTr("Chrono")
				}
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
					print("AddButton pressed...");
					idMainStack.push(idAlrmDlg);
				}
			}
		}
	}

	Component {
		id: idAlrmDlg
		Item {
			Label {
				text: "hello from dlg"
				font.pointSize: 30
				color: "white"
			}
		}
	}
}
