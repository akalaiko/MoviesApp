//
//  TrailerPlayer.swift
//  MoviesApp
//
//  Created by anduser on 25.10.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

final class TrailerPlayer: UIViewController, YTPlayerViewDelegate {
    
    // MARK: - Properties
    
    private var playerView: YTPlayerView?
    private let videoId: String

    // MARK: - Initialization

    init(videoId: String) {
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        playerView = YTPlayerView()
        playerView?.delegate = self
        view = playerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let playerVars: [String: Any] = [
            "playsinline": 1,
            "autoplay": 1,
        ]

        playerView?.load(withVideoId: videoId, playerVars: playerVars)
    }

    // MARK: - YTPlayerViewDelegate
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

