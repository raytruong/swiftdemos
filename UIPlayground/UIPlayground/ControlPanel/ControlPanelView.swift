import CombineExt
import Combine
import SwiftUI

struct ControlPanelView: View {
    @State private var viewModel = ControlPanelViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.audio)
                .font(.largeTitle)
                .frame(minHeight: 100)

            Toggle(
                isOn: Binding(
                    get: {
                        viewModel.isMuted
                    },
                    set: { newValue in
                        viewModel.didTapToggle.send(newValue)
                    }
                )
            ) {
                Label(
                    "Silent Mode",
                    systemImage: viewModel.isMuted ? "bell.slash.fill" : "bell.fill"
                )
            }
            .toggleStyle(.switch)

            VStack(alignment: .leading, spacing: 8) {
                Text("Volume: \(viewModel.volume)")
                Slider(
                    value: Binding(
                        get: { viewModel.volume },
                        set: { newValue in
                            viewModel.didMoveSlider.send(newValue)
                        }
                    ),
                    in: 0...10, step: 1
                )
                .disabled(viewModel.isMuted)
            }

            Button (
                action: {
                    viewModel.didTapPlay.send()
                },
                label: {
                    Text("Play")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear { viewModel.setup() }
    }
}

@Observable
class ControlPanelViewModel {
    // MARK: View events
    let didTapPlay: PassthroughSubject<Void, Never> = .init()
    let didTapToggle: PassthroughSubject<Bool, Never> = .init()
    let didMoveSlider: PassthroughSubject<Double, Never> = .init()

    // MARK: UI State
    private(set) var audio: String = ""
    private(set) var isMuted: Bool = false
    private(set) var volume: Double = 5.0

    private var cancellables = Set<AnyCancellable>()

    func setup() {
        // MARK: Transforms

        let toggleValue = didTapToggle
            .prepend(isMuted)
            .removeDuplicates()

        let sliderValue = didMoveSlider
            .prepend(volume)
            .removeDuplicates()

        let isMuted = toggleValue

        let volume = sliderValue

        let shouldPlaySound = didTapPlay
            .withLatestFrom(isMuted, volume)
            .map { (isMuted, volume) -> Int? in
                guard !isMuted else { return nil }
                return Int(volume.rounded())
            }

        // MARK: Side effects

        toggleValue
            .sink { [weak self] value in
                guard let self else { return }
                self.isMuted = value
            }
            .store(in: &cancellables)

        sliderValue
            .map { Double($0.rounded()) }
            .sink { [weak self] value in
                guard let self else { return }
                self.volume = value
            }
            .store(in: &cancellables)

        shouldPlaySound
            .map { volume -> String in
                guard let volume else {
                    return ""
                }
                return "Ding" + String(repeating: "!", count: max(0, volume))
            }
            .sink { audio in
                self.audio = audio
            }
            .store(in: &cancellables)
    }
}

#Preview {
    ControlPanelView()
}
