//
//  ViewController.swift
//  Imgur
//
//  Created by Marcio Izar Bastos de Oliveira on 03/09/20.
//  Copyright © 2020 Marcio Izar Bastos de Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topWeekLabel: UILabel!
    @IBOutlet weak var onlyEBackView: UIView!
    @IBOutlet weak var onlyPrototypeLabel: UILabel!
    @IBOutlet weak var backToMenuLabel: UILabel!
    @IBOutlet weak var imagensCollectionView: UICollectionView!
    @IBOutlet weak var loadErrorView: UIView!
    @IBOutlet weak var reloadTotalImageView: UIImageView!
    @IBOutlet weak var ohFailedLabel: UILabel!
    
    var imgur2: Imgur?
    var isLandscape: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLabels()
        setupReloadTotalImageView()

        if let layout = self.imagensCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
            print("Portraitmode!")
            isLandscape = true
        } else {
            isLandscape = false
        }

        let imgurD = ImgurDados()
        imgurD.getListaImagens(completion: { imgur in
            if imgur == nil {
                DispatchQueue.main.async {
                    if imgurD.isError {
                        self.loadErrorView.isHidden = false
                    } else {
                        self.loadErrorView.isHidden = true
                    }
                }
            } else {
                self.imgur2 = imgur
                DispatchQueue.main.async {
                    if imgurD.isError {
                        self.loadErrorView.isHidden = false
                    } else {
                        self.loadErrorView.isHidden = true
                    }
                    self.imagensCollectionView.reloadData()
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var quantidade: Int = 1
        if imgur2 != nil {
            quantidade = imgur2!.data.count
        }
        return quantidade
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "normalCell", for: indexPath) as? ImagensCollectionViewCell
        setupReloadImageView(cell!)
  
        cell?.sociaisView.backgroundColor = UIColor(red: 0x47/256, green: 0x4A/256, blue: 0x51/256, alpha: 1)
        cell?.comentarioView.backgroundColor = UIColor(red: 0x47/256, green: 0x4A/256, blue: 0x51/256, alpha: 1)
        
        cell?.blocoAbaixoView.backgroundColor = UIColor(red: 0x47/256, green: 0x4A/256, blue: 0x51/256, alpha: 1)
        cell?.blocoAbaixoView.layer.cornerRadius = 5
        cell?.blocoAbaixoView.layer.borderWidth = 0
        
        cell?.fotoImageView.layer.cornerRadius = 5
        cell?.fotoImageView.layer.borderWidth = 0

        setupItensCellCollection(cell!)
                
        if imgur2 != nil {
            cell?.balanceLabel.text = imgur2!.data[indexPath.row].points?.description
            cell?.balanceLabel.text = imgur2!.data[indexPath.row].points?.description
            cell?.comentLabel.text = imgur2!.data[indexPath.row].comment_count?.description
            cell?.viewsLabel.text = imgur2!.data[indexPath.row].views?.description

            var urlImagem = URL(string: "http://")

            //estrutura raiz
            if imgur2!.data[indexPath.row].type != nil {
                if let strUrl = imgur2!.data[indexPath.row].link {
                    cell?.reloadImageView.isHidden = false
                    cell?.reloadContainerView.isHidden = false
                    urlImagem = URL(string: strUrl)!
                    //imagem na estrutura raiz
                    if (imgur2!.data[indexPath.row].type?.contains("image"))! {
                        self.downloadImage(from: urlImagem!, to: cell!)
                        cell?.reloadImageView.isHidden = true
                        cell?.reloadContainerView.isHidden = true
                    //video na estrutura raiz
                    } else {
                        self.getThumbnailImageFromVideoUrl(url: URL(string: strUrl)!) { (thumbImage) in
                            cell?.fotoImageView.image = thumbImage
                            cell?.reloadImageView.isHidden = true
                            cell?.reloadContainerView.isHidden = true
                        }
                    }
                //Erro - nao encontrada estrutura
                } else {
                    cell?.reloadImageView.isHidden = false
                    cell?.reloadContainerView.isHidden = false
                    print("outro raiz - \(imgur2!.data[indexPath.row].images?[0].type ?? "nenhum type")")
                }
            //estrutura images
            } else {
                if let strUrl = imgur2!.data[indexPath.row].images?[0].link {
                    cell?.reloadImageView.isHidden = false
                    cell?.reloadContainerView.isHidden = false
                    urlImagem = URL(string: strUrl)!
                    //imagem na estrutura images
                    if (imgur2!.data[indexPath.row].images?[0].type?.contains("image"))! {
                        self.downloadImage(from: urlImagem!, to: cell!)
                        cell?.reloadImageView.isHidden = true
                        cell?.reloadContainerView.isHidden = true
                    //vídeo na estrutura images
                    } else {
                        self.getThumbnailImageFromVideoUrl(url: URL(string: strUrl)!) { (thumbImage) in
                            cell?.fotoImageView.image = thumbImage
                            cell?.reloadImageView.isHidden = true
                            cell?.reloadContainerView.isHidden = true
                        }
                    }
                //Erro - nao encontrada estrutura
                } else {
                    cell?.reloadImageView.isHidden = false
                    cell?.reloadContainerView.isHidden = false
                    print("outro - \(imgur2!.data[indexPath.row].images?[0].type ?? "nenhum type")")
                }
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat
        let leftAndRightPaddings: CGFloat

        if isLandscape {
            numberOfItemsPerRow = 2.0
            leftAndRightPaddings = 26.0

        } else {
            numberOfItemsPerRow = 1.0
            leftAndRightPaddings = 0.0
        }
    
        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: 234)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         super.viewWillTransition(to: size, with: coordinator)

        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
        } else {
            isLandscape = false
        }
        setupReloadTotalImageView()
        imagensCollectionView.reloadData()
    }
    
    private func setupItensCellCollection(_ cell: ImagensCollectionViewCell) {
        cell.balanceLabel.textColor = UIColor(red: 0xAF/256, green: 0xAF/256, blue: 0xAF/256, alpha: 1)
        cell.balanceLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        cell.comentLabel.textColor = UIColor(red: 0xAF/256, green: 0xAF/256, blue: 0xAF/256, alpha: 1)
        cell.comentLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        cell.viewsLabel.textColor = UIColor(red: 0xAF/256, green: 0xAF/256, blue: 0xAF/256, alpha: 1)
        cell.viewsLabel.font = UIFont(name: "SFPro-Regular", size: 14)
    }
    
    private func setupLabels() {
        view.backgroundColor = UIColor(red: 0x2C/256, green: 0x2E/256, blue: 0x33/256, alpha: 1)
        imagensCollectionView.backgroundColor = UIColor(red: 0x2C/256, green: 0x2E/256, blue: 0x33/256, alpha: 1)
        
        onlyEBackView.backgroundColor = UIColor(red: 0x2C/256, green: 0x2E/256, blue: 0x33/256, alpha: 1)
        
        topWeekLabel.font = UIFont(name: "SFPro-Bold", size: 30)
        topWeekLabel.textColor = .white
        onlyPrototypeLabel.font = UIFont(name: "SFPro-Regular", size: 10)
        onlyPrototypeLabel.textColor = .white
        backToMenuLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        backToMenuLabel.textColor = .white
        
        ohFailedLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        ohFailedLabel.textColor = UIColor(red: 0xBC/256, green: 0xBC/256, blue: 0xBC/256, alpha: 1)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, to cell: ImagensCollectionViewCell) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                cell.fotoImageView.image = UIImage(data: data)
            }
        }
    }

    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    func setupReloadTotalImageView() {
        loadErrorView.backgroundColor = UIColor(red: 0x2C/256, green: 0x2E/256, blue: 0x33/256, alpha: 1)
        
        reloadTotalImageView.layer.borderWidth = 1
        reloadTotalImageView.backgroundColor = UIColor(red: 0x2C/256, green: 0x2E/256, blue: 0x33/256, alpha: 1)
        reloadTotalImageView.layer.borderColor = UIColor(red: 0xE3/256, green: 0xE3/256, blue: 0xE3/256, alpha: 1).cgColor
        reloadTotalImageView.setRounded()
    }
    

    func setupReloadImageView(_ cell: ImagensCollectionViewCell) {
        cell.reloadContainerView.backgroundColor = UIColor(red: 0xA0/256, green: 0xA0/256, blue: 0xA0/256, alpha: 1)
        cell.reloadContainerView.layer.cornerRadius = 5
        cell.reloadContainerView.layer.borderWidth = 0
        
        cell.reloadImageView.layer.borderWidth = 1
        cell.reloadImageView.backgroundColor = .clear
        cell.reloadImageView.layer.borderColor = UIColor(red: 0xE3/256, green: 0xE3/256, blue: 0xE3/256, alpha: 1).cgColor
        cell.reloadImageView.setRounded()
    }
}

extension UIImageView {
   func setRounded() {
    let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}

