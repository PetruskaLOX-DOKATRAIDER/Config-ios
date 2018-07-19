//
//  Date+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension Date {
    func daysBetweenDate(_ date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: date).day
    }
}
