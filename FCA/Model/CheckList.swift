//
//  CheckList.swift
//  FCA
//

import UIKit

class CheckList: NSObject {
    var image: String!
    var exams: String!
    var marks: [String]!
    var point: [Double]!
    
    init(image: String, exams: String, mark: [String]) {
        self.image = image
        self.exams = exams
        self.marks = mark
        point = []
        for _ in marks {
            point.append(0)
        }
    }
    
    public func updatePoint(index: Int, point: Double) {
        self.point[index] = point
    }
    
    public func plusPoint(index: Int, max: Double) {
        if (self.point[index] < max) {
            self.point[index] += 0.5
        }
    }
    
    public func calculateTotalPoint() -> Double {
        var total = 0.0;
        for i in point {
            total += i
        }
        return total
    }
}
