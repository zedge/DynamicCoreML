//
//  MainView.swift
//  GAN
//
//  Created by John Chen on 18/08/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    var compileModelButton: UIButton = MainView.createButton(title: "Change model by compiling")
    var decompressModelButton: UIButton = MainView.createButton(title: "Change Model by Decompressing")
    var truncateModelButton: UIButton = MainView.createButton(title: "Change model by weights")
    var generateButton: UIButton = MainView.createButton(title: "Generate")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(compileModelButton)
        compileModelButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        compileModelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(decompressModelButton)
        decompressModelButton.topAnchor.constraint(equalTo: compileModelButton.bottomAnchor, constant: 30).isActive = true
        decompressModelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(truncateModelButton)
        truncateModelButton.topAnchor.constraint(equalTo: decompressModelButton.bottomAnchor, constant: 30).isActive = true
        truncateModelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(generateButton)
        generateButton.topAnchor.constraint(equalTo: truncateModelButton.bottomAnchor, constant: 30).isActive = true
        generateButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return button
    }
    
}
