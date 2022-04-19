//
//  UserDefaultsUtils.swift
 //
//  Created by YuliangTao on 16/2/26.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

let firstEntry = "firstEntry"

public func objectForKey(key: String) -> AnyObject? {
    let userDefaults = UserDefaults()
    return userDefaults.object(forKey: key) as AnyObject
}

public func stringForKey(key: String) -> String? {
    var value: String?
    let userDefaults = UserDefaults()
    value = userDefaults.string(forKey: key) as String?
    return value
}

public func doubleForKey(key: String) -> Double? {
    var value: Double?
    let userDefaults = UserDefaults()
    value = userDefaults.double(forKey: key) as Double?
    return value
}

public func intForKey(key: String) -> Int? {
    var value: Int?
    let userDefaults = UserDefaults()
    value = userDefaults.integer(forKey: key) as Int?
    return value
}

func boolForKey(key: String) -> Bool {
    var value = false
    let userDefaults = UserDefaults()
    value = userDefaults.bool(forKey: key)
    return value
}

func setValueForKey(value: AnyObject?, key: String) {
    let userDefaults = UserDefaults()
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}

func setStringValueForKey(value: String?, key: String) {
    let userDefaults = UserDefaults()
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}
func setIntValueForKey(value: Int?, key: String) {
    let userDefaults = UserDefaults()
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}

func removeValueForKey(key: String) {
    let userDefaults = UserDefaults()
    userDefaults.removeObject(forKey: key)
    //userDefaults.remove(key)
}

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    for key in dictionary.keys {
        defaults.removeObject(forKey: key)
    }
    defaults.synchronize()
}
