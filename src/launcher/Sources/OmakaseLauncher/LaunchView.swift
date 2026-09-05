import Combine
import SwiftUI

struct LaunchView: View {
    @ObservedObject var session: Session
    @FocusState private var fieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            field
            Rectangle()
                .fill(session.palette.surface)
                .frame(height: 1)
            rows
            footer
        }
        .frame(width: 560, height: 440)
        .background(session.palette.background)
        .onAppear {
            session.prepare()
            fieldFocused = true
        }
    }

    private var field: some View {
        TextField(placeholder, text: $session.query)
            .textFieldStyle(.plain)
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(session.palette.foreground)
            .focused($fieldFocused)
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
    }

    private var rows: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(session.visible.enumerated()), id: \.element.id) { index, item in
                        row(item, selected: index == session.selected)
                            .id(item.id)
                    }
                }
            }
            .onReceive(session.$selected) { index in
                if session.visible.indices.contains(index) {
                    proxy.scrollTo(session.visible[index].id, anchor: .center)
                }
            }
        }
    }

    private var footer: some View {
        HStack {
            Text(hint)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(session.palette.muted)
            Spacer()
            Text("Omakase")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(session.palette.accent)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 10)
    }

    private var placeholder: String {
        switch session.mode {
        case .launch:
            return "App, file, or command"
        case .system:
            return "Lock, sleep, restart"
        }
    }

    private var hint: String {
        switch session.mode {
        case .launch:
            return "↵ open    esc close    Super+Space toggle"
        case .system:
            return "↵ run    esc close"
        }
    }

    private func row(_ item: Item, selected: Bool) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(item.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(session.palette.foreground)
            Spacer(minLength: 12)
            Text(item.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(session.palette.muted)
                .lineLimit(1)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 9)
        .background(selected ? session.palette.highlight.opacity(0.45) : Color.clear)
        .overlay(alignment: .leading) {
            if selected {
                Rectangle()
                    .fill(session.palette.accent)
                    .frame(width: 2)
            }
        }
    }
}
