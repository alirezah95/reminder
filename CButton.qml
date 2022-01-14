import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material.impl
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes

Control {
	id: idControl
	property alias button: idBtn
	property alias imageIcon: idIcon
	property alias iconColor: idIconOverlay.color

	Material.elevation: 6

	width: 56
	height: 56

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

		rightPadding: 16
		leftPadding: 16
		topPadding: 16
		bottomPadding: 16

		onReleased: buttonReleased();

		background: Rectangle {
			id: idBg
			anchors.fill: parent
			visible: !idBtn.flat || idBtn.pressed
			color: idBtn.highlighted ? idControl.Material.accent:
									   idControl.Material.background
			radius: parent.width * 0.5

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

		contentItem: Item {
			Image {
				id: idIcon
				anchors.fill: parent
			}
			ColorOverlay {
				id: idIconOverlay
				anchors.fill: idIcon
				source: idIcon
				color: idBtn.flat ? Material.foreground : Material.primary
			}
		}

		highlighted: false
	}
}
