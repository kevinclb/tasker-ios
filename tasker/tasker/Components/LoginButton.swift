//
//  LoginButton.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class LoginButton: UIButton {
    
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

extension LoginButton {
    func setGradientLayer(_ l: CAGradientLayer) -> CAGradientLayer {
        l.frame = self.bounds
        l.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1).cgColor,
            UIColor(red: 0.942, green: 0.942, blue: 0.942, alpha: 1).cgColor,
            UIColor(red: 0.942, green: 0.942, blue: 0.942, alpha: 1).cgColor,
            UIColor(red: 0.917, green: 0.917, blue: 0.917, alpha: 1).cgColor
          ]
        l.locations = [0, 0.19, 1, 1, 1, 1]
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
