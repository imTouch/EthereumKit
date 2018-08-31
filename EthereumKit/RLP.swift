//
//  RLP.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/16.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation
import RLP_ObjC

public enum RLPError : Error {
    case decode
    case encode
}

public struct RLP {
    static func encode(_ data: [Data]) -> Data {
        return rlp_encode(data)
    }
    
    static func decode(_ serialized: Data) throws -> [Data] {
        guard let decoded = rlp_decode(serialized) as? [Data] else {
            throw RLPError.decode
        }
        return decoded
    }
}
