//
//  ShowActorItemViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 17/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowActorItemViewModel : ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = Cell.actorItem
    
    var actorName: String?
    var characterName: String?
    
    init(model: TVMaze.Actor) {
        self.model = model
        self.actorName = model.person?.name
        self.characterName = model.character?.name
    }
    
}
