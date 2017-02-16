//
//  Kingfisher.swift
//  SwiftTest
//
//  Created by GeWei on 2016/12/23.
//  Copyright © 2016年 GeWei. All rights reserved.
//

import Foundation
import Kingfisher

class KingfisherViewController: UICollectionViewController {
    
    init(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 250, height: 250)
        let paddingY:CGFloat = 10
        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        layout.minimumLineSpacing = paddingY
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kingfisher"
        
        let clearButton: UIButton = UIButton()
        clearButton.setTitle("Clear", for:.normal)
        clearButton.addTarget(self, action: #selector(clearCache(sender:)), for: .touchUpInside)
        self.view .addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.leading.equalTo(self.view).offset(15)
            make.top.equalTo(self.view).offset(30)
        }
        
        let reloadButton: UIButton = UIButton()
        reloadButton.setTitle("Reload", for:.normal)
        reloadButton.addTarget(self, action: #selector(reload(sender:)), for: .touchUpInside)
        self.view .addSubview(reloadButton)
        reloadButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.trailing.equalTo(self.view).offset(-15)
            make.top.equalTo(self.view).offset(30)
        }
        
       navigationItem.rightBarButtonItems = [ UIBarButtonItem(customView: reloadButton), UIBarButtonItem(customView: clearButton)]
        
         self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier:"cell")

    }
    
    func clearCache(sender: AnyObject) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    func reload(sender: AnyObject) {
        collectionView?.reloadData()
    }
    
}

extension KingfisherViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This will cancel all unfinished downloading task when the cell disappearing.
       // cell 不存在时无法下载,这里强解包
        (cell as! CollectionViewCell).cellImageView.kf.cancelDownloadTask()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let url = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(indexPath.row + 1).jpg")!
       /*
         Resource: URL遵守的Protocol，一般传入图片的URL，不可为空
         placeholder: 是一个默认的占位图，可为空
         KingfisherOptionsInfo: 是个枚举数组，配置Kingfisher下载图片的一些操作行为,动画
         DownloadProgressBlock: 是个下载进度闭包，可以用于更新下载UI
         completionHandler: 下载完成闭包，闭包参数包含图片，错误，缓存类型，URL 信息

         */
        _ = (cell as! CollectionViewCell).cellImageView.kf.setImage(with: url,
                                                                    placeholder: nil,
                                                                    options: [.transition(ImageTransition.fade(1))],
                                                                    progressBlock: { receivedSize, totalSize in
                                                                        print("\(indexPath.row + 1): receivedSize: \(receivedSize)/ totalSize: \(totalSize)")
        },
                                                                    completionHandler: { image, error, cacheType, imageURL in
                                                                        print("\(indexPath.row + 1): Finished")
        })

      ///FIXME: 使用这个下载器下载的图片?
      /*
         KingfisherOptionsInfo : 常用枚举解析
         这个成员的关联值是一个ImageCache对象。 Kingfisher使用指定的缓存对象处理 相关业务,包括试图检索缓存图像和存储下载的图片。
        case targetCache(ImageCache)
        
        这个成员的关联值应该是一个ImageDownloader对象。Kingfisher将使用这个下载器下载的图片。
        case downloader(ImageDownloader)
        
        如果从网络下载的图片 Kingfisher将使用“ImageTransition这个枚举动画。从内存或磁盘缓存时默认过渡不会发生。如果需要,设置ForceTransition
        case transition(ImageTransition)
        
        有关“浮动”值将被设置为图像下载任务的优先级。值在0.0 ~ 1.0之间。如果没有设置这个选项,默认值(“NSURLSessionTaskPriorityDefault”)将被使用。
        case downloadPriority(Float)
        
        如果设置,将忽略缓存,开启一个下载任务的资源
        case forceRefresh
        
        如果设置 即使缓存的图片也将开启过渡动画
        case forceTransition
        
        如果设置，Kingfisher只会在内存中缓存值而不是磁盘
        case cacheMemoryOnly
        
        如果设置 Kingfisher只会从缓存中加载图片
        case onlyFromCache
    */
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        // WebUR indicatorType indicator  imageTask 属性均使用属性关联技术实现数据的存取
        cell.cellImageView.kf.indicatorType = .activity
        
        return cell
    }
}

extension KingfisherViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.flatMap {
            URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\($0.row + 1).jpg")
        }
        
        ImagePrefetcher(urls: urls).start()
    }
}

