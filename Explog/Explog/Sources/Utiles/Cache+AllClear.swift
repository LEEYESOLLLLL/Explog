//
//  Cache+AllClear.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Kingfisher

extension ImageCache {
    func allClear() {
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
}
