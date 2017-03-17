//
//  TVMazeNetwork.swift
//  Maze
//
//  Created by Cristian Bellomo on 17/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Gloss

extension TVMaze {
    
    struct Network: Decodable {
        
        let id: Int
        let name: String
        
        init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
        }
        
    }
    
}
