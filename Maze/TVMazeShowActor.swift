//
//  TVMazeShowActor.swift
//  Maze
//
//  Created by Cristian Bellomo on 17/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Boomerang
import Gloss

extension TVMaze {
    
    struct Actor: Decodable, ModelType {
        
        let person: TVMaze.Person?
        let character: TVMaze.Character?
        
        init?(json: JSON) {
            person = "person" <~~ json
            character = "character" <~~ json
        }
        
    }
    
    struct Person: Decodable, ModelType {
        
        let id: Int
        let name: String
        var mediumImage: TVMaze.Image?
        
        init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
            if let imgPath: String = "image.medium" <~~ json {
                self.mediumImage = TVMaze.Image(path: imgPath)
            }
        }
        
    }
    
    struct Character: Decodable, ModelType {
        
        let id: Int
        let name: String
        var mediumImage: TVMaze.Image?
        
        init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
            if let imgPath: String = "image.medium" <~~ json {
                self.mediumImage = TVMaze.Image(path: imgPath)
            }
        }
        
    }
    
}
