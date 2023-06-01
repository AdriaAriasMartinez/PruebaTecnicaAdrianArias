//
//  Bank.swift
//  PruebaTecnica
//
//  Created by AdrianArias on 31/05/23.
//

import Foundation

struct BankModel: Codable {
    
    var description: String
    var age: Int
    var url: String
    var bankName: String
    var image: Data?
    
    init(description: String, age: Int, url: String, bankName: String, image: Data?) {
        self.description = description
        self.age = age
        self.url = url
        self.bankName = bankName
        self.image = image
    }
    
    init(){
        self.description = ""
        self.age = 0
        self.url = ""
        self.bankName = ""
        self.image = Data()
    }
}
