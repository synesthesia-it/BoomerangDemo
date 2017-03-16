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
    
    static func getShows(withQuery query: String) -> Observable<[TVMaze.Show]> {
        if (query.isEmpty) {
            return .just([])
        }
        return self.provider.request(.searchShows(query: query))
            .mapArray(type: TVMaze.ShowResult.self)
            .map {shows in
                return shows
                    .map { $0.show }
                    .flatMap{ $0 }
            }
            .catchErrorJustReturn([])
    }
    
}
