//
//  ViewController.swift
//
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



import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: actions
  
  @IBAction func buttonHandler(sender: AnyObject) {

    let storyboard = UIStoryboard(storyboard: .Main)
    
    let detail: DetailViewController = storyboard.instantiateViewController()
    
    
    
    detail.transitioningDelegate = self
    detail.modalPresentationStyle = .Custom
    
    navigationController?.presentViewController(detail, animated: true, completion: nil)
    
  }
}

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