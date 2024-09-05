//
//  DetailViewController.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
   // func showImage(image: UIImage?)
}

class DetailViewController: UIViewController {

    var presenter: DetailPresenterProtocol?
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        presenter?.viewDidLoaded()
        initialize()
        addSubviews()
        setupLayout()
    }

}

private extension DetailViewController {
    func initialize() {
        
    }
    
    func addSubviews() {
        view.addSubview(imageView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)

           ])
    }
}

extension DetailViewController: DetailViewProtocol {
    
    func showImage(image: UIImage?) {
//        DispatchQueue.main.async {
//            self.imageView.image = image
//        }
    }
}

