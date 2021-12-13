import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls

Item {
	property int fontPSize: 40
	id: idChrn
	RowLayout {
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.top
			topMargin: parent.height / 4
		}

		Label {
			id: idMinLbl
			Layout.fillWidth: true
			font.pointSize: fontPSize
			text: "00:"
		}
		Label {
			id: idSecLbl
			Layout.fillWidth: true
			font.pointSize: fontPSize
			text: "00."
		}
		Label {
			id: idMSecLbl
			Layout.fillWidth: true
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
			idChrn.state = "Start";
		}

		Behavior on anchors.horizontalCenterOffset {
			NumberAnimation { duration: 200 }
		}
	}

	states: [
		State {
			name: "Idle"
			PropertyChanges { target: idStop; visible: false
				anchors.horizontalCenterOffset: 0
			}
			PropertyChanges { target: idStartPause
				anchors.horizontalCenterOffset: 0
				icon.source: "qrc:/assets/pause.png"
			}
		},
		State {
			name: "Start"
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
			PropertyChanges { icon.source: "qrc:/assets/pause.png" }
		}
	]
}
