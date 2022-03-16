//
//  CollectionViewController.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import UIKit
import SnapKit

class CollectionViewController: UIViewController {
    
    let connectedService = ConnectImp()
    let dataService = DataServiceImp()
    let cachService = CashNewsImp.shared
//    let imageCache = CashImage.imageCache
//    let newsCache = CashImage.newsCache
    let newsStorage  = NewsDataBaseImp()
    
    private var collectionView : UICollectionView?
    
    var news = [News]()
    var category: String? = nil
    var imageArray = [UIImage]()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        getDate()
    }
    
    private func config(){
        view.backgroundColor = .clear
//        configCash()
        configCollectionView()
    }
    
//    func configCash() {
//        imageCache.countLimit = 100
//    }
    
    private func configCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        self.collectionView = collectionView
    }
        
    func getDate() {
        
        guard let category = category else {return}
        
        if let news = cachService.objectNews(forKey: category) {
            self.news = news
            collectionView?.reloadData()
            
        } else {
            
            if connectedService.checkConnection() {
                
                dataService.receiveData(category: category) {[weak self] news in
                    guard let self = self else {return}
                    self.news = news.sorted{
                        $0.publishedAt.dateFromUTC() < $1.publishedAt.dateFromUTC()
                    }
                    
                    self.newsStorage.clearCategory(category: category)
                    self.newsStorage.addToList(category: category, news: self.news)
                    self.cachService.setObject(news: self.news, forKey: category)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                } error: { error in
//                    print(error as Any)
                }
                
            } else {
                news = newsStorage.fetchNewsFor(category: category)
                cachService.setObject(news: news, forKey: category)
                collectionView?.reloadData()
            }
        }
    }
    
    deinit {
//        print("deinit HourlyViewController")
    }
    
    private func fill(cell: NewsCollectionViewCell, withContent: News, indexPath: IndexPath) -> UICollectionViewCell {
        cell.indexPath = indexPath
        cell.textNews.text = withContent.title
        
        if let imageData = withContent.imageData {
            guard let image = UIImage(data: imageData) else {return cell}
            cell.imageNews.image = image
        } else {
            let keyImage = withContent.urlToImage ?? ""
            
            if let cachedImage = cachService.objectImage(forKey: keyImage) {
                cell.imageNews.image = cachedImage
            } else {
                guard let urlToImage = withContent.urlToImage else {
                    return cell
                }
                dataService.loadImage(url: urlToImage) { [weak self] imageData in
                    guard let self = self else {return}
                    guard let uuid = withContent.uuid else {return}
                    
                    var newsWithImage = withContent
                    newsWithImage.imageData = imageData
                    
                    self.newsStorage.updateNews(id: uuid, news: newsWithImage)
                    
                    guard let image = UIImage(data: imageData) else {return}
                    self.cachService.setObject(image: image, forKey: keyImage)
                
                    if cell.indexPath == indexPath {
                        DispatchQueue.main.async {
                            cell.imageNews.image = image
                        }
                    }
                } error: { error in
    //                print(error as Any)
                }
            }
        }
        return cell
    }
    
    private func prepareWebViewController(startLink: String?) -> WebViewController? {
        guard let link = startLink else {return nil}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller  = storyboard.instantiateViewController(identifier: "WebViewControllerIdent") as? WebViewController {
            controller.modalPresentationStyle = .formSheet
            controller.url = URL(string: link)
            return controller
        } else {
            return nil
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let newsCell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: NewsCollectionViewCell.identifier,
                    for: indexPath) as? NewsCollectionViewCell
        else {return UICollectionViewCell()}
        
        let new = news[indexPath.row]
        let cell = fill(cell: newsCell, withContent: new, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = news[indexPath.row].url
        guard let controller = prepareWebViewController(startLink: url) else {return}
        self.present(controller, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width / 2.5,
                          height: collectionView.frame.size.height)
        return size
    }
}
