import SwiftUI

struct ControlPanelViewImperative: View {
    @State private var viewModel = ControlPanelViewModelImperative()

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.audio)
                .font(.largeTitle)
                .frame(minHeight: 100)

            Toggle(isOn: Binding(
                get: { viewModel.isMuted },
                set: { newValue in
                    viewModel.setMuted(newValue)
                }
            )) {
                Label("Silent Mode", systemImage: viewModel.isMuted ? "bell.slash.fill" : "bell.fill")
            }
            .toggleStyle(.switch)

            VStack(alignment: .leading, spacing: 8) {
                Text("Volume: \(Int(viewModel.volume))")
                Slider(value: Binding(
                    get: { viewModel.volume },
                    set: { newValue in
                        viewModel.setVolume(newValue)
                    }
                ), in: 0...10, step: 1)
                .disabled(viewModel.isMuted)
            }

            Button {
                viewModel.play()
            } label: {
                Text("Play")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

@Observable
class ControlPanelViewModelImperative {
    // MARK: UI State
    private(set) var audio: String = ""
    private(set) var isMuted: Bool = false
    private(set) var volume: Double = 5.0

    // MARK: Imperative intents
    func setMuted(_ newValue: Bool) {
        isMuted = newValue
    }

    func setVolume(_ newValue: Double) {
        volume = Double(Int(newValue.rounded()))
    }

    func play() {
        guard !isMuted else {
            audio = ""
            return
        }
        let exclamations = String(repeating: "!", count: max(0, Int(volume)))
        audio = "Ding" + exclamations
    }
}

#Preview {
    ControlPanelViewImperative()
}
