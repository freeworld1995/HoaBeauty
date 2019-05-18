//
//  DatabaseService.swift
//  FCA
//
//  Created by Jimmy Hoang on 5/18/19.
//  Copyright © 2019 minhcong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

enum CollectionKey: String {
    case account = "accounts"
}

class DatabaseService: NSObject {
    static var instance = DatabaseService();
    
    var database: Firestore!
    
    override init() {
        // Init database
        database = Firestore.firestore()
        
        
    }
    
    func GetAllUser(completion: @escaping (Result<[Account], Error>) -> Void) {
        var listAccount:[Account] = []
        
        database.collection(CollectionKey.account.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                print("Get all user error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dict = document.data()
                    let account = try? Account(from: dict)
                    if let account = account {
                        listAccount.append(account)
                    } else {
                        print("Parse data error")
                    }
                }
            }
            completion(.success(listAccount))
        }
    }
    
    func SaveUser(account: Account, completion: @escaping (Bool) -> Void) {
        let dict = try? account.asDictionary()
        
        if let dict = dict, let accountName = account.account {
            database.collection(CollectionKey.account.rawValue).document(accountName).setData(dict) { (error) in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("New account added")
                    completion(true)
                }
            }
        }
    }
}

