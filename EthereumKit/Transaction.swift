//
//  Transaction.swift
//  EthereumKit
//
//  Created by Liu Pengpeng on 2018/8/31.
//  Copyright © 2018年 Crypto Touch. All rights reserved.
//

import Foundation

/*
 * @property {Data} raw The raw rlp encoded transaction
 * @param {Data} data.nonce nonce number
 * @param {Data} data.gasLimit transaction gas limit
 * @param {Data} data.gasPrice transaction gas price
 * @param {Data} data.to to the to address
 * @param {Data} data.value the amount of ether sent
 * @param {Data} data.data this will contain the data of the message or the init of a contract
 * @param {Data} data.v EC recovery ID
 * @param {Data} data.r EC signature parameter
 * @param {Data} data.s EC signature parameter
 * @param {Data} data.chainId EIP 155 chainId - mainnet: 1, ropsten: 3
 * */
public struct Transaction {
    public let raw: Data
    
    var nonce: Data { return try! RLP.decode(raw)[0] }
    var gasLimit: Data { return try! RLP.decode(raw)[1] }
    var gasPrice: Data { return try! RLP.decode(raw)[2] }
    var to: Data { return try! RLP.decode(raw)[3] }
    var value: Data { return try! RLP.decode(raw)[4] }
    var data: Data { return try! RLP.decode(raw)[5] }
    var v: Data { return try! RLP.decode(raw)[6] }
    var r: Data { return try! RLP.decode(raw)[7] }
    var s: Data { return try! RLP.decode(raw)[8] }
    
    public init(_ data: [Data], privateKey: Data) throws {
        let tx = RLP.encode(data).sha3(.keccak256)
        
        let sig = try Signature(txHash, privateKey: privateKey)
        
        tx.append(sig.v);
        tx.append(sig.r)
        tx.append(sig.s);
        
        self.raw = RLP.encode(decoded)
    }
    
    public init(_ serialized: Data, privateKey: Data) throws {
        var decoded = try RLP.decode(serialized)
        decoded = Array(decoded[0..<6])
        
        let txHash = RLP.encode(decoded).sha3(.keccak256)
        
        let sig = try Signature(txHash, privateKey: privateKey)
        
        decoded.append(sig.v);
        decoded.append(sig.r)
        decoded.append(sig.s);

        self.raw = RLP.encode(decoded)
    }
    
    public func isValid(addressTo: String, amount: Decimal) -> Bool {
        var value = amount
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return data == self.to && Data(hex: addressTo) == to
    }
}
