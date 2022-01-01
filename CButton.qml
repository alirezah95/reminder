import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Item {
	property alias contentItem: idBtn.contentItem
	property alias icon: idBtn.icon

	width: Math.max(idBtn.width, 0)
	height: Math.max(idBtn.height, 0)

	signal buttonReleased

	RectangularGlow {
		anchors.fill: idBtn
		glowRadius: 10
		spread: 0.1
		color: Material.color(Material.Grey)
		cornerRadius: idBg.radius + glowRadius
	}

	Button {
		id: idBtn
		readonly property alias radius: idBg.radius

		width: Math.min(idRoot.width, idRoot.height) / 8; height: width
		anchors.centerIn: parent

		onReleased: buttonReleased();

		background: Rectangle {
			property Rectangle sourceItem: this
			id: idBg
			anchors.fill: parent
			color: Material.background
			radius: parent.width * 0.5
		}
		icon.width: width / 3; icon.height: height / 3

		Ripple {
			id: idRip
			width: idBtn.width; height: idBtn.height
			anchor: idBg
			active: idBtn.hovered && !idBtn.pressed
			pressed: idBtn.pressed
			color: Material.shade(Material.background, Material.Shade300)
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
