//
//  APIClient.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Response

protocol APIResponse {
    associatedtype ResponseType
    var value: ResponseType { get }
    var httpStatusCode: Int { get }
}

struct APISwiftyJSONResponse: APIResponse {
    typealias ResponseType = JSON

    var value: JSON
    var httpStatusCode: Int
}

// MARK: - Request

protocol APIRequestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Encodable? { get }
    var encoder: ParameterEncoder { get }
    var appendingHeaders: [String: String]? { get }
}

extension APIRequestable {
    var method: HTTPMethod { .get }
    var parameters: Encodable? { nil }
    var encoder: ParameterEncoder { JSONEncoding.default as! ParameterEncoder }
    var appendingHeaders: [String: String]? { nil }

    func buildURL(endpoint: String) -> String { endpoint + path }
}

// MARK: - Client

protocol APIClientProtocol: class {
    typealias RequestHandle = (Result<APISwiftyJSONResponse, Error>) -> Void
    
    var endpoint: String { get }
    var defaultHeaders: [String: String] { get }
    func send(request: APIRequestable, handler: @escaping RequestHandle)
}

class APIClient: APIClientProtocol {
    let defaultHeaders: [String : String]
    let endpoint: String
    
    init(endpoint: String, defaultHeaders: [String: String] = [:]) {
        self.endpoint = endpoint
        self.defaultHeaders = defaultHeaders
    }
    
    static var shared: APIClientProtocol = APIClient(endpoint: "https://2zw3cqudp7.execute-api.ap-northeast-1.amazonaws.com/dev/")

    func send(request: APIRequestable, handler: @escaping RequestHandle) {
        let headers: Alamofire.HTTPHeaders = .init(buildHeaders(appendingHeaders: request.appendingHeaders))
        let url: Alamofire.URLConvertible = request.buildURL(endpoint: endpoint)
        
        AF.request(url, headers: headers).responseJSON { response in
            let httpStatusCode: Int = response.response?.statusCode ?? 0
            
            switch response.result {
            case .success(let value):
                handler(.success(.init(value: JSON(value), httpStatusCode: httpStatusCode)))
                
            case .failure(let afError):
                handler(.failure(afError))
            }
        }
    }
    
    private func buildHeaders(appendingHeaders: [String: String]?) -> [String: String] {
        guard let appendingHeaders = appendingHeaders else { return defaultHeaders }
        return defaultHeaders.merging(appendingHeaders) { $1 }
    }
}
