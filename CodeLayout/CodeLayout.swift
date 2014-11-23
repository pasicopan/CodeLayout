import Foundation
import UIKit

/**
CodeLayout, used to autolayout in code. It is a layout engine, which can express complicated layout

Features:

The layout of one element can be calculated by: 
*/

public class BaseOperation {
    public func calculate(node: Node) -> (value: CGFloat?, error: NSString?) {
        return (nil, "Base operation")
    }
}

public class Value: BaseOperation {
    var value: CGFloat
    
    public init(_ value: CGFloat){
        self.value = value
    }
    
    public override func calculate(node: Node) -> (value: CGFloat?, error: NSString?) {
        return (self.value, nil)
    }
}

public enum ValueType: Int {
    case Left, Right, Width, HCenter, Top, Bottom, Height, VCenter
}

public class NodeOperation: BaseOperation {
    var type: ValueType
    
    public init(_ type: ValueType){
        self.type = type
    }
    
    public override func calculate(node: Node) -> (value: CGFloat?, error: NSString?) {
        
        let result = self.getNode(node)
        if let n = result.node {
            switch self.type {
            case .Left:
                return (n.calculatedLeft, "Node left not calculated")
            case .Right:
                return (n.calculatedRight, "Node right not calculated")
            case .Width:
                return (n.calculatedWidth, "Node width not calculated")
            case .HCenter:
                return (n.calculatedHCenter, "Node horizental center not calculated")
            case .Top:
                return (n.calculatedTop, "Node top not calculated")
            case .Bottom:
                return (n.calculatedBottom, "Node bottom not calculated")
            case .Height:
                return (n.calculatedHeight, "Node height not calculated")
            case .VCenter:
                return (n.calculatedVCenter, "Node vertical center not calculated")
            }
        }
        else{
            return (nil, "There is no node for \(node) err: \(result.error)")
        }
    }
    
    func getNode(node: Node) -> (node: Node?, error: String?) {
        return (nil, "Get node in base class")
    }
}

public class Parent: NodeOperation {
    override func getNode(node: Node) -> (node: Node?, error: String?) {
        return (node.parent, "No Parent")
    }
}

public var ParentLeft = Parent(.Left)
public var ParentRight = Parent(.Right)
public var ParentWidth = Parent(.Width)
public var ParentHCenter = Parent(.HCenter)
public var ParentTop = Parent(.Top)
public var ParentBottom = Parent(.Bottom)
public var ParentHeight = Parent(.Height)
public var ParentVCenter = Parent(.VCenter)

public class Prev: NodeOperation {
    override func getNode(node: Node) -> (node: Node?, error: String?) {
        if let p = node.parent {
            return (p.prevNode(node), nil)
        }
        return (nil, "No Parent")
    }
}

public var PrevLeft = Prev(.Left)
public var PrevRight = Prev(.Right)
public var PrevWidth = Prev(.Width)
public var PrevHCenter = Prev(.HCenter)
public var PrevTop = Prev(.Top)
public var PrevBottom = Prev(.Bottom)
public var PrevHeight = Prev(.Height)
public var PrevVCenter = Prev(.VCenter)



public class Next: NodeOperation {
    override func getNode(node: Node) -> (node: Node?, error: String?) {
        if let p = node.parent {
            return (p.nextNode(node), nil)
        }
        return (nil, "No Parent")
    }
}

public var NextLeft = Next(.Left)
public var NextRight = Next(.Right)
public var NextWidth = Next(.Width)
public var NextHCenter = Next(.HCenter)
public var NextTop = Next(.Top)
public var NextBottom = Next(.Bottom)
public var NextHeight = Next(.Height)
public var NextVCenter = Next(.VCenter)


public class Me: NodeOperation {
    override func getNode(node: Node) -> (node: Node?, error: String?) {
        return (node, nil)
    }
}

public var MeLeft = Me(.Left)
public var MeRight = Me(.Right)
public var MeWidth = Me(.Width)
public var MeHCenter = Me(.HCenter)
public var MeTop = Me(.Top)
public var MeBottom = Me(.Bottom)
public var MeHeight = Me(.Height)
public var MeVCenter = Me(.VCenter)


public class BiOperantOperation: BaseOperation {
    var left: BaseOperation
    var right: BaseOperation
    
