//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation

protocol NetworkService {
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void)
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CoinHistoryResponse, Error>) -> Void)
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<DetailsCryptoCoinDetailsResponse, Error>) -> Void)
}


class NetworkManager: NetworkService {
    static var shared = NetworkManager()
    
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
            let responseDataString = String(data: data, encoding: .utf8)
                print("Inq Response Data: \(responseDataString)")
            
            do {
                print("Inquiry Response Data: \(data)")
                let decoder = JSONDecoder()
                let response = try decoder.decode(Crypto.self, from: data)
                completion(.success(response.data?.coins ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<DetailsCryptoCoinDetailsResponse, Error>) -> Void) {
        let urlString = "https://api.coinranking.com/v2/coin/\(uuid)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        print("URL: \(url)")
        
        var request = URLRequest(url: url)
        request.setValue(NetworkConstants.apiKey, forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseDataString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseDataString)")
            } else {
                print("No data received")
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DetailsCryptoCoinDetailsResponse.self, from: data)
                completion(.success(response))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

extension NetworkManager {
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CoinHistoryResponse, Error>) -> Void) {
        let urlString = "\(NetworkConstants.baseURL)coin/\(uuid)/history?timePeriod=\(timePeriod)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(NetworkConstants.apiKey, forHTTPHeaderField: "x-access-token") // Add the API key here
        
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
                let response = try decoder.decode(CoinHistoryResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
