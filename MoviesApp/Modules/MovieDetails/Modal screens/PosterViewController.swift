//
//  PosterViewController.swift
//  MoviesApp
//
//  Created by anduser on 25.10.2023.
//

import UIKit
import SDWebImage

final class PosterViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    private let path: String
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = Constants.Common.minZoomScale
        scrollView.maximumZoomScale = Constants.Common.maxZoomScale
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    init(path: String) {
        self.path = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        scrollView.delegate = self

        // MARK: Double Tap Gesture
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)

        if let posterURL = URL(string: Constants.URLs.largePicturePath + path) {
            imageView.sd_setImage(with: posterURL, completed: nil)
        } else {
            imageView.image = UIImage(named: Constants.ImageNames.noImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .systemBackground
        scrollView.frame = view.bounds
        imageView.frame = scrollView.bounds
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // MARK: - Double Tap Gesture Handler

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == Constants.Common.minZoomScale {
            let newZoomScale = min(scrollView.maximumZoomScale, scrollView.zoomScale * 1.5)
            let zoomRect = zoomRectForScale(scale: newZoomScale, center: gesture.location(in: imageView))
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(Constants.Common.minZoomScale, animated: true)
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: view)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

