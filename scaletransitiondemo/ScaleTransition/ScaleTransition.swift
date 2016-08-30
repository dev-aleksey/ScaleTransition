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
    
  public init (duration: Double, scale: Double) {
    self.duration   = duration
    self.scaleValue = scale
  }
}

extension ScaleShowTransition: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view else {
      fatalError()
    }
    fromView.tintAdjustmentMode     = .dimmed
    fromView.isUserInteractionEnabled = false
    
    guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
      fatalError()
    }
    
    let containerVeiw = transitionContext.containerView
    
    let blurView = createBlurView(sourceView: fromView)
    containerVeiw.addSubview(blurView)
    let show = alphaAnimation(fromValue: 0, toValue: 1, duration: duration / 2.0)
    blurView.layer.add(show, forKey: nil)
    
    toView.center = containerVeiw.center
    toView.layer.add(show, forKey: nil)
    containerVeiw.addSubview(toView)
  
      
    // scale
    let scale = scaleAnimation(fromValue: 1, toValue: scaleValue, duration: duration / 2.0)
    fromView.layer.add(scale, forKey: nil)
    transitionContext.completeTransition(true)
  }
}

extension ScaleShowTransition {

  fileprivate func createBlurView(sourceView: UIView) -> UIView {
    
    let blurView = createBlurView(frame: sourceView.bounds)
    sourceView.addSubview(blurView)
    defer {
      blurView.removeFromSuperview()
    }
    guard let snapShot = sourceView.snapshotView(afterScreenUpdates: true) else {
      return blurView
    }
    snapShot.accessibilityLabel = "blurView"

    return snapShot
    
  }
  
  fileprivate func createBlurView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    visualEffectView.frame = frame
    view.addSubview(visualEffectView)
    return view
  }
}

// MARK: ScaleHideTransition

public class ScaleHideTransition: NSObject, Animations {
  
  let duration  : Double
  let scaleValue: Double
  
  public init (duration: Double, scale: Double) {
    self.duration   = duration
    self.scaleValue = scale
  }
}

extension ScaleHideTransition: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view else {
      fatalError()
    }
    let hide = alphaAnimation(fromValue: 1, toValue: 0, duration: duration / 2.0)
    fromView.alpha = 0
    fromView.layer.add(hide, forKey: nil)
    
    guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
      fatalError()
    }
    toView.tintAdjustmentMode     = .normal
    toView.isUserInteractionEnabled = true
    
    // scale animation
    let scale = scaleAnimation(fromValue: scaleValue, toValue: 1, duration: duration / 2.0)
    toView.layer.add(scale, forKey: nil)

    let containerVeiw = transitionContext.containerView
    let blurView = containerVeiw.subviews.filter{$0.accessibilityLabel == "blurView"}.first
    blurView?.alpha = 0
    blurView?.layer.add(hide, forKey: nil)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
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
        return Init(value: CABasicAnimation(keyPath: "transform.scale")) {
            $0.fromValue = (fromValue)
            $0.toValue   = (toValue)
            $0.duration  = duration
            $0.fillMode  = kCAFillModeForwards
            $0.isRemovedOnCompletion = false;
        }
    }

    func alphaAnimation(fromValue: Double, toValue: Double, duration: Double) -> CABasicAnimation {
        return Init(value: CABasicAnimation(keyPath: "opacity")) {
            $0.fromValue = (fromValue)
            $0.toValue   = (toValue)
            $0.duration  = duration
        }
    }
}


// MARK: helpesrs

private func Init<Type>(value : Type, block: (_ object: Type) -> Void) -> Type {
  block(value)
  return value
}
