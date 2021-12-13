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
			width: idView.width
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: pointSize
			color: Material.foreground
			font.weight: opacity > 0.4 ? Font.ExtraBold: Font.Light
			opacity: {
				var op = 0.4;
				var center = idView.height / 2;
				var halfH = this.height / 2.5;
				var fst = idView.indexAt(0, idView.contentY + center + halfH);
				var sec = idView.indexAt(0, idView.contentY + center - halfH);
				if (index === sec) {
					op += 0.3;
				}
				if (index === fst){
					op += 0.3;
				}
				return op;
			}
		}

		Component.onCompleted: {
			for (let i = from; i < to; i++){
				idModel.append({ value: i });
			}
		}
	}
}
