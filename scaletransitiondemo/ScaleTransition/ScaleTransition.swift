//
//
//  ScaleTransition.swift
//
// Copyright (c) 21/02/16. Alex K  (dev.aleksey@yandex.ru)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation
import UIKit

// MARK: ScaleShowTransition

public class ScaleShowTransition: NSObject, Animations {
  
  let duration:   Double
  let scaleValue: Double
    
  init (duration: Double, scale: Double) {
    self.duration   = duration
    self.scaleValue = scale
  }
}

extension ScaleShowTransition: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }

  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    guard let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view else {
      fatalError()
    }
    fromView.tintAdjustmentMode     = .Dimmed
    fromView.userInteractionEnabled = false
    
    guard let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view else {
      fatalError()
    }
    
    guard let containerVeiw = transitionContext.containerView() else { fatalError() }
    
    let blurView = createBlurView(fromView.frame)
    containerVeiw.addSubview(blurView)
    let show = alphaAnimation(0, toValue: 1, duration: duration / 2.0)
    blurView.layer.addAnimation(show, forKey: nil)
    
    toView.center = containerVeiw.center
    toView.layer.addAnimation(show, forKey: nil)
    containerVeiw.addSubview(toView)
  
      
    // scale
    let scale = scaleAnimation(1, toValue: scaleValue, duration: duration / 2.0)
    fromView.layer.addAnimation(scale, forKey: nil)
    transitionContext.completeTransition(true)
  }
}

extension ScaleShowTransition {

  private func createBlurView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    visualEffectView.frame = frame
    view.addSubview(visualEffectView)
    view.accessibilityLabel = "blurView" // create constants enum
//    view.alpha = 0
    return view
  }
}

// MARK: ScaleHideTransition

public class ScaleHideTransition: NSObject, Animations {
  
  let duration  : Double
  let scaleValue: Double
  
  init (duration: Double, scale: Double) {
    self.duration   = duration
    self.scaleValue = scale
  }
}

extension ScaleHideTransition: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view else {
      fatalError()
    }
    let hide = alphaAnimation(1, toValue: 0, duration: duration / 2.0)
    fromView.alpha = 0
    fromView.layer.addAnimation(hide, forKey: nil)
    
    guard let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view else {
      fatalError()
    }
    toView.tintAdjustmentMode     = .Normal
    toView.userInteractionEnabled = true
    
    // scale animation
    let scale = scaleAnimation(scaleValue, toValue: 1, duration: duration / 2.0)
    toView.layer.addAnimation(scale, forKey: nil)

    guard let containerVeiw = transitionContext.containerView() else { fatalError() }
    let blurView = containerVeiw.subviews.filter{$0.accessibilityLabel == "blurView"}.first
    blurView?.alpha = 0
    blurView?.layer.addAnimation(hide, forKey: nil)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        transitionContext.completeTransition(true)
    }
  }
}

// MARK: animations

protocol Animations {
  func scaleAnimation(fromValue: Double, toValue: Double, duration: Double) -> CABasicAnimation
  
  func alphaAnimation(fromValue: Double, toValue: Double, duration: Double) -> CABasicAnimation
}

extension Animations {
  
    func scaleAnimation(fromValue: Double, toValue: Double, duration: Double) -> CABasicAnimation {
        return Init(CABasicAnimation(keyPath: "transform.scale")) {
            $0.fromValue = (fromValue)
            $0.toValue   = (toValue)
            $0.duration  = duration
            $0.fillMode  = kCAFillModeForwards
            $0.removedOnCompletion = false;
        }
    }

    func alphaAnimation(fromValue: Double, toValue: Double, duration: Double) -> CABasicAnimation {
        return Init(CABasicAnimation(keyPath: "opacity")) {
            $0.fromValue = (fromValue)
            $0.toValue   = (toValue)
            $0.duration  = duration
        }
    }
}


// MARK: helpesrs

@warn_unused_result
private func Init<Type>(value : Type, @noescape block: (object: Type) -> Void) -> Type {
  block(object: value)
  return value
}
