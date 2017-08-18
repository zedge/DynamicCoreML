//
//  ViewController.swift
//  GAN
//
//  Created by Jørgen Henrichsen on 21/06/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    var generator: Generator
    var tools: Tools = Tools()
    var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var modelPath: URL
    private var modelController: ModelController
    
    lazy var mainView: MainView = {
        let view = MainView()
        view.generateButton.addTarget(self, action: #selector(generate), for: .touchUpInside)
        view.compileModelButton.addTarget(self, action: #selector(compileModel), for: .touchUpInside)
        view.decompressModelButton.addTarget(self, action: #selector(decompressModel), for: .touchUpInside)
        view.truncateModelButton.addTarget(self, action: #selector(truncateModel), for: .touchUpInside)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let originalPath = Bundle.main.url(forResource: "mnistStock", withExtension: "mlmodelc") else {
                return nil
        }

        self.modelPath = documentUrl.appendingPathComponent("mnistStock.mlmodelc")
        
        do {
            Tools.deleteFile(atPath: modelPath)
            try FileManager.default.copyItem(at: originalPath, to: modelPath)
        }
        catch let error {
            print(error)
        }
    
        generator = Generator(modelPath)
        modelController = ModelController(at: modelPath, with: generator)
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.frame = view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateImage(generatorIn: generator)
    }
    
    @objc func compileModel() {
        Tools.timeIt {
            modelController.compileModel(with: Bundle.main.url(forResource: "mnistNew", withExtension: "mlmodel")!)
        }
        generateImage(generatorIn: generator)
    }
    
    @objc func decompressModel() {
        Tools.timeIt {
            modelController.decompressModel(with: Bundle.main.url(forResource: "mnistNew.tar", withExtension: "bz2")!)
        }
        generateImage(generatorIn: generator)
    }
    
    @objc func truncateModel() {
        Tools.timeIt {
            modelController.truncateModel(with: Bundle.main.url(forResource: "mnistnew", withExtension: "weights")!)
        }
        generateImage(generatorIn: generator)
    }
    
    @objc func generate() {
        generateImage(generatorIn: generator)
    }
    
    func generateImage(generatorIn: Generator?) {
        guard let generator = generatorIn else {
            return
        }
        
        if let data = generator.generateRandomData(),
            let output = generator.generate(input: data, verbose: true) {
            
            let byteData = tools.convert(output)
            let image = tools.createImage(data: byteData, width: 28, height: 28, components: 1)
            
            // Display Image
            if let image = image {
                DispatchQueue.main.async {
                    self.mainView.imageView.image = UIImage(cgImage: image)
                }
            }
        }
    }
}

