//
//  TVMazeShow.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Boomerang
import Gloss
typealias Genre = String

extension TVMaze {
    
    struct Show: Decodable, ModelType {
        
        let id: Int
        let name: String
        let summary: String
        let status: String?
        var thumbnail: TVMaze.Image?
        var network: TVMaze.Network?
        var genres: [Genre]?
        var actors:[TVMaze.Actor]?
        var _embedded: TVMaze.Embedded?
        
        init?(json: JSON) {
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
                self.thumbnail = TVMaze.Image(path: thumbPath)
            }
            self._embedded = "_embedded" <~~ json
            self.actors = "_embedded.cast" <~~ json
        }
        
    }

    struct Embedded: Decodable, ModelType {
        
        var cast: [TVMaze.Actor]?
        
        init?(json: JSON) {
            self.cast = "cast" <~~ json
        }
        
    }

    
}
