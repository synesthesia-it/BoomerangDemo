//
//  Episode.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Gloss
import Boomerang

class Episode : Decodable, ModelType {

    var show : Show?
    var title: String?
    
    required init?(json:JSON) {

        show = "show" <~~ json
        title = "name" <~~ json
        
    }
}
