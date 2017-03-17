//
//  ShowDetailViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 17/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum ShowDetailSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum ShowDetailSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class ShowDetailViewModel : ListViewModelType, ViewModelTypeSelectable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    var model: TVMaze.Show
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        return model as? ItemViewModelType
//        guard let item = model as? ShowDetail else {
//            return nil
//        }
//        return ViewModelFactory.__proper_factory_method_here()
    }
    
    lazy var selection : Action<ShowDetailSelectionInput,ShowDetailSelectionOutput> = Action { input in
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
    
    init(model:TVMaze.Show) {
        self.model = model
    }
}
