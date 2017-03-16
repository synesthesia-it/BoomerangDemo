//
//  TVMaze.swift
//  aMazeTV
//
//  Created by Cristian Bellomo on 13/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Moya
import Gloss
import Moya_Gloss
import RxSwift
import Boomerang
import AlamofireImage

struct TvMaze {
    private static let provider = RxMoyaProvider<TVMazeService>()
    
    static func getShows(withQuery query:String) -> Observable<[Show]> {
        if (query.isEmpty) {
            return .just([])
        }
        return self.provider.request(.searchShows(query: query))
            .mapArray(type: TvMaze.ShowResult.self)
            .map {shows in
                return shows
                    .map { $0.show }
                    .flatMap{ $0 }
            }
            .catchErrorJustReturn([])
    }
    
    struct ShowResult: Decodable {
        let score: Double
        let show: Show
        
        init?(json:JSON) {
            guard let score: Double = "score" <~~ json,
                let show: Show = "show" <~~ json
                else { return nil }
            self.score = score
            self.show = show
        }
    }
    
    struct Show: Decodable, ModelType {
        let id: Int
        let name: String
        let image: Image?
        
        init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            self.id = id
            self.name = name
            self.image = "image" <~~ json
        }
    }

    
}
struct Image: Decodable, ImageType {
    static let downloader = {return ImageDownloader()}()
    static func  download(url:String?) -> Observable<UIImage?> {
        guard let url = url else {
            return .just(nil)
        }
        return Observable.create({ observer  in
            let start = Date()
            if let url = URL(string: url) {
                let urlRequest = URLRequest(url:url )
                
                let receipt = downloader.download(urlRequest, completion: { (response) in
                    
                    if let error =  response.result.error{
                        observer.onError(error)
                        //obs.send(error: CustomError(error: error))
                    }
                    if let image = response.result.value {
                        let time = Date().timeIntervalSinceNow - start.timeIntervalSinceNow
//                        image.downloadTime = CGFloat(time)
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                    
                })
                return Disposables.create {
                    if (receipt != nil){
                        downloader.cancelRequest(with: receipt!)
                    }
                }
                
            }
            return Disposables.create()
        })
    }
        let medium: String?
        let original: String?
        func get() -> Observable<UIImage?> {
         return Image.download(url: medium)
        }
        init(json: JSON) {
            self.medium = "medium" <~~ json
            self.original = "original" <~~ json
        }
    }
protocol ImageType {
    func get() -> Observable<UIImage?>
}
extension UIImage: ImageType {
    func get() -> Observable<UIImage?> {
        return .just(self)
    }
}
/*
 Moya Service
 TVMaze API doc: http://www.tvmaze.com/api
 */

enum TVMazeService {
    case searchShows(query: String)
}

extension TVMazeService: TargetType {
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
