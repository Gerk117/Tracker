//
//  File.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 31.01.2024.
//


import SnapKit
import UIKit

final class OnboardingPageView: UIPageViewController {
    private var pages: [UIViewController] = {
        let first = OnboardingViewController()
        first.setupViewContent(imageName: "background1",
                               labelText: "Отслеживайте только\n то, что хотите")
        let second = OnboardingViewController()
        second.setupViewContent(imageName: "background2",
                                labelText: "Даже если это\n не литры воды и йога")
        return [first, second]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = pages.count
        page.currentPage = 0
        page.isEnabled = false
        page.currentPageIndicatorTintColor = UIColor.black
        page.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageControl)
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-168)
        }
    }
    
    
}

extension OnboardingPageView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
    
    
}

extension OnboardingPageView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
