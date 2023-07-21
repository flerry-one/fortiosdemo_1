import UIKit

class Atributted {
    
    struct AtributtedMultiString {
        let text: String
        let font: UIFont
        let color: UIColor
        var strike: Bool = false
        var underLine: Bool = false
    }
    
    static func withParagraphStyle(text: String, lineHeight: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineHeightMultiple = lineHeight
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    static func withStrikethroughStyle(text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
    }
    
    static func multiString(strings: [AtributtedMultiString], lineHeight: CGFloat = 1 , aligment: NSTextAlignment) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        paragraphStyle.lineHeightMultiple = lineHeight
        
        var stringResult = ""
        
        var ranges: [NSRange] = []
        var location = 0
        for string in strings {
            stringResult += string.text
            let length = string.text.count
            let range = NSRange(location: location, length: length)
            ranges.append(range)
            location += length
        }
        
        let attributedString = NSMutableAttributedString(string: stringResult)
        
        for (index, string) in strings.enumerated() {
            let nsRange = ranges[index]

            attributedString.addAttributes([
                .font: string.font,
                .foregroundColor: string.color,
                .strikethroughStyle: string.strike ? NSUnderlineStyle.single.rawValue : .zero,
                .paragraphStyle: paragraphStyle,
                .underlineStyle: string.underLine ? NSUnderlineStyle.single.rawValue : ""
            ], range: nsRange)
        }
        
        return attributedString
    }
    
}
