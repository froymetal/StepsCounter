//
//  Steps.swift
//  StepsCounter
//
//  Created by Froy on 9/18/21.
//

import Foundation

struct Step: Identifiable{
    let id = UUID()
    let count: Int
    let date: Date
}
