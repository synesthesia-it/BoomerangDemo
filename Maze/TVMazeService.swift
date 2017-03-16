//
//  TVMazeService.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Moya
import Boomerang

/*
 Moya Service
 TVMaze API doc: http://www.tvmaze.com/api
 */

extension TVMaze {
    
    enum Service {
        case searchShows(query: String)
    }
    
}

extension TVMaze.Service: TargetType {
    var baseURL: URL { return URL(string: "https://api.tvmaze.com")! }
    
    var path: String {
        switch self {
        case .searchShows:
            return "/search/shows"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchShows:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchShows(let query):
            return ["q": query]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .searchShows:
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        return "Blah blah!".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .searchShows:
            return .request
        }
    }
}
