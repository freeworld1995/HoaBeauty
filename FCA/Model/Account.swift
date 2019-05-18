//
//  Account.swift
//  FCA
//
//  Created by 1 on 8/6/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import Foundation
enum AccountType {
    
}

struct Account: Codable {
    var account: String?
    var password: String?
    var type: String?
    var retrictions: [Int]?
    
    init(account: String, password: String, type: String) {
        self.account = account;
        self.password = password;
        self.type = type;
    }
    
    init(account: String, password: String, type: String, retrictions: [Int]) {
        self.account = account
        self.password = password
        self.type = type
        self.retrictions = retrictions
    }
    
    func isMatchLogin(account: String, pass: String) -> Bool {
        if (self.account == account && self.password == pass) {
            return true
        }
        return false
    }
}

struct Examination {
    var name: String?
    var infor: String?
    var imageName: String?
    var listFactor: [Int]?
    
    init(name: String, infor: String, image: String, factor: [Int]) {
        self.name = name
        self.infor = infor
        self.imageName = image
        self.listFactor = factor
    }
}
