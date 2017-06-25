//
//  TVMazeShow.swift
//  Maze
//
//  Created by Synesthesia on 16/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Gloss
import DateToolsSwift

typealias Genre = String


    
    class Show: Decodable, ModelType {
        static let dateFormatter:DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        let id: Int
        let name: String
        let summary: String
        let status: String?
        var thumbnail: Image?
        var poster: Image?
        var network: Network?
        var genres: [Genre]?
        var actors:[Actor]?
        var seasons:[Season]?
        var episodes:[Episode]?
        var premiereDate: Date?
        var _embedded: Embedded?
        var year:String? {
            guard let y = self.premiereDate?.year else { return nil }
            return String(describing:y)
        }
        required init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
            self.summary = ("summary" <~~ json) ?? ""
            self.status = "status" <~~ json
            self.network = "network" <~~ json
            self.genres = "genres" <~~ json
            if let thumbPath: String = "image.medium" <~~ json {
                self.thumbnail = Image(path: thumbPath)
            }
            if let posterPath: String = "image.original" <~~ json {
                self.poster = Image(path: posterPath)
            }
            self._embedded = "_embedded" <~~ json
            self.actors = "_embedded.cast" <~~ json
            self.episodes = "_embedded.episodes" <~~ json
            self.seasons = "_embedded.seasons" <~~ json
            self.seasons?.forEach { season in
                season.episodes = self.episodes?.filter { $0.seasonNumber == season.number }
            }
            
            self.premiereDate = Decoder.decode(dateForKey: "premiered", dateFormatter:Show.dateFormatter)(json)
        }
        
    }

    struct Embedded: Decodable, ModelType {
        
        var cast: [Actor]?
        
        init?(json: JSON) {
            self.cast = "cast" <~~ json
        }
        
    }

    

