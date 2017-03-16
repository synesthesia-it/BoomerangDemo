//
//  TVMazeShowResult.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Gloss

extension TVMaze {
    
    struct ShowResult: Decodable {
        
        let score: Double
        let show: Show
        
        init?(json:JSON) {
            guard let score: Double = "score" <~~ json,
                let show: Show = "show" <~~ json
                else { return nil }
            
            self.score = score
            self.show = show
        }
        
    }
    
}

struct ShowResult: Decodable {
    
    let score: Double
    let show: TVMaze.Show
    
    init?(json:JSON) {
        guard let score: Double = "score" <~~ json,
            let show: TVMaze.Show = "show" <~~ json
            else { return nil }
        
        self.score = score
        self.show = show
    }
    
}
