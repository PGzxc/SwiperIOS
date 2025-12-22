import SwiftUI
import UIKit

struct VerticalPageView<Content: View>: UIViewControllerRepresentable {
    var pages: [Content]
    @Binding var currentIndex: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        // Explicitly set interPageSpacing to 0 to remove gaps between videos
        let options: [UIPageViewController.OptionsKey: Any] = [
            .interPageSpacing: 0
        ]
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .vertical,
            options: options
        )
        
        pvc.dataSource = context.coordinator
        pvc.delegate = context.coordinator
        
        context.coordinator.controllers = pages.map { content in
            // Apply ignoresSafeArea to the SwiftUI view inside UIHostingController
            // This ensures the content extends to the very edges of the hosting controller's view
            let host = UIHostingController(rootView: content.ignoresSafeArea())
            host.view.backgroundColor = .clear
            return host
        }
        
        if let first = context.coordinator.controllers.first {
            pvc.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        
        pvc.view.backgroundColor = .clear
        
        // Remove scroll indicators and ensure scroll view background is clear
        for sub in pvc.view.subviews {
            sub.backgroundColor = .clear
            if let sv = sub as? UIScrollView {
                sv.showsVerticalScrollIndicator = false
                sv.contentInsetAdjustmentBehavior = .never // Important: Prevent auto-insetting
            }
        }
        
        return pvc
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        // Handle external index changes if necessary, but be careful of loops
        // For now, we assume gesture-driven navigation updates the binding via Coordinator
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: VerticalPageView
        var controllers: [UIViewController] = []

        init(_ parent: VerticalPageView) {
            self.parent = parent
            super.init()
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            NotificationCenter.default.post(name: .verticalPageWillTransition, object: nil)
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
            return controllers[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController), index + 1 < controllers.count else { return nil }
            return controllers[index + 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard completed, let visible = pageViewController.viewControllers?.first, let index = controllers.firstIndex(of: visible) else { return }
            parent.currentIndex = index
            NotificationCenter.default.post(name: .verticalPageDidShow, object: nil, userInfo: ["index": index])
            NotificationCenter.default.post(name: .verticalPageDidEndTransition, object: nil)
        }
    }
}

extension Notification.Name {
    static let verticalPageDidShow = Notification.Name("VerticalPageViewDidShowPage")
    static let verticalPageWillTransition = Notification.Name("VerticalPageViewWillTransition")
    static let verticalPageDidEndTransition = Notification.Name("VerticalPageViewDidEndTransition")
}
