//
//  ViewController.swift
//  SpringTest
//
//  Created by Daichi Nakajima on 2018/07/19.
//  Copyright © 2018年 Daichi Nakajima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func springAnimation() -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.mass = CGFloat(mass.value)
        animation.damping = CGFloat(damping.value)
        animation.stiffness = CGFloat(stiffness.value)

        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fromValue = 0.6
        animation.toValue = 1.0

        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.duration = CFTimeInterval(duration.value)

        print("mass: \(mass.value), damping: \(damping.value), stiffness: \(stiffness.value), duration: \(duration.value)")

        return animation
    }

    var rotationAnimation: CABasicAnimation = {
        var animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.repeatCount = Float.infinity
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.isCumulative = true
        animation.duration = 0.7
        return animation
    }()

    var scaleDownAnimation: CABasicAnimation = {
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.repeatCount = 1
        animation.fromValue = 1
        animation.toValue = 0.7
        animation.isCumulative = true
        animation.duration = 0.15
        return animation
    }()

    var scaleUpAnimation: CABasicAnimation = {
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.repeatCount = 1
        animation.fromValue = 0.7
        animation.toValue = 1
        animation.isCumulative = true
        animation.duration = 0.15
        return animation
    }()

    func fade(show: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.repeatCount = 1
        if show {
            animation.fromValue = 0
            animation.toValue = 1
        } else {
            animation.fromValue = 1
            animation.toValue = 0
        }
        animation.isCumulative = true
        animation.duration = 0.15
        animation.delegate = self
        return animation
    }

    @IBOutlet weak var containerView: UIView! {
        didSet {

            let width: CGFloat = containerView.frame.width
            let startAngle: CGFloat = 0
            let endAngle: CGFloat = CGFloat(Double.pi * 2 * 0.75)
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: width / 2, y: width / 2),
                radius: width / 2 - 5,
                startAngle: startAngle,
                endAngle: endAngle, clockwise: true
            )

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 3

            containerView.layer.addSublayer(shapeLayer)
        }
    }

    @IBOutlet weak var mass: UISlider!
    @IBOutlet weak var damping: UISlider!
    @IBOutlet weak var stiffness: UISlider!
    @IBOutlet weak var duration: UISlider!


    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var stiffnessLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!


    func startAnimation(){
        self.containerView.alpha = 1
        containerView.layer.add(rotationAnimation, forKey: "start1")
        containerView.layer.add(springAnimation(), forKey: "start2")
        containerView.layer.add(fade(show: true), forKey: "start3")

    }
    @IBAction func didTap(_ sender: UIButton) {
        startAnimation()
    }

    @IBAction func didTapStop(_ sender: UIButton) {
        containerView.layer.add(scaleDownAnimation, forKey: "end1")
        containerView.layer.add(fade(show: false), forKey: "end2")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.containerView.alpha = 0

            self.containerView.layer.removeAnimation(forKey: "start1")
            self.containerView.layer.removeAnimation(forKey: "start2")
            self.containerView.layer.removeAnimation(forKey: "start3")

        }
    }

    @IBAction func valueChanged(_ sender: UISlider) {
        if sender == mass {
            massLabel.text = "mass: \(sender.value)"
        } else if sender == damping {
            dampingLabel.text = "damping: \(sender.value)"

        } else if sender == stiffness {
            stiffnessLabel.text = "stiffness: \(sender.value)"

        } else if sender == duration {
            durationLabel.text = "duration: \(sender.value)"
        }
    }

}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("anim: \(anim.debugDescription), flag: \(flag)")
    }
}
