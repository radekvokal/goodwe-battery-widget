import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: configRoot

    property alias cfg_inverterIp: inverterIpField.text

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
}
