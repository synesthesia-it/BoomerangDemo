//
//  DescriptionItemViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 22/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang



final class DescriptionItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = Cell.summary
    var string:String?
    init(model: String) {
        self.model = model
        self.string = model
    }
    init(model:TVMaze.Show) {
        self.model = model.summary
        self.string = model.summary
        
    }
}
