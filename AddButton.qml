import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Button {
	readonly property alias radius: idBg.radius

	width: Math.min(idRoot.width, idRoot.height) * 0.1; height: width
	anchors.bottom: parent.bottom
	anchors.bottomMargin: 30
	anchors.horizontalCenter: parent.horizontalCenter

	contentItem: Text {
		text: "+"
		horizontalAlignment: Qt.AlignHCenter
		verticalAlignment: Qt.AlignVCenter
		color: "black"
	}

	background: Rectangle {
		id: idBg
		anchors.fill: parent
		color: idAddNew.Material.accent
		radius: parent.width * 0.5
	}

	Ripple {
		id: idRip
		width: idAddNew.width; height: idAddNew.height
		anchor: idBg
		active: idAddNew.hovered && !idAddNew.pressed
		pressed: idAddNew.pressed
		color: Material.color(Material.Purple, Material.Shade400)
		layer.enabled: true
		layer.effect: OpacityMask {
			maskSource: Rectangle {
				width: idRip.width; height: idRip.height
				radius: idBg.radius
			}
		}
	}
}
