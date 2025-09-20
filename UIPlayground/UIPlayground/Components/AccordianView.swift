import SwiftUI

struct AccordianView: View {
    @State private var isExpanded: Bool = false

    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)

                    if isExpanded {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(.black, lineWidth: 1)
        )
        .transition(.opacity.combined(with: .scale))
        .onTapGesture {
            withAnimation(.snappy(duration: 0.2)) {
                self.isExpanded.toggle()
            }
        }
    }
}

#Preview {
    AccordianView(
        title: "This is the title",
        subtitle: "this is the subtitle"
    )
    .padding(.horizontal, 8)
}
