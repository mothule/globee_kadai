//
//  AttributedStringDecorator.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

typealias AttrKey = NSAttributedString.Key

protocol DecorationTypeProtocol {
    func attribute() -> (AttrKey, Any)
}

enum DecorationType {
    // 行間(単位 ponit)
    case lineHeight(CGFloat)
    // 行間(単位 em)
    case lineHeightPerEM(CGFloat)
    // 字間(単位 point)
    case letterSpacing(CGFloat)
    // 行間(単位 point)
    case lineSpacing(CGFloat)
    // フォント(フォント名, フォントサイズ)
    case fontByName(String, CGFloat)
    // 背景
    case backgroundColor(UIColor)
    // 文字色
    case foregroundColor(UIColor)
    // 下線
    case underline(NSUnderlineStyle)
    // 下線色
    case underlineColor(UIColor)
    // 取り消し線
    case strikethrough
    // 太さ指定取り消し線
    case strikethroughWithWidth(Int)
    // 影
    case shadow(CGSize, CGFloat)
    // Baseline
    case baselineOffset(CGFloat)
}

extension DecorationType: DecorationTypeProtocol {
    func attribute() -> (AttrKey, Any) {
        switch self {
        case .lineHeight(let value):       return LineHeightDecorator(height: value).decorate()
        case .lineHeightPerEM(let value):  return LineHeightDecorator(heightPerEm: value).decorate()
        case let .fontByName(name, size):  return FontDecorator(fontName: name, fontSize: size).decorate()
        case .letterSpacing(let value):    return LetterSpacingDecorator(letterSpacing: value).decorate()
        case .lineSpacing(let value):    return LineSpacingDecorator(lineSpacing: value).decorate()
        case .backgroundColor(let color):  return ColorDecorator(background: color).decorate()
        case .foregroundColor(let color):  return ColorDecorator(foreground: color).decorate()
        case .underline(let style):        return UnderlineDecorator(style: style).decorate()
        case .underlineColor(let color):   return UnderlineColorDecorator(color: color).decorate()
        case .strikethrough:               return StrikethroughDecorator().decorate()
        case .strikethroughWithWidth(let width): return StrikethroughDecorator(width: width).decorate()
        case let .shadow(offset, radius):  return ShadowDecorator(shadowOffset: offset, blurRadius: radius).decorate()
        case .baselineOffset(let offset):  return BaseLineOffsetDecorator(offset: offset).decorate()
        }
    }
}

protocol Decoratable {
    func decorate() -> (AttrKey, Any)
}

// MARK: - Each Decorators

struct LineHeightDecorator: Decoratable {

    enum Unit {
        case point
        // swiftlint:disable:next identifier_name
        case em
    }

    private let height: CGFloat
    private let unit: Unit

    init(height: CGFloat) {
        self.height = height
        self.unit = .point
    }
    init(heightPerEm: CGFloat) {
        self.height = heightPerEm
        self.unit = .em
    }
    public func decorate() -> (AttrKey, Any) {
        let style = NSMutableParagraphStyle()
        switch unit {
        case .point:
            style.minimumLineHeight = height
            style.maximumLineHeight = height
        case .em:
            style.lineHeightMultiple = height
        }
        return (NSAttributedString.Key.paragraphStyle, style)
    }
}
struct LineSpacingDecorator: Decoratable {
    private let lineSpacing: CGFloat
    init(lineSpacing: CGFloat) {
        self.lineSpacing = lineSpacing
    }
    public func decorate() -> (AttrKey, Any) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        return (NSAttributedString.Key.paragraphStyle, style)
    }
}
struct LetterSpacingDecorator: Decoratable {
    private let letterSpacing: CGFloat
    init(letterSpacing: CGFloat) {
        self.letterSpacing = letterSpacing
    }
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.kern, letterSpacing)
    }
}
struct FontDecorator: Decoratable {
    let font: UIFont
    init(fontName: String, fontSize: CGFloat) {
        font = UIFont(name: fontName, size: fontSize)!
    }
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.font, font)
    }
}
struct ColorDecorator: Decoratable {
    enum `Type` {
        case background
        case foreground
    }
    let color: UIColor
    let type: Type

    init(background color: UIColor) {
        self.color = color
        self.type = .background
    }
    init(foreground color: UIColor) {
        self.color = color
        self.type = .foreground
    }
    public func decorate() -> (AttrKey, Any) {
        let key: AttrKey
        switch type {
        case .background: key = NSAttributedString.Key.backgroundColor
        case .foreground: key = NSAttributedString.Key.foregroundColor
        }
        return (key, color)
    }
}
struct UnderlineDecorator: Decoratable {
    let style: NSUnderlineStyle
    init(style: NSUnderlineStyle) {
        self.style = style
    }
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.underlineStyle, style.rawValue)
    }
}
struct UnderlineColorDecorator: Decoratable {
    let color: UIColor
    init(color: UIColor) {
        self.color = color
    }
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.underlineColor, color)
    }
}
struct StrikethroughDecorator: Decoratable {
    let width: Int
    
    init() {
        self.width = 1
    }
    init(width: Int) {
        self.width = width
    }
    
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.strikethroughStyle, width)
    }
}
struct ShadowDecorator: Decoratable {
    let shadow: NSShadow
    
    init(shadowOffset: CGSize, blurRadius: CGFloat) {
        shadow = NSShadow()
        shadow.shadowOffset = shadowOffset
        shadow.shadowBlurRadius = blurRadius
    }
    
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.shadow, shadow)
    }
}
struct BaseLineOffsetDecorator: Decoratable {
    let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
    }
    public func decorate() -> (AttrKey, Any) {
        return (NSAttributedString.Key.baselineOffset, offset)
    }
}

// MARK: - extension Array

extension Array where Element: DecorationTypeProtocol {
    var attributes: [AttrKey: Any] {
        var dict: [AttrKey: Any] = [:]
        self.forEach {
            let (key, value) = $0.attribute()
            dict[key] = value
        }
        return dict
    }
}

// MARK: - extension String/NSString

extension String {
    func decorate(by decoTypes: [DecorationType], range: NSRange? = nil) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        
        var attrs: [AttrKey: Any] = [:]
        decoTypes.forEach({
            let attr = $0.attribute()
            attrs[attr.0] = attr.1
        })
        
        let unwarppedRange = range != nil ? range! : NSRange(location: 0, length: self.count)
        
        attrString.addAttributes(attrs, range: unwarppedRange)
        
        return attrString
    }
    
    @available(*, unavailable, renamed: "decorate")
    func decorate(withDecorateTypes decoTypes: [DecorationType], range: NSRange? = nil ) -> NSAttributedString {
        return decorate(by: decoTypes, range: range)
    }
}
extension NSString {
    func decorate(withDecorateTypes decoTypes: [DecorationType], range: NSRange? = nil ) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: self as String)

        var attrs: [AttrKey: Any] = [:]
        decoTypes.forEach({
            let attr = $0.attribute()
            attrs[attr.0] = attr.1
        })

        let unwrappedRange = range != nil ? range! : NSRange(location: 0, length: self.length)

        attrString.addAttributes(attrs, range: unwrappedRange)

        return attrString
    }
}

