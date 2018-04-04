//
//  ItunesRouter.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/2/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import Alamofire

public enum ItunesRouter: URLRequestConvertible {
    static let baseURLPath = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums"
    
    case content
    case genere(String)
    
    var method: HTTPMethod {
        switch self {
        case .content:
            return .get
        case .genere:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .content:
            return "/all/10/explicit.json"
        case .genere:
            return "/all/10/explicit.json"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .genere(let genereName):
                return ["content": genereName]
            default:
                return [:]
            }
        }()
        let url = try ItunesRouter.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
    
}
