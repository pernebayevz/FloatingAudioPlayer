//
//  FloatingWindow.swift
//  FloatingAudioPlayer
//
//  Created by Zhangali Pernebayev on 11/16/20.
//

import UIKit

protocol FloatingAudioPlayerDelegate {
    func point(inside point: CGPoint, with event: UIEvent?, for window: UIWindow) -> Bool
}

extension FloatingAudioPlayerDelegate {
    func point(inside point: CGPoint, with event: UIEvent?, for window: UIWindow) -> Bool { return true }
}

public class FloatingAudioPlayer: UIWindow {

    private static var shared: FloatingAudioPlayer?
    
    var playerViewController: FloatingAudioPlayerViewController {
        return rootViewController as! FloatingAudioPlayerViewController
    }
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        onInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return (rootViewController as? FloatingAudioPlayerDelegate)?.point(inside: point, with: event, for: self) ?? true
    }
    
    private func onInit() {
        isHidden = false
        backgroundColor = nil
        rootViewController = FloatingAudioPlayerViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    public static func play(audioModel: FloatingAudioModel, delegate: FloatingAudioPlayerViewDelegate) {
        if shared == nil {
            shared = FloatingAudioPlayer()
        }
        shared?.playerViewController.floatingAudioPlayerView.play(audioModel: audioModel, delegate: delegate)
    }
    
    public static func dismiss() {
        shared = nil
    }
    
    public static func setAudio(progress: Float) {
        shared?.playerViewController.floatingAudioPlayerView.setAudio(progress: progress)
    }
    
    @objc private func keyboardDidShow(note: NSNotification) {
        windowLevel = UIWindow.Level(rawValue: 0)
        windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }
}
