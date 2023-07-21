import UIKit

class TappableTextView: BaseView {
    
    struct Content {
        let text: String
        let payload: Any
    }
    
    var links: [Content]
    
    var atributtedString: NSAttributedString {
        didSet {
            textView.attributedText = atributtedString
            layoutIfNeeded()
        }
    }
    
    var tapped: ((Any?) -> Void)?
    
    private lazy var textView: UITextView = {
        $0.isEditable = false
        $0.isSelectable = false
        $0.isScrollEnabled = false
        $0.attributedText = atributtedString
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.textContainer.lineFragmentPadding = CGFloat(0.0)
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .clear
        return $0
    }(UITextView())
    
    override func setupAppearence() {
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        if links.isEmpty {
            tapped?(nil)
            return
        }

        let textView = sender.view as! UITextView
        let tapLocation = sender.location(in: textView)
        if let textPosition = textView.closestPosition(to: tapLocation) {
            if let tappedWordRange = textView.tokenizer.rangeEnclosingPosition(textPosition, with: UITextGranularity.word, inDirection: .layout(.left)) {
                
                var result: [(Content, [NSRange])] = .init()
                var link: Content?
                
                for link in links {
                    let ranges = rangesOfPhrase(link.text, inText: atributtedString.string)
                    result.append((link, ranges))
                }
                 
                for item in result {
                    
                    let ranges = item.1
                    
                    for range in ranges {
                        let value = textRange(tappedWordRange, isContainedIn: range, in: textView)
                        if value {
                            link = item.0
                        }
                    }
                    
                }
                
                tapped?(link?.payload)
            } else {
                tapped?(nil)
            }
        }
    }
    
    private func rangesOfPhrase(_ phrase: String, inText: String) -> [NSRange] {
        let nsText = inText.lowercased() as NSString
        let range = NSMakeRange(0, nsText.length)
        var ranges = [NSRange]()

        var rangeLocation = range.location
        while rangeLocation < range.length {
            let foundRange = nsText.range(of: phrase.lowercased(), options: [], range: NSMakeRange(rangeLocation, range.length - rangeLocation))
            if foundRange.location == NSNotFound {
                break
            }
            ranges.append(foundRange)
            rangeLocation = foundRange.location + foundRange.length
        }
        return ranges
    }
    
    private func textRange(_ range: UITextRange, isContainedIn nsRange: NSRange, in textView: UITextView) -> Bool {
        if let startIndex = textView.position(from: range.start, offset: 0),
            let endIndex = textView.position(from: range.end, offset: 0),
            let selectedRange = textView.textRange(from: startIndex, to: endIndex) {
                let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                let length = textView.offset(from: selectedRange.start, to: selectedRange.end)
                let matchRange = NSMakeRange(location, length)
                return NSIntersectionRange(matchRange, nsRange).length != 0
        }
        return false
    }

    init(atributtedString: NSAttributedString, links: [Content]) {
        self.atributtedString = atributtedString
        self.links = links
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
}
