import SwiftUI

public struct BottomSheet<Content: View>: View {
    @Binding var isShowingSheet: Bool

    /// Determines whether the line at the top of the sheet should be shown.
    let showHandleBar: Bool

    /// Determines whether the dismiss button at the bottom of the sheet should be shown.
    let showDismissButton: Bool

    /// Determines whether the sheet should have rounded corners at the top
    let showRoundedCorners: Bool

    /// Defines the text of the dismiss button.
    let dismissText: LocalizedStringKey

    /// Defines the content to be shown in the sheet.
    let content: Content

    @State private var currentPanningOffset: CGFloat = 0
    private let minimumPanningThreshold: CGFloat = 20

    public init(
        isShowingSheet: Binding<Bool>,
        showHandleBar: Bool = true,
        showDismissButton: Bool = true,
        showRoundedCorners: Bool = true,
        dismissText: LocalizedStringKey = "Dismiss",
        @ViewBuilder content: () -> Content
    ) {
        _isShowingSheet = isShowingSheet
        self.showHandleBar = showHandleBar
        self.showDismissButton = showDismissButton
        self.showRoundedCorners = showRoundedCorners
        self.dismissText = dismissText
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Color(UIColor.label)
                .opacity(0.3)
                .opacity(isShowingSheet ? 1 : 0)
                .animation(.easeIn)
                .onTapGesture {
                    dismiss()
                }
                .ignoresSafeArea()

            GeometryReader { geo in
                VStack {
                    Spacer()

                    VStack {
                        if showHandleBar {
                            Capsule()
                                .frame(width: 180, height: 6)
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                .padding(.top, 10)
                        }

                        content

                        if showDismissButton {
                            Button(action: dismiss) {
                                Text(dismissText)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(showRoundedCorners ? 40 : 0, corners: .top)
                    .animation(.easeInOut)
                    .offset(y: isShowingSheet ? 0 : geo.size.height)
                    .offset(y: currentPanningOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                currentPanningOffset = max(0, value.translation.height)
                            }
                            .onEnded { value in
                                if value.translation.height > minimumPanningThreshold {
                                    dismiss()
                                }
                                currentPanningOffset = 0
                            }
                    )
                }
            }
            .ignoresSafeArea()
        }
    }

    func dismiss() {
        isShowingSheet.toggle()
    }
}

extension UIRectCorner {
    static var top: UIRectCorner { [.topLeft, .topRight] }
    static var bottom: UIRectCorner { [.bottomLeft, .bottomRight] }
    static var left: UIRectCorner { [.topLeft, .bottomLeft] }
    static var right: UIRectCorner { [.topRight, .bottomRight] }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

