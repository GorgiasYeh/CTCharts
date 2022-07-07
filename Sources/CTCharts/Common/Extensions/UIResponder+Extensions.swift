//
//  UIResponder.swift
//  
//
//  Created by Gorgias on 2022/6/8.
//

import UIKit

extension UIResponder {
    
    @objc func didSelectPlotDataPoints(_ index: Array.Index) {
        next?.didSelectPlotDataPoints(index)
    }
    
    @objc func beganSelectPlotDataPoints() {
        next?.beganSelectPlotDataPoints()
    }
    
    @objc func endedSelectPlotDataPoints() {
        next?.endedSelectPlotDataPoints()
    }
}
