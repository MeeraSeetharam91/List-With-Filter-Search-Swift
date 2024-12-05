//
//  CoinRepository.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 29/11/24.
//

import Foundation

protocol CoinRepository {
    func fetchCoins() async throws -> [Coin]
    func fetchCoinsFromFile() async throws -> [Coin]
}

// CoinDataSource
class CoinDataSource: CoinRepository {
    private static let COIN_LOCAL_JSONFile = "CoinListJson"

    private let networkManager = NetworkManager(baseURL: API.Endpoint.baseURL)

    // Implement network calls to fetch coins from an API
    func fetchCoins() async throws -> [Coin] {
        // Fetch messages from a data store
        var coinList = [Coin]()
        func fetchData() {
            networkManager.fetchData(from: API.Endpoint.itemlist.path) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let list: [Coin] = try decoder.decode([Coin].self, from: data)
                        print("coin list: \(list)")
                        coinList = list
                        return
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
        return coinList
    }
    
    func fetchCoinsFromFile() async throws -> [Coin] {
        return try await networkManager.fetchFromFile(fileName: Self.COIN_LOCAL_JSONFile)
    }
    
}
