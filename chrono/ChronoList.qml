import QtQuick
import QtQuick.Controls

ListView {
	function addRecord(txt) {
		if (count > 0)
			itemAtIndex(0).opacity = 0.9;
		idModel.insert(0, { recTxt: txt });
		return;
	}

	function clear() {
		idModel.clear();
	}

	id: idView

	ListModel {
		id: idModel
	}

	clip: true
	model: idModel

	delegate: Label {
		width: idView.width - 8
		x: 4
		text: model.recTxt
		font.family: "DejaVu Sans Mono"
		font.pixelSize: idChrn.fontPSize * 0.5
	}
	header: Rectangle {
		color: Material.accent
		opacity: 0.6
		width: idView.width
		height: 3
	}
	add: Transition {
		NumberAnimation { property: "opacity"; from: 0; to: 0.9
			duration: 300; easing.type: Easing.InQuint }
	}
	addDisplaced: Transition {
		NumberAnimation { property: "y"; duration: 200 }
	}
}
