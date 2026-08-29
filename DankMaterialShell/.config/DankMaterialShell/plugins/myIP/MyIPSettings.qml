import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "myip"

    StyledText {
        width: parent.width
        text: "My IP Plugin"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "View and copy your private, public, and Tailscale IPs (v4 and v6) along with your Tailscale MagicDNS hostname."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StringSetting {
        id: triggerSetting
        settingKey: "trigger"
        label: "Trigger"
        description: "Prefix to activate the plugin in the launcher (e.g., myip, ip)"
        placeholder: "myip"
        defaultValue: "myip"
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "What's displayed"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM

        Repeater {
            model: [
                "Private IPv4 — local network address",
                "Private IPv6 — local network address",
                "Public IPv4 — internet-facing address",
                "Public IPv6 — internet-facing address",
                "Tailscale IPv4 — VPN address",
                "Tailscale IPv6 — VPN address",
                "Tailscale MagicDNS hostname — VPN hostname"
            ]

            StyledText {
                required property string modelData
                text: "• " + modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Usage"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM
        bottomPadding: Theme.spacingL

        Repeater {
            model: [
                "1. Open the Launcher (Super+Space or click the launcher button)",
                "2. Type your trigger (e.g., 'myip') to see your IPs",
                "3. Optionally filter by typing (e.g., 'myip 10.')",
                "4. Press Enter on an item to copy it to your clipboard"
            ]

            StyledText {
                required property string modelData
                text: modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }
}
