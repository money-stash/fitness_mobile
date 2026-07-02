import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    /// Enables the shorthand `.foregroundStyle(.brand)`.
    static var brand: Color { Color.brand }
}

extension Color {
    static let brand = Color(red: 0.15, green: 0.68, blue: 0.45)

    static func named(_ name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "teal": return .teal
        case "indigo": return .indigo
        case "mint": return .mint
        default: return .brand
        }
    }
}

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func daysAgo(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -n, to: self) ?? self
    }

    var shortLabel: String {
        let f = DateFormatter()
        f.locale = Settings.shared.language.locale
        f.dateFormat = "d MMM"
        return f.string(from: self)
    }

    var fullLabel: String {
        let f = DateFormatter()
        f.locale = Settings.shared.language.locale
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: self).capitalized
    }

    var timeLabel: String {
        let f = DateFormatter()
        f.locale = Settings.shared.language.locale
        f.dateFormat = "d MMM, HH:mm"
        return f.string(from: self)
    }
}

extension Double {
    /// Formats "72.5", but keeps "72" without a redundant trailing zero.
    var clean: String {
        truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.1f", self)
    }
}

extension Int {
    var durationLabel: String {
        let m = self / 60
        let s = self % 60
        if m >= 60 {
            return "\(m / 60) \(L("unit.hour")) \(m % 60) \(L("unit.min"))"
        }
        return s > 0 && m < 10 ? "\(m):\(String(format: "%02d", s))" : "\(m) \(L("unit.min"))"
    }
}

/// Standard card background.
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func card() -> some View { modifier(CardBackground()) }
}

/// Circular progress indicator.
struct RingView: View {
    var progress: Double
    var lineWidth: CGFloat = 12
    var color: Color = .brand

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(1, progress))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.6), value: progress)
        }
    }
}

/// Horizontal macro progress bar.
struct MacroBar: View {
    var title: String
    var value: Double
    var target: Double
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value)) / \(Int(target)) \(L("unit.g"))")
                    .font(.caption.weight(.medium))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(color.opacity(0.15))
                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * min(1, target > 0 ? value / target : 0))
                }
            }
            .frame(height: 6)
        }
    }
}

/// Star rating indicator.
struct StarsView: View {
    var rating: Double

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: Double(i) <= rating.rounded() ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
            }
        }
    }
}
