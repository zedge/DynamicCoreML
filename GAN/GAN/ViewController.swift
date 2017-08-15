//
//  ViewController.swift
//  GAN
//
//  Created by Jørgen Henrichsen on 21/06/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import UIKit
import CoreML
import BZipCompression

class ViewController: UIViewController {
    
    var generatorA: Generator?
    var generatorB: Generator?
    
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
        button.setTitle("Generate with A", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageA), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    
    lazy var generateBButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Generate with B", for: .normal)
        button.addTarget(self, action: #selector(self.generateImageB), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }()
    
    let bitMapInfo: CGBitmapInfo = DeviceInformation.simulator ? .floatComponents : .byteOrder16Little
    let bitsPerComponent: Int = DeviceInformation.simulator ? 32 : 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(generateAButton)
        generateAButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        generateAButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(generateBButton)
        generateBButton.topAnchor.constraint(equalTo: generateAButton.bottomAnchor, constant: 30).isActive = true
        generateBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let url = Bundle(for: Generator.self).url(forResource: "mnistStock", withExtension: "mlmodelc") {
            generatorA = Generator(url)
        }
        
        print("Starting compilation of .mlmodel file")
        var startTime = UInt64(NSDate().timeIntervalSince1970 * 1000)
        if let url = Bundle(for: ViewController.self).url(forResource: "mnistNew", withExtension: "mlmodel") {
            print("Found MLModel", url)
            do {
                let mdl = try MLModel.compileModel(at: url)
                print(UInt64(NSDate().timeIntervalSince1970 * 1000) - startTime)
                generatorB = Generator(mdl)
            } catch { }
        }
        
        print("Starting decompression using BZip2")
        startTime = UInt64(NSDate().timeIntervalSince1970 * 1000)
        if let url = Bundle(for: Generator.self).url(forResource: "mnistNew.tar", withExtension: "bz2") {
            print("Found BZ2")
            do {
                let data = try Data(contentsOf: url)
                print("Got data", url, data.count)
                let _ = try BZipCompression.decompressedData(with: data)
                print(UInt64(NSDate().timeIntervalSince1970 * 1000) - startTime)
            }
            catch {
                print("Failed to coerce Data")
            }
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
            
            let byteData = convert(output)
            let image = createImage(data: byteData, width: 28, height: 28, components: 1)
            
            // Display Image
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(cgImage: image)
                }
            }
        }
    }
    
    
    /**
     * Convert a MLMultiarray, containig Doubles, to a bytearray.
     */
    func convert(_ data: MLMultiArray) -> [UInt8] {
        
        var byteData: [UInt8] = []
        
        for i in 0..<data.count {
            let out = data[i]
            let floatOut = out as! Float32
            
            if DeviceInformation.simulator {
                let bytesOut = toByteArray((floatOut + 1.0) / 2.0)
                byteData.append(contentsOf: bytesOut)
            }
            else {
                let byteOut: UInt8 = UInt8((floatOut * 127.5) + 127.5)
                byteData.append(byteOut)
            }
        }
        
        return byteData
        
    }
    
    
    /**
     * Create a CGImage from a bytearray.
     */
    func createImage(data: [UInt8], width: Int, height: Int, components: Int) -> CGImage? {
        
        let colorSpace: CGColorSpace
        switch components {
        case 1:
            colorSpace = CGColorSpaceCreateDeviceGray()
            break
        case 3:
            colorSpace = CGColorSpaceCreateDeviceRGB()
            break
        default:
            fatalError("Unsupported number of components per pixel.")
        }
        
        let cfData = CFDataCreate(nil, data, width*height*components*bitsPerComponent / 8)!
        let provider = CGDataProvider(data: cfData)!
        
        let image = CGImage(width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent, //
            bitsPerPixel: bitsPerComponent * components, //
            bytesPerRow: ((bitsPerComponent * components) / 8) * width, // comps
            space: colorSpace,
            bitmapInfo: bitMapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent)!
        
        return image
        
    }
    
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }


}