    public init(left: BaseOperation, right: BaseOperation){
        self.left = left
        self.right = right
    }
    
    public override func calculate(node: Node) -> (value: CGFloat?, error: NSString?) {
        var leftResult = left.calculate(node)
        if leftResult.value == nil {
            return (nil, "Left operant \(self.left) not calculated: \(leftResult.error)")
        }
        
        var rightResult = right.calculate(node)
        if rightResult.value == nil {
            return (nil, "Right operant \(self.right) not calculated: \(rightResult.error)")
        }
        
        return (self.doCalculate(left: leftResult.value!, right: rightResult.value!), nil)
    }
    
    public func doCalculate(#left:CGFloat, right: CGFloat) -> CGFloat {
        assert(false, "Should not call BiOperantOperation's doCalculate")
    }
}

public class Add: BiOperantOperation {
    public override func doCalculate(#left:CGFloat, right: CGFloat) -> CGFloat {
        return left + right
    }
}

public class Substract: BiOperantOperation {
    public override func doCalculate(#left: CGFloat, right: CGFloat) -> CGFloat {
        return left - right
    }
}

public class Multiply: BiOperantOperation {
    public override func doCalculate(#left: CGFloat, right: CGFloat) -> CGFloat {
        return left * right
    }
}

public class Divide: BiOperantOperation {
    public override func doCalculate(#left: CGFloat, right: CGFloat) -> CGFloat {
        return left / right
    }
}

public func + (left: BaseOperation, right: BaseOperation) -> BaseOperation {
    return Add(left: left, right: right)
}

public func + (left: BaseOperation, right: Int) -> BaseOperation {
    return Add(left: left, right: Value(CGFloat(right)))
}

public func + (left: BaseOperation, right: CGFloat) -> BaseOperation {
    return Add(left: left, right: Value(right))
}

public func - (left: BaseOperation, right: BaseOperation) -> BaseOperation {
    return Substract(left: left, right: right)
}

public func - (left: BaseOperation, right: Int) -> BaseOperation {
    return Substract(left: left, right: Value(CGFloat(right)))
}

public func * <T: BaseOperation>(left: T, right: T) -> BaseOperation {
    return Multiply(left: left, right: right)
}

public func * (left: BaseOperation, right: CGFloat) -> BaseOperation {
    return Multiply(left: left, right: Value(right))
}

public func / <T: BaseOperation>(left: T, right: T) -> BaseOperation {
    return Divide(left: left, right: right)
}

public class Max: BiOperantOperation {
    public override func doCalculate(#left: CGFloat, right: CGFloat) -> CGFloat {
        return max(left, right)
    }
}

public class Min: BiOperantOperation {
    public override func doCalculate(#left: CGFloat, right: CGFloat) -> CGFloat {
        return min(left, right)
    }
}

public class Node {
    var left: BaseOperation?
    var right: BaseOperation?
    var top: BaseOperation?
    var bottom: BaseOperation?
    var hcenter: BaseOperation?
    var vcenter: BaseOperation?
    var width: BaseOperation?
    var height: BaseOperation?
    
