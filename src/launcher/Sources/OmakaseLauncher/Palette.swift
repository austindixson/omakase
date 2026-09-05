import Foundation
import SwiftUI

struct Palette {
    var background: Color
    var foreground: Color
    var muted: Color
    var accent: Color
    var highlight: Color
    var surface: Color

    static let kyoto = Palette(
        background: color(argb: 0xE0_1A_19_16),
        foreground: color(argb: 0xFF_E7_DC_C8),
        muted: color(argb: 0xFF_8A_82_78),
        accent: color(argb: 0xFF_C2_3A_2B),
        highlight: color(argb: 0xFF_3D_4C_7D),
        surface: color(argb: 0xFF_2A_27_22)
    )

    static func load(stateDir: URL) -> Palette {
        let url = stateDir.appendingPathComponent("current/theme.sh")
        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            return .kyoto
        }
        return parse(text) ?? .kyoto
    }

    static func parse(_ text: String) -> Palette? {
        var values: [String: UInt32] = [:]
        for line in text.split(whereSeparator: \.isNewline) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty || trimmed.hasPrefix("#") {
                continue
            }
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            guard parts.count == 2 else { continue }
            let key = String(parts[0])
            let raw = parts[1].trimmingCharacters(in: .whitespaces)
            guard raw.hasPrefix("0x") || raw.hasPrefix("0X") else { continue }
            let hex = String(raw.dropFirst(2))
            guard let value = UInt32(hex, radix: 16) else { continue }
            values[key] = value
        }
        guard let background = values["BAR_BG"] else { return nil }
        return Palette(
            background: color(argb: background),
            foreground: color(argb: values["BAR_FG"] ?? 0xFF_E7_DC_C8),
            muted: color(argb: values["BAR_MUTED"] ?? 0xFF_8A_82_78),
            accent: color(argb: values["BAR_ACCENT"] ?? 0xFF_C2_3A_2B),
            highlight: color(argb: values["BAR_HIGHLIGHT"] ?? 0xFF_3D_4C_7D),
            surface: color(argb: values["BAR_SURFACE"] ?? 0xFF_2A_27_22)
        )
    }

    static func color(argb: UInt32) -> Color {
        Color(
            .sRGB,
            red: Double((argb >> 16) & 0xFF) / 255,
            green: Double((argb >> 8) & 0xFF) / 255,
            blue: Double(argb & 0xFF) / 255,
            opacity: Double((argb >> 24) & 0xFF) / 255
        )
    }
}
