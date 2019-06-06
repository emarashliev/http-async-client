import XCTest
@testable import NIOHTTPClient

final class sNIOHTTPClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NIOHTTPClientTests().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
