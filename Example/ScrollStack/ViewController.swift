//
//  ViewController.swift
//  ScrollStack
//
//  Created by cmc5788 on 01/05/2019.
//  Copyright (c) 2019 cmc5788. All rights reserved.
//

import UIKit
import SnapKit
import ScrollStack

/// Example ViewController
class ViewController: UIViewController {
    
    override func loadView() {
        self.view = PagesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupExample()
    }

    func setupExample() {
        
        // Add three horizontally scrollable pages ...
        
        for _ in 0 ... 2 {
            
            // In each page, add a combination of fixed size items
            // and self-sizing items, with and without constraints,
            // some of which use internally nested ScrollStackViews.
        
            let scrollStack = pages.addPage()
            
            for i in 0 ... 3 {
                
                scrollStack.pushItem(.init(UIView(), constraintWrapped: i % 2 == 0))
                { (item, v: UIView) in
                    v.backgroundColor = .random()
                    return item
                        .fixedSize(50)
                        .leading(16)
                        .trailing(16)
                }
            }
            
            for i in 0 ... 3 {
                
                if i % 2 == 0 {
                    scrollStack.pushItem(ScrollStackViewItem(FrameTestRow())
                        .leading(16).trailing(16))
                } else {
                    scrollStack.pushItem(ScrollStackViewItem(AutoLayoutTestRow())
                        .leading(16).trailing(16))
                }
            }
            
            for i in 0 ... 3 {
                
                scrollStack.pushItem(ScrollStackViewItem(Row(), constraintWrapped: i % 2 == 0)
                    .leading(16).trailing(16))
            }
            
            for i in 0 ... 3 {
                
                scrollStack.pushItem(.init(UIView(), constraintWrapped: i % 2 == 0))
                { (item, v: UIView) in
                    v.backgroundColor = .random()
                    return item
                        .fixedSize(50)
                        .leading(16)
                        .trailing(16)
                }
            }
        }
    }
}

/// Example ViewController's view
class PagesView: UIView {
    
    lazy var pages: Pages = {
        let pages = Pages()
        return pages
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.addSubview(pages)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        pages.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
}

/// A row that self-sizes and uses frame-based layout
class FrameTestRow: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.text = "Frame Test Row"
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .black
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: 48)
    }
    
    override func layoutSubviews() {
        label.frame = CGRect(x: 16, y: 0, width: self.bounds.width - 32, height: self.bounds.height)
    }
}

/// A row that self-sizes and uses autolayout
class AutoLayoutTestRow: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.text = "Autolayout Test Row"
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16).priority(999)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// ScrollStackView used as a set of horizontally scrollable pages
class Pages: ScrollStackView {
    
    private var _onEndScrolling: ((CGFloat, CGFloat) -> ())?
    override var onEndScrolling: ((CGFloat, CGFloat) -> ())? {
        get {
            return super.onEndScrolling
        }
        set {
            self._onEndScrolling = newValue
        }
    }
    
    private func handleEndScrolling(_ amount: CGFloat, _ percent: CGFloat) {
        let page = Int(floor(percent * CGFloat(pageCount - 1)))
        guard page != selectedPage else { return }
        selectedPage = page
        pageSelected(page)
    }
    
    private(set) public var selectedPage: Int = 0
    
    open func pageSelected(_ page: Int) {
        print("selected page \(page)")
    }
    
    private var _pages: [ScrollStackViewItem] = []
    
    public var pageCount: Int {
        return _pages.count
    }
    
    public func pageAt(_ i: Int) -> ScrollStackView {
        guard i >= 0, i < _pages.count else { fatalError("Index out of bounds.") }
        return _pages[i].view as! ScrollStackView
    }
    
    public func addPage() -> ScrollStackView {
        let stack = ScrollStackView(
            orientation: .vertical,
            scrollEnabled: true,
            selfSizePrimaryAxis: false,
            selfSizeAltAxis: false)
        let item = ScrollStackViewItem(stack)
            .percentSize(1)
            .altAxisMode(.fill)
        self.pushItem(item)
        _pages.append(item)
        return stack
    }
    
    init() {
        
        super.init(
            orientation: .horizontal,
            scrollEnabled: true,
            selfSizePrimaryAxis: false,
            selfSizeAltAxis: false)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        super.onEndScrolling = { [weak self] amount, percent in
            guard let self = self else { return }
            self.handleEndScrolling(amount, percent)
            self._onEndScrolling?(amount, percent)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// ScrollStackView used as a basic image/text cell layout
class Row: ScrollStackView {
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "icon_time").withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.black.withAlphaComponent(0.87)
        return image
    }()
    
    lazy var textColumn: ScrollStackView = {
        let column = ScrollStackView(
            orientation: .vertical,
            scrollEnabled: false,
            selfSizePrimaryAxis: true,
            selfSizeAltAxis: false)
        return column
    }()
    
    lazy var text1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.text = "Text goes here"
        return label
    }()
    
    lazy var text2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.text = "Text goes here"
        return label
    }()
    
    lazy var text3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.87)
        label.text = "Text goes here"
        return label
    }()
    
    lazy var arrow: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "icon_arrow_right").withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.black.withAlphaComponent(0.87)
        return image
    }()
    
    lazy var bottomDivider: UIView = {
        let div = UIView()
        div.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return div
    }()
    
    init() {
        super.init(
            orientation: .horizontal,
            scrollEnabled: false,
            selfSizePrimaryAxis: false,
            selfSizeAltAxis: true)
        
        var item: ScrollStackView.ScrollStackViewItem
        
        item = ScrollStackView.ScrollStackViewItem(image)
            .leading(12)
            .top(12)
            .bottom(12)
            .fixedSize(32)
            .altAxisMode(.fill)
        self.pushItem(item)
        
        item = ScrollStackView.ScrollStackViewItem(textColumn)
            .leading(12)
            .trailing(12)
            .top(12)
            .bottom(12)
            .weightedSize(1)
            .altAxisMode(.fit(nil, float: .begin))
        self.pushItem(item)
        
        textColumn.pushItem(.init(text1))
        textColumn.pushItem(.init(text2))
        textColumn.pushItem(.init(text3))
        
        item = ScrollStackView.ScrollStackViewItem(arrow)
            .trailing(12)
            .fixedSize(16)
            .altAxisMode(.fill)
        self.pushItem(item)
        
        self.addSubview(bottomDivider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomDivider.frame = CGRect(
            x: 0,
            y: self.bounds.height - 1,
            width: self.bounds.width,
            height: 1)
    }
}

// MARK: - Helpers

extension ViewController {
    
    var pages: Pages {
        return (self.view as! PagesView).pages
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