    public var calculatedLeft: CGFloat? {
        didSet {
            if calculatedHCenter != nil {
                if calculatedWidth == nil {
                    calculatedWidth = (calculatedHCenter! - calculatedLeft!) * 2
                }
                if calculatedRight == nil {
                    calculatedRight = calculatedLeft! + calculatedWidth!
                }
            }
            else if calculatedWidth != nil {
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedWidth! / 2 + calculatedLeft!
                }
                if calculatedRight == nil {
                    calculatedWidth = calculatedWidth! + calculatedLeft!
                }
            }
            else if calculatedRight != nil {
                if calculatedWidth == nil {
                    calculatedWidth = calculatedRight! - calculatedLeft!
                }
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedLeft! + calculatedWidth! / 2
                }
            }
        }
    }
    
    public var calculatedRight: CGFloat? {
        didSet {
            if calculatedRight == nil {
                return
            }
            
            if calculatedLeft != nil {
                if calculatedWidth == nil {
                    calculatedWidth = calculatedRight! - calculatedLeft!
                }
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedLeft! + calculatedWidth! / 2
                }
            }
            else if calculatedWidth != nil {
                if calculatedLeft == nil {
                    calculatedLeft = calculatedRight! - calculatedWidth!
                }
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedLeft! + calculatedWidth! / 2
                }
            }
            else if calculatedHCenter != nil {
                if calculatedWidth == nil {
                    calculatedWidth = (calculatedRight! - calculatedHCenter!) * 2
                }
                if calculatedLeft == nil {
                    calculatedLeft = calculatedRight! - calculatedWidth!
                }
            }
        }
    }
    
    public var calculatedWidth: CGFloat? {
        didSet {
            if calculatedWidth == nil {
                return
            }
            
            if calculatedLeft != nil {
                if calculatedRight == nil {
                    calculatedRight = calculatedWidth! + calculatedLeft!
                }
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedLeft! + calculatedWidth! / 2
                }
            }
            else if calculatedRight != nil {
                if calculatedLeft == nil {
                    calculatedLeft = calculatedRight! - calculatedWidth!
                }
                if calculatedHCenter == nil {
                    calculatedHCenter = calculatedLeft! + calculatedWidth! / 2
                }
            }
            else if calculatedHCenter != nil {
                if calculatedLeft == nil {
                    calculatedLeft = calculatedHCenter! - calculatedWidth! / 2
                }
                if calculatedRight == nil {
                    calculatedRight = calculatedWidth! + calculatedLeft!
                }
            }
        }
    }
    
    
    public var calculatedHCenter: CGFloat? {
        didSet {
            if calculatedHCenter == nil {
                return
            }
            
            if calculatedLeft != nil {
                if calculatedWidth == nil {
                    calculatedWidth = (calculatedHCenter! - calculatedLeft!) * 2
                }
                if calculatedRight == nil {
                    calculatedRight = calculatedLeft! + calculatedWidth!
                }
            }
            else if calculatedRight != nil {
                if calculatedWidth == nil {
                    calculatedWidth = (calculatedRight! - calculatedHCenter!) * 2
                }
                if calculatedLeft == nil {
                    calculatedLeft = calculatedRight! - calculatedWidth!
                }
            }
            else if calculatedWidth != nil {
                if calculatedLeft == nil {
                    calculatedLeft = calculatedHCenter! - calculatedWidth! / 2
                }
                if calculatedRight == nil {
                    calculatedRight = calculatedLeft! + calculatedWidth!
                }
            }
        }
    }
   
    public var calculatedTop: CGFloat? {
        didSet{
            if calculatedHeight != nil {
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
                if calculatedVCenter == nil {
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedBottom != nil {
                if calculatedHeight == nil {
                    calculatedHeight = calculatedBottom! - calculatedTop!
                }
                if calculatedVCenter == nil {
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedVCenter != nil {
                if calculatedHeight == nil {
                    calculatedHeight = (calculatedVCenter! - calculatedTop!) * 2
                }
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
            }
        }
    }
    
    public var calculatedBottom: CGFloat? {
        didSet{
            if calculatedTop != nil {
                if calculatedHeight == nil {
                    calculatedHeight = calculatedBottom! - calculatedTop!
                }
                if calculatedVCenter == nil {
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedHeight != nil {
                if calculatedTop == nil{
                    calculatedTop = calculatedBottom! - calculatedHeight!
                }
                if calculatedVCenter == nil{
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedVCenter != nil {
                if calculatedHeight == nil {
                    calculatedHeight = (calculatedBottom! - calculatedVCenter!) * 2
                }
                if calculatedTop == nil {
                    calculatedTop = calculatedBottom! - calculatedHeight!
                }
            }
        }
    }
    
    public var calculatedHeight: CGFloat? {
        didSet{
            if calculatedTop != nil {
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
                if calculatedVCenter == nil {
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedBottom != nil {
                if calculatedTop == nil {
                    calculatedTop = calculatedBottom! - calculatedHeight!
                }
                if calculatedVCenter == nil {
                    calculatedVCenter = calculatedTop! + calculatedHeight! / 2
                }
            }
            else if calculatedVCenter != nil {
                if calculatedTop == nil {
                    calculatedTop = calculatedVCenter! - calculatedHeight! / 2
                }
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
            }
        }
    }
    
    public var calculatedVCenter: CGFloat? {
        didSet{
            if calculatedTop != nil {
                if calculatedHeight == nil {
                    calculatedHeight = (calculatedVCenter! - calculatedTop!) * 2
                }
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
                
            }
            else if calculatedBottom != nil {
                if calculatedHeight == nil {
                    calculatedHeight = (calculatedBottom! - calculatedVCenter!) * 2
                }
                if calculatedTop == nil {
                    calculatedTop = calculatedBottom! - calculatedHeight!
                }
                
            }
            else if calculatedHeight != nil {
                if calculatedTop == nil {
                    calculatedTop = calculatedVCenter! - calculatedHeight! / 2
                }
                if calculatedBottom == nil {
                    calculatedBottom = calculatedTop! + calculatedHeight!
                }
            }
        }
    }
    
    var subNodes: [Node] = []
    weak var parent: Node?
    var view: UIView?
    
    public init(left: BaseOperation? = nil, right: BaseOperation? = nil,
        top: BaseOperation? = nil, bottom: BaseOperation? = nil,
        hcenter: BaseOperation? = nil, vcenter: BaseOperation? = nil,
        width: BaseOperation? = nil, height: BaseOperation? = nil,
        view: UIView? = nil){
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
            self.hcenter = hcenter
            self.vcenter = vcenter
            self.width = width
            self.height = height
            self.view = view
    }
    
    public func calculate() -> (needAnotherRound: Bool, errors: [String]){
        var needAnotherRound = false
        var errors: [String] = []
        
        for opitem in [
            (self.left, {self.calculatedLeft = $0}),
            (self.right, {self.calculatedRight = $0}),
            (self.width, {self.calculatedWidth = $0}),
            (self.hcenter, {self.calculatedHCenter = $0}),
            (self.top, {self.calculatedTop = $0}),
            (self.bottom, {self.calculatedBottom = $0}),
            (self.height, {self.calculatedHeight = $0}),
            (self.vcenter, {self.calculatedVCenter = $0}),
            ] {
            if let v = opitem.0 {
                var result = v.calculate(self)
                if result.value != nil {
                    opitem.1(result.value!)
                }
                else{
                    needAnotherRound = true
                    errors.append(result.error!)
                }
            }
        }
        
        for subNode in subNodes {
            let result = subNode.calculate()
            if result.needAnotherRound {
                needAnotherRound = true
                for e in result.errors {
                    errors.append(e)
                }
            }
        }
        
        return (needAnotherRound, errors)
    }
    
    public func calculateWithRound(_ round: Int = 3) -> (complete: Bool, errors: [String]){
        var result = self.calculate()
        for _ in 1..<round {
            if result.needAnotherRound {
                result = self.calculate()
            }
        }
    
        if result.needAnotherRound {
            return (false, result.errors)
        }
        else{
            return (true, [])
        }
    }
    
    public func addSubNode(node: Node){
        self.subNodes.append(node)
        node.parent = self
    }
    
    public func indexOfNode(node: Node) -> Int? {
        for (index, item) in enumerate(self.subNodes) {
            if item === node {
                return index
            }
        }
        return nil
    }
    
    public func nextNode(node: Node) -> Node? {
        if let index = self.indexOfNode(node) {
            if index + 1 < self.subNodes.count {
                return self.subNodes[index + 1]
            }
        }
        return nil
    }
    
    public func prevNode(node: Node) -> Node? {
        if let index = self.indexOfNode(node) {
            if index > 0 {
                return self.subNodes[index - 1]
            }
        }
        return nil
    }
    
    public func setupViewTreeInto(rootView: UIView){
        var rootViewForSubNode = rootView
        if let view = self.view {
            rootView.addSubview(view)
            rootViewForSubNode = view
        }
        
        for subNode in self.subNodes {
            subNode.setupViewTreeInto(rootViewForSubNode)
        }
    }
    
    public func setViewFrame(){
        // The method should be called after setupViewTreeInto and calculateWithRound
        if self.calculatedLeft == nil || self.calculatedTop == nil || self.calculatedWidth == nil || self.calculatedHeight == nil {
            assert(false, "The node layout not calculated")
        }
        
        if let view = self.view {
            let x = self.calculatedLeft!, y = self.calculatedTop!, width = self.calculatedWidth!, height = self.calculatedHeight!
            let resultFrame = CGRectMake(x, y, width, height)
            if !CGRectEqualToRect(view.frame, resultFrame) {
                view.frame = resultFrame
            }
        }
        
        for subNode in self.subNodes {
            subNode.setViewFrame()
        }
    }
}