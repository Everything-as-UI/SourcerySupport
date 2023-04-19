// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import TemplateEngine_Example

// MARK: - SomeProtocolMock

final class SomeProtocolMock: SomeProtocol {
    var invokedDoSomething: Bool = false
    var invokedDoSomethingCount: Int = 0
    func doSomething() {
        invokedDoSomething = true
        invokedDoSomethingCount += 1
    }
    var invokedDoSomething2: Bool = false
    var invokedDoSomething2Count: Int = 0
    var invokedDoSomething2Parameters: (String)?
    var invokedDoSomething2ParametersList = [(String)]()
    func doSomething2(arg1: String) {
        invokedDoSomething2 = true
        invokedDoSomething2Count += 1
        invokedDoSomething2Parameters = (arg1)
        invokedDoSomething2ParametersList += [(arg1)]
    }
    var invokedDoSomething3: Bool = false
    var invokedDoSomething3Count: Int = 0
    var invokedDoSomething3Parameters: (String)?
    var invokedDoSomething3ParametersList = [(String)]()
    var shouldInvokeDoSomething3Completion = false
    func doSomething3(arg1: String, completion: () -> Void) {
        invokedDoSomething3 = true
        invokedDoSomething3Count += 1
        invokedDoSomething3Parameters = (arg1)
        invokedDoSomething3ParametersList += [(arg1)]
        if shouldInvokeDoSomething3Completion { completion() }
    }
    var invokedDoSomething4: Bool = false
    var invokedDoSomething4Count: Int = 0
    var invokedDoSomething4Parameters: (arg1: String, argTwo: Int)?
    var invokedDoSomething4ParametersList = [(arg1: String, argTwo: Int)]()
    var shouldInvokeDoSomething4Completion = false
    var stubbedDoSomething4Result: Bool!
    func doSomething4(arg1: String, argTwo: Int, completion: @escaping () -> Void) -> Bool {
        invokedDoSomething4 = true
        invokedDoSomething4Count += 1
        invokedDoSomething4Parameters = (arg1, argTwo)
        invokedDoSomething4ParametersList += [(arg1, argTwo)]
        if shouldInvokeDoSomething4Completion { completion() }
        return stubbedDoSomething4Result
    }
}
