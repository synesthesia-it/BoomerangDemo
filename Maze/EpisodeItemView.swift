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

class EpisodeItemView: UIView, ViewModelBindable, EmbeddableView {
    
    var viewModel:ItemViewModelType?
    var disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var img_poster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? EpisodeItemViewModel else {
            return
        }
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.title
        self.lbl_subtitle.text = viewModel.subtitle
        if self.isPlaceholder { return }
        viewModel.poster.bind(to: img_poster.rx.image).disposed(by: disposeBag)
    }
}
