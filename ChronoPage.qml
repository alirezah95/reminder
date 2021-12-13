import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import 'chrono.js' as Chrono

Item {
	property int fontPSize: 40
	readonly property double preferredWidth: idTxM.width + 2;
	id: idChrn

	TextMetrics {
		id: idTxM
		font.family: idFont.name
		font.pointSize: fontPSize
		text: "00"
	}

	Timer {
		id: idTimer
		interval: 10; running: false; repeat: true
		onTriggered: {
			Chrono.update();
			idMinLbl.text = (Chrono.min < 10 ? "0" : "") + String(Chrono.min);
			idSecLbl.text = (Chrono.sec < 10 ? "0" : "") + String(Chrono.sec);
			idMSecLbl.text = String(Chrono.msec);
		}
	}

	RowLayout {
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.top
			topMargin: parent.height / 4
		}
		Label {
			id: idMinLbl
			Layout.preferredWidth: preferredWidth
			font.pointSize: fontPSize
			text: "00"
		}
		Label { font.pointSize: fontPSize; text: ":" }
		Label {
			id: idSecLbl
			Layout.preferredWidth: preferredWidth
			font.pointSize: fontPSize
			text: "00"
		}
		Label { font.pointSize: fontPSize; text: "." }
		Label {
			id: idMSecLbl
			Layout.preferredWidth: preferredWidth
			font.pointSize: fontPSize
			text: "00"
		}
	}

	CButton {
		id: idStop
		anchors.centerIn: idStartPause
		icon.source: "qrc:/assets/stop.png"
		visible: false

		Behavior on anchors.horizontalCenterOffset {
			NumberAnimation { duration: 200 }
		}

		onButtonReleased: idChrn.state = "Idle";
	}

	CButton {
		id: idStartPause
		anchors {
			bottom: parent.bottom
			bottomMargin: width / 2.5
			horizontalCenter: parent.horizontalCenter
		}
		icon.source: "qrc:/assets/play.png"

		onButtonReleased: {
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
			PropertyChanges { target: idTimer; running: false }
			PropertyChanges { target: idStop; visible: false
				anchors.horizontalCenterOffset: 0
			}
			PropertyChanges { target: idStartPause
				anchors.horizontalCenterOffset: 0
				icon.source: "qrc:/assets/play.png"
			}
			PropertyChanges { target: idMinLbl; text: "00" }
			PropertyChanges { target: idSecLbl; text: "00" }
			PropertyChanges { target: idMSecLbl; text: "00" }
		},
		State {
			name: "Start"
			PropertyChanges { target: idTimer; running: true }
			PropertyChanges { target: idStop; visible: true
				anchors.horizontalCenterOffset: -(idStartPause.width + 20)
			}
			PropertyChanges { target: idStartPause
				anchors.horizontalCenterOffset: idStartPause.width / 2 + 10
				icon.source: "qrc:/assets/pause.png"
			}
		},
		State {
			name: "Pause"
			PropertyChanges { target: idTimer; running: false }
			PropertyChanges { target: idStop; visible: true
				anchors.horizontalCenterOffset: -(idStartPause.width + 20)
			}
			PropertyChanges { target: idStartPause
				anchors.horizontalCenterOffset: idStartPause.width / 2 + 10
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
		}
	]

	Component.onCompleted: {
		print("P: ", preferredWidth);
		Chrono.reset();
		idChrn.state = "Idle";
	}
}
