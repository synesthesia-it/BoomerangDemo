//
//  TVMazeNetwork.swift
//  Maze
//
//  Created by Synesthesia on 17/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Gloss


    
    class Network: Decodable {
        
        let id: Int
        let name: String
        
        required init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
        }
        
    }
    

