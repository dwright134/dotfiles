pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string privateIPv4: ""
    property string privateIPv6: ""
    property string publicIPv4: ""
    property string publicIPv6: ""
    property string tailscaleIPv4: ""
    property string tailscaleIPv6: ""
    property string tailscaleHostname: ""

    property bool fetching: false
    property bool tailscaleProbed: false
    property bool tailscaleAvailable: false
    property int pendingProcs: 0

    signal resultsUpdated

    function probe() {
        if (!whichProc.running)
            whichProc.running = true;
    }

    function fetchAllIPs() {
        if (fetching)
            return;
        fetching = true;
        privateIPv4 = "";
        privateIPv6 = "";
        publicIPv4 = "";
        publicIPv6 = "";
        tailscaleIPv4 = "";
        tailscaleIPv6 = "";
        tailscaleHostname = "";
        pendingProcs = 3;
        privateProc.running = true;
        publicProc.running = true;
        tailscaleStatusProc.running = true;
        fetchTimer.restart();
    }

    function procFinished() {
        pendingProcs--;
        if (pendingProcs <= 0) {
            fetching = false;
            fetchTimer.stop();
        }
        resultsUpdated();
    }

    Timer {
        id: fetchTimer
        interval: 15000
        onTriggered: {
            root.pendingProcs = 0;
            root.fetching = false;
            root.resultsUpdated();
        }
    }

    Process {
        id: privateProc
        command: ["sh", "-c", "v4=$(hostname -I 2>/dev/null | awk '{print $1}'); [ -z \"$v4\" ] && v4=$(ip -4 addr show scope global 2>/dev/null | awk '/inet / {split($2,a,\"/\"); print a[1]; exit}'); echo \"$v4\"; v6=$(ip -6 addr show scope global 2>/dev/null | awk '/inet6 / && $2 !~ /^fe80:/ {split($2,a,\"/\"); print a[1]; exit}'); echo \"$v6\""]
        stdout: StdioCollector {
            id: privateOut
            waitForEnd: true
        }
        onExited: exitCode => {
            if (exitCode === 0) {
                var lines = (privateOut.text || "").trim().split("\n");
                root.privateIPv4 = (lines[0] || "").trim();
                if (lines.length > 1)
                    root.privateIPv6 = lines[1].trim();
            }
            root.procFinished();
        }
    }

    Process {
        id: publicProc
        command: ["sh", "-c", "v4=$(curl -4 -s --max-time 5 ifconfig.me 2>/dev/null || curl -4 -s --max-time 5 api.ipify.org 2>/dev/null); echo \"${v4:-}\"; v6=$(curl -6 -s --max-time 5 ifconfig.me 2>/dev/null || curl -6 -s --max-time 5 api.ipify.org 2>/dev/null); echo \"${v6:-}\""]
        stdout: StdioCollector {
            id: publicOut
            waitForEnd: true
        }
        onExited: exitCode => {
            var lines = (publicOut.text || "").trim().split("\n");
            root.publicIPv4 = (lines[0] || "").trim();
            if (lines.length > 1 && lines[1].trim() !== "")
                root.publicIPv6 = lines[1].trim();
            root.procFinished();
        }
    }

    Process {
        id: tailscaleIPsProc
        command: ["sh", "-c", "v4=$(tailscale ip -4 2>/dev/null); echo \"${v4:-}\"; v6=$(tailscale ip -6 2>/dev/null); echo \"${v6:-}\""]
        stdout: StdioCollector {
            id: tsIPsOut
            waitForEnd: true
        }
        onExited: exitCode => {
            if (exitCode === 0) {
                var lines = (tsIPsOut.text || "").trim().split("\n");
                root.tailscaleIPv4 = (lines[0] || "").trim();
                if (lines.length > 1)
                    root.tailscaleIPv6 = lines[1].trim();
            }
            root.procFinished();
        }
    }

    Process {
        id: tailscaleStatusProc
        command: ["tailscale", "status", "--json"]
        stdout: StdioCollector {
            id: tsStatusOut
            waitForEnd: true
        }
        onExited: exitCode => {
            if (exitCode === 0) {
                try {
                    var data = JSON.parse(tsStatusOut.text);
                    if (data.BackendState === "Running" && data.Self) {
                        if (data.Self.DNSName)
                            root.tailscaleHostname = data.Self.DNSName.replace(/\.$/, "");
                        root.pendingProcs++;
                        tailscaleIPsProc.running = true;
                    }
                } catch (e) {
                    console.log("[MyIP] Failed to parse tailscale status:", e);
                }
            }
            root.procFinished();
        }
    }

    Process {
        id: whichProc
        command: ["sh", "-c", "command -v tailscale"]
        onExited: exitCode => {
            root.tailscaleProbed = true;
            root.tailscaleAvailable = exitCode === 0;
            if (root.tailscaleAvailable && !tailscaleStatusProc.running)
                tailscaleStatusProc.running = true;
        }
    }
}
