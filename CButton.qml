import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Item {
	property alias contentItem: idBtn.contentItem
	property alias icon: idBtn.icon

	width: Math.max(idBtn.width, idShadow.width)
	height: Math.max(idBtn.height, idShadow.height)

	signal buttonReleased

	Rectangle {
		property var sourceItem: this
		id: idShadow
		width: idBtn.width * 1.3; height: width
		anchors.centerIn: parent
		anchors.verticalCenterOffset: 10
		radius: idBtn.radius
		color: "transparent"
		layer.enabled: true
		layer.effect: ElevationEffect {
			elevation: 15
			source: idShadow
		}
	}

	Button {
		id: idBtn
		readonly property alias radius: idBg.radius

		width: Math.min(idRoot.width, idRoot.height) * 0.1; height: width
		anchors.centerIn: parent

		onReleased: buttonReleased();

		background: Rectangle {
			id: idBg
			anchors.fill: parent
			color: idBtn.Material.accent
			radius: parent.width * 0.5
		}
		icon.width: width / 3; icon.height: height / 3

		Ripple {
			id: idRip
			width: idBtn.width; height: idBtn.height
			anchor: idBg
			active: idBtn.hovered && !idBtn.pressed
			pressed: idBtn.pressed
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
}
