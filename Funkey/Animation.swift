protocol Animatable {
    typealias State
    
    func setup(state: State, animated:Bool)
}
