import XCTest
@testable import TemplateEngine_Example

final class TemplateEngine_ExampleTests: XCTestCase {
    var mock: SomeProtocolMock! = SomeProtocolMock()

    func testMock() throws {
        mock.doSomething()

        XCTAssertTrue(mock.invokedDoSomething)
        XCTAssertEqual(mock.invokedDoSomethingCount, 1)

        mock.doSomething2(arg1: "doSomething2_string_arg")

        XCTAssertTrue(mock.invokedDoSomething2)
        XCTAssertEqual(mock.invokedDoSomething2Count, 1)
        XCTAssertEqual(mock.invokedDoSomething2Parameters, "doSomething2_string_arg")
        XCTAssertEqual(mock.invokedDoSomething2ParametersList, ["doSomething2_string_arg"])

        var doSomething3CompletionCalled = false
        mock.shouldInvokeDoSomething3Completion = true
        mock.doSomething3(arg1: "doSomething3_string_arg") {
            doSomething3CompletionCalled = true
        }

        XCTAssertTrue(mock.invokedDoSomething3)
        XCTAssertEqual(mock.invokedDoSomething3Count, 1)
        XCTAssertEqual(mock.invokedDoSomething3Parameters, "doSomething3_string_arg")
        XCTAssertEqual(mock.invokedDoSomething3ParametersList, ["doSomething3_string_arg"])
        XCTAssertTrue(doSomething3CompletionCalled)

        var doSomething4CompletionCalled = false
        mock.shouldInvokeDoSomething4Completion = true
        mock.stubbedDoSomething4Result = true
        let doSomething4Result = mock.doSomething4(arg1: "doSomething4_string_arg", argTwo: 5) {
            doSomething4CompletionCalled = true
        }

        XCTAssertTrue(mock.invokedDoSomething4)
        XCTAssertEqual(mock.invokedDoSomething4Count, 1)
        let doSomething4Parameters = mock.invokedDoSomething4Parameters
        XCTAssertEqual(doSomething4Parameters?.arg1, "doSomething4_string_arg")
        XCTAssertEqual(doSomething4Parameters?.argTwo, 5)
        let doSomething4ParametersList = mock.invokedDoSomething4ParametersList
        XCTAssertEqual(doSomething4ParametersList.first?.arg1, "doSomething4_string_arg")
        XCTAssertEqual(doSomething4ParametersList.first?.argTwo, 5)
        XCTAssertTrue(doSomething4CompletionCalled)
        XCTAssertTrue(doSomething4Result)
    }
}
