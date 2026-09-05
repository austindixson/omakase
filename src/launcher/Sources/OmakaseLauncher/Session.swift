import AppKit
import Combine
import Foundation

final class Session: ObservableObject {
    @Published var query = "" {
        didSet { refresh() }
    }
    @Published var visible: [Item] = []
    @Published var selected = 0
    @Published var palette: Palette = .kyoto

    let mode: Mode
    private let launchPath: String
    private let stateDir: URL
    private var apps: [Item] = []
    private var commands: [Item] = []
    private var fileSearch = 0

    init(mode: Mode, launchPath: String, stateDir: URL) {
        self.mode = mode
        self.launchPath = launchPath
        self.stateDir = stateDir
    }

    func prepare() {
        palette = Palette.load(stateDir: stateDir)
        commands = Catalog.commands(mode: mode)
        switch mode {
        case .system:
            apps = []
        case .launch:
            apps = Catalog.apps(extraRoot: ProcessInfo.processInfo.environment["OMAKASE_APP_ROOT"])
        }
        refresh()
    }

    func move(_ delta: Int) {
        if visible.isEmpty { return }
        let next = selected + delta
        selected = (next % visible.count + visible.count) % visible.count
    }

    func confirm() {
        guard visible.indices.contains(selected) else {
            quit()
            return
        }
        run(visible[selected])
        quit()
    }

    func quit() {
        NSApp.terminate(nil)
    }

    private func refresh() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        var items = (commands + apps).filter { $0.matches(q) }
        items.sort { $0.rank(q) < $1.rank(q) }
        visible = items
        selected = 0
        switch mode {
        case .system:
            return
        case .launch:
            searchFiles(q)
        }
    }

    private func searchFiles(_ q: String) {
        fileSearch += 1
        let token = fileSearch
        guard q.count >= 2 else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let files = Catalog.files(matching: q)
            DispatchQueue.main.async {
                self.mergeFiles(files, token: token, query: q)
            }
        }
    }

    private func mergeFiles(_ files: [Item], token: Int, query: String) {
        if token != fileSearch { return }
        if query != self.query.trimmingCharacters(in: .whitespacesAndNewlines) { return }
        var items = visible + files.filter { $0.matches(query) }
        items.sort { $0.rank(query) < $1.rank(query) }
        visible = items
        if selected >= visible.count { selected = 0 }
    }

    private func run(_ item: Item) {
        switch item.kind {
        case .app, .file:
            NSWorkspace.shared.open(URL(fileURLWithPath: item.target))
        case .command:
            runCommand(item.target)
        }
    }

    private func runCommand(_ verb: String) {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/bin/bash")
        proc.arguments = [launchPath, verb]
        proc.environment = ProcessInfo.processInfo.environment
        do {
            try proc.run()
        } catch {
            NSSound.beep()
        }
    }
}
