import UIKit

struct TableViewCellState: Printable {
    let identifier: Int
    let subviewOffset: CGFloat
    let backgroundColor: UIColor
    
    var description: String {
        return "(offset: \(subviewOffset), color: \(backgroundColor))"
    }
}

class TableViewCell: UITableViewCell {
    @IBOutlet var subview: UIView!
    @IBOutlet var offset: NSLayoutConstraint!
    
    func setup(state: TableViewCellState) {
        offset.constant = state.subviewOffset
        contentView.backgroundColor = state.backgroundColor
    }
}
