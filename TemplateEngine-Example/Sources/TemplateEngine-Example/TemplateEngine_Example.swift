
// sourcery: AutoMockable
protocol SomeProtocol {
    func doSomething()
    func doSomething2(arg1: String)
    func doSomething3(arg1: String, completion: () -> Void)
    func doSomething4(arg1: String, argTwo: Int, completion: @escaping () -> Void) -> Bool
}
