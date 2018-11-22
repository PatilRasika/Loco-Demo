//
//  ViewController.swift
//  Video
//
//

import UIKit


class ViewController: UIViewController,CAAnimationDelegate {
    
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var circularView: UIView!
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
        self.perform(#selector(fadeIn), with: nil, afterDelay: 5.0)
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
    
    func addCircleView(animateIn:Bool) {
        if(animateIn == true){
            self.circleView.frame.size.height = 0
            self.circleView.frame.size.width = 0
            self.circleView.center =  self.circularView.center
            
        }else {
            circleView.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 0, height: 0)
        }
        
        let maskPath = UIBezierPath(ovalIn: self.circleView.frame)
        
        // define the masking layer to be able to show that circle animation
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.frame
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        
        // define the end frame
        let bigCirclePath = UIBezierPath(ovalIn: CGRect(x: self.view.frame.origin.x - 400, y: self.view.frame.origin.y - 400, width: self.view.frame.width + 1000 , height: self.view.frame.height + 1000 ))
        
        // create the animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = maskPath.cgPath
        pathAnimation.toValue = bigCirclePath
        pathAnimation.duration = 0.5
        maskLayer.path = bigCirclePath.cgPath
        maskLayer.add(pathAnimation, forKey: "pathAnimation")
    }
    
    func loadview(){
        self.videoView.frame = self.view.frame
        self.videoView.layer.cornerRadius = 0.0
    }
   
    
    // MARK: Method to animate the video to full screen view
    
    func fadeOut() {
        self.perform(#selector(self.loadview), with: nil, afterDelay: 0.01)
        addCircleView(animateIn: true)
        self.perform(#selector(self.fadeIn), with: nil, afterDelay: 5.0)
    }
    
    // MARK: Method to animate the video to circular view
    
    func fadeIn() {
        self.addCircleView(animateIn: false)
        self.videoView.frame.size.height = CGFloat(videoHeight)
        self.videoView.frame.size.width = CGFloat(videoWidth)
        self.videoView.center =  self.circularView.center
        self.videoView.layer.cornerRadius = self.videoView.frame.size.width/2
        self.view.bringSubview(toFront: self.videoView)
        self.videoView.clipsToBounds = true
        self.videoView.playerLayer?.needsDisplayOnBoundsChange = true
        self.cardView.isHidden = false
        self.circularView.isHidden = false
        self.perform(#selector(self.fadeOut), with: nil, afterDelay: 5.0)
    }
}



