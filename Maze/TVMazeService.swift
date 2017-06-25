//
//  TVMazeService.swift
//  Maze
//
//  Created by Synesthesia on 16/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Moya
import Boomerang

/*
 Moya Service
 TVMaze API doc: http://www.tvmaze.com/api
 */


    
    enum Service {
        case searchShows(query: String)
        case getShow(id: Int)
        case castOfShow(id: Int)
        case schedule
    }
    


extension Service: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.tvmaze.com")! }
    
    var path: String {
        switch self {
        case .schedule :
            return "schedule"
        case .searchShows:
            return "/search/shows"
        case .getShow(let id):
            return "/shows/\(id)"
        case .castOfShow(let id):
            return "/shows/\(id)/cast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchShows(let query):
            return ["q": query]
        case .getShow:
            return ["embed": ["episodes", "cast"]]
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        return "Blah blah!".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        default:
            return .request
        }
    }
    
}
