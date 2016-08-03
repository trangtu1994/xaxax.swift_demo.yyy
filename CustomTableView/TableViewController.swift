import UIKit

//MARK : Controller
class TableViewController : UITableViewController {

    var labelContents = [String] ()
    var labelItems = [String] ()
    var nums = [1,2,3,4,5,3,2,1]
    var numOfRow = 0
    let identiferCell = "cellDemo"
    let numOfSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAutoHeightCell(estimatedRowHeight: 100)
        for i in 0...20 {
            labelContents.append("this is Item at \(i) is load")
            if i == 5 {
                labelItems.append("Address of item:")
            } else {
                labelItems.append("Address:")
            }
        }
            numOfRow = nums.count
    }
    
    private func tableViewAutoHeightCell(estimatedRowHeight cellHeight: CGFloat) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = cellHeight
    }
    
//MARK: DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numOfSection
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numOfRow == 0 {
            tableView.backgroundView =  dataNotfoundView
            return 0
        }
        return numOfRow
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("simple", forIndexPath: indexPath)
        (cell.viewWithTag(1) as! Rating).vote = nums[indexPath.row]
        (cell.viewWithTag(2) as! UILabel).text = labelItems[indexPath.row]

        return cell
    }
    
    private func createCellFromIdentifer (identifer: String, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer, forIndexPath: indexPath)
            return cell
    }
    
//MARK: Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print((cell?.viewWithTag(1) as! Rating).vote)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    var dataNotfoundView : UIView {
        let fullSize = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        let labelNotFound = UILabel()
        labelNotFound.text = "Data is not found"
//        labelNotFound.sizeToFit()
        labelNotFound.backgroundColor = UIColor.grayColor()
        labelNotFound.textColor = UIColor.redColor()
        labelNotFound.textAlignment = NSTextAlignment.Center
        labelNotFound.font = UIFont(name: "Arial-BoldMT", size: 30)
        return labelNotFound
    }
}


