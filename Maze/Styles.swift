//
//  Styles.swift
//  Maze
//
//  Created by Cristian Bellomo on 22/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
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
            .font(.boldSystemFont(ofSize: 14)), .xmlRules([
                .style("p", StringStyle(.color(.black))),
                .style("strong", StringStyle(.color(.red)))
            ])
        ))
    }
    
}
