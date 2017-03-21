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

struct TVMaze {
    
    private static let provider = RxMoyaProvider<TVMaze.Service>()
    
    static func searchShow(withQuery query: String) -> Observable<[TVMaze.Show]> {
        if query.isEmpty {
            return .just([])
        }
        return self.provider.request(.searchShows(query: query))
            .mapArray(type: TVMaze.ShowResult.self)
            .map { shows in
                return shows
                    .map { $0.show }
                    .flatMap{ $0 }
            }
            .catchErrorJustReturn([])
    }
    
    static func getCast(forShow show: TVMaze.Show) -> Observable<[TVMaze.Actor]> {
        return self.provider.request(.castOfShow(id: show.id))
            .mapArray(type: TVMaze.Actor.self)
            .map { actors in
                print(actors.count)
                return actors.flatMap { $0 } }
            .catchErrorJustReturn([])
    }
    
    static func getShow(id showId: Int) -> Observable<TVMaze.Show> {
        return self.provider.request(.castOfShow(id: showId))
            .mapObject(type: TVMaze.Show.self)
    }
    
}
