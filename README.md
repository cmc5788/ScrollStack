# ScrollStack

[![Build Status](https://travis-ci.com/cmc5788/ScrollStack.svg?branch=master)](https://travis-ci.com/cmc5788/ScrollStack)
[![Version](https://img.shields.io/cocoapods/v/ScrollStack.svg?style=flat)](https://cocoapods.org/pods/ScrollStack)
[![License](https://img.shields.io/cocoapods/l/ScrollStack.svg?style=flat)](https://cocoapods.org/pods/ScrollStack)
[![Platform](https://img.shields.io/cocoapods/p/ScrollStack.svg?style=flat)](https://cocoapods.org/pods/ScrollStack)

ScrollStack combines UIScrollView and some concepts from UIStackView into a single view called `ScrollStackView`. In addition, it adds the concept of weighted sizes for children. Currently the best way to get up and running with `ScrollStackView` is to check out the [Example app's `ViewController.swift` file](https://github.com/cmc5788/ScrollStack/blob/master/Example/ScrollStack/ViewController.swift). Adding a child to a `ScrollStackView` is as simple as:

```swift
scrollStack.pushItem(.init(UIView()))
{ (item, v: UIView) in
    v.backgroundColor = .random()
    return item
        .fixedSize(50)
        .leading(16)
        .trailing(16)
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ScrollStack is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ScrollStack'
```

## Author

cmc5788, cmc5788@gmail.com

## License

ScrollStack is available under the MIT license. See the LICENSE file for more info.
