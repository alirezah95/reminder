import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls

Item {
	function updateTime() {
		var now = new Date;
		idTimeLbl.text = now.toLocaleTimeString(Qt.locale(), "hh:mm:ss");
		idDateLbl.text = now.toDateString();
	}

	Timer {
		interval: 200; running: true; repeat: true; triggeredOnStart: true
		onTriggered: updateTime();
	}

	ColumnLayout {
		anchors {
			left: parent.left
			right: parent.right
		}
		spacing: 0

		Label {
			id: idTimeLbl
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
			Layout.topMargin: idRoot.height / 12
			horizontalAlignment: Qt.AlignHCenter
			font.pointSize: 25
			font.weight: Font.Bold
			font.letterSpacing: 3
		}

		Label {
			id: idDateLbl
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
			Layout.topMargin: idRoot.height / 12
			horizontalAlignment: Qt.AlignHCenter
			font.pointSize: Math.round(idTimeLbl.font.pointSize * 0.9)
			font.weight: Font.Light
			font.letterSpacing: 3
		}
	}
}
