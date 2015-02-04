import UIKit

public struct ViewControllerState: UIElementState {
    typealias Difference = [ArrayDifferenceOperation<TableViewCellState>]
    
    public let cells: [TableViewCellState]
    
    func differenceFrom(state: ViewControllerState) -> Difference {
        return differenceBetween(oldArray: state.cells, andNewArray: self.cells)
    }
}

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var state: ViewControllerState! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        state = randomViewControllerState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.speed = 0.5
    }
    
    @IBAction func update(sender: NSObject) {
        let newState = randomViewControllerState()
        update(toState: newState, difference: newState.differenceFrom(state))
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
        cell.reset(state.cells[indexPath.row])
        return cell
    }
}

////////////////// MARK: Animatable

extension ViewController: UIElement {
    typealias State = ViewControllerState
    
    func reset(state: State) {
        self.state = state
        tableView.reloadData()
    }
    
    func update(toState state: State, difference: State.Difference) {
        let oldState = self.state
        self.state = state
        tableView.beginUpdates()
        for change in difference {
            switch change {
            case .Deletion(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            case .Insertion(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            case let .Move(oldIndexPath, newIndexPath):
                tableView.moveRowAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                
            case .Update(let indexPath):
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                if let c = cell as? TableViewCell {
                    let oldCellState = oldState.cells[indexPath.row]
                    let newCellState = state.cells[indexPath.row]
                    c.update(toState: newCellState,
                             difference: newCellState.differenceFrom(oldCellState))
                }
            }
            
        }
        tableView.endUpdates()
    }
}

////////////////// MARK: Misc

extension ViewControllerState: Equatable {}
public func ==(a: ViewControllerState, b: ViewControllerState) -> Bool {
    return false
}

extension ViewControllerState: Printable {
    public var description: String {
        return cells.description
    }
}

public func randomViewControllerState(minCount: Int = 17,
                                      maxCount: Int = 20) -> ViewControllerState {
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
        if rand() % 30 == 0 {
            let i2 = Int(UInt(rand()) % UInt(count))
            let a = cells[i]
            cells[i] = cells[i2]
            cells[i2] = a
        }
    }
    return ViewControllerState(cells: cells)
}
