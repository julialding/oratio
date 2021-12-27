import SwiftUI

struct FlowView<Data, ID: Hashable, Content: View>: View {
    let data: [Data]
    let id: KeyPath<Data, ID>
    let onChangeHeight: () -> Void
    @ViewBuilder var content: (Data) -> Content
    @State private var totalHeight = CGFloat.zero // CGFloat.infinity   // << variant for VStack
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
                .overlay {
                    self.viewHeightReader(self.$totalHeight)
                }
        }
        .frame(height: self.totalHeight)
        .onChange(of: self.totalHeight) { _ in
            self.onChangeHeight()
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(data, id: id) { item in
                self.content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item[keyPath: id] == self.data.last![keyPath: id] {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item[keyPath: id] == self.data.last![keyPath: id] {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
