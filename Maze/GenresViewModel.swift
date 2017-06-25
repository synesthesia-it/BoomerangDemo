//
//  GenresViewModel.swift
//  Maze
//
//  Created by Synesthesia on 17/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum GenreSelectionInput : SelectionInput {
    case item(IndexPath)
}
enum GenreSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class GenresViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Genre else {
            return nil
        }
        return ViewModelFactory.genreItemViewModel(withModel: item)
    }
    
    lazy var selection:Action<GenreSelectionInput,GenreSelectionOutput> = Action<GenreSelectionInput,GenreSelectionOutput> { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? Genre) else {
                return .empty()
            }
            return .empty()
//            let destinationViewModel = __proper_factory_method_here__
//            return .just(.viewModel(destinationViewModel))
        }
    }
    
    
    init(withShow show:Show) {
        let array = show.genres ?? []
        self.dataHolder = ListDataHolder(data: .just(ModelStructure(array)))
    }
}
