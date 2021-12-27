import SwiftUI

struct MicButton: View {
    @Binding var isActive: Bool

    @ScaledMetric var iconSize: CGFloat = 40

    var body: some View {
        Button(action: { self.isActive.toggle() }) {
            Image(systemName: self.isActive ? "stop" : "mic")
                .resizable()
                .scaledToFit()
                .frame(width: self.iconSize, height: self.iconSize)
        }
        .symbolVariant(.fill)
    }
}
