import UIKit

class Applicant: NSObject {
    var exam: String!
    var factor: [String]!
    var point: [Double]!
    var id: String!
    var name: String!
    var type: String!
    
    init(exam: String, factor: [String], point: [Double], id: String, name: String, type: String) {
        self.exam = exam
        self.factor = factor
        self.point = point
        self.id = id
        self.name = name
        self.type = type
    }
    
    public func updatePoint(index: Int, point: Double) {
        self.point[index] = point
    }
    
    public func updatePoint(point: [Double]) {
        if self.point.count != point.count {
            self.point = point
        } else {
            for i in 0..<point.count {
                if self.point[i] == 0 && point[i] != 0 {
                    self.point[i] = point[i]
                }
            }
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
