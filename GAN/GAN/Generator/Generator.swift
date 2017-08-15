//
//  Generator.swift
//  GAN
//
//  Created by Jørgen Henrichsen on 21/06/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import Foundation
import CoreML


class Generator {
    
    let model: mnistStock?
    
    init(_ urlOfModel: URL) {
        self.model = try? mnistStock(contentsOf: urlOfModel)
    }
    
    /**
     * Generate some random data that can be used as input for the MLModel.
     */
    func generateRandomData() -> MLMultiArray? {
        guard let input = try? MLMultiArray(shape: [100], dataType: MLMultiArrayDataType.double) else {
            return nil
        }
        
        for i in 0...99 {
            let number = 2 * Double(Float(arc4random()) / Float(UINT32_MAX)) - 1
            input[i] = NSNumber(floatLiteral: number)
        }
        
        return input
    }
    
    
    /**
     * Use the model to generate picture data.
     */
    func generate(input: MLMultiArray, verbose: Bool = false) -> MLMultiArray? {
        if let generated = try? model?.prediction(input1: input) {
            
            return generated?.output1
        }
        return nil
    }
}

