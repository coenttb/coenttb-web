//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//

import Foundation
import CoenttbHTML
import Dependencies

// MARK: - Text Color Definitions

//extension HTMLColor {
//    public static let buttonText: Self = .primary.reverse()
//    public static let primary: Self = .black.withDarkColor(.white)
//    public static let text: Self = primary
//    public static let secondary: Self = .gray300.withDarkColor(.gray700)
//    public static let tertiary: Self = .gray450.withDarkColor(.gray550)
//}

// MARK: - Background Color Definitions
//
//extension HTMLColor {
//    public static let offBackground: Self = .offWhite.withDarkColor(.offBlack)
//    public static let background: Self = .white.withDarkColor(.black)
//}

// MARK: - HTMLColor Extensions

extension HTMLColor {
    /// Reverses the light and dark colors
    public func reverse() -> Self {
        .init(
            light: self.dark ?? self.light,
            dark: self.light
        )
    }
    
    /// Calculates the midpoint color between two HTMLColors for gradients
    public static func gradientMidpoint(from color1: HTMLColor, to color2: HTMLColor) -> HTMLColor? {
        func midpoint(_ c1: CSS.Color, _ c2: CSS.Color) -> CSS.Color? {
            let rgb1 = toRGB(c1)
            let rgb2 = toRGB(c2)
            
            guard let r1 = rgb1, let r2 = rgb2 else { return nil }
            
            let midR = (r1.0 + r2.0) / 2
            let midG = (r1.1 + r2.1) / 2
            let midB = (r1.2 + r2.2) / 2
            
            return .rgb(red: midR, green: midG, blue: midB)
        }
        
        let lightMid = midpoint(color1.light, color2.light)
        let darkMid = color1.dark.flatMap { d1 in
            color2.dark.flatMap { d2 in
                midpoint(d1, d2)
            }
        }
        
        guard let light = lightMid else { return nil }
        return HTMLColor(light: light, dark: darkMid)
    }
    
    public static func readablePrimaryColor(on backgroundColor: HTMLColor) -> Self {
        let brightness = calculateBrightness(from: backgroundColor.light.description)
        return brightness > 0.5 ? .init(light: .hex("000000")) : .init(light: .hex("FFFFFF"))
    }
    
    private static func calculateBrightness(from hex: String) -> CGFloat {
        guard let (red, green, blue) = hexToRGB(hex) else { return 0 }
        
        let redComponent = CGFloat(red) * 299
        let greenComponent = CGFloat(green) * 587
        let blueComponent = CGFloat(blue) * 114
        
        let sum = redComponent + greenComponent + blueComponent
        return sum / 1000
    }
}

// MARK: - HTML Extensions

extension HTML {
    /// Applies a gradient background to the HTML element
    public func gradient(
        bottom: HTMLColor,
        top: HTMLColor
    ) -> some HTML {
        self
            .inlineStyle("background", "linear-gradient(0deg, \(bottom.light.description) 0%, \(top.light.description) 100%);")
            .inlineStyle(
                "background",
                "linear-gradient(0deg, \(bottom.dark?.description ?? "") 0%, \(top.dark?.description ?? "") 100%);",
                media: .dark
            )
    }
    
    public func gradient(
        bottom: HTMLColor,
        middle: HTMLColor,
        top: HTMLColor
    ) -> some HTML {
        self
            .inlineStyle("background", "linear-gradient(0deg, \(bottom.light.description) 0%, \(middle.light.description) 50%, \(top.light.description) 100%);")
            .inlineStyle(
                "background",
                bottom.dark.flatMap { bottom in
                    middle.dark.flatMap { middle in
                        top.dark.map { top in
                            "linear-gradient(0deg, \(bottom) 0%, \(middle) 50%, \(top) 100%);"
                        }
                    }
                },
                media: .dark
            )
    }
}

// MARK: - Private Helper Functions

