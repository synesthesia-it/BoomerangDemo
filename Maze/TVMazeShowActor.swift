//
//  TVMazeShowActor.swift
//  Maze
//
//  Created by Synesthesia on 17/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Gloss


    
    class Actor: Decodable, ModelType {
        
        let person: Person?
        let character: Character?
        
        required init?(json: JSON) {
            person = "person" <~~ json
            character = "character" <~~ json
        }
        
    }
    
    class Person: Decodable, ModelType {
        
        let id: Int
        let name: String
        var mediumImage: Image?
        
        required init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
            if let imgPath: String = "image.medium" <~~ json {
                self.mediumImage = Image(path: imgPath)
            }
        }
        
    }
    
    class Character: Decodable, ModelType {
        
        let id: Int
        let name: String
        var mediumImage: Image?
        
        required init?(json: JSON) {
            guard let name: String = "name" <~~ json,
                let id: Int = "id" <~~ json
                else { return nil }
            
            self.id = id
            self.name = name
            if let imgPath: String = "image.medium" <~~ json {
                self.mediumImage = Image(path: imgPath)
            }
        }
        
    }
    

