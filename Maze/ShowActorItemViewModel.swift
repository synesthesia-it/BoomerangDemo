//
//  ShowActorItemViewModel.swift
//  Maze
//
//  Created by Synesthesia on 17/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowActorItemViewModel : ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = Cell.actorItem
    
    var actorName: String?
    var characterName: String?
    var actorPhoto: ObservableImage?
    
    init(model: Actor) {
        self.model = model
        self.actorName = model.person?.name
        self.characterName = model.character?.name
        self.actorPhoto = model.character?.mediumImage?.get().shareReplay(1)
    }
    
}