extension HTMLColor {
    private static func toRGB(_ color: CSS.Color) -> (Int, Int, Int)? {
        switch color {
        case .keyword(let keyword):
            return keywordToRGB(keyword)
        case .hex(let hex):
            return hexToRGB(hex)
        case .rgb(let r, let g, let b):
            return (r, g, b)
        case .rgba(let r, let g, let b, _):
            return (r, g, b)
        case .hsl(let h, let s, let l):
            return hslToRGB(h: h, s: s, l: l)
        case .hsla(let h, let s, let l, _):
            return hslToRGB(h: h, s: s, l: l)
        case .hwb(let h, let w, let b):
            return hwbToRGB(h: h, w: w, b: b)
        case .lab(let l, let a, let b):
            return labToRGB(l: l, a: a, b: b)
        case .lch(let l, let c, let h):
            return lchToRGB(l: l, c: c, h: h)
        default:
            return nil
        }
    }
    
    private static func hexToRGB(_ hex: String) -> (Int, Int, Int)? {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }
        
        guard hex.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&rgbValue) else { return nil }
        
        let r = Int((rgbValue & 0xFF0000) >> 16)
        let g = Int((rgbValue & 0x00FF00) >> 8)
        let b = Int(rgbValue & 0x0000FF)
        
        return (r, g, b)
    }
    
    private static func hslToRGB(h: Int, s: Double, l: Double) -> (Int, Int, Int) {
        let h = Double(h) / 360
        let s = s / 100
        let l = l / 100
        
        func hue2rgb(_ p: Double, _ q: Double, _ t: Double) -> Double {
            var t = t
            if t < 0 { t += 1 }
            if t > 1 { t -= 1 }
            if t < 1/6 { return p + (q - p) * 6 * t }
            if t < 1/2 { return q }
            if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
            return p
        }
        
        if s == 0 {
            let gray = Int(l * 255)
            return (gray, gray, gray)
        } else {
            let q = l < 0.5 ? l * (1 + s) : l + s - l * s
            let p = 2 * l - q
            let r = hue2rgb(p, q, h + 1/3)
            let g = hue2rgb(p, q, h)
            let b = hue2rgb(p, q, h - 1/3)
            return (Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    private static func hwbToRGB(h: Int, w: Double, b: Double) -> (Int, Int, Int) {
        let rgb = hslToRGB(h: h, s: 100, l: 50)
        let white = w / 100
        let black = b / 100
        
        let factor = 1 - white - black
        
        let r = Int((Double(rgb.0) * factor + 255 * white).rounded())
        let g = Int((Double(rgb.1) * factor + 255 * white).rounded())
        let b = Int((Double(rgb.2) * factor + 255 * white).rounded())
        
        return (r, g, b)
    }
    
    private static func labToRGB(l: Double, a: Double, b: Double) -> (Int, Int, Int) {
        let y = (l + 16) / 116
        let x = a / 500 + y
        let z = y - b / 200
        
        func fromLinear(_ c: Double) -> Double {
            return c > 0.0031308 ? 1.055 * pow(c, 1 / 2.4) - 0.055 : 12.92 * c
        }
        
        let r = fromLinear(3.2404542 * x - 1.5371385 * y - 0.4985314 * z)
        let g = fromLinear(-0.9692660 * x + 1.8760108 * y + 0.0415560 * z)
        let b = fromLinear(0.0556434 * x - 0.2040259 * y + 1.0572252 * z)
        
        return (Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()))
    }
    
    private static func lchToRGB(l: Double, c: Double, h: Double) -> (Int, Int, Int) {
        let a = c * cos(h * .pi / 180)
        let b = c * sin(h * .pi / 180)
        return labToRGB(l: l, a: a, b: b)
    }
    
    private static func keywordToRGB(_ keyword: CSS.Color.Keyword) -> (Int, Int, Int)? {
        switch keyword {
        case .black: return (0, 0, 0)
        case .white: return (255, 255, 255)
        case .red: return (255, 0, 0)
        case .green: return (0, 255, 0)
        case .blue: return (0, 0, 255)
        // Add more cases for other keywords
        default: return nil
        }
    }
    
    private static func rgbToHex(red: Int, green: Int, blue: Int) -> String {
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}
