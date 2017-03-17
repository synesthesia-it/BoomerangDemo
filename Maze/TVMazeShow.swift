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
        var thumbnail: TVMaze.ShowImage?
        var original: TVMaze.ShowImage?
        var genres:[Genre]?
        init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.genres = "genres" <~~ json
            self.name = name
            if let thumbPath:String = "image.medium" <~~ json {
                self.thumbnail = TVMaze.ShowImage(path: thumbPath)
            }
        }
        
    }
    
}
