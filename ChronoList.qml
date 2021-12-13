import QtQuick
import QtQuick.Controls

ListView {
	function addRecord(txt) {
		idModel.append({ recTxt: txt });
		return;
	}

	id: idView

	ListModel {
		id: idModel
	}

	clip: true
	model: idModel
	delegate: Label {
		width: idView.width;
		text: index + ". " + model.recTxt
		font.pointSize: idChrn.fontPSize * 0.6
		font.weight: Font.Light
	}
	header: Rectangle {
		color: Material.accent
		opacity: 0.6
		width: idView.width
		height: 2
	}
}
