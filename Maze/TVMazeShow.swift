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
typealias Genre = String


    
    class Show: Decodable, ModelType {
        
        let id: Int
        let name: String
        let summary: String
        let status: String?
        var thumbnail: Image?
        var network: Network?
        var genres: [Genre]?
        var actors:[Actor]?
        var _embedded: Embedded?
        
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
            self._embedded = "_embedded" <~~ json
            self.actors = "_embedded.cast" <~~ json
        }
        
    }

    struct Embedded: Decodable, ModelType {
        
        var cast: [Actor]?
        
        init?(json: JSON) {
            self.cast = "cast" <~~ json
        }
        
    }

    

