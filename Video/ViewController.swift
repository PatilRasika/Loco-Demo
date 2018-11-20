//
//  ViewController.swift
//  Video
//
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var circularView: UIView!
    var circleLayer: CAShapeLayer = CAShapeLayer()
    var circleView:UIView = UIView()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoView()
        setupCardView()
        
    }
    
    // MARK: Method to setup Video View
    
    func setupVideoView(){
        videoView.configure()
        self.videoView.frame = self.view.frame
        videoView.isLoop = true
        videoView.play()
        self.perform(#selector(fadeIn(withDuration:)), with: nil, afterDelay: 5.0)
    }
    
    // MARK: Method to setup Card View
    
    func setupCardView()  {
        cardView.layer.cornerRadius = 20.0
        circularView.layer.cornerRadius = self.circularView.frame.width/2
        circularView.layer.borderWidth = 10.0
        let borderColor = UIColor(displayP3Red: 94.0/255.0, green: 34.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        circularView.layer.borderColor = borderColor.cgColor
        cardView.isHidden = true
        circularView.isHidden = true
    }
    
    // MARK: Methods for animation
    
    func addCircleView() {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        let circleWidth = CGFloat(200)
        let circleHeight = circleWidth
        
        // Create a new CircleView
        circleView.frame = CGRect(x: diceRoll, y: 0, width: circleWidth, height: circleHeight)
        view.addSubview(circleView)
        // Animate the drawing of the circle over the course of 1 second
        animateCircle(duration: 1.0)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e The speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // Right value when the animation ends
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.fillColor = UIColor.gray.cgColor
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    // MARK: Method to animate the video to full screen view
    
    func fadeOut(withDuration duration: TimeInterval = 0.5) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.videoView.frame = self.view.frame
            self.videoView.layer.cornerRadius = 0.0
        }, completion: {
            (value: Bool) in
            self.perform(#selector(self.fadeIn(withDuration:)), with: nil, afterDelay: 5.0)
        })
    }
    
    // MARK: Method to animate the video to circular view
    
    func fadeIn(withDuration duration: TimeInterval = 0.3) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.addCircleView()
            self.videoView.frame.size.height = 90
            self.videoView.frame.size.width = 90
            self.videoView.center =  self.circularView.center
            self.videoView.layer.cornerRadius = self.videoView.frame.size.width/2
            self.view.bringSubview(toFront: self.videoView)
            self.videoView.clipsToBounds = true
            self.videoView.playerLayer?.needsDisplayOnBoundsChange = true
            self.cardView.isHidden = false
            self.circularView.isHidden = false
        }, completion: {
            (value: Bool) in
            self.perform(#selector(self.fadeOut(withDuration:)), with: nil, afterDelay: 5.0)
            
        })
    }
}



