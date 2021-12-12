import QtQuick 2.0
import QtQuick.Controls

Item {
	readonly property alias viewWidth: idView.width
	property double pointSize: 20
	property int from: 0
	property int to: 10

	function currentIndex() { return idView.currentIndex; }

	ListModel {
		id: idModel
	}

	ListView {
		id: idView

		model: idModel
		spacing: 0
		clip: true
		snapMode: ListView.SnapToItem
		boundsBehavior: Flickable.StopAtBounds
		bottomMargin: 0
		topMargin: 0
		currentIndex: indexAt(0, contentY + height / 2);
		width: idRoot.width / 8
		onContentHeightChanged: {
			var h = contentHeight / (to - from);
			bottomMargin = 2 * h;
			topMargin = bottomMargin;
			height = h * 5.0;
		}
		delegate: Label{
			id: idLbl
			text: value
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: pointSize
			font.bold: opacity === 1.0
			opacity: {
				if (index === idView.currentIndex)
					return 1;
				else
					return 0.4;
			}
		}

		Component.onCompleted: {
			for (let i = from; i < to; i++){
				idModel.append({ value: i });
			}
		}
	}
}
