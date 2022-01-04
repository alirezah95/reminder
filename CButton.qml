import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Control {
	id: idControl
	property alias button: idBtn

	width: 56
	height: 56

	rightPadding: 8
	leftPadding: 8
	topPadding: 8
	bottomPadding: 8

	signal buttonReleased

	RectangularGlow {
		anchors.centerIn: idBtn
		anchors.verticalCenterOffset: idBtn.pressed ? glowRadius : 3
		visible: idBg.visible
		width: parent.width - 6
		height: parent.height - 10
		glowRadius: idBtn.pressed ? idControl.Material.elevation: 1.5
		spread: 0.34
		color: Qt.alpha("black", 0.42)
		cornerRadius: idBg.radius
	}

	Button {
		readonly property Item sourceItem: idBg
		id: idBtn

		width: idControl.width - idControl.rightPadding
		height: idControl.height - idControl.topPadding
		anchors.centerIn: parent
		rightPadding: 0
		leftPadding: 0
		topPadding: 0
		bottomPadding: 0

		onReleased: buttonReleased();

		background: Rectangle {
			id: idBg
			anchors.fill: parent
			visible: !idBtn.flat || idBtn.pressed
			color: idBtn.highlighted ? idControl.Material.accent:
									   idControl.Material.background
			radius: parent.width * 0.5
		}

		highlighted: false

		icon.width: 24
		icon.height: 24

		Ripple {
			id: idRip
			width: idBtn.width; height: idBtn.height
			anchor: idBg
			visible: idBg.visible
			active: idBtn.hovered && !idBtn.pressed
			pressed: idBtn.pressed
			color: Qt.darker(idBg.color, 1.15)
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
