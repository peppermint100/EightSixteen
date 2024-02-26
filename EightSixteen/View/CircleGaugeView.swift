//
//  FastingCircleView.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import UIKit

class CircleGaugeView: UIView {
    
    static let animationDuration = 1.0
    static let lineWidth: CGFloat = 30
    var greenPathOccupationRatio: CGFloat = 0.5
    
    private lazy var redLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 30
        layer.strokeColor = UIColor.red.cgColor
        layer.frame = bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        return layer
    }()
    
    private lazy var greenLayer: CAShapeLayer = {
         let layer = CAShapeLayer()
         layer.lineWidth = 30
         layer.strokeColor = UIColor.green.cgColor
         layer.fillColor = UIColor.clear.cgColor
         layer.lineCap = .round
         layer.frame = bounds
         return layer
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let mid = 0.8 + greenPathOccupationRatio * 1.4
        let redPath = UIBezierPath(arcCenter: center, radius: radius - CircleGaugeView.lineWidth / 2, startAngle: .pi * 0.8, endAngle: .pi * 0.2, clockwise: true)
        redLayer.path = redPath.cgPath
        layer.addSublayer(redLayer)
        
        let greenPath = UIBezierPath(arcCenter: center, radius: radius - CircleGaugeView.lineWidth / 2, startAngle: .pi * 0.8, endAngle: .pi * mid, clockwise: true)
        greenLayer.path = greenPath.cgPath
        layer.addSublayer(greenLayer)
        
        animateGreenLayer()
    }
    
    private func animateGreenLayer() {
        let greenLayerAnimation = CABasicAnimation(keyPath: "strokeEnd")
        greenLayerAnimation.fromValue = 0
        greenLayerAnimation.toValue = 1
        greenLayerAnimation.duration = CircleGaugeView.animationDuration
        greenLayerAnimation.fillMode = .forwards
        greenLayerAnimation.isRemovedOnCompletion = false
            
        greenLayer.add(greenLayerAnimation, forKey: "foregroundAnimation")
    }
}
