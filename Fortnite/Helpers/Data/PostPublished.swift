import Combine

@propertyWrapper
public class PostPublished<Value> {
    /// A `Publisher` that emits the new value of `wrappedValue` _after it was_ mutated (using `didSet` semantics).
    public let projectedValue: AnyPublisher<Value, Never>
    /// A `Publisher` that fires whenever `wrappedValue` _was_ mutated. To access the new value of `wrappedValue`, access `wrappedValue` directly, this `Publisher` only signals a change, it doesn't contain the changed value.
    public let valueDidChange: AnyPublisher<Void, Never>
    private let didChangeSubject: PassthroughSubject<Value, Never>
    public var wrappedValue: Value { didSet { didChangeSubject.send(wrappedValue) } }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        let didChangeSubject = PassthroughSubject<Value, Never>()
        self.didChangeSubject = didChangeSubject
        self.projectedValue = didChangeSubject.eraseToAnyPublisher()
        self.valueDidChange = didChangeSubject.voidPublisher()
    }
}

public extension Publisher {
    /// Maps the `Output` of its upstream to `Void` and type erases its upstream to `AnyPublisher`.
    func voidPublisher() -> AnyPublisher<Void, Failure> {
        map { _ in Void() }
        .eraseToAnyPublisher()
    }
}
