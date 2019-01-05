//
//  ViewController.swift
//  ScrollStack
//
//  Created by cmc5788 on 01/05/2019.
//  Copyright (c) 2019 cmc5788. All rights reserved.
//

import UIKit
import ScrollStack

class ViewController: UIViewController {
    
    override func loadView() {
        self.view = MyView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupExample()
    }

    func setupExample() {
        
        for _ in 0 ... 16 {
            
            myView.scrollStack.pushItem(.init(UIView())) { (item, v: UIView) in
                
                v.backgroundColor = .random()
                
                return item
                    .fixedSize(100)
                    .leading(16)
                    .trailing(16)
            }
        }
    }
}

class MyView: UIView {
    
    lazy var scrollStack: ScrollStackView = {
        let scrollStack = ScrollStackView()
        return scrollStack
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if scrollStack.superview != self {
            self.addSubview(scrollStack)
        }
        
        scrollStack.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
}

extension ViewController {
    
    var myView: MyView {
        return self.view as! MyView
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
