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
    
    init(modelPath: URL, generator: Generator) {
        self.modelPath = modelPath
        self.generator = generator
    }
    
    func decompressModel(with newModelAddress: URL){
        print("Starting decompression using BZip2")
        if let url = Bundle(for: Generator.self).url(forResource: "mnistNew.tar", withExtension: "bz2") {
            print("Found BZ2")
            do {
                let data = try Data(contentsOf: url)
                print("Got data", url, data.count)
                let tarData = try BZipCompression.decompressedData(with: data)
                try FileManager.default.createFilesAndDirectories(at: modelPath, withTarData: tarData, progress: { (progress) in
                    print(progress)
                })
            }
            catch {
                print("Failed to coerce Data")
            }
        }
        generator.setModel(with: modelPath)
    }
    
    func compileModel(with newModelAddress: URL) {
        if let compiledAddress = try? MLModel.compileModel(at: newModelAddress){
            replaceModel(with: compiledAddress)
        }
    }
    
    private func replaceModel(with newModel: URL) {
        do {
            try fileManager.copyItem(at: newModel, to: modelPath)
            generator.setModel(with: modelPath) // Refresh
        }
        catch {}
    }
}
