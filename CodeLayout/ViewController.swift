import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var subview = UIView()
        subview.backgroundColor = UIColor.lightGrayColor()
        
        var subview2 = UIView()
        subview2.backgroundColor = UIColor.blackColor()
        
        var subview3 = UIView()
        subview3.backgroundColor = UIColor.grayColor()
        
        var rootNode = Node(
            left: Value(0), right: Value(300), top: Value(0), height: Value(500),
            view: subview)
        rootNode.addSubNode(
            Node(
                left: ParentWidth * 0.3, width: ParentWidth * 0.4 - 40,
                vcenter: ParentHeight * 0.5, height: Value(100),
                view: subview2))
        rootNode.addSubNode(
            Node(
                left: Value(0), top: PrevTop,
                width: PrevWidth * 2, height: Value(20),
                view: subview3))
        
        rootNode.setupViewTreeInto(self.view)
        rootNode.calculateWithRound()
        rootNode.setViewFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

