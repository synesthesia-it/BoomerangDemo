//
//  ShowActorsViewModel.swift
//  Maze
//
//  Created by Synesthesia on 17/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum ShowActorSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum ShowActorSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class ShowActorsViewModel: ListViewModelType, ViewModelTypeSelectable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Actor else {
            return model as? ItemViewModelType
        }
        return ViewModelFactory.actorItemViewModel(withModel: item)
    }
    
    lazy var selection:Action<ShowActorSelectionInput,ShowActorSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? Actor) else {
                return .empty()
            }
            
            return .empty()
//            let destinationViewModel = __proper_factory_method_here__
//            return .just(.viewModel(destinationViewModel))
        }
    }
    
    init(withModel model: Show) {
        let obs = TVMaze.getCast(forShow: model).structured()
        self.dataHolder = ListDataHolder(data: obs)
    }
    
}
