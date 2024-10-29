//
//  Model.swift
//  Journal
//
//  Created by Reem on 25/04/1446 AH.
//

import SwiftUI

struct Journals: Identifiable {
    let id: UUID = .init()
    var title: String
    var date: String
    var description: String
    var isBookmarked: Bool = false
}
