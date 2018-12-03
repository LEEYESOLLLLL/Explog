//
//  Data+Decode_Encode.swift
//  Explog
//
//  Created by Minjun Ju on 02/12/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver

extension Data {
    func decode<T: Codable>(type: T.Type) -> T? {
        guard let decoded = try? JSONDecoder().decode(type, from: self) else {
            SwiftyBeaver.verbose("Fail to decode from data")
            return nil
        }
        return decoded
    }
}

extension Encodable {
    func encodeJSON() -> Data? {
        let copy = self
        guard let encoded = try? JSONEncoder().encode(copy) else {
            SwiftyBeaver.verbose("Fail to encode from data")
            return nil
        }
        return encoded
    }
}
