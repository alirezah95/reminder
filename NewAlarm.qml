import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Layouts

Item {
	GridLayout {
		id: idGrid
		anchors.fill: parent
		columns: 2
		columnSpacing: 50

		ScrollBox {
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop | Qt.AlignRight
			boxAlignment: Qt.AlignRight
			pointSize: 40
			from: 0; to: 24
		}
		ScrollBox {
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop | Qt.AlignLeft
			boxAlignment: Qt.AlignLeft
			pointSize: 40
			from: 0; to: 60
		}
	}
}
