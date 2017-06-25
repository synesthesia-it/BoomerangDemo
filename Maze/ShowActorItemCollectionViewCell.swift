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
        self.actorPhoto.layer.cornerRadius = 25
        self.actorPhoto.layer.masksToBounds = true
    }
    
    func bind(to viewModel: ViewModelType?) {
        self.disposeBag = DisposeBag()
        
        guard let viewModel = viewModel as? ShowActorItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.actorName.text = viewModel.actorName
        
            self.characterName.text =  viewModel.characterName
        
        
        self.disposeBag = DisposeBag()
        viewModel.actorPhoto?
            .bind(to:self.actorPhoto.rx.image)
            .disposed(by:self.disposeBag)
    }
    
}
