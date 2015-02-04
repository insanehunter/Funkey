protocol UIElementState: Equatable {
    typealias Difference
    
    func differenceFrom(state: Self) -> Difference
}

protocol UIElement {
    typealias State: UIElementState
    
    func reset(state: State)
    func update(toState state: State, difference: State.Difference)
}
