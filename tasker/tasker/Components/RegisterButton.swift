//
//  RegisterButton.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class RegisterButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadowAndGradient()
    }
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        return setGradientLayer(l)
    }()
}

extension RegisterButton {
    func setGradientLayer(_ l: CAGradientLayer) -> CAGradientLayer {
        l.frame = self.bounds
        l.colors = [
            UIColor(red: 0, green: 0.712, blue: 0.632, alpha: 0.71).cgColor,
            UIColor(red: 0.009, green: 0.683, blue: 0.607, alpha: 1).cgColor
        ]
        l.locations = [0, 1]
        l.startPoint = CGPoint(x: 0.25, y: 0.5)
        l.endPoint = CGPoint(x: 0.75, y: 0.5)
        l.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer.insertSublayer(l, at: 0)
        return l
    }
    
    func setShadowAndGradient() {
        gradientLayer.frame = bounds
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            shadowLayer.cornerRadius = 20
            self.layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}
