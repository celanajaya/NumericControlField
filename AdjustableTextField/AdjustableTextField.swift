
import Cocoa

class AdjustableTextField: NSTextField, NSTextViewDelegate {

/* -Event Handlers -
     I wrote both a closure and a protocol that could handle the drag event.
     Do we want to pick one? or keep both and let the developer choose?
 */
    var onValueChangedHandler: ((Int) -> ())?
    weak var adjustableTextFieldDelegate: AdjustableTextFieldDelegate?
    
    private var currentValue = 0
    private var dragDiff: CGFloat = 0.0

    private lazy var customCursor: NSCursor = {
        let image = NSImage(size: NSMakeSize(16, 16))
        image.lockFocus()
        NSColor.white.set()
        NSBezierPath(rect: NSMakeRect(0, 12, 10, 4)).fill()
        NSColor.black.set()
        NSBezierPath(rect: NSMakeRect(1, 13, 8, 2)).fill()
        image.unlockFocus()
        return NSCursor(image: image, hotSpot: NSZeroPoint)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        isEditable = false
    }

    override func mouseDown(with event: NSEvent) {
        if !isEnabled {
            return
        }
        if event.clickCount == 2 {
            refusesFirstResponder = false
            isEditable = true
            isSelectable = true
            selectText(stringValue)
            return
        }
        refusesFirstResponder = true
        isEditable = false

        if let range = currentEditor()?.selectedRange {
            currentEditor()?.selectedRange = NSRange(location: range.length, length: 0)
        }
        window?.makeFirstResponder(superview)
        dragDiff = 0
        if let newValue = Int(stringValue) {
            currentValue = newValue
        }

        // change mouse cursor image to custom image
        customCursor.set()
    }

    override func mouseUp(with event: NSEvent) {
        // restore mouse cursor
        NSCursor.arrow().set()
    }

    override func mouseDragged(with event: NSEvent) {
        if !isEnabled {
            return
        }
        customCursor.set()
        dragDiff += event.deltaY
        let newValue = currentValue - Int(dragDiff)
        
        stringValue = "\(newValue)"
        
        //MARK: Closure style event handler
        onValueChangedHandler?(newValue)
        
        //MARK: Delegate style event handler
        adjustableTextFieldDelegate?.onValueChanged(newValue)
    }
    

}

protocol AdjustableTextFieldDelegate: class {
    func onValueChanged(_ newValue: Int)
}
