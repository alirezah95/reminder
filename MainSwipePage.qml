import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import 'alarm'
import 'time'
import 'chrono'

Page {
	id: idSwipePage

	/* Item to manage select and deselecting data. */
	QtObject {
		id: idSelectObj
		property var deleteCallback: idAlarmSwItem.onSelectDeletePressed
		property var selectedIndexes: []
		property ListView targetListView: idAlarmSwItem.lv
		signal selectAllChanged(bool allSelected);

		function selectEnabled() {
			return idSwipePage.state === "select";
		}

		function setSelectEnable(enabled) {
			if (enabled) {
				idSwipePage.state = "select";
			}
			else {
				idDelLoader.item.y = 100;
				idDelLoader.item.scale = 0;
				idSwipePage.state = "idle";
			}
		}

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
					+ " selected main";
			if (idSelectObj.selectedIndexes.length === targetListView.count)
				idCheckAll.checked = true;
			else
				idCheckAll.checked = false;
		}

		function selectAll() {
			selectedIndexes = [];
			for (var i = 0; i < targetListView.count; i++) {
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
			if (deleteCallback) {
				deleteCallback(selectedIndexes);
			} else {
				print("delete callback is undefined");
			}
		}
	}

	state: "idle"
	states: [
		State {
			name: "idle"
			AnchorChanges {
				target: idSelectBar
				anchors.top: idPageButtons.bottom
			}
			AnchorChanges {
				target: idPageButtons
				anchors.top: parent.top
			}
			StateChangeScript {
				name: "LoaderScript"
				script: idDelLoader.releaseButton();
			}
			PropertyChanges {
				target: idMainSwipe
				interactive: true
			}
		},
		State {
			name: "select"
			AnchorChanges {
				target: idSelectBar
				anchors.top: parent.top
			}
			AnchorChanges {
				target: idPageButtons
				anchors.top: idSelectBar.bottom
			}
			StateChangeScript {
				name: "LoaderScript"
				script: idDelLoader.loadButton()
			}
			PropertyChanges {
				target: idMainSwipe
				interactive: false
			}
		}
	]

	transitions: [
		Transition {
			from: "idle"; to: "select"
			AnchorAnimation {
				duration: 200
			}
		},
		Transition {
			from: "select"; to: "idle"
			SequentialAnimation {
				AnchorAnimation {
					duration: 200
				}
				PauseAnimation {
					duration: 50
				}
				ScriptAction {
					scriptName: "LoaderScript"
				}
			}
		}
	]

	Component {
		id: idDeleteBtnComponent
		RoundButton {
			y: 100
			scale: 0

			Component.onCompleted: {
				y = 0;
				scale = 1;
			}

			Material.background: Material.BlueGrey
			icon.source: "qrc:/assets/delete.png"
			icon.color: Material.foreground
			onReleased: {
				idSwipePage.state = "idle";
				idSelectObj.deleteSelectedItems();
				idSelectObj.selectedIndexes = [];
			}

			Behavior on y {
				NumberAnimation { duration: 200 }
			}
			Behavior on scale {
				NumberAnimation { duration: 200 }
			}
		}
	}

	Loader {
		id: idDelLoader
		function loadButton() {
			if (status === Loader.Null || status === Loader.Error) {
				sourceComponent = idDeleteBtnComponent;
			}
		}

		function releaseButton() {
			if (status === Loader.Ready) {
				sourceComponent = undefined;
			}
		}

		width: 60
		height: 60
		z: 1
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
	}

	SwipeView {
		id: idMainSwipe
		anchors.fill: parent
		currentIndex: idPageButtons.currentIndex

		onCurrentIndexChanged: {
			if (currentItem === idAlarmSwItem || currentItem === idTimeSwItem) {
				idSelectObj.targetListView = currentItem.lv;
				idSelectObj.deleteCallback = currentItem.onSelectDeletePressed;
			}
		}

		AlarmPage {
			id: idAlarmSwItem
		}

		TimePage {
			id: idTimeSwItem
		}

		ChronoPage {
			id: idChronoSwItem
		}
	}

	footer: Item {
		height: 48
		TabBar {
			id: idPageButtons
			height: parent.height
			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
			}
			position: TabBar.Footer

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

		ToolBar {
			id: idSelectBar
			height: parent.height
			anchors {
				left: parent.left
				right: parent.right
				top: idPageButtons.bottom
			}

			RowLayout {
				anchors.fill: parent
				anchors.leftMargin: 16
				ToolButton {
					id: idClose
					icon.source: "qrc:/assets/close.png"
					onReleased: {
						idDelLoader.item.y = 100;
						idDelLoader.item.scale = 0;
						idSelectObj.selectedIndexes = [];
						idSelectObj.setSelectEnable(false);
					}
				}
				Label {
					id: idSelectLbl
					text: "0 item selected main"
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
					checked: (idSelectObj.selectedIndexes.length === idSelectObj.targetListView.count)

					onToggled: {
						if (idSelectObj.selectedIndexes.length === idSelectObj.targetListView.count) {
							idSelectObj.deselectAll();
						} else {
							idSelectObj.selectAll();
						}
					}
				}
			}
		}
	}
}
