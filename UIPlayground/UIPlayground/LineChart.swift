import Playgrounds
import SwiftUI

struct LineChart: View {
    // Title for the chart
    var title: String = "Net Worth"

    // Data to plot. Defaults provided so #Preview works out of the box.
    var values: [Double] = [
        1200, 1800, 1650, 2100, 2400, 3000, 2800, 3500, 4200, 4800, 5200, 6000
    ]

    // Scrub state
    @State private var selectedIndex: Int? = nil

    var body: some View {
        // Glass card container
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            // Chart area
            GeometryReader { geo in
                let size = geo.size
                let minValue = values.min() ?? 0
                let maxValue = values.max() ?? 1
                let range = max(maxValue - minValue, 1)
                let stepX = size.width / CGFloat(max(values.count - 1, 1))

                // Compute points for the path
                let points: [CGPoint] = values.enumerated().map { (idx, value) in
                    let x = CGFloat(idx) * stepX
                    let normalized = (value - minValue) / range
                    let y = size.height - CGFloat(normalized) * size.height
                    return CGPoint(x: x, y: y)
                }

                ZStack {
                    // Background grid (subtle)
                    VStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(.secondary.opacity(0.08))
                                .frame(height: 1)
                            Spacer()
                        }
                    }

                    // Area under line (very subtle)
                    if points.count > 1 {
                        Path { path in
                            path.move(to: CGPoint(x: points.first!.x, y: size.height))
                            for p in points { path.addLine(to: p) }
                            path.addLine(to: CGPoint(x: points.last!.x, y: size.height))
                            path.closeSubpath()
                        }
                        .fill(
                            LinearGradient(
                                colors: [Color.green.opacity(0.20), Color.blue.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }

                    // Line path
                    if let first = points.first, points.count > 1 {
                        Path { path in
                            path.move(to: first)
                            for p in points.dropFirst() {
                                path.addLine(to: p)
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [Color.green, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.5, lineJoin: .round)
                        )
                    }

                    // Dots for each point (subtle)
                    ForEach(Array(points.enumerated()), id: \.0) { idx, p in
                        Circle()
                            .fill(Color.primary.opacity(0.15))
                            .frame(width: 6, height: 6)
                            .position(p)
                            .accessibilityHidden(true)
                    }

                    // Scrub indicator (dot + vertical guideline + value label)
                    if let i = selectedIndex, i < points.count {
                        let p = points[i]
                        // Guideline
                        Path { path in
                            path.move(to: CGPoint(x: p.x, y: 0))
                            path.addLine(to: CGPoint(x: p.x, y: size.height))
                        }
                        .stroke(Color.accentColor.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                        // Follower dot
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .position(p)

                        // Floating value label
                        let currencyCode = Locale.current.currency?.identifier ?? "USD"
                        Text(values[i], format: .currency(code: currencyCode))
                            .font(.caption)
                            .monospacedDigit()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                            .shadow(radius: 1, y: 1)
                            .position(x: p.x, y: max(14, p.y - 20))
                            .accessibilityLabel("Selected value")
                            .accessibilityValue(Text(values[i], format: .currency(code: currencyCode)))
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let x = min(max(0, value.location.x), size.width)
                            let idx = Int(round(x / max(stepX, 0.0001)))
                            selectedIndex = min(max(idx, 0), values.count - 1)
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedIndex = nil
                            }
                        }
                )
                .animation(.easeInOut(duration: 0.15), value: selectedIndex)
            }
            .frame(height: 240)
        }
        .padding(16)
        .glassEffect(.regular.tint(Color.accentColor.opacity(0)).interactive(), in: .rect(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 18, y: 8)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(title))
    }
}

#Preview {
    LineChart()
}
