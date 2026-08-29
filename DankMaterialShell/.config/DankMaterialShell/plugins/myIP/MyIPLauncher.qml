import QtQuick
import Quickshell
import Quickshell.Io
import "."

QtObject {
    id: root

    property var pluginService: null
    property string pluginId: "myip"
    property string trigger: "myip"

    // double, not int: Date.now() overflows a 32-bit int
    property double lastFetchTime: 0

    signal itemsChanged

    property Connections svcConn: Connections {
        target: MyIPService
        function onResultsUpdated() {
            root.lastFetchTime = Date.now();
            root.refreshResults();
        }
    }

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData("myip", "trigger", "myip");
        MyIPService.probe();
    }

    function getItems(query) {
        if (query && query.trim().length > 0) {
            var items = buildItems();
            if (items.length === 0)
                return [];
            var lower = query.trim().toLowerCase();
            return items.filter(function(item) {
                return item.name && item.name.toLowerCase().indexOf(lower) !== -1;
            });
        }

        var now = Date.now();
        if (!MyIPService.fetching && now - lastFetchTime > 60000)
            MyIPService.fetchAllIPs();

        return buildItems();
    }

    function buildItems() {
        var items = [];

        var entries = [
            { ip: MyIPService.privateIPv4, icon: "material:lan", comment: "Private IPv4" },
            { ip: MyIPService.privateIPv6, icon: "material:lan", comment: "Private IPv6" },
            { ip: MyIPService.publicIPv4, icon: "material:public", comment: "Public IPv4" },
            { ip: MyIPService.publicIPv6, icon: "material:public", comment: "Public IPv6" },
            { ip: MyIPService.tailscaleIPv4, icon: "material:vpn_lock", comment: "Tailscale IPv4" },
            { ip: MyIPService.tailscaleIPv6, icon: "material:vpn_lock", comment: "Tailscale IPv6" },
            { ip: MyIPService.tailscaleHostname, icon: "material:dns", comment: "Tailscale MagicDNS hostname" }
        ];

        for (var i = 0; i < entries.length; i++) {
            var e = entries[i];
            if (e.ip) {
                items.push({
                    name: e.ip,
                    icon: e.icon,
                    comment: e.comment,
                    action: "copy:" + e.ip,
                    categories: ["My IP"]
                });
            }
        }

        if (items.length === 0) {
            items.push({
                name: MyIPService.fetching ? "Fetching IPs..." : "No IPs found",
                icon: MyIPService.fetching ? "material:refresh" : "material:error",
                comment: MyIPService.fetching ? "Gathering your network information" : "Could not retrieve any IP information",
                action: "none",
                categories: ["My IP"]
            });
        }

        return items;
    }

    function refreshResults() {
        if (!pluginService || !pluginId)
            return;
        if (typeof pluginService.requestLauncherUpdate === "function")
            pluginService.requestLauncherUpdate(pluginId);
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        var parts = item.action.split(":");
        if (parts[0] === "copy" && parts.length > 1) {
            var text = parts.slice(1).join(":");
            Quickshell.execDetached(["dms", "cl", "copy", text]);
            if (typeof ToastService !== "undefined")
                ToastService.showInfo("My IP", "Copied: " + text);
        }
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData("myip", "trigger", trigger);
    }
}
