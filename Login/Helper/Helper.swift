//
//  Bundle.swift
//  Login
//
//  Created by JINSEOK on 7/10/24.
//

import Foundation

struct Helper {
    
    static func getBundelValue(_ key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else { return "" }
        return value
    }
}
