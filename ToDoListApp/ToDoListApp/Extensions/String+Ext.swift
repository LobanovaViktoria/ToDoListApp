//
//  String+Ext.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
