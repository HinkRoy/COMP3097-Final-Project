//
//  CategoriesTransformer.swift
//  TaskMaster
//
//  Created by Heng Zhou on 2024/4/10.
//

import Foundation

@objc(CategoriesTransformer)
final class CategoriesTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [NSArray.self, NSString.self]
    }

    public static func register() {
        let transformer = CategoriesTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("CategoriesTransformer"))
    }
}

