import XCTest
@testable import example

final class exampleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(example().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
