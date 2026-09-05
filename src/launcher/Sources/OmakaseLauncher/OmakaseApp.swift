import AppKit
import SwiftUI

enum LauncherArgs {
    static func mode(from args: [String]) -> Mode {
        if let idx = args.firstIndex(of: "--mode"), args.indices.contains(idx + 1) {
            return args[idx + 1] == "system" ? .system : .launch
        }
        if let arg = args.first(where: { $0.hasPrefix("--mode=") }) {
            return String(arg.dropFirst("--mode=".count)) == "system" ? .system : .launch
        }
        return .launch
    }

    static func launchPath() -> String {
        if let env = ProcessInfo.processInfo.environment["OMAKASE_LAUNCH"], !env.isEmpty {
            return env
        }
        return NSHomeDirectory() + "/.config/omakase/bin/omakase-launch"
    }

    static func stateDir() -> URL {
        if let env = ProcessInfo.processInfo.environment["OMAKASE_STATE"], !env.isEmpty {
            return URL(fileURLWithPath: env)
        }
        return URL(fileURLWithPath: NSHomeDirectory() + "/.config/omakase")
    }
}

@main
struct OmakaseApp: App {
    @StateObject private var session = Session(
        mode: LauncherArgs.mode(from: CommandLine.arguments),
        launchPath: LauncherArgs.launchPath(),
        stateDir: LauncherArgs.stateDir()
    )

    var body: some Scene {
        WindowGroup {
            LaunchView(session: session)
                .onAppear { decorate() }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 560, height: 440)
    }

    private func decorate() {
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        guard let window = NSApp.windows.first else { return }
        window.center()
        window.level = .floating
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(session.palette.background)
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        installKeys()
    }

    private func installKeys() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            handle(event)
        }
    }

    private func handle(_ event: NSEvent) -> NSEvent? {
        switch event.keyCode {
        case KeyCode.escape:
            session.quit()
            return nil
        case KeyCode.return, KeyCode.enter:
            session.confirm()
            return nil
        case KeyCode.down:
            session.move(1)
            return nil
        case KeyCode.up:
            session.move(-1)
            return nil
        default:
            return event
        }
    }
}

private enum KeyCode {
    static let escape: UInt16 = 53
    static let `return`: UInt16 = 36
    static let enter: UInt16 = 76
    static let down: UInt16 = 125
    static let up: UInt16 = 126
}
