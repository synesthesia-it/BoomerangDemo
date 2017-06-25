//
//  Styles.swift
//  Maze
//
//  Created by Synesthesia on 22/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import BonMot

enum Styles: String {
    case summary
    
    var value: String {
        return self.rawValue
    }
    
    static func setup() {
        NamedStyles.shared.registerStyle(forName: Styles.summary.value, style: StringStyle(
            .color(.black),
            .font(Font.ralewayRegular(14).font), .xmlRules([
                .style("p", StringStyle(.color(.black))),
                .style("strong", StringStyle(.color(.red)))
            ])
        ))
    }
    
}
