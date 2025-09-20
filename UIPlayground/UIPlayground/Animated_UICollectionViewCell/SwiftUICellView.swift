import SwiftUI

struct SwiftUICellView: View {
    let title: String
    let subtitle: String
    let isExpanded: Bool

    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)

                    if isExpanded {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }
                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 8)
        .onTapGesture {
            withAnimation {
                onTap()
            }
        }
    }
}

#Preview {
    @Previewable @State var isExpanded: Bool = false

    SwiftUICellView(
        title: "This is the title",
        subtitle: "this is the subtitle",
        isExpanded: true,
        onTap: { isExpanded.toggle() }
    )
}
