//
//  Episode.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Gloss
import Boomerang


class Episode : Decodable, ModelType {
    
    var show : Show?
    var title: String?
    var seasonNumber: Int?
    var number:Int?
    required init?(json:JSON) {
        
        show = "show" <~~ json
        title = "name" <~~ json
        seasonNumber = "season" <~~ json
        number = "number" <~~ json
    }
}


class Season : Decodable, ModelType {

    var show : Show?
    var title: String?
    var number: Int?
    var summary:String?
    var episodeCount: Int?
    var episodes:[Episode]?
    var thumbnail: Image?
    var poster: Image?
    required init?(json:JSON) {

        show = "show" <~~ json
        title = "name" <~~ json
        summary = "summary" <~~ json
        number = "number" <~~ json
        episodeCount = "episodeOrder" <~~ json
        
        if let thumbPath: String = "image.medium" <~~ json {
            self.thumbnail = Image(path: thumbPath)
        }
        if let posterPath: String = "image.original" <~~ json {
            self.poster = Image(path: posterPath)
        }
        
    }
}
