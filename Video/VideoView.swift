//
//  VideoView.swift
//  Video
//


import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override var frame: CGRect {
        didSet {
            //rescaling of video layer
            
            if(bounds.size.width<=100)
            {
                playerLayer?.frame.size.width = 90
                playerLayer?.frame.size.height = (playerLayer!.frame.size.width) * 1.7
            }
            else{
                playerLayer?.frame = bounds
            }
            playerLayer?.videoGravity = AVLayerVideoGravityResize
        }
    }
    
    
    // MARK: Configure the Video View
    
    func configure() {
        guard let path = Bundle.main.path(forResource: "videoplayback", ofType:"mp4") else {
            debugPrint("video not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.needsDisplayOnBoundsChange = true
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    // MARK: Play the Video
    
    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            player?.play()
        }
        else
        {
            debugPrint("video unable to play")
        }
    }
    
    // MARK: Pause the Video
    
    func pause() {
        player?.pause()
    }
    
    // MARK: Stop the Video
    
    func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
    }
    
    // MARK: Video Completion listner method
    
    func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: kCMTimeZero)
            player?.play()
        }
    }
}
