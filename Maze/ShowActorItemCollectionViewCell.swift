//
//  CollectionViewCell.swift
//  
//
//  Created by Stefano Mondino on 07/03/17.
//
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class ShowActorItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var actorPhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowActorItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.actorName.text = viewModel.actorName
        if let charName = viewModel.characterName {
            self.characterName.text = "as \(charName)"
        }
    }
    
}
