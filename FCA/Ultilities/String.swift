//
//  String.swift
//  FCA
//
//  Created by 1 on 8/6/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import Foundation
final class Strings {
    static let LOGIN_ERROR_MESSAGE: String = "Login information is incorrect, please try again!"
}

final class Keys {
    static let ACCOUNT: String = "account"
    static let PASSWORD: String = "password"
    static let TYPE: String = "type"
    static let ADMIN: String = "admin"
    static let QUALIFIER: String = "qualifier"
    static let EXAMINATION_NAME: String = "examination"
    static let EXAMINATION_TYPE: String = "examinationType"
    
    static let FACTOR_LIST: String = "factorList"
    static let POINT_LIST: String = "pointList"
    static let CURRENT_FACTOR: String = "currentFactor"

    static let ACCOUNT_LIST: String = "accountList"
    
    // Code is name
    static let CANDIDATE_CODE: String = "currentCandidateCode"
    static let CANDIDATE_PHONE: String = "currentCandidatePhone"
    static let CANDIDATE_CHECKED: String = "currentCandidateChecked"
    
    static let CHECK_QRCODE: String = ""
    
    static let CHECK_UPDATE_POINT: String = "checkUpdatePoint"
    static let UPDATE_OBJECT: String = "updateObject"
    static let UPDATE_INDEX: String = "updateIndex"
}

