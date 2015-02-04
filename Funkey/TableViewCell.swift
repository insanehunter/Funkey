import UIKit

public struct TableViewCellState: UIElementState {
    public let identifier: Int
    public let subviewOffset: CGFloat
    public let backgroundColor: UIColor
    
    typealias Difference = TableViewCellState
    func differenceFrom(state: TableViewCellState) -> Difference {
        return (identifier == state.identifier &&
                subviewOffset == state.subviewOffset &&
                backgroundColor == state.backgroundColor) ? self : state;
    }
}

class TableViewCell: UITableViewCell {
    @IBOutlet var subview: UIView!
    @IBOutlet var offset: NSLayoutConstraint!
}

////////////// MARK: Animatable

extension TableViewCell: UIElement {
    typealias State = TableViewCellState
    
    func reset(state: State) {
        offset.constant = state.subviewOffset
        contentView.backgroundColor = state.backgroundColor
    }
    
    func update(toState state: State, difference: State.Difference) {
        self.contentView.layoutIfNeeded()
        UIView.animateWithDuration(0.5, delay: 0, options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.offset.constant = difference.subviewOffset
                self.contentView.backgroundColor = difference.backgroundColor
                self.contentView.layoutIfNeeded()
            }, completion: nil)
    }
}

////////////// MARK: Equatable

extension TableViewCellState: Equatable {}
public func ==(a: TableViewCellState, b: TableViewCellState) -> Bool {
    return a.identifier == b.identifier
}

////////////// MARK: Printable

extension TableViewCellState: Printable {
    public var description: String {
        return "(cell: \(identifier), offset: \(subviewOffset), color: \(backgroundColor))"
    }
}
