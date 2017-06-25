//
//  swift
//  aMazeTV
//
//  Created by Synesthesia on 13/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Moya
import Gloss
import Moya_Gloss
import RxSwift
import Boomerang
import AlamofireImage

struct TVMaze {
    
    private static let provider = RxMoyaProvider<Service>()
    
    static func searchShow(withQuery query: String) -> Observable<[Show]> {
        if query.isEmpty {
            return .just([])
        }
        return self.provider.request(.searchShows(query: query))
            .mapArray(type: ShowResult.self)
            .map { shows in
                return shows
                    .map { $0.show }
                    .flatMap{ $0 }
            }
            .catchErrorJustReturn([])
    }
    
    static func schedule() -> Observable<[Episode]> {
      
        return self.provider.request(.schedule)
            .mapArray(type: Episode.self)
    }
    
    static func getCast(forShow show: Show) -> Observable<[Actor]> {
        return self.provider.request(.castOfShow(id: show.id))
            .mapArray(type: Actor.self)
            .map { actors in
                print(actors.count)
                return actors.flatMap { $0 } }
            .catchErrorJustReturn([])
    }
    
    static func getShow(id showId: Int) -> Observable<Show> {
        return self.provider.request(.getShow(id: showId))
            .mapObject(type: Show.self)
    }
    
}
