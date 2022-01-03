import XCTest
import SwiftUI
@testable import BottomSheet

final class BottomSheetTests: XCTestCase {
    func testDefaultValues() throws {
        let sut = BottomSheet(
            isShowingSheet: .constant(false)
        ) {
            Text("Hello World!")
        }

        XCTAssertFalse(sut.isShowingSheet)
        XCTAssertTrue(sut.showHandleBar)
        XCTAssertTrue(sut.showDismissButton)
        XCTAssertTrue(sut.showRoundedCorners)
        XCTAssertEqual(sut.dismissText, "Dismiss")
    }

    func testCustomValues() {
        let sut = BottomSheet(
            isShowingSheet: .constant(false),
            showHandleBar: false,
            showDismissButton: false,
            showRoundedCorners: false,
            dismissText: "Close"
        ) {
            Text("Hello World!")
        }

        XCTAssertFalse(sut.isShowingSheet)
        XCTAssertFalse(sut.showHandleBar)
        XCTAssertFalse(sut.showDismissButton)
        XCTAssertFalse(sut.showRoundedCorners)
        XCTAssertEqual(sut.dismissText, "Close")
    }

    func testPresentSheet() {
        var bindingValue = false
        let binding = Binding {
            bindingValue
        } set: {
            bindingValue = $0
        }

        let sut = BottomSheet(
            isShowingSheet: binding
        ) {
            Text("Hello World!")
        }

        sut.isShowingSheet.toggle()

        XCTAssertTrue(sut.isShowingSheet)
    }

    func testDismissSheet() {
        var bindingValue = true
        let binding = Binding {
            bindingValue
        } set: {
            bindingValue = $0
        }

        let sut = BottomSheet(
            isShowingSheet: binding
        ) {
            Text("Hello World!")
        }

        sut.dismiss()

        XCTAssertFalse(sut.isShowingSheet)
    }

    func testPresentAndDismissSheet() {
        var bindingValue = false
        let binding = Binding {
            bindingValue
        } set: {
            bindingValue = $0
        }

        let sut = BottomSheet(
            isShowingSheet: binding
        ) {
            Text("Hello World!")
        }

        sut.isShowingSheet.toggle()

        XCTAssertTrue(sut.isShowingSheet)

        sut.dismiss()

        XCTAssertFalse(sut.isShowingSheet)
    }
}
