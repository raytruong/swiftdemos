import SwiftUI
import UIKit

struct CALayerInteractiveDemoView: View {
    @State private var backgroundColor: UIColor? = .systemYellow
    @State private var borderWidth: CGFloat = 2
    @State private var borderColor: UIColor? = .orange
    @State private var cornerRadius: CGFloat = 8
    @State private var shadowColor: UIColor? = .black
    @State private var shadowOpacity: Float = 0.3
    @State private var shadowOffsetW: CGFloat = 2
    @State private var shadowOffsetH: CGFloat = 2
    @State private var shadowRadius: CGFloat = 4

    // Color options (label, UIColor?)
    let colorOptions: [(String, UIColor?)] = [
        ("None", nil),
        ("Clear", .clear),
        ("System Yellow", .systemYellow),
        ("System Blue", .systemBlue),
        ("System Red", .systemRed),
        ("System Green", .systemGreen),
        ("System Purple", .systemPurple),
        ("System Pink", .systemPink),
        ("System Gray", .systemGray),
        ("Black", .black),
        ("White", .white),
        ("Orange", .orange),
        ("Dark Gray", .darkGray),
        ("Light Gray", .lightGray)
    ]

    var body: some View {
        VStack(spacing: 18) {
            CALayerDemoRepresentable(
                backgroundColor: backgroundColor,
                borderWidth: borderWidth,
                borderColor: borderColor,
                cornerRadius: cornerRadius,
                shadowColor: shadowColor,
                shadowOpacity: shadowOpacity,
                shadowOffset: CGSize(width: shadowOffsetW, height: shadowOffsetH),
                shadowRadius: shadowRadius
            )
            .frame(width: 140, height: 140)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray4)))
            .padding(.bottom, 8)

            Group {
                propertyPicker(title: "Background", selection: $backgroundColor)
                propertyPicker(title: "Border", selection: $borderColor)
                propertyPicker(title: "Shadow", selection: $shadowColor)
            }
            .padding(.bottom, 2)

            HStack {
                Text("Border Width")
                Slider(value: $borderWidth, in: 0...10, step: 1)
                Text("\(Int(borderWidth))")
            }
            HStack {
                Text("Corner Radius")
                Slider(value: $cornerRadius, in: 0...70, step: 1)
                Text("\(Int(cornerRadius))")
            }
            HStack {
                Text("Shadow Opacity")
                Slider(value: $shadowOpacity, in: 0...1, step: 0.05)
                Text(String(format: "%.2f", shadowOpacity))
            }
            HStack {
                Text("Shadow Radius")
                Slider(value: $shadowRadius, in: 0...20, step: 1)
                Text("\(Int(shadowRadius))")
            }
            HStack {
                Text("Shadow Offset W")
                Slider(value: $shadowOffsetW, in: -20...20, step: 1)
                Text("\(Int(shadowOffsetW))")
            }
            HStack {
                Text("Shadow Offset H")
                Slider(value: $shadowOffsetH, in: -20...20, step: 1)
                Text("\(Int(shadowOffsetH))")
            }
        }
        .padding()
    }

    // MARK: - Helpers
    func propertyPicker(title: String, selection: Binding<UIColor?>) -> some View {
        HStack {
            Text(title)
                .frame(width: 85, alignment: .leading)
            Picker(title, selection: selection) {
                ForEach(colorOptions, id: \.0) { label, color in
                    if let color = color {
                        HStack {
                            Circle()
                                .fill(Color(color))
                                .frame(width: 16, height: 16)
                            Text(label)
                        }
                        .tag(Optional(color) as UIColor?)
                    } else {
                        Text(label).tag(nil as UIColor?)
                    }
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

#Preview {
    CALayerInteractiveDemoView()
}
