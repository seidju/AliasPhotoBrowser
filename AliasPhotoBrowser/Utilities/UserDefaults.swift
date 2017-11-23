//
//  UserDefaults.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import Foundation

func getFromSettings(key: String) -> AnyObject? {
  let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
  return UserDefaults.standard.object(forKey: "\(appName).\(key)") as AnyObject?
}

//Set settings to user defaults
func setToSettings(key: String, value: AnyObject) {
  let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
  UserDefaults.standard.set(value, forKey: "\(appName).\(key)")
  UserDefaults.standard.synchronize()
}
