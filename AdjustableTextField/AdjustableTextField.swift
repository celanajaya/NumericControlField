
import Cocoa

class AdjustableTextField: NSTextField, NSTextViewDelegate {

    var valueChangedHandler: ((Double) -> ())?
    weak var adjustableTextFieldDelegate: AdjustableTextFieldDelegate?

    @IBInspectable var value: Double = 0 { // TODO: how do we get the default value to appear in the inspector in IB?
        didSet {
            if value > maxValue {
                value = maxValue
            }
            if value < minValue {
                value = minValue
            }
            stringValue = "\(value)"

            // MARK: Closure style event handler
            valueChangedHandler?(value)

            // MARK: Delegate style event handler
            adjustableTextFieldDelegate?.adjustableTextField(self, didChangeValue: value)
        }
    }
    @IBInspectable var maxValue: Double = 1
    @IBInspectable var minValue: Double = 0
    @IBInspectable var responsiveness: Double = 0.5

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

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isEditable = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isEditable = false
    }

    override func textDidEndEditing(_ notification: Notification) {
        if let dValue = Double(stringValue) {
            value = dValue
        }
    }

    // MARK: Mouse Events
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
        if let newValue = Double(stringValue) {
            value = newValue
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
        value -= Double(event.deltaY) * responsiveness
    }

    // MARK: NSTextViewDelegate Methods

    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        if let string = replacementString {
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return false
    }

}

protocol AdjustableTextFieldDelegate: class {
    func adjustableTextField(_ adjustableTextField: AdjustableTextField, didChangeValue newValue: Double)
}
