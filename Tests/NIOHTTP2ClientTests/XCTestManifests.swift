import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swift_nio_http2_clientTests.allTests),
    ]
}
#endif
