//
//  NetworkLayer.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 03.09.2024.
//

import Foundation

final class NetworkLayer {
    
    //MARK: - Properties
    
    private let baseURLString = "https://dummyjson.com/todos"
    private let session = URLSession.shared
    
    //MARK: - Methods
    
    func getList(
        completion: @escaping (
            Result<[TodoAPIModel],NetworkLayerError>
        ) -> Void) {
        let getURLResult = getUrl()
        switch getURLResult {
        case .success(let url):
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request) {
                [weak self] data, response, error in
                guard let self, let response else {
                    completion(.failure(.unknownError))
                    return
                }
                let responseResult = self.handle(response: response)
                switch responseResult {
                case .success(_):
                    if error != nil {
                        completion(.failure(.networkError))
                        return
                    }
                    if let data {
                        let decoder = JSONDecoder()
                        if let list = try? decoder.decode(
                            Welcome.self, from: data) {
                            completion(.success(list.todos))
                        } else {
                            completion(.failure(.decodingError))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func getUrl() -> Result<URL, NetworkLayerError> {
        guard let url = URL(string: baseURLString) else {
            return .failure(.wrongURL)
        }
        return .success(url)
    }
    
    private func handle(
        response: URLResponse
    ) -> Result<Void, NetworkLayerError> {
        guard let response = response as? HTTPURLResponse,
              let code = HTTPResponseCode(
                rawValue: response.statusCode
              ) else {
            return .failure(.wrongResponseType)
        }
        switch code {
        case .success:
            return .success(())
        case .serverError, .notFound:
            return .failure(.serverError)
        }
    }
}

//MARK: - Enums

enum HTTPResponseCode: Int {
    case success = 200
    case notFound = 404
    case serverError = 500
}

enum NetworkLayerError: Error {
    case wrongURL
    case networkError
    case decodingError
    case unknownError
    case wrongResponseType
    case serverError
    
    var errorText: String {
        switch self {
        case.wrongURL:
            "Incorrect link, check the link is correct"
        default:
            "The server did not return the data, try again later"
        }
    }
}
