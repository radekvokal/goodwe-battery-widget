import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: configRoot

    property alias cfg_inverterIp: inverterIpField.text
    property alias cfg_backgroundOpacity: opacitySlider.value

    TextField {
        id: inverterIpField
        Kirigami.FormData.label: i18n("Inverter IP address:")
        placeholderText: "192.168.0.22"
        inputMethodHints: Qt.ImhPreferNumbers
    }

    Label {
        text: i18n("The local network IP address of your GoodWe inverter.")
        font.pointSize: 8
        opacity: 0.6
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }

    Item { height: Kirigami.Units.largeSpacing }

    RowLayout {
        Kirigami.FormData.label: i18n("Background opacity:")
        spacing: Kirigami.Units.smallSpacing

        Label { text: i18n("Transparent") }

        Slider {
            id: opacitySlider
            from: 0
            to: 100
            stepSize: 5
            Layout.fillWidth: true
        }

        Label { text: i18n("Opaque") }
    }

    Label {
        text: i18n("Current: %1%", opacitySlider.value)
        font.pointSize: 8
        opacity: 0.6
    }
}
