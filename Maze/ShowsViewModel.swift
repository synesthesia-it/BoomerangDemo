//
//  ShowsViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 15/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Boomerang

enum ShowSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum ShowSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class ShowsViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let model = model as? TVMaze.Show else {
            return nil
        }
        return ShowItemViewModel(model:model)
        
        //ViewModelFactory.__proper_factory_method_here()
    }
    
    lazy var selection:Action<ShowSelectionInput,ShowSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? TVMaze.Show) else {
                return .empty()
            }
            return .empty()
//            let destinationViewModel = __proper_factory_method_here__
//            return .just(.viewModel(destinationViewModel))
        }
    }
    
    
    init() {
        let obs = TVMaze.getShows(withQuery: "Alias").structured()
        self.dataHolder = ListDataHolder(data:obs)
    }
}
