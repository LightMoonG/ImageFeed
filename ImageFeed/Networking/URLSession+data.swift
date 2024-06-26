//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Глеб Хамин on 14.06.2024.
//

import Foundation

enum NetworkError: Error {
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = {
            result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        print("Ошибка декодирования в функции \(#function): \(error.localizedDescription), данные: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletionOnMainThread(.failure(NetworkError.decodingError(statusCode as! Error)))
                    }
                } else {
                    print("Ошибка HTTP-статуса в функции \(#function): \(statusCode), данные: \(String(data: data, encoding: .utf8) ?? "")")
                    fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Ошибка URL-запроса в функции \(#function): \(error.localizedDescription)")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Ошибка сессии URL в функции \(#function)")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
