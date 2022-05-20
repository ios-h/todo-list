//
//  NSNotification+Extension.swift
//  TODOList
//
//  Created by 안상희 on 2022/05/19.
//

import Foundation

extension NSNotification.Name {
    static let memoDidAdd = NSNotification.Name("MemoDidAddNotification")
    static let memoDidUpdate = NSNotification.Name("MemoDidUpdateNotification")
    static let memoDidDelete = NSNotification.Name("MemoDidDeleteNotification")
    static let networkError = NSNotification.Name("Network Error")
}
