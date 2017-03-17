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
    var image:ObservableImage?
    var networkName: String?
    var status: String?
    
    var description: String?
    
    init(model: TVMaze.Show) {
        self.model = model
        self.itemTitle = model.name
        self.image = model.thumbnail?.get().shareReplay(1)
        self.networkName = model.network?.name
        self.status = model.status
        self.description = [self.networkName, self.status].flatMap({ $0 }).joined(separator: " - ")
    }
    
    init(model: String) {
        self.model = model
        self.itemTitle = model
    }
    
}
