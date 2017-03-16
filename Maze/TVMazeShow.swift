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

extension TVMaze {
    
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