final class AccountData {
    static let account: [[String]] = [["admin1", "admin", "admin", "Hán Thành Đức"],
                                      ["admin2", "admin", "admin", "Quang An"],
                                      ["qualifier001", "hoabeautylashes", "qualifier", "NGUYỄN MEE"],
                                      ["qualifier002", "hoabeautylashes", "qualifier", "MINH QUỲNH ANH"],
                                      ["qualifier003", "hoabeautylashes", "qualifier", "KIM TRAN"],
                                      ["qualifier004", "hoabeautylashes", "qualifier", "HỒ SẤN PHÙNG"],
                                      ["qualifier005", "hoabeautylashes", "qualifier", "HỢP VŨ"],
                                      ["qualifier006", "hoabeautylashes", "qualifier", "HANNA HOANG"],
                                      ["qualifier007", "hoabeautylashes", "qualifier", "PHẠM PHƯỢNG"],
                                      ["qualifier008", "hoabeautylashes", "qualifier", "HƯƠNG NGUYỄN"],
                                      ["qualifier009", "hoabeautylashes", "qualifier", "HIẾU HẠNH"],
                                      ["qualifier010", "hoabeautylashes", "qualifier", "DƯƠNG VÂN NGA"],
                                      ["qualifier011", "hoabeautylashes", "qualifier", "MAI MI"],
                                      ["qualifier012", "hoabeautylashes", "qualifier", "LINH MI XINH"],
                                      ["qualifier013", "hoabeautylashes", "qualifier", "TRẦN THỊ THU THOA"],
                                      ["qualifier014", "hoabeautylashes", "qualifier", "LINH KHÁNH VŨ"],
                                      ["qualifier015", "hoabeautylashes", "qualifier", "HOA PHẠM"],
                                    ["qualifier016", "hoabeautylashes", "qualifier", "LUYNH XINH DO"],
                                    ["qualifier017", "hoabeautylashes", "qualifier", "MY NGỌC"],
                                    ["qualifier018", "hoabeautylashes", "qualifier", "TUẤN ĐỖ"],
                                    ["qualifier019", "hoabeautylashes", "qualifier", "HANA PUJATO"],
                                    ["qualifier020", "hoabeautylashes", "qualifier", "KRISTIN"],
                                    ["qualifier021", "hoabeautylashes", "qualifier", "KATARZYNA"],
                                    ["qualifier022", "hoabeautylashes", "qualifier", "ANASTASIYA"],
                                    ["qualifier101", "hoabeautylashes", "qualifier", "LIÊN LƯU"],
                                    ["qualifier102", "hoabeautylashes", "qualifier", "NGUYỄN KHẢI ĐẠT"],
                                    ["qualifier103", "hoabeautylashes", "qualifier", "NGUYỄN THỊ THÁI HẬU"],
                                    ["qualifier104", "hoabeautylashes", "qualifier", "TRƯƠNG Ý NHI"],
                                    ["qualifier105", "hoabeautylashes", "qualifier", "MAI KIM PHỤNG"],
                                    ["qualifier106", "hoabeautylashes", "qualifier", "NGHI NGUYEN"],
                                    ["qualifier107", "hoabeautylashes", "qualifier", "HẢI YẾN"],
                                    ["qualifier108", "hoabeautylashes", "qualifier", "MAI KIM PHUC"],
                                    ["qualifier109", "hoabeautylashes", "qualifier", "THUY DUONG"],
                                    ["qualifier110", "hoabeautylashes", "qualifier", "PHUONG PHAN"],
                                    ["qualifier111", "hoabeautylashes", "qualifier", "WERONIKA"],
                                    ["qualifier112", "hoabeautylashes", "qualifier", "WENDY WOOHOO"],
                                    ["qualifier113", "hoabeautylashes", "qualifier", "PHI LONG"]]
    static let accountRestriction: [[[Int]]] = [[[5, 6], [0], [0]],// NGUYỄN MEE~
                                                [[1, 2, 7, 8], [3, 10], [3, 10], [9], [9]],//MINH QUỲNH ANH~
                                                [[1, 2, 5, 6], [7], [7], [4, 5], [4, 5]],//KIM TRAN~
                                                [[7, 8], [3], [3]],//HỒ SẤN PHÙNG~
                                                [[7, 8], [1], [1]],// 5HỢP VŨ~
                                                [[]],// 6HANNA HOANG
                                                [[1, 2, 7, 8], [2], [2], [8, 14], [8, 14]],// 7PHẠM PHƯỢNG~
                                                [[3, 4, 5, 6], [0, 8], [0, 8], [10], [10]],// 8HƯƠNG NGUYỄN~
                                                [[3, 4, 5, 6], [1], [1], [11, 12], [11, 12]],// 9HIẾU HẠNH~
                                                [[1, 2, 5, 6], [0], [0], [3], [3]],// 10DƯƠNG VÂN NGA
                                                [[3, 4, 5, 6], [3], [3], [9, 13], [9, 13]],//MAI MI~
                                                [[1, 2], [12], [12]],//LINH MI XINH~
                                                [[3, 4, 7, 8], [11], [11], [0], [0]],//TRẦN THỊ THU THOA~
                                                [[3, 4], [2], [2]],//LINH KHÁNH VŨ~
                                                [[3, 4, 7, 8], [6], [6], [6, 7], [6, 7]], // 15HOA PHẠM~
                                                [[3, 4, 5, 6], [9], [9], [2], [2]],//LUYNH XINH DO~
                                                [[1, 2, 3, 4, 7, 8], [1], [1], [10], [10], [4, 13], [4, 13]],//MY NGỌC~
                                                [[1, 2, 5, 6, 7, 8], [11], [11], [6, 7], [6, 7], [10], [10]],//TUẤN ĐỖ~
                                                [[5, 6, 7, 8], [1], [1], [5], [5]],//HANA PUJATO~
                                                [[1, 2, 5, 6], [9], [9], [8, 14], [8, 14]],// 20KRISTIN~
                                                [[1, 2, 3, 4, 7, 8], [4, 5, 13], [4, 5, 13], [7, 12], [7, 12], [11, 12], [11, 12]],//KATARZYNA~
                                                [[1, 2, 3, 4, 7, 8], [6, 8], [6, 8], [4, 5, 13], [4, 5, 13], [2], [2]],// 22ANASTASIYA~
                                                [[9, 10], [7], [7]],// 1LIÊN LƯU~
                                                [[9, 10, 11], [6], [6], [4, 5, 6]],//NGUYỄN KHẢI ĐẠT~
                                                [[]],//NGUYỄN THỊ THÁI HẬU~
                                                [[9, 10, 11], [5], [5], [3, 7, 8]],//TRƯƠNG Ý NHI~
                                                [[9, 10, 11], [2], [2], [9, 10]],//5MAI KIM PHỤNG~
                                                [[9, 10, 11, 12], [4], [4], [2, 11, 12]],//NGHI NGUYEN~
                                                [[9, 13, 14], [0], [7], [7]],//HẢI YẾN~
                                                [[9, 10, 13, 14], [8], [8], [1, 5], [1, 5]],//MAI KIM PHUC~
                                                [[9, 13, 14], [9], [2], [2]],//THUY DUONG~
                                                [[9, 10, 11, 13, 14], [3], [3], [0, 1], [6], [6]],//10PHUONG PHAN~
                                                [[10, 13, 14], [9], [4], [4]],//WERONIKA~
                                                [[9, 10, 13, 14], [1], [1], [0, 3], [3]],//WENDY WOOHOO~
                                                [[10, 14], [0], [0]]//13PHI LONG~
                                                ]
    //2620
    static func getInforByAccount(account: String) -> String {
        var result = ""
        for i in 0..<self.account.count {
            if self.account[i].first == account {
                result = self.account[i].last!
                break
            }
        }
        return result
    }
    
    static func getListActiveExam(account: String) -> [Int] {
        var result: [Int] = []
        for i in 0..<self.account.count {
            if self.account[i].first == account {
                result = self.accountRestriction[i - 2].first!
                break
            }
        }
        return result
    }
    
