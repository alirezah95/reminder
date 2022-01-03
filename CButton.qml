import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Item {
	property alias contentItem: idBtn.contentItem
	property alias icon: idBtn.icon

	width: 48
	height: 48

	signal buttonReleased

	RectangularGlow {
		width: idBtn.width
		height: idBtn.height
		anchors.centerIn: idBtn
		anchors.verticalCenterOffset: 4
		glowRadius: 8
		spread: idBtn.pressed ? 0.4: 0.1
		color: Qt.alpha(Material.color(Material.Grey), 0.9)
		cornerRadius: idBg.radius + glowRadius
	}

	Button {
		id: idBtn
		readonly property alias radius: idBg.radius

		implicitWidth: parent.width
		implicitHeight: parent.height

		onReleased: buttonReleased();

		background: Rectangle {
			id: idBg
			anchors.fill: parent
			color: Material.accent
			radius: parent.width * 0.5
		}

		icon.width: width / 3; icon.height: height / 3

		Ripple {
			id: idRip
			width: idBtn.width; height: idBtn.height
			anchor: idBg
			active: idBtn.hovered && !idBtn.pressed
			pressed: idBtn.pressed
			color: Qt.darker(Material.accent, 1.15)
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
