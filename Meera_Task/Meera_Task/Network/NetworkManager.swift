//
//  NetworkManager.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 02/12/24.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case dataTaskError(error: Error?)
    case noData
    case decodingError(error: Error)
}
//https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io
enum API {
    enum Endpoint {
        static let baseURL = "https://37656be98b8f42ae8348e4da3ee3193f.api"
        
        case itemlist
        
        var path: String {
            switch self {
            case .itemlist: return ".mockbin.io"
            }
        }
    }
}

class NetworkManager {
    
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: self.baseURL + urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.dataTaskError(error: error)))
                
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: self.baseURL + urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.dataTaskError(error: nil)
        }

        return data
    }
    
    func fetchFromFile<T: Decodable>(fileName: String) async throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"), let data = try? Data(contentsOf: url) else {
            throw NetworkError.dataTaskError(error: nil)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
