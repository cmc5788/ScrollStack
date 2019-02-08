//
//  ScrollStackView.swift
//  ScrollStackView
//
//  Created by Christopher Casey on 1/5/19.
//

import UIKit

public typealias ScrollStackViewItem = ScrollStackView.ScrollStackViewItem

open class ScrollStackView: UIView {
    
    class ScrollStackViewScrollView: UIScrollView {
        
        fileprivate var _allowSetContentInsetAdjustmentBehavior: Bool = false
        
        @available(iOS 11.0, *)
        override var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
            get {
                return super.contentInsetAdjustmentBehavior
            }
            set {
                guard _allowSetContentInsetAdjustmentBehavior else {
                    fatalError("setting contentInsetAdjustmentBehavior not allowed. "
                        + "Use autoAdjustTopInset and autoAdjustBottomInset instead.")
                }
                super.contentInsetAdjustmentBehavior = .never
            }
        }
        
        fileprivate var _allowSetDelegate: Bool = false
        
        override var delegate: UIScrollViewDelegate? {
            get {
                return super.delegate
            }
            set {
                guard _allowSetDelegate else {
                    if delegate == nil { super.delegate = nil; return }
                    fatalError("setting custom UIScrollViewDelegate not currently allowed.")
                }
                super.delegate = newValue
            }
        }
    }
    
    public enum ScrollStackViewOrientation {
        case vertical
        case horizontal
    }
    
    public struct ScrollStackViewItem: Hashable {
        
        public enum AltAxisFloat: Hashable {
            case begin
            case middle
            case end
        }
        
        public enum AltAxisMode: Hashable {
            case fill
            case percent(CGFloat, float: AltAxisFloat)
            case fit(CGFloat?, float: AltAxisFloat)
        }
        
        public let view: UIView
        public let leading: CGFloat
        public let trailing: CGFloat
        public let top: CGFloat
        public let bottom: CGFloat
        public let fixedSize: CGFloat
        public let percentSize: CGFloat
        public let weightedSize: CGFloat?
        public let altAxisMode: AltAxisMode
        public let meta: AnyHashable?
        
        fileprivate var left: CGFloat {
            return UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .leftToRight
                ? leading
                : trailing
        }
        
        fileprivate var right: CGFloat {
            return UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .leftToRight
                ? trailing
                : leading
        }
        
        public init(_ view: UIView,
                    constraintWrapped: Bool = false,
                    leading: CGFloat = 0,
                    trailing: CGFloat = 0,
                    top: CGFloat = 0,
                    bottom: CGFloat = 0,
                    percentSize: CGFloat = -1,
                    fixedSize: CGFloat = -1,
                    weightedSize: CGFloat? = nil,
                    altAxisMode: AltAxisMode = .fill,
                    meta: AnyHashable? = nil) {
            
            if constraintWrapped {
                let wrapper = UIView()
                wrapper.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                let leadingConstraint = NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutConstraint.Attribute.leading,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: wrapper,
                    attribute: NSLayoutConstraint.Attribute.leading,
                    multiplier: 1,
                    constant: 0)
                let trailingConstraint = NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutConstraint.Attribute.trailing,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: wrapper,
                    attribute: NSLayoutConstraint.Attribute.trailing,
                    multiplier: 1,
                    constant: 0)
                let topConstraint = NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutConstraint.Attribute.top,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: wrapper,
                    attribute: NSLayoutConstraint.Attribute.top,
                    multiplier: 1,
                    constant: 0)
                let bottomConstraint = NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutConstraint.Attribute.bottom,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: wrapper,
                    attribute: NSLayoutConstraint.Attribute.bottom,
                    multiplier: 1,
                    constant: 0)
                wrapper.addConstraints([
                    leadingConstraint,
                    trailingConstraint,
                    topConstraint,
                    bottomConstraint
                    ])
                self.view = wrapper
            } else {
                self.view = view
            }
            
            self.leading = leading
            self.trailing = trailing
            self.top = top
            self.bottom = bottom
            self.percentSize = percentSize
            self.fixedSize = fixedSize
            self.weightedSize = weightedSize
            self.altAxisMode = altAxisMode
            self.meta = meta
            
            if percentSize > 1 {
                fatalError("percentSize > 1 not supported.")
            }
            
            if weightedSize != nil && weightedSize! < 0 {
                fatalError("weightedSize must be a positive number.")
            }
        }
        
        public func view(_ view: UIView) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func leading(_ leading: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func trailing(_ trailing: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func top(_ top: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func bottom(_ bottom: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func percentSize(_ percentSize: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func fixedSize(_ fixedSize: CGFloat) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func weightedSize(_ weightedSize: CGFloat?) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func altAxisMode(_ altAxisMode: AltAxisMode) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func meta(_ meta: AnyHashable?) -> ScrollStackViewItem {
            return ScrollStackViewItem(
                view,
                leading: leading,
                trailing: trailing,
                top: top,
                bottom: bottom,
                percentSize: percentSize,
                fixedSize: fixedSize,
                weightedSize: weightedSize,
                altAxisMode: altAxisMode,
                meta: meta)
        }
        
        public func config<V: UIView>(_ configFunc: (ScrollStackViewItem, V) -> ScrollStackViewItem) -> ScrollStackViewItem {
            return configFunc(self, self.view as! V)
        }
    }
    
    public let orientation: ScrollStackViewOrientation
    public let scrollEnabled: Bool
    public let selfSizePrimaryAxis: Bool
    public let selfSizeAltAxis: Bool
    
    private var lastScrollPercent: CGFloat = 0
    
    public var scrollPercent: CGFloat {
        let maxOffset: CGFloat = self.orientation == .vertical
            ? scrollView.contentSize.height - scrollView.frame.height
            : scrollView.contentSize.width - scrollView.frame.width
        let curOffset: CGFloat = self.orientation == .vertical
            ? scrollView.contentOffset.y
            : scrollView.contentOffset.x
        let pct = min(1, max(0, curOffset / maxOffset))
        return pct
    }
    
    private var lastScrollAmount: CGFloat = 0
    
    public var scrollAmount: CGFloat {
        let curOffset: CGFloat = self.orientation == .vertical
            ? scrollView.contentOffset.y
            : scrollView.contentOffset.x
        return curOffset
    }
    
    open var onScroll: ((_ amount: CGFloat, _ percent: CGFloat) -> ())? {
        didSet {
            guard scrollEnabled else { fatalError("May not set onScroll when scrollEnabled is false.") }
        }
    }
    
    open var onEndScrolling: ((_ amount: CGFloat, _ percent: CGFloat) -> ())? {
        didSet {
            guard scrollEnabled else { fatalError("May not set onEndScrolling when scrollEnabled is false.") }
        }
    }
    
    open var customSizingPolicy: ((ScrollStackViewItem) -> CGFloat?)?
    
    private var _items: [ScrollStackViewItem] = []
    public var items: [ScrollStackViewItem] {
        return _items
    }
    
    private lazy var _scrollView = ScrollStackViewScrollView()
    public var scrollView: UIScrollView {
        guard scrollEnabled else { fatalError("May not access scrollView when scrollEnabled is false.") }
        return _scrollView
    }
    
    private(set) public lazy var content = UIView()
    
    public var autoAdjustTopInset: Bool = true {
        didSet {
            if autoAdjustTopInset == oldValue { return }
            layoutDeferred()
        }
    }
    
    public var autoAdjustBottomInset: Bool = true {
        didSet {
            if autoAdjustBottomInset == oldValue { return }
            layoutDeferred()
        }
    }
    
    public init(orientation: ScrollStackViewOrientation = .vertical,
                scrollEnabled: Bool = true,
                selfSizePrimaryAxis: Bool = false,
                selfSizeAltAxis: Bool = false) {
        
        self.orientation = orientation
        self.scrollEnabled = scrollEnabled
        self.selfSizePrimaryAxis = selfSizePrimaryAxis
        self.selfSizeAltAxis = selfSizeAltAxis
        
        super.init(frame: .zero)
        
        if scrollEnabled {
            _scrollView._allowSetDelegate = true
            scrollView.delegate = self
            _scrollView._allowSetDelegate = false
            
            if #available(iOS 11.0, *) {
                _scrollView._allowSetContentInsetAdjustmentBehavior = true
                scrollView.contentInsetAdjustmentBehavior = .never
                _scrollView._allowSetContentInsetAdjustmentBehavior = false
            } else {
                fatalError("iOS 11.0+ required.")
            }
            
            self.addSubview(scrollView)
            scrollView.addSubview(content)
        } else {
            self.addSubview(content)
        }
        
        initSelfSizingConstraints()
    }
    
    private lazy var widthSelfSizer = UIView()
    private lazy var heightSelfSizer = UIView()
    
    private func initSelfSizingConstraints() {
        
        // Setting these constraints allows this frame-based layout hierarchy to cooperate nicely with autolayout
        // being used to lay this view out inside its superview. If we don't do this, in self-sizing mode, other
        // elements cannot be laid out relative this one using autolayout. This technique seems to work, but it
        // should be monitored closely for more weird issues or bugs... it took a lot of trial and error to arrive
        // at this as a nice "gap-bridger" between the frame world and the autolayout world.
        
        var makeWidthSelfSizer: Bool
        var makeHeightSelfSizer: Bool
        if orientation == .vertical {
            makeWidthSelfSizer = selfSizeAltAxis
            makeHeightSelfSizer = selfSizePrimaryAxis
        } else {
            makeWidthSelfSizer = selfSizePrimaryAxis
            makeHeightSelfSizer = selfSizeAltAxis
        }
        
        if makeWidthSelfSizer {
            self.addSubview(widthSelfSizer)
            widthSelfSizer.translatesAutoresizingMaskIntoConstraints = false
            let widthConstraint = NSLayoutConstraint(
                item: widthSelfSizer,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.content,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1,
                constant: 0)
            widthConstraint.priority = .init(999)
            let leftConstraint = NSLayoutConstraint(
                item: widthSelfSizer,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.left,
                multiplier: 1,
                constant: 0)
            leftConstraint.priority = .init(999)
            let rightConstraint = NSLayoutConstraint(
                item: widthSelfSizer,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.right,
                multiplier: 1,
                constant: 0)
            rightConstraint.priority = .init(999)
            self.addConstraints([
                widthConstraint,
                leftConstraint,
                rightConstraint
                ])
        }
        if makeHeightSelfSizer {
            self.addSubview(heightSelfSizer)
            heightSelfSizer.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = NSLayoutConstraint(
                item: heightSelfSizer,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self.content,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 1,
                constant: 0)
            heightConstraint.priority = .init(999)
            let topConstraint = NSLayoutConstraint(
                item: heightSelfSizer,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1,
                constant: 0)
            topConstraint.priority = .init(999)
            let bottomConstraint = NSLayoutConstraint(
                item: heightSelfSizer,
                attribute: NSLayoutConstraint.Attribute.bottom,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: self,
                attribute: NSLayoutConstraint.Attribute.bottom,
                multiplier: 1,
                constant: 0)
            bottomConstraint.priority = .init(999)
            self.addConstraints([
                heightConstraint,
                topConstraint,
                bottomConstraint
                ])
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var intrinsicContentSize: CGSize {
        return content.bounds.size
    }
    
    private var contentBoundsSize: CGSize? {
        didSet {
            if contentBoundsSize == oldValue { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if orientation == .vertical {
            layoutSubviewsVertically()
        } else {
            layoutSubviewsHorizontally()
        }
        
        self.contentBoundsSize = content.bounds.size
    }
    
    open func layoutSubviewsVertically() {
        
        let contentWidth: CGFloat = max(self.frame.width, self.bounds.width)
        
        let scrollHeight: CGFloat = selfSizePrimaryAxis ? 0 : max(self.frame.height, self.bounds.height)
        
        var contentHeight: CGFloat = 0
        
        var maxWidth: CGFloat = 0
        
        var containsWeights: Bool = false
        var emptySpaceHeight: CGFloat = 0
        var totalWeights: CGFloat = 0
        
        var cachedFitHeights: [ScrollStackViewItem:CGFloat] = [:]
        
        let calcHeights: (Bool) -> Void = { useWeights in
            
            if #available(iOS 11.0, *) {
                contentHeight = self.autoAdjustTopInset ? self.safeAreaInsets.top : 0
            } else {
                fatalError("iOS 11.0+ required.")
            }
            
            maxWidth = 0
            
            if self.selfSizeAltAxis {
                for item in self._items {
                    if self.selfSizeAltAxis, case let .fit(x, _) = item.altAxisMode {
                        let calcWidth = x ?? max(item.view.frame.width, item.view.bounds.width)
                        maxWidth = max(maxWidth, calcWidth + item.leading + item.trailing)
                    }
                }
            }
            
            for item in self._items {
                
                var calcHeight: CGFloat
                if useWeights, let weight = item.weightedSize {
                    if item.percentSize >= 0, item.percentSize <= 1 {
                        calcHeight = max(item.percentSize * scrollHeight, item.fixedSize, 0)
                    } else {
                        calcHeight = max(item.fixedSize, 0)
                    }
                    let normWeight: CGFloat = weight / totalWeights
                    calcHeight += emptySpaceHeight * normWeight
                } else {
                    if item.percentSize >= 0, item.percentSize <= 1 {
                        calcHeight = max(item.percentSize * scrollHeight, item.fixedSize, 0)
                    } else {
                        calcHeight = max(item.fixedSize, 0)
                    }
                    if item.weightedSize != nil {
                        containsWeights = true
                        calcHeight = max(calcHeight, 0)
                    }
                }
                
                let frameLeft: CGFloat
                let calcWidth: CGFloat
                let totalWidth: CGFloat = (self.selfSizeAltAxis ? maxWidth : contentWidth)
                    - item.leading - item.trailing
                let altAxisFloat: ScrollStackViewItem.AltAxisFloat
                switch item.altAxisMode {
                case .fill:
                    calcWidth = totalWidth
                    altAxisFloat = .begin
                    break
                case .percent(let x, let float):
                    calcWidth = x * totalWidth
                    altAxisFloat = float
                    break
                case .fit(let x, let float):
                    calcWidth = x ?? max(item.view.frame.width, item.view.bounds.width)
                    altAxisFloat = float
                    break
                }
                switch altAxisFloat {
                case .begin:
                    frameLeft = item.left
                case .middle:
                    frameLeft = item.left + (totalWidth - calcWidth) / 2
                case .end:
                    frameLeft = item.left + (totalWidth - calcWidth)
                }
                
                item.view.bounds = CGRect(
                    x: 0,
                    y: 0,
                    width: calcWidth,
                    height: calcHeight)
                
                item.view.frame = CGRect(
                    x: frameLeft,
                    y: contentHeight + item.top,
                    width: calcWidth,
                    height: calcHeight)
                
                if item.weightedSize == nil,
                    item.fixedSize < 0,
                    (item.percentSize < 0 || item.percentSize > 1) {
                    
                    if let customSize = self.customSizingPolicy?(item) {
                        calcHeight = customSize
                    } else if item.view is UILabel {
                        item.view.sizeToFit()
                        calcHeight = cachedFitHeights[item] ??
                            max(item.view.frame.height, item.view.bounds.height)
                    } else if item.view is ScrollStackView {
                        calcHeight = cachedFitHeights[item] ?? max(item.view
                            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            .height, item.view.frame.height, item.view.bounds.height,
                                     item.view.intrinsicContentSize.height)
                    } else {
                        calcHeight = cachedFitHeights[item] ?? max(item.view
                            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            .height, item.view.frame.height, item.view.bounds.height,
                            item.view.intrinsicContentSize.height)
                    }
                    cachedFitHeights[item] = calcHeight
                    
                    item.view.bounds = CGRect(
                        x: 0,
                        y: 0,
                        width: calcWidth,
                        height: calcHeight)
                    
                    item.view.frame = CGRect(
                        x: frameLeft,
                        y: contentHeight + item.top,
                        width: calcWidth,
                        height: calcHeight)
                }
                
                contentHeight = contentHeight + item.top + calcHeight + item.bottom
            }
            
            if #available(iOS 11.0, *) {
                contentHeight += self.autoAdjustBottomInset ? self.safeAreaInsets.bottom : 0
            } else {
                fatalError("iOS 11.0+ required.")
            }
        }
        
        calcHeights(false)
        
        if contentHeight < scrollHeight {
            emptySpaceHeight = scrollHeight - contentHeight
            contentHeight = scrollHeight
        }
        
        if containsWeights, emptySpaceHeight > 0 {
            
            for item in _items {
                guard let weight = item.weightedSize else { continue }
                totalWeights += weight
            }
            
            if totalWeights > 0 {
                calcHeights(true)
            }
        }
        
        content.bounds = CGRect(
            x: 0,
            y: 0,
            width: selfSizeAltAxis ? maxWidth : contentWidth,
            height: contentHeight)
        
        content.frame = CGRect(
            x: 0,
            y: 0,
            width: selfSizeAltAxis ? maxWidth : contentWidth,
            height: contentHeight)
        
        if scrollEnabled {
            scrollView.bounds = CGRect(
                x: 0,
                y: 0,
                width: selfSizeAltAxis ? maxWidth : contentWidth,
                height: scrollHeight)
            
            scrollView.frame = CGRect(
                x: 0,
                y: 0,
                width: selfSizeAltAxis ? maxWidth : contentWidth,
                height: scrollHeight)
            
            scrollView.contentSize = CGSize(
                width: selfSizeAltAxis ? maxWidth : contentWidth,
                height: contentHeight)
        }
        
        if selfSizePrimaryAxis {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: selfSizeAltAxis ? maxWidth : self.frame.width,
                height: contentHeight)
        } else if selfSizeAltAxis {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: maxWidth,
                height: self.frame.height)
        }
    }
    
    open func layoutSubviewsHorizontally() {
        
        let contentHeight: CGFloat = max(self.frame.height, self.bounds.height)
        
        let scrollWidth: CGFloat = selfSizePrimaryAxis ? 0 : max(self.frame.width, self.bounds.width)
        
        var contentWidth: CGFloat = 0
        
        var maxHeight: CGFloat = 0
        
        var containsWeights: Bool = false
        var emptySpaceWidth: CGFloat = 0
        var totalWeights: CGFloat = 0
        
        var cachedFitWidths: [ScrollStackViewItem:CGFloat] = [:]
        
        let calcWidths: (Bool) -> Void = { useWeights in
            
            contentWidth = 0
            
            maxHeight = 0
            
            if self.selfSizeAltAxis {
                for item in self._items {
                    if self.selfSizeAltAxis, case let .fit(x, _) = item.altAxisMode {
                        let calcHeight = x ?? max(item.view.frame.height, item.view.bounds.height)
                        maxHeight = max(maxHeight, calcHeight + item.top + item.bottom)
                    }
                }
            }
            
            for item in self._items {
                
                var calcWidth: CGFloat
                if useWeights, let weight = item.weightedSize {
                    if item.percentSize >= 0, item.percentSize <= 1 {
                        calcWidth = max(item.percentSize * scrollWidth, item.fixedSize, 0)
                    } else {
                        calcWidth = max(item.fixedSize, 0)
                    }
                    let normWeight: CGFloat = weight / totalWeights
                    calcWidth += emptySpaceWidth * normWeight
                } else {
                    if item.percentSize >= 0, item.percentSize <= 1 {
                        calcWidth = max(item.percentSize * scrollWidth, item.fixedSize, 0)
                    } else {
                        calcWidth = max(item.fixedSize, 0)
                    }
                    if item.weightedSize != nil {
                        containsWeights = true
                        calcWidth = max(calcWidth, 0)
                    }
                }
                
                let frameTop: CGFloat
                let calcHeight: CGFloat
                let totalHeight: CGFloat = (self.selfSizeAltAxis ? maxHeight : contentHeight)
                    - item.top - item.bottom
                let altAxisFloat: ScrollStackViewItem.AltAxisFloat
                switch item.altAxisMode {
                case .fill:
                    calcHeight = totalHeight
                    altAxisFloat = .begin
                    break
                case .percent(let x, let float):
                    calcHeight = x * totalHeight
                    altAxisFloat = float
                    break
                case .fit(let x, let float):
                    if item.view is UILabel {
                        item.view.frame = CGRect(
                            x: contentWidth + item.left,
                            y: 0,
                            width: calcWidth,
                            height: 0)
                        item.view.sizeToFit()
                    }
                    calcHeight = x ?? max(item.view.frame.height, item.view.bounds.height)
                    altAxisFloat = float
                    break
                }
                switch altAxisFloat {
                case .begin:
                    frameTop = item.top
                case .middle:
                    frameTop = item.top + (totalHeight - calcHeight) / 2
                case .end:
                    frameTop = item.top + (totalHeight - calcHeight)
                }
                
                item.view.bounds = CGRect(
                    x: 0,
                    y: 0,
                    width: calcWidth,
                    height: calcHeight)
                
                item.view.frame = CGRect(
                    x: contentWidth + item.left,
                    y: frameTop,
                    width: calcWidth,
                    height: calcHeight)
                
                if item.weightedSize == nil,
                    item.fixedSize < 0,
                    (item.percentSize < 0 || item.percentSize > 1) {
                    
                    if let customSize = self.customSizingPolicy?(item) {
                        calcWidth = customSize
                    } else if item.view is UILabel {
                        item.view.sizeToFit()
                        calcWidth = cachedFitWidths[item] ??
                            max(item.view.frame.width, item.view.bounds.width)
                    } else if item.view is ScrollStackView {
                        calcWidth = cachedFitWidths[item] ?? max(item.view
                            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            .width, item.view.frame.width, item.view.bounds.width,
                                    item.view.intrinsicContentSize.width)
                    } else {
                        calcWidth = cachedFitWidths[item] ?? max(item.view
                            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            .width, item.view.frame.width, item.view.bounds.width,
                                    item.view.intrinsicContentSize.width)
                    }
                    cachedFitWidths[item] = calcWidth
                    
                    item.view.bounds = CGRect(
                        x: 0,
                        y: 0,
                        width: calcWidth,
                        height: calcHeight)
                    
                    item.view.frame = CGRect(
                        x: contentWidth + item.left,
                        y: frameTop,
                        width: calcWidth,
                        height: calcHeight)
                }
                
                contentWidth = contentWidth + item.left + calcWidth + item.right
            }
        }
        
        calcWidths(false)
        
        if contentWidth < scrollWidth {
            emptySpaceWidth = scrollWidth - contentWidth
            contentWidth = scrollWidth
        }
        
        if containsWeights, emptySpaceWidth > 0 {
            
            for item in _items {
                guard let weight = item.weightedSize else { continue }
                totalWeights += weight
            }
            
            if totalWeights > 0 {
                calcWidths(true)
            }
        }
        
        content.bounds = CGRect(
            x: 0,
            y: 0,
            width: contentWidth,
            height: selfSizeAltAxis ? maxHeight : contentHeight)
        
        content.frame = CGRect(
            x: 0,
            y: 0,
            width: contentWidth,
            height: selfSizeAltAxis ? maxHeight : contentHeight)
        
        if scrollEnabled {
            scrollView.bounds = CGRect(
                x: 0,
                y: 0,
                width: scrollWidth,
                height: selfSizeAltAxis ? maxHeight : contentHeight)
            
            scrollView.frame = CGRect(
                x: 0,
                y: 0,
                width: scrollWidth,
                height: selfSizeAltAxis ? maxHeight : contentHeight)
            
            scrollView.contentSize = CGSize(
                width: contentWidth,
                height: selfSizeAltAxis ? maxHeight : contentHeight)
        }
        
        if selfSizePrimaryAxis {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: contentWidth,
                height: selfSizeAltAxis ? maxHeight : self.frame.height)
        } else if selfSizeAltAxis {
            self.frame = CGRect(
                x: self.frame.minX,
                y: self.frame.minY,
                width: self.frame.width,
                height: maxHeight)
        }
    }
    
    @discardableResult
    open func pushItem<V: UIView>(
        _ item: ScrollStackViewItem,
        _ configFunc: (ScrollStackViewItem, V) -> ScrollStackViewItem  = { itm, _ in itm }) -> ScrollStackView {
        defer { layoutDeferred() }
        
        for itm in _items {
            if itm.view == item.view {
                fatalError("item's view may not be added twice.")
            }
        }
        
        _items.append(item)
        content.addSubview(item.view)
        
        return self.configLastItem(configFunc)
    }
    
    @discardableResult
    open func popItem() -> ScrollStackViewItem? {
        if _items.isEmpty { return nil }
        
        defer { layoutDeferred() }
        
        let item = _items.removeLast()
        item.view.removeFromSuperview()
        return item
    }
    
    @discardableResult
    open func replaceItem(at: Int, with newItem: ScrollStackViewItem) -> ScrollStackViewItem? {
        if at < 0 || at >= _items.count { fatalError("Index out of bounds.") }
        
        var oldItemIndex = at
        var oldItem = _items[at]
        
        defer { layoutDeferred() }
        
        _items.remove(at: oldItemIndex)
        oldItem.view.removeFromSuperview()
        
        _items.insert(newItem, at: oldItemIndex)
        content.addSubview(newItem.view)
        return newItem
    }
    
    @discardableResult
    open func replaceItem(_ item: ScrollStackViewItem, newItem: ScrollStackViewItem) -> ScrollStackViewItem? {
        
        var oldItemIndex: Int?
        var oldItem: ScrollStackViewItem?
        for (i, itm) in _items.enumerated() {
            if itm == item {
                oldItemIndex = i
                oldItem = itm
                break
            }
        }
        
        guard oldItemIndex != nil, oldItem != nil else { return nil }
        
        defer { layoutDeferred() }
        
        _items.remove(at: oldItemIndex!)
        oldItem!.view.removeFromSuperview()
        
        _items.insert(newItem, at: oldItemIndex!)
        content.addSubview(newItem.view)
        return newItem
    }
    
    @discardableResult
    open func insertItem(_ item: ScrollStackViewItem, at: Int) -> ScrollStackViewItem {
        if at < 0 || at > _items.count { fatalError("Index out of bounds.") }
        
        defer { layoutDeferred() }
        
        for itm in _items {
            if itm.view == item.view {
                fatalError("item's view may not be added twice.")
            }
        }
        
        _items.insert(item, at: at)
        content.addSubview(item.view)
        return item
    }
    
    @discardableResult
    open func removeItem(at: Int) -> ScrollStackViewItem? {
        if at < 0 || at >= _items.count { return nil }
        
        defer { layoutDeferred() }
        
        let item = _items.remove(at: at)
        item.view.removeFromSuperview()
        return item
    }
    
    @discardableResult
    open func removeItem(_ item: ScrollStackViewItem) -> ScrollStackViewItem? {
        
        for (i, itm) in _items.enumerated() {
            if itm == item {
                return self.removeItem(at: i)
            }
        }
        
        return nil
    }
    
    @discardableResult
    open func removeItem(_ view: UIView) -> ScrollStackViewItem? {
        
        for (i, itm) in _items.enumerated() {
            if itm.view == view {
                return self.removeItem(at: i)
            }
        }
        
        return nil
    }
    
    @discardableResult
    open func configItem<V: UIView>(at: Int, _ configFunc: (ScrollStackViewItem, V) -> ScrollStackViewItem) -> ScrollStackView {
        if at < 0 || at >= _items.count { fatalError("Index out of bounds.") }
        
        let item = _items[at]
        let newItem = item.config(configFunc)
        if newItem != item { self.replaceItem(at: at, with: newItem) }
        return self
    }
    
    @discardableResult
    open func configLastItem<V: UIView>(_ configFunc: (ScrollStackViewItem, V) -> ScrollStackViewItem) -> ScrollStackView {
        return self.configItem(at: _items.count - 1, configFunc)
    }
    
    @discardableResult
    open func configFirstItem<V: UIView>(_ configFunc: (ScrollStackViewItem, V) -> ScrollStackViewItem) -> ScrollStackView {
        return self.configItem(at: 0, configFunc)
    }
    
    private var layoutDeferredCt: UInt64 = 0
    
    public func layoutDeferred() {
        layoutDeferredCt += 1
        let ct = layoutDeferredCt
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self, self.layoutDeferredCt == ct else { return }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}

extension ScrollStackView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onEndScrolling?(self.scrollAmount, self.scrollPercent)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.onEndScrolling?(self.scrollAmount, self.scrollPercent)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let amount = self.scrollAmount
        let percent = self.scrollPercent
        guard amount != self.lastScrollAmount || percent != self.lastScrollPercent else { return }
        self.lastScrollAmount = amount
        self.lastScrollPercent = percent
        onScroll?(amount, percent)
    }
}
