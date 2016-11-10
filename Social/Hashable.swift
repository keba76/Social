//
//  Hashable.swift
//  Social
//
//  Created by Ievgen Keba on 11/10/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import Foundation

class HashableWrapper<T>: Hashable {
    let object: T
    let equal: (_ obj1: T,_ obj2: T) -> Bool
    let hash: (_ obj: T) -> Int
    
    var hashValue:Int {
        get {
            return self.hash(self.object)
        }
    }
    init(obj: T, equal:@escaping (_ obj1: T, _ obj2: T) -> Bool, hash: @escaping (_ obj: T) -> Int) {
        self.object = obj
        self.equal = equal
        self.hash = hash
    }
    
}

func ==<T>(lhs:HashableWrapper<T>, rhs:HashableWrapper<T>) -> Bool
{
    return lhs.equal(lhs.object,rhs.object)
}
