import QtQuick 2.0
import QtQuick.Controls

Item {
	property double pointSize: 20
	property int boxAlignment: Qt.AlignLeft
	property int from: 0
	property int to: 10

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
		width: parent.width
		onContentHeightChanged: {
			var h = contentHeight / (to - from);
			bottomMargin = 2 * h;
			topMargin = bottomMargin;
			height = h * 5.0;
		}
		delegate: Label{
			id: idLbl
			x: boxAlignment === Qt.AlignRight ? idView.width - width: 0;
			text: value
			width: idRoot.width / 10.0;
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: pointSize
			font.bold: opacity === 1.0;
			opacity: {
				var i = idView.indexAt(x, idView.contentY + idView.height / 2);
				if (index === i)
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
