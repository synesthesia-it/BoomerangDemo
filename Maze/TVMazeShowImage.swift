//
//  TVMazeShowImage.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Gloss

extension TVMaze {

    struct ShowImage: Decodable {
        
        let medium: String?
        let original: String?
        
        init(json: JSON) {
            self.medium = "medium" <~~ json
            self.original = "original" <~~ json
        }
        
    }

}
