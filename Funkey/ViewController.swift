import UIKit

public struct ViewControllerState: Printable {
    public let cells: [TableViewCellState]
    
    public var description: String {
        return cells.description
    }
}

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var state: ViewControllerState! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        state = randomViewControllerState()
    }
    
    @IBAction func update(sender: NSObject) {
        let newState = randomViewControllerState()
        setup(newState, animated: true)
    }
}

//////////////// MARK: Table View

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(state.cells)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
            -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as TableViewCell
        cell.setup(state.cells[indexPath.row], animated: false)
        return cell
    }
}

////////////////// MARK: Animatable

extension ViewController: Animatable {
    typealias State = ViewControllerState
    
    func setup(state: State, animated: Bool) {
        animated ? setupAnimated(state) : setupImmediately(state)
    }
    
    func setupImmediately(state: State) {
        self.state = state
        tableView.reloadData()
    }
    
    func setupAnimated(state: State) {
        let diff = differenceBetween(oldArray: self.state.cells, andNewArray: state.cells)
        self.state = state
        tableView.beginUpdates()
        for change in diff {
            switch change {
            case .Deletion(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Insertion(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case let .Move(oldIndexPath, newIndexPath):
                tableView.moveRowAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
            case .Update(let indexPath):
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                if let c = cell as? TableViewCell {
                    c.setup(state.cells[indexPath.row], animated: true)
                }
            }
            
        }
        tableView.endUpdates()
    }
}

////////////////// MARK: Misc

public func randomViewControllerState(minCount: Int = 7,
                                      maxCount: Int = 10) -> ViewControllerState {
    assert(maxCount >= minCount)
    
    // Creating cells
    let count = minCount + Int(rand() % (maxCount - minCount + 1))
    var cells = [TableViewCellState]()
    for i in 0..<count {
        var offset: CGFloat = (rand() % 2) > 0 ? 10 : 286
        let h: CGFloat = (1.0 / CGFloat(maxCount) * CGFloat(i))
        let color = UIColor(hue: h, saturation: 0.7, brightness: 1, alpha: 1)
        cells.append(TableViewCellState(identifier: i,
                                        subviewOffset: offset,
                                        backgroundColor: color))
    }
    
    // Shuffle
    for i in 0..<count {
        if rand() % 10 == 0 {
            let i2 = Int(UInt(rand()) % UInt(count))
            let a = cells[i]
            cells[i] = cells[i2]
            cells[i2] = a
        }
    }
    return ViewControllerState(cells: cells)
}
