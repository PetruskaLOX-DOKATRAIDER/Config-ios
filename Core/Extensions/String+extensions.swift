//
//  String+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 07.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension String {
    func contains(find: String) -> Bool{
        return range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return range(of: find, options: .caseInsensitive) != nil
    }
}
