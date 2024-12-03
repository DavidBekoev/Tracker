//
//  ColorTransform.swift
//  Tracker
//
//  Created by Давид Бекоев on 26.11.2024.
//
import UIKit

@objc
class ColorTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data as Data)
    }

    static func register() {
        ValueTransformer.setValueTransformer(
            ColorTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ColorTransformer.self))
        )
    }
}
