//
//  DetailItemViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 21/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class DetailItemViewModel: ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = ""
    
    init(model: TVMaze.Show) {
        self.model = model
    }
    
}
