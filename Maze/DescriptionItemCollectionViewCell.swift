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
import BonMot
class DescriptionItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var summary: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? DescriptionItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.summary.styledText = viewModel.string?.replacingOccurrences(of: "\n", with: "")
    }
}
