//
//  DetailsViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 21/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum DetailSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum DetailSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class DetailsViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? TVMaze.Show else {
            return nil
        }
        return ViewModelFactory.showItemViewModel(withModel: item)
    }
    
    lazy var selection:Action<DetailSelectionInput,DetailSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex: indexPath) as? TVMaze.Show) else {
                return .empty()
            }
            let destinationViewModel = ViewModelFactory.showItemViewModel(withModel: model)
            return .just(.viewModel(destinationViewModel))
        }
    }
    
    
    init() {
        
    }
}
