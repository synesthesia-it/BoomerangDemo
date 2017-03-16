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

class ShowItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var viewModel: ItemViewModelType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.itemTitle
        viewModel.image?.get().bindTo(image.rx.image).addDisposableTo(self.disposeBag)
    }
}
