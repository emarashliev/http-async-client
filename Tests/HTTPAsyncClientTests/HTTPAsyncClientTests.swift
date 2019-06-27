import XCTest
@testable import HTTPAsyncClient

final class HTTPAsyncClientTests: XCTestCase {
    var text: String {
        return "Hello, World!"
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
