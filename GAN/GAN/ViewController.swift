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
    
    var generatorA: Generator?
    var generatorB: Generator?
    var tools: ImageTools = ImageTools()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var generateAButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change model by compiling", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageA), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    
    lazy var generateBButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change model by decompressing", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageB), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    
    lazy var generateTruncateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change model by weights", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageB), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    
    lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Generate image", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageB), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(generateAButton)
        generateAButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        generateAButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(generateBButton)
        generateBButton.topAnchor.constraint(equalTo: generateAButton.bottomAnchor, constant: 30).isActive = true
        generateBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(generateTruncateButton)
        generateTruncateButton.topAnchor.constraint(equalTo: generateBButton.bottomAnchor, constant: 30).isActive = true
        generateTruncateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(generateButton)
        generateButton.topAnchor.constraint(equalTo: generateTruncateButton.bottomAnchor, constant: 30).isActive = true
        generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let url = Bundle(for: Generator.self).url(forResource: "mnistStock", withExtension: "mlmodelc") {
            generatorA = Generator(url)
        }
        
        generateImageA()
    }
    
    @objc func generateImageA() {
        generateImage(generatorIn: generatorA)
    }
    
    @objc func generateImageB() {
        generateImage(generatorIn: generatorB)
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
                    self.imageView.image = UIImage(cgImage: image)
                }
            }
        }
    }
}

