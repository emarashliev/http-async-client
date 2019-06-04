import XCTest
@testable import swift_nio_http2_client

final class swift_nio_http2_clientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_nio_http2_client().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
