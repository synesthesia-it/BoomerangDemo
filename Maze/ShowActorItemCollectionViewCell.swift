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
    
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowActorItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.actorName.text = viewModel.actorName
        if let charName = viewModel.characterName {
            self.characterName.text = "as \(charName)"
        }
        
        self.disposeBag = DisposeBag()
        viewModel.actorPhoto?
            .bindTo(self.actorPhoto.rx.image)
            .addDisposableTo(self.disposeBag)
    }
    
}
