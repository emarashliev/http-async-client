import XCTest

import swift_nio_http2_clientTests

var tests = [XCTestCaseEntry]()
tests += swift_nio_http2_clientTests.allTests()
XCTMain(tests)
