//
//  DetailItemViewModel.swift
//  Maze
//
//  Created by Synesthesia on 21/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class DetailItemViewModel: ItemViewModelType {
    
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = ""
    
    init(model: Show) {
        self.model = model
    }
    
}
