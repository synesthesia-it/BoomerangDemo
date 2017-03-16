//
//  ShowItemViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 15/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowItemViewModel: ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = Cell.showItem
    var itemTitle: String?
    var imageUrl: String?
    
    init(model: TVMaze.Show) {
        self.model = model
        self.itemTitle = model.name
        self.imageUrl = model.image?.medium
    }
    
}
