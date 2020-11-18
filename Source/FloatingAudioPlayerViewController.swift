//
//  FloatingAudioPlayerViewController.swift
//  FloatingAudioPlayer
//
//  Created by Zhangali Pernebayev on 11/12/20.
//

import UIKit

class FloatingAudioPlayerViewController: UIViewController {

    @IBOutlet weak var floatingAudioPlayerView: FloatingAudioPlayerView!
    @IBOutlet weak var floatingAudioPlayerViewBottomConstraint: NSLayoutConstraint!
    
    init() {
        super.init(nibName: "FloatingAudioPlayerViewController", bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        floatingAudioPlayerView.isUserInteractionEnabled = true
        floatingAudioPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:))))
    }
}

extension FloatingAudioPlayerViewController {
    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        floatingAudioPlayerViewBottomConstraint.constant -= offset.y
        floatingAudioPlayerView.layoutIfNeeded()
        
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }
    
    private func snapButtonToSocket() {
        let bottomMin: CGFloat = 0
        let bottomMax: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height - floatingAudioPlayerView.bounds.height
        var bottom = floatingAudioPlayerViewBottomConstraint.constant
        if bottom < bottomMin {
            bottom = bottomMin
        }else if bottom > bottomMax {
            bottom = bottomMax
        }
        floatingAudioPlayerViewBottomConstraint.constant = bottom
        floatingAudioPlayerView.layoutIfNeeded()
    }
}

extension FloatingAudioPlayerViewController: FloatingAudioPlayerDelegate {
    func point(inside point: CGPoint, with event: UIEvent?, for window: UIWindow) -> Bool {
        let viewPoint = window.convert(point, to: floatingAudioPlayerView)
        return floatingAudioPlayerView.point(inside: viewPoint, with: event)
    }
}
