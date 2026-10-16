import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property int batteryPercent: 0
    property bool isCharging: false
    property string batteryMode: "..."
    property bool hasError: false
    property color statusColor: isCharging ? "#4caf50" : "#f44336"
    property color barColor: batteryPercent > 50 ? "#4caf50" : (batteryPercent >= 20 ? "#ffc107" : "#f44336")
    property real bgOpacity: (Plasmoid.configuration.backgroundOpacity !== undefined ? Plasmoid.configuration.backgroundOpacity : 100) / 100

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    readonly property string inverterIp: Plasmoid.configuration.inverterIp || "192.168.0.22"
    readonly property string cmd: "/usr/bin/python3 /home/rvokal/.local/bin/goodwe-battery-status.py " + inverterIp

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var stdout = data["stdout"] || ""
            try {
                var result = JSON.parse(stdout)
                if (result.soc >= 0) {
                    root.batteryPercent = result.soc
                    root.isCharging = result.charging
                    root.batteryMode = result.mode || "Unknown"
                    root.hasError = false
                } else {
                    root.hasError = true
                }
            } catch (e) {
                root.hasError = true
            }
            disconnectSource(source)
        }
    }

    function fetchData() {
        executable.connectSource(root.cmd)
    }

    Timer {
        id: updateTimer
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchData()
    }

    fullRepresentation: Rectangle {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 10
        Layout.preferredHeight: Kirigami.Units.gridUnit * 5
        Layout.minimumWidth: Kirigami.Units.gridUnit * 6
        Layout.minimumHeight: Kirigami.Units.gridUnit * 3
        radius: Kirigami.Units.cornerRadius
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r,
                       Kirigami.Theme.backgroundColor.g,
                       Kirigami.Theme.backgroundColor.b,
                       root.bgOpacity)

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: root.isCharging ? "battery-charging" : "battery-080"
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
            }

            PlasmaComponents.Label {
                text: root.hasError ? "?" : root.batteryPercent + "%"
                font.pointSize: 22
                font.bold: true
                color: root.statusColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.largeSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing
            Layout.preferredHeight: Kirigami.Units.gridUnit * 0.5
            radius: height / 2
            color: Qt.rgba(Kirigami.Theme.textColor.r,
                           Kirigami.Theme.textColor.g,
                           Kirigami.Theme.textColor.b, 0.15)

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Math.max(0, Math.min(100, root.batteryPercent)) / 100
                radius: height / 2
                color: root.barColor

                Behavior on width {
                    NumberAnimation { duration: 600; easing.type: Easing.InOutQuad }
                }
                Behavior on color {
                    ColorAnimation { duration: 400 }
                }
            }
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (root.hasError) return "Connection error"
                if (root.isCharging) return "Charging"
                return "Discharging"
            }
            font.pointSize: 9
            opacity: 0.7
        }
        }
    }
}
