//
//  ViewController07_CustomBackImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController07_CustomBackImage: CustomTableViewController {}

extension ViewController07_CustomBackImage {
    override var nx_backImage: UIImage? {
        return UIImage(systemName: "arrow.left.to.line")
    }
}
