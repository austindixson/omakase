import Foundation

enum Mode {
    case launch
    case system
}

enum Catalog {
    static func commands(mode: Mode) -> [Item] {
        switch mode {
        case .system:
            return systemCommands()
        case .launch:
            return dailyCommands() + systemCommands()
        }
    }

    static func apps(extraRoot: String?) -> [Item] {
        var seen = Set<String>()
        var items: [Item] = []
        for url in appURLs(extraRoot: extraRoot) {
            let name = url.deletingPathExtension().lastPathComponent
            let key = name.lowercased()
            if seen.contains(key) { continue }
            seen.insert(key)
            items.append(
                Item(
                    id: "app:\(name)",
                    title: name,
                    subtitle: "Application",
                    kind: .app,
                    target: url.path
                )
            )
        }
        return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    static func files(matching query: String) -> [Item] {
        guard let spotlight = spotlightQuery(query) else { return [] }
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/mdfind")
        proc.arguments = ["-onlyin", NSHomeDirectory(), spotlight]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = FileHandle.nullDevice
        do {
            try proc.run()
        } catch {
            return []
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        proc.waitUntilExit()
        guard proc.terminationStatus == 0 else { return [] }
        let paths = String(data: data, encoding: .utf8)?
            .split(whereSeparator: \.isNewline)
            .prefix(12) ?? []
        return paths.map { path in
            let url = URL(fileURLWithPath: String(path))
            return Item(
                id: "file:\(url.path)",
                title: url.lastPathComponent,
                subtitle: url.deletingLastPathComponent().path,
                kind: .file,
                target: url.path
            )
        }
    }

    static func spotlightQuery(_ query: String) -> String? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 2 { return nil }
        if trimmed.contains(where: { #"\"*()[]"#.contains($0) }) { return nil }
        return "kMDItemDisplayName == \"*\(trimmed)*\"cd"
    }

    private static func dailyCommands() -> [Item] {
        [
            Item(id: "terminal", title: "Terminal", subtitle: "Ghostty, or Terminal.app", kind: .command, target: "terminal"),
            Item(id: "browser", title: "Browser", subtitle: "Safari unless launch.conf says otherwise", kind: .command, target: "browser"),
            Item(id: "files", title: "Finder", subtitle: "Files", kind: .command, target: "files"),
            Item(id: "editor", title: "Editor", subtitle: "TextEdit unless launch.conf says otherwise", kind: .command, target: "editor"),
            Item(id: "music", title: "Music", subtitle: "Music.app", kind: .command, target: "music"),
            Item(id: "passwords", title: "Passwords", subtitle: "1Password if installed", kind: .command, target: "passwords"),
        ]
    }

    private static func systemCommands() -> [Item] {
        [
            Item(id: "lock", title: "Lock Screen", subtitle: "Command", kind: .command, target: "lock"),
            Item(id: "sleep", title: "Sleep", subtitle: "Command", kind: .command, target: "sleep"),
            Item(id: "restart", title: "Restart", subtitle: "Command", kind: .command, target: "restart"),
        ]
    }

    private static func appURLs(extraRoot: String?) -> [URL] {
        var roots = [
            URL(fileURLWithPath: "/Applications"),
            URL(fileURLWithPath: "/System/Applications"),
            URL(fileURLWithPath: "/System/Applications/Utilities"),
            URL(fileURLWithPath: NSHomeDirectory() + "/Applications"),
        ]
        if let extraRoot, !extraRoot.isEmpty {
            roots.append(URL(fileURLWithPath: extraRoot))
        }
        return roots.flatMap { collectApps(in: $0, depth: 1) }
    }

    private static func collectApps(in root: URL, depth: Int) -> [URL] {
        if depth < 0 { return [] }
        let kids = (try? FileManager.default.contentsOfDirectory(
            at: root,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )) ?? []
        var out: [URL] = []
        for url in kids {
            if url.pathExtension == "app" {
                out.append(url)
                continue
            }
            if depth > 0 {
                out.append(contentsOf: collectApps(in: url, depth: depth - 1))
            }
        }
        return out
    }
}