    static func getListActiveExam1(account: String) -> [Int] {
        var result: [Int] = []
        for i in 0..<self.account.count {
            if self.account[i].first == account {
                let listActive = self.accountRestriction[i - 2].first!
                for value in listActive {
                    result.append((value - 1) / 2)
                }
                break
            }
        }
        return result
    }
    
    static func getListActiveFactor(account: String, exam: Int) -> [Int] {
        var result: [Int] = []
        for i in 0..<self.account.count {
            if self.account[i].first == account {
                let listExam = self.accountRestriction[i - 2].first
                result = self.accountRestriction[i - 2][(listExam?.index(of: exam + 1))! + 1]
                break
            }
        }
        return result
    }
    
    static func getExamIndex(exam: String, type: String) -> Int {
        var result = 0
        var typeName = ""
        switch type {
        case "1":
            typeName = "Expert"
            break
        case "2":
            typeName = "Master"
            break
        case "3":
            typeName = "Human"
            break
        case "4":
            typeName = "3D Skin"
            break
        default:
            break
        }
        for name in ExamData.ExaminationListFull {
            if name.contains(exam) && name.contains(typeName) {
                result = ExamData.ExaminationListFull.index(of: name)!
                break
            }
        }
        return result
    }
    
    static func checkListExams(exam: String, account: String) -> [String] {
        var result: [String] = []
        var listExam = getListActiveExam(account: account)
        for examIndex in listExam {
            let examName = ExamData.ExaminationListFull[examIndex - 1]
            if examName.contains(exam) {
                var type = examName.replacingOccurrences(of: exam, with: "")
                type = type.replacingOccurrences(of: " ", with: "")
                result.append(type)
            }
        }
        return result
    }
    
    static func getExamTypes(exam: String) -> [String] {
        var result: [String] = []
        if ExamData.ExaminationList.index(of: exam)! <= 3 {
            result.append("Expert")
            result.append("Master")
        } else {
            result.append("Human")
            result.append("3D Skin")
        }
        return result
    }
}

final class ExamData {
    static let ExaminationList: [String] = ["Classic Nam - Men Classic", "Classic Nữ - Classic", "Volume 2D- 3D", "Volume 5D+", "Xăm Chân Mày - Brows Permanent MakeUp", "Điêu Khắc - Microblading", "Xăm Môi - Lips Permanent Makeup"]
    static let ExaminationListFull: [String] = ["Classic Nam - Men Classic Expert", "Classic Nam - Men Classic Master", "Classic Nữ - Classic Expert", "Classic Nữ - Classic Master", "Volume 2D- 3D Expert", "Volume 2D- 3D Master", "Volume 5D+ Expert", "Volume 5D+ Master", "Xăm Chân Mày - Brows Permanent MakeUp Human", "3D Skin Xăm Chân Mày - Brows Permanent MakeUp", "Điêu Khắc - Microblading Human", "3D Skin Điêu Khắc - Microblading", "Xăm Môi - Lips Permanent Makeup Human", "3D Skin Xăm Môi - Lips Permanent Makeup"]
    static let ExaminationListType: [String] = ["Expert", "Master", "Human", "3D Skin"]
    static let InformationList: [String] = ["Classic Nam", "Classic Nữ", "Volume 2D-3D",
                                            "Volume 5D+", "Xăm chân mày", "Điêu khắc", "Xăm môi"]
    static let ExaminationFactors: [[Int]] = [[1,2,3,4,5,6,7,8,9,10,11,12,13,14],
                                              [1,2,3,4,5,6,7,8,9,10,11,12,13,14],
                                              [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
                                              [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
                                              [16,17,18,19,12,20,21,22,23, 24],
                                              [17,18,19,25,16,20,26,12,21,22,23,24,27],
                                              [23,3,22,29,18,28,24,19]]
    static let FactorList: [String] = ["1Directions", "2Styling", "3Perfect line", "4Converage", "5Stickies",
                                       "6Attachment", "7Clean work", "8Lenght", "9Thickness", "10Distance from the eyelid",
                                       "11Inner and ourter corner ", "12Symmetry", "13Over look", "14Glue", "15Fan",
                                       "16Thickness of eyebrow", "17Eyebrow shape", "18Technique of making", "19Quality of drawing", "20Smoothness of lines",
                                       "21Head and Tail of eyebrow", "22Color", "23Over look", "24Degree of traumatis", "25Thickness of lines",
                                       "26Hair direction ", "27Precision of lines", "28Shape", "29Smoothness of color"]
    static let imageList: [String] = ["Classic Nam", "Classic Nữ", "Volume 2D-3D",
                                      "Volume 5D+", "Xăm chân mày", "Điêu khắc", "Xăm môi"]
}
