import XCTest

import NIOHTTPClientTests

var tests = [XCTestCaseEntry]()
tests += NIOHTTPClientTests.allTests()
XCTMain(tests)
