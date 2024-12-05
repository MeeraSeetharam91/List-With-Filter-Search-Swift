//
//  CoinModel.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 29/11/24.
//

import Foundation

struct Coin: Codable {
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: String
    
    var cryptoType: CryptoType {
        if let newType = CryptoType(rawValue: self.type) {
            return newType
        }
        return .coin
    }
    
}

enum CryptoType: String {
    case coin
    case token
}

enum Filter: String, CaseIterable {
    case active = "Active Coins"
    case inactive = "Inactive Coins"
    case tokenOnly = "Only Tokens"
    case coinOnly = "Only Coins"
    case new = "New Coins"
}

struct FilterSelection {
    let filterType: Filter
    var isSelected: Bool = false
}
