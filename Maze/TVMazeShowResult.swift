//
//  TVMazeShowResult.swift
//  Maze
//
//  Created by Synesthesia on 16/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Gloss



    


class ShowResult: Decodable {
    
    let score: Double
    let show: Show
    
    required init?(json:JSON) {
        guard let score: Double = "score" <~~ json,
            let show: Show = "show" <~~ json
            else { return nil }
        
        self.score = score
        self.show = show
    }
    
}


