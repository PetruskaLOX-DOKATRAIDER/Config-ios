//
//  PaginationViewModelStrategies.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PaginatedResponseType {
    associatedtype Content
    var content: [Content] { get }
    var index: Int { get }
    var totalPages: Int { get }
}

extension Page: PaginatedResponseType { }

public enum PaginationViewModelStrategies {
    public enum Comparations {
        public static func alwaysFails<T>(content: [T], page: [T]) -> Bool {
            return false
        }
    }
    
    public enum Accomulations {
        public static func excludeDuplicates<Page: PaginatedResponseType> (content: [Page.Content], page: Page) -> [Page.Content] where Page.Content: Equatable {
            guard page.index != 1 else { return page.content }
            return content + page.content.filter({ !content.contains($0) })
        }
        
        public static func additive<Page: PaginatedResponseType> (content: [Page.Content], page: Page) -> [Page.Content] {
            return page.index <= 1 ? page.content : content + page.content
        }
    }
}
