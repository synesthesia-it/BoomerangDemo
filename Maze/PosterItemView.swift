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

class PosterItemView: UIView, ViewModelBindable, EmbeddableView {
    
    @IBOutlet weak var img_poster: UIImageView!
    var viewModel:ItemViewModelType?
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? PosterItemViewModel else {
            return
        }
        if (self.isPlaceholder) { return }
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        viewModel.poster.bind(to: self.img_poster.rx.image).disposed(by: disposeBag)
    }
}
