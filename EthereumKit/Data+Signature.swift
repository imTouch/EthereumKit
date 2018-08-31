//
//  Data+Signature.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/31.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

extension Data {
    public func sign(_ privateKey: Data) -> Data {
        return Crypto.sign(hash: self, privateKey: privateKey)
    }
}
