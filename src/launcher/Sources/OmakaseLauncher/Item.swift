import Foundation

struct Item: Identifiable, Equatable {
    enum Kind {
        case app
        case file
        case command
    }

    let id: String
    let title: String
    let subtitle: String
    let kind: Kind
    let target: String

    func matches(_ query: String) -> Bool {
        if query.isEmpty { return kind != .file }
        let q = query.lowercased()
        return title.lowercased().contains(q) || subtitle.lowercased().contains(q)
    }

    func rank(_ query: String) -> Int {
        if query.isEmpty { return kindRank() }
        let q = query.lowercased()
        let title = title.lowercased()
        if title == q { return 0 }
        if title.hasPrefix(q) { return 1 }
        if title.contains(q) { return 2 }
        return 3 + kindRank()
    }

    private func kindRank() -> Int {
        switch kind {
        case .command: return 0
        case .app: return 1
        case .file: return 2
        }
    }
}
