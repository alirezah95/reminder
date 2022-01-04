import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import 'chrono.js' as Chrono
import '..'

Item {
	property int fontPSize: 40
	readonly property double preferredWidth: idTxM.width + 5;
	id: idChrn

	TextMetrics {
		id: idTxM
		font.family: Qt.application.font.family
		font.pixelSize: fontPSize
		text: "00"
	}

	Timer {
		id: idTimer
		interval: 10; running: false; repeat: true
		onTriggered: {
			Chrono.update();
			idMinLbl.text = (Chrono.min < 10 ? "0" : "") + Chrono.min;
			idSecLbl.text = (Chrono.sec < 10 ? "0" : "") + Chrono.sec;
			idMSecLbl.text = (Chrono.msec < 10 ? "0" : "") + Chrono.msec;
		}
	}

	RowLayout {
		id: idTimeRow
		spacing: 4
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.top
			topMargin: parent.height / 4
		}

		Behavior on anchors.topMargin {
			NumberAnimation { duration: 200 }
		}

		Label {
			id: idMinLbl
			Layout.preferredWidth: preferredWidth
			font.pixelSize: fontPSize
			text: "00"
		}
		Label { font.pixelSize: fontPSize; text: ":" }
		Label {
			id: idSecLbl
			Layout.preferredWidth: preferredWidth
			font.pixelSize: fontPSize
			text: "00"
		}
		Label { font.pixelSize: fontPSize; text: "." }
		Label {
			id: idMSecLbl
			Layout.preferredWidth: preferredWidth
			font.pixelSize: fontPSize
			text: "00"
		}
	}

	ChronoList {
		property double topM: idRoot.height / 12
		property double leftM: idRoot.width / 15

		id: idChList
		anchors {
			top: idTimeRow.bottom
			topMargin: topM
			bottom: idStop.top
			bottomMargin: topM
			left: parent.left
			leftMargin: leftM
			right: parent.right
			rightMargin: leftM
		}
	}

	CButton {
		id: idStop
		anchors.centerIn: idStartPause
		button.icon.source: "qrc:/assets/stop.png"
		visible: false

		Behavior on anchors.horizontalCenterOffset {
			NumberAnimation { duration: 200 }
		}

		button.onReleased: {
			idChrn.state = "Idle";
			idChList.clear();
		}
	}

	CButton {
		id: idLap
		anchors.centerIn: idStartPause
		button.icon.source: "qrc:/assets/flag.png"
		visible: false

		Behavior on anchors.horizontalCenterOffset {
			NumberAnimation { duration: 200 }
		}
		button.onReleased: {
			if (idChrn.state === "Start")
				idChList.addRecord(idChList.count + 1 + ". " + idMinLbl.text
								   + ":" + idSecLbl.text + "."
								   + idMSecLbl.text);
		}
	}


	CButton {
		id: idStartPause
		anchors {
			bottom: parent.bottom
			bottomMargin: width / 4
			horizontalCenter: parent.horizontalCenter
		}
		button.icon.source: "qrc:/assets/play.png"

		button.onReleased: {
			if (idChrn.state === "Idle") {
				idTimer.start();
				idChrn.state = "Start";
			} else if (idChrn.state === "Start") {
				idChrn.state = "Pause";
			} else if (idChrn.state === "Pause") {
				idChrn.state = "Start";
			}
		}

		Behavior on anchors.horizontalCenterOffset {
			NumberAnimation { duration: 200 }
		}
	}

	states: [
		State {
			name: "Idle"
			PropertyChanges { target: idTimeRow;
				anchors.topMargin: parent.height / 4
			}
			PropertyChanges { target: idTimer; running: false }
			PropertyChanges { target: idStop; visible: false
				anchors.horizontalCenterOffset: 0
			}
			PropertyChanges { target: idLap; visible: false
				anchors.horizontalCenterOffset: 0
			}
			PropertyChanges { target: idStartPause
				button.icon.source: "qrc:/assets/play.png"
			}
			PropertyChanges { target: idMinLbl; text: "00" }
			PropertyChanges { target: idSecLbl; text: "00" }
			PropertyChanges { target: idMSecLbl; text: "00" }
		},
		State {
			name: "Start"
			PropertyChanges { target: idTimeRow;
				anchors.topMargin: parent.height / 10
			}
			PropertyChanges { target: idTimer; running: true }
			PropertyChanges { target: idStop; visible: true
				anchors.horizontalCenterOffset: -(idStartPause.width + 15)
			}
			PropertyChanges { target: idLap; visible: true
				anchors.horizontalCenterOffset: idStartPause.width + 15
			}
			PropertyChanges { target: idStartPause
				button.icon.source: "qrc:/assets/pause.png"
			}
		},
		State {
			name: "Pause"
			extend: "Start"
			PropertyChanges { target: idTimer; running: false }
			PropertyChanges { target: idStartPause
				icon.source: "qrc:/assets/play.png"
			}
		}
	]

	transitions: [
		Transition {
			from: "*"; to: "Idle"
			PropertyAnimation { target: idStop; property: "visible"
				duration: 200
			}
			PropertyAnimation { target: idLap; property: "visible"
				duration: 200
			}
		}
	]

	Component.onCompleted: {
		print("P: ", preferredWidth);
		Chrono.reset();
		idChrn.state = "Idle";
	}
}
