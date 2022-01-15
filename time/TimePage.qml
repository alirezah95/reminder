import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import time
import '..'

Page {
	id: idPage
	readonly property ListView lv: idTimesList

	function onSelectDeletePressed(selectedIndexes) {
		if (selectedIndexes.length === 1) {
			idTimesModel.remove(selectedIndexes[0]);
		} else {
			idTimesModel.removeMultiple(selectedIndexes);
		}
	}

	function updateTime() {
		var now = new Date;
		idDateLbl.text = now.toDateString();
		idTimeLbl.text = now.toLocaleTimeString(Qt.locale(), "hh:mm:ss");

		var l = idTimeLbl.text.length;
		var sec = idTimeLbl.text.substring(l - 2, l);
		if (sec === "00") {
			idTimesModel.updateTimes();
		}
	}

	Timer {
		interval: 200; running: true; repeat: true; triggeredOnStart: true
		onTriggered: updateTime();
	}

	ColumnLayout {
		anchors.fill: parent
		anchors.topMargin: 36
		spacing: 48

		ColumnLayout {
			spacing: 8
			Label {
				id: idTimeLbl
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
				horizontalAlignment: Qt.AlignHCenter
				font.pointSize: 25
				font.weight: Font.Bold
				font.letterSpacing: 3
			}

			Label {
				id: idDateLbl
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
				horizontalAlignment: Qt.AlignHCenter
				font.pointSize: Math.round(idTimeLbl.font.pointSize * 0.9)
				font.weight: Font.Light
				font.letterSpacing: 3
			}
		}
		ListView {
			id: idTimesList

			Layout.fillHeight: true
			Layout.fillWidth: true

			model: TimesModel {
				id: idTimesModel
			}

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
					ColumnLayout {
						Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
						Label {
							Layout.fillWidth: true
							font.pixelSize: 18
							horizontalAlignment: Qt.AlignLeft
							text: model.city
						}
						Label {
							Layout.fillWidth: true
							font.pixelSize: 14
							horizontalAlignment: Qt.AlignLeft
							text: model.country
							opacity: 0.64
						}
					}
					ColumnLayout {
						Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
						Label {
							Layout.fillWidth: true
							font.pixelSize: 18
							horizontalAlignment: Qt.AlignRight
							text: model.time
						}
						Label {
							Layout.fillWidth: true
							font.pixelSize: 14
							horizontalAlignment: Qt.AlignRight
							text: model.date
							opacity: 0.64
						}
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
								idSelectObj.itemSelected(model.index)
							}
							else {
								idSelectObj.itemDeselected(model.index)
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
		}
	}

	CButton {
		id: idNewTime
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
			idMainStack.push(idZonesComp);
		}
		Behavior on scale {
			NumberAnimation { duration: 200 }
		}

	}

	Component {
		id: idZonesComp
		Page {
			header: ToolBar {
				ToolButton {
					icon.source: "qrc:/assets/back.png"

					onReleased: {
						idMainStack.pop();
					}
				}
			}

			ColumnLayout {
				anchors.fill: parent
				TextField {
					id: idZoneSearch
					Layout.fillWidth: true
					Layout.preferredHeight: 56
					leftPadding: 16
					rightPadding: 16
					placeholderText: "Search timezone"
					onDisplayTextChanged: {
						idTzModel.setFilterRegularExpression(
									RegExp(idZoneSearch.displayText, "i"));
					}
				}

				TableView {
					id: idTbV
					Layout.fillHeight: true
					Layout.fillWidth: true

					clip: true

					model: TimezonesModel {
						id: idTzModel
					}
					columnWidthProvider: function (column) {
						return idTbV.width
					}
					rowHeightProvider: function (row) {
						return 72;
					}

					delegate: ItemDelegate {
						onReleased: {
							idTimesModel.insert(model.id);
							idMainStack.pop();
						}

						contentItem: ColumnLayout {
							spacing: 0
							Label {
								font.pixelSize: 18
								text: model.city
							}
							Label {
								leftPadding: 4
								font.pixelSize: 12
								opacity: 0.64
								text: model.country + " GMT" + model.offset
							}
						}
					}
				}
			}
		}
	}
}
