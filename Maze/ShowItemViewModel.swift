//
//  ShowItemViewModel.swift
//  Maze
//
//  Created by Synesthesia on 15/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowItemViewModel: ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = Cell.showItem
    
    var id: Int?
    var itemTitle: String?
    var imageUrl: String?
    var image: ObservableImage?
    var networkName: String?
    var status: String?
    
    var description: String?
    
    init(model: Show) {
        self.model = model
        id = model.id
        itemTitle = model.name
        image = model.thumbnail?.get().shareReplay(1)
        networkName = model.network?.name
        status = model.status
        description = [networkName, status].flatMap({ $0 }).joined(separator: " - ")
    }
    
    init(model: Genre) {
        self.model = model
        itemTitle = model
    }
    
}
