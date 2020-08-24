# HJLayout

[![Languages](https://img.shields.io/badge/language-swift%205.0%20-FF69B4.svg?style=plastic)](#) <br/> 
[![CI Status](https://img.shields.io/travis/HJKim95/HJLayout.svg?style=flat)](https://travis-ci.org/HJKim95/HJLayout?branch=master)
[![Version](https://img.shields.io/cocoapods/v/HJLayout.svg?style=flat)](https://cocoapods.org/pods/HJLayout)
[![License](https://img.shields.io/cocoapods/l/HJLayout.svg?style=flat)](https://cocoapods.org/pods/HJLayout)
[![Platform](https://img.shields.io/cocoapods/p/HJLayout?color=red&style=flat)](https://cocoapods.org/pods/HJLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 10.0+ 
* Xcode 11+
* Swift 5.0+

## Installation
* Manually
* Cocoapods

### Manually
1. ***[Download](#)*** the source code.
2. Extract the zip file, simply drag folder ***[Classes](#)*** into your project.
3. Make sure ***Copy items if needed*** is checked.

### Cocoapods

HJLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HJLayout'
```

## Demos
* [Demo1 - Layouts](#demo_layout)
* [Demo2 - Transforming](#demo_transforming)

### 1. Demo1 - Layouts <a id='demo_layout'></a>
|Pinterest|
|---|
|![Pinterest](https://user-images.githubusercontent.com/29699823/91012308-da0f5000-e620-11ea-8443-bf16e3eb5697.gif)|
```swift
let layout = PinterestLayout()
layout.delegate = self
layout.numberOfColumns = 2
layout.cellPadding = 10
layout.headerReferenceSizeHeight = 180
```
---

|StickyHeader|
|---|
|![StickyHeader](https://user-images.githubusercontent.com/29699823/91012340-e4c9e500-e620-11ea-8f35-3140183f41a1.gif)|
```swift
let layout = StickyHeaderLayout()
layout.headerReferenceSize = CGSize(width: view.frame.width, height: 180)
```
---

|UltraVisual|
|---|
|![UltraVisual](https://user-images.githubusercontent.com/29699823/91012345-e5fb1200-e620-11ea-829e-869056a80160.gif)|
```swift
let layout = UltraVisualLayout()
// for smooth snapping
collectionview.decelerationRate = .fast
```
---

|Timbre|
|---|
|![Timbre](https://user-images.githubusercontent.com/29699823/91012350-e72c3f00-e620-11ea-87f0-c45673d155aa.gif)|
```swift
let layout = TimbreLayout()
layout.minimumLineSpacing = 16
collectionview.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
```
---

### 2. Demo2 - Transforming <a id='demo_transforming'></a>
|crossFading|
|---|
|![crossFading](https://user-images.githubusercontent.com/29699823/91015125-98cd6f00-e625-11ea-8675-6efbabf4a8a6.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .crossFading
```
---

|zoomOut|
|---|
|![zoomOut](https://user-images.githubusercontent.com/29699823/91015164-a4209a80-e625-11ea-886e-f53d1cb507cd.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .zoomOut
```
---

|depth|
|---|
|![depth](https://user-images.githubusercontent.com/29699823/91015154-a125aa00-e625-11ea-862b-0826af16202e.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .depth
```
---

|linear|
|---|
|![linear](https://user-images.githubusercontent.com/29699823/91015161-a3880400-e625-11ea-9e73-a58bee7a7927.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .linear
```
---

|ferrisWheel|
|---|
|![ferrisWheel](https://user-images.githubusercontent.com/29699823/91015156-a256d700-e625-11ea-953c-31850638ac17.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .ferrisWheel
```
---

|invertedFerrisWheel|
|---|
|![invertedFerrisWheel](https://user-images.githubusercontent.com/29699823/91015159-a2ef6d80-e625-11ea-8e08-e4f237c40a05.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .invertedFerrisWheel
```
---

|cubic|
|---|
|![cubic](https://user-images.githubusercontent.com/29699823/91015149-9ff47d00-e625-11ea-8a83-2c6986ec2550.gif)|
```swift
let layout = TransformingLayout()
layout.transformer_type = .cubic
```
---


## Tutorial
* [Getting started with Layout](#getting_started_layout)
* [Getting started with TransformingLayout](#getting_started_transforming)

### 1. Getting started with Layout <a id='getting_started_layout'></a>

* Getting started with code
Check examples for needed properties.

```swift
// Create a layout and set property
let layout = PinterestLayout()
layout.delegate = self
layout.numberOfColumns = 2
layout.cellPadding = 10
layout.headerReferenceSizeHeight = 180
let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
cv.delegate = self
cv.dataSource = self
```

### 2. Getting started with TransformingLayout <a id='getting_started_transforming'></a>

* Getting started with code

```swift
// Create a layout and set property
let layout = TransformingLayout()
layout.transformer_type = .crossFading
let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
cv.delegate = self
cv.dataSource = self
// for smooth snapping
cv.decelerationRate = .fast
```

## Author

HJKim95, 25ephipany@naver.com

## License

HJLayout is available under the MIT license. See the LICENSE file for more info.
