//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let urlString = "\(NetworkConstants.baseURL)coins?limit=20&offset=\(page * 20)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        print("URL=======\(url)")
        print("API Key=======\(NetworkConstants.apiKey)")

        var request = URLRequest(url: url)
        request.setValue("Bearer \(NetworkConstants.apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Crypto.self, from: data)
                completion(.success(response.data?.coins ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
