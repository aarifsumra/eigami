//
//  RxDataSources+Sectioned.swift
//  shibi
//
//  Created by Aarif Sumra on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import RxDataSources

struct Group<T> {
    var header: String
    var items: [Item]
}

extension Group: SectionModelType {
    typealias Item = T
    
    init(original: Group<T>, items: [Item]) {
        self = original
        self.items = items
    }
}
