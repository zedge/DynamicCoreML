//
//  ModelController.swift
//  GAN
//
//  Created by John Chen on 15/08/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import Foundation
import CoreML
import BZipCompression


/**
 * AI model controller
 **/
class ModelController{
    
    let fileManager = FileManager.default

    let modelPath: URL
    let generator: Generator
    
    init(at modelPath: URL, with generator: Generator) {
        self.modelPath = modelPath
        self.generator = generator
        
    }
    
    func truncateModel(with newWeightAddress: URL) {
        Tools.replaceFile(at: modelPath.appendingPathComponent("model.espresso.weights"), withFileAt: newWeightAddress)
        generator.setModel(with: modelPath)
    }
    
    func decompressModel(with newModelAddress: URL){
        print("Starting decompression using BZip2")
        do {
            let data = try Data(contentsOf: newModelAddress)
            print("Got data", newModelAddress, data.count)
            let tarData = try BZipCompression.decompressedData(with: data)

            print("Unpacking to " + modelPath.absoluteString)
            let tempPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            try fileManager.createFilesAndDirectories(at: tempPath, withTarData: tarData, progress: { (progress) in
                print(progress)
            })
            print("Finished decompressing")
            
            Tools.replaceFile(at: modelPath, withFileAt: tempPath.appendingPathComponent("mnistNew.mlmodelc"))
            generator.setModel(with: modelPath)
        }
        catch {
            print("Failed to coerce Data")
        }
    }
    
    func compileModel(with newModelAddress: URL) {
        if let compiledAddress = try? MLModel.compileModel(at: newModelAddress){
            Tools.replaceFile(at: modelPath, withFileAt: compiledAddress)
            generator.setModel(with: modelPath)
        }
    }
    

}
