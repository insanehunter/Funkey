import UIKit

public struct TableViewCellState {
    let identifier: Int
    let subviewOffset: CGFloat
    let backgroundColor: UIColor
}

class TableViewCell: UITableViewCell {
    @IBOutlet var subview: UIView!
    @IBOutlet var offset: NSLayoutConstraint!
}

////////////// MARK: Animatable

extension TableViewCell: Animatable {
    typealias State = TableViewCellState
    
    func setup(state: TableViewCellState, animated:Bool) {
        animated ? setupAnimated(state) : setupImmediately(state)
    }
    
    func setupAnimated(state: TableViewCellState) {
        self.contentView.layoutIfNeeded()
        UIView.animateWithDuration(0.5, delay: 0, options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.setupImmediately(state)
                self.contentView.layoutIfNeeded()
            }, completion: nil)
    }
    
    func setupImmediately(state: TableViewCellState) {
        offset.constant = state.subviewOffset
        contentView.backgroundColor = state.backgroundColor
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
