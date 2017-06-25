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

class ShowTitleItemView: UIView, ViewModelBindable , EmbeddableView{
    
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    var viewModel:ItemViewModelType?
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowTitleItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.title
        self.lbl_description.text = viewModel.description
    }
}
