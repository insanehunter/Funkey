import UIKit

struct ViewControllerState: Printable {
    let cells: [TableViewCellState]
    
    var description: String {
        return cells.description
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var state: ViewControllerState! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        state = randomViewControllerState()
    }
    
    @IBAction func update(sender: NSObject) {
        state = randomViewControllerState()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(state.cells)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
            -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as TableViewCell
        cell.setup(state.cells[indexPath.row])
        return cell
    }
}


//////////////////////////// MARK: Generating random state


func randomViewControllerState() -> ViewControllerState {
    let MAX_COUNT = 7
    let MIN_COUNT = 3
    
    // Creating cells
    let count = MIN_COUNT + Int(arc4random_uniform(MAX_COUNT - MIN_COUNT + 1))
    var cells = [TableViewCellState]()
    for i in 0..<count {
        var offset: CGFloat = (arc4random() % 2) > 0 ? 10 : 100
        let h: CGFloat = (1.0 / CGFloat(MAX_COUNT) * CGFloat(i))
        let color = UIColor(hue: h, saturation: 0.7, brightness: 1, alpha: 1)
        cells.append(TableViewCellState(identifier: i,
                                        subviewOffset: offset,
                                        backgroundColor: color))
    }
    
    // Shuffle
    for i in 0..<count {
        if arc4random() % 3 == 0 {
            let i2 = Int(UInt(arc4random()) % UInt(count))
            let a = cells[i]
            cells[i] = cells[i2]
            cells[i2] = a
        }
    }
    return ViewControllerState(cells: cells)
}
