//
//  Then.swift
//  FCA
//

import Foundation
import CoreGraphics

public protocol Then {}

extension Then {
    public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
