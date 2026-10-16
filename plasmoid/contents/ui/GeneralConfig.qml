import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: configRoot

    property alias cfg_inverterIp: inverterIpField.text
    property alias cfg_backgroundOpacity: opacitySlider.value
    property string cfg_viewStyle: "bar"

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

    Item { height: Kirigami.Units.largeSpacing }

    ComboBox {
        id: viewStyleCombo
        Kirigami.FormData.label: i18n("Widget style:")
        model: [
            { text: i18n("Classic (progress bar)"), value: "bar" },
            { text: i18n("Neon battery"), value: "neon" }
        ]
        textRole: "text"
        currentIndex: cfg_viewStyle === "neon" ? 1 : 0
        onCurrentIndexChanged: cfg_viewStyle = model[currentIndex].value
    }
}
