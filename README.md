# ScaleTransition

![Animation](Source/ScaleTransition.gif)

## Requirements

- iOS 8.0+
- Xcode 7.2

## Installation

Just add the ScaleTransition.swift file to your project.

## Usage


``` swift
// create viewcontroller
let storyboard = UIStoryboard(storyboard: .Main)
let detail: DetailViewController = storyboard.instantiateViewController()
    
// configure transition    
detail.transitioningDelegate = self
detail.modalPresentationStyle = .Custom

// presentViewController    
navigationController?.presentViewController(detail, animated: true, completion: nil)
```

``` swift
// MARK: transition delegate
extension ViewController: UIViewControllerTransitioningDelegate {
  
  func animationControllerForPresentedController(presented: UIViewController,
                           presentingController presenting: UIViewController,
                                   sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                                    
    return ScaleShowTransition(duration: 0.5, scale: 0.9)
  }

  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScaleHideTransition(duration: 0.5, scale: 0.9)
  }
}
```

## Licence

Folding cell is released under the MIT license.
See [LICENSE](./LICENSE) for details.

## About
