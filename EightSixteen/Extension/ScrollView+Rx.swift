//
//  ScrollView+Rx.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    public var reachedBottom: ControlEvent<Void> {
        let event = base.rx.contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                return y > threshold ? Observable.just(()) : Observable.empty()
            }
        return ControlEvent(events: event)
    }
}
