//
//  GenreItemViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 17/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class GenreItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = Cell.genre
    var title:String?
    init(model: Genre) {
        self.model = model
        self.title = model
    }
}
