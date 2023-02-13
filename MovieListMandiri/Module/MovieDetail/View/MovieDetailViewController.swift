//
//  MovieDetailViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxCocoa
import RxSwift
import SkeletonView
import FloatingPanel

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var castingCollectionView: UICollectionView!
    @IBOutlet weak var reviewContentView: UIView!
    @IBOutlet weak var reviewAvatarImageView: UIImageView!
    @IBOutlet weak var reviewNameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet weak var noReviewLabel: UILabel!
    @IBOutlet weak var allReviewBtn: UIButton!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    var presenter: MovieDetailPresenterProtocol?
    
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    var model: ResponseMovieByGenreModel.Result?
    var request, requestCredit: RequestMovieDetailModel?
    var requestReview: RequestReviewModel?
    var detailModel: ResponseMovieDetailModel?
    var reviewModel: ResponseReviewModel?
    var creditModel: ResponseCreditModel?
    var requestVideo: RequestVideoModel?
    var videoModel: ResponseVideoModel?
    
    private let disposeBag = DisposeBag()
    private var readMoreArticleFPC: FloatingPanelController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupButtonAction()
        setupCollectionView()
        dropShadow()
        bindView()
    }
    
    private func setupCollectionView() {
        castingCollectionView.delegate = self
        castingCollectionView.dataSource = self
        let nibName = UINib(nibName: String(describing: CastCollectionViewCell.self), bundle: nil)
        castingCollectionView.register(nibName, forCellWithReuseIdentifier: String(describing: CastCollectionViewCell.self))
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        let nibNameMedia = UINib(nibName: String(describing: MediaCollectionViewCell.self), bundle: nil)
        mediaCollectionView.register(nibNameMedia, forCellWithReuseIdentifier: String(describing: MediaCollectionViewCell.self))
    }
    
    private func showSkeloton() {
        [moviePosterImageView, movieTitleLabel, movieOverviewLabel, reviewAvatarImageView, reviewNameLabel, reviewDateLabel, reviewDescriptionLabel, noReviewLabel, allReviewBtn].forEach {
            $0?.showAnimatedSkeleton()
        }
    }
    
    private func hideSkeloton() {
        [moviePosterImageView, movieTitleLabel, movieOverviewLabel, reviewAvatarImageView, reviewNameLabel, reviewDateLabel, reviewDescriptionLabel, noReviewLabel, allReviewBtn].forEach {
            $0?.hideSkeleton()
        }
    }
    
    private func dropShadow() {
        reviewContentView.layer.cornerRadius = 8
        let grayColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        reviewContentView.layer.borderColor = grayColor.cgColor
        reviewContentView.layer.applySketchShadow(color: grayColor, alpha: 1.0, x: 0, y: 1, blur: 4, spread: 0)
    }
    
    private func setReviewData(_ reviewer: ResponseReviewModel.Result?) {
        if let validReviewer = reviewer {
            var avatarUrl = ""
            if let validaAthorDetails = validReviewer.authorDetails, let validAvatarPath = validaAthorDetails.avatarPath {
                if validAvatarPath.contains("https://") {
                    avatarUrl = validAvatarPath
                } else {
                    avatarUrl = "https://www.themoviedb.org/t/p/w440_and_h660_face\(validAvatarPath)"
                }
                self.reviewAvatarImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(avatarUrl)", placeholder: "img_no_image")
                self.reviewNameLabel.text = "A Review by \(validaAthorDetails.username ?? "")"
                if let validCreatedDate = validReviewer.createdAt, let validDate = CustomDateFormatter.yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ss_dot_SSSZ.dateFromString(validCreatedDate) {
                    let validCreatedString = CustomDateFormatter.MMM_dd_comma_yyyy.stringFromDate(validDate)
                    reviewDateLabel.text = "Written by \(validaAthorDetails.username ?? "") on \(validCreatedString)"
                }
            }
            if let htmlString = validReviewer.content, let attrString = htmlString.htmlToAttributedString {
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ] as [NSAttributedString.Key: Any]
                attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length))
                reviewDescriptionLabel.attributedText = attrString
            } else {
                reviewDescriptionLabel.text = nil
            }
            if reviewDescriptionLabel.numberOfVisibleLines > 7 {
                let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
                let readmoreFontColor = UIColor.blue
                DispatchQueue.main.async {
                    self.reviewDescriptionLabel.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                }
                
                let tap = UITapGestureRecognizer(target: self, action:#selector(tapMore(_:)))
                reviewDescriptionLabel.isUserInteractionEnabled = true
                reviewDescriptionLabel.addGestureRecognizer(tap)
            }
        }
    }
    
    private func setupButtonAction() {
        allReviewBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                if let validModel = weakSelf.reviewModel {
                    weakSelf.presenter?.goToReviewList(model: validModel)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func tapMore(_ sender: UITapGestureRecognizer) {
        readMoreArticleFPC = FloatingPanelControllerHelper.createFloatingPanelController()
        readMoreArticleFPC?.delegate = self
        
        guard let fpc = readMoreArticleFPC else {
            return
        }
        
        let reviewVC = ReviewDetailViewController.loadFromNib()
        if let validModel = reviewModel, let validResult = validModel.results {
            reviewVC.reviewerData = validResult.first
        }
        
        fpc.set(contentViewController: reviewVC)
        present(fpc, animated: true, completion: nil)
    }
    
    private func bindView() {
        if let model = model {
            request = RequestMovieDetailModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            requestReview = RequestReviewModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            requestVideo = RequestVideoModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            requestCredit = RequestMovieDetailModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            presenter?.getMovieDetail(request: request)
        }
        
        self.loadingState.asObservable().observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading, .notLoad, .failed:
                    self.showSkeloton()
                    self.castingCollectionView.showAnimatedSkeleton()
                    self.mediaCollectionView.showAnimatedSkeleton()
                case .finished:
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else { return }
                        self.hideSkeloton()
                        self.castingCollectionView.hideSkeleton()
                        self.castingCollectionView.reloadData()
                        self.mediaCollectionView.hideSkeleton()
                        self.mediaCollectionView.reloadData()
                    }
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castingCollectionView {
            if (creditModel?.cast?.count ?? 0) > 8 {
                return 9
            } else {
                return creditModel?.cast?.count ?? 0
            }
        } else {
            return self.videoModel?.results?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castingCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell {
                if let validModel = creditModel {
                    if indexPath.row == 8 {
                        cell.configureSeeMore()
                    } else {
                        cell.configureCellData(validModel.cast?[indexPath.row])
                    }
                }
                return cell
            }
            return UICollectionViewCell()
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell {
                if let model = videoModel {
                    cell.configureCellData(model.results?[indexPath.row])
                }
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castingCollectionView {
            if indexPath.row == 8 {
                if let validModel = creditModel {
                    presenter?.goToCastList(model: validModel)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castingCollectionView {
            return CGSize(width: castingCollectionView.frame.width/3, height: castingCollectionView.frame.height)
        } else {
            return CGSize(width: mediaCollectionView.frame.width/2, height: mediaCollectionView.frame.height)
        }
    }
}

extension MovieDetailViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == castingCollectionView {
            return String(describing: CastCollectionViewCell.self)
        } else {
            return String(describing: MediaCollectionViewCell.self)
        }
        
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func didSuccessGetVideo(_ model: ResponseVideoModel?) {
        videoModel = model
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func didFailGetVideo(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
    
    func didSuccessGetReview(_ model: ResponseReviewModel?) {
        reviewModel = model
        if let validModel = reviewModel, let validResult = validModel.results {
            DispatchQueue.main.async {
                self.hideSkeloton()
                if validResult.count == 0 {
                    self.noReviewLabel.isHidden = false
                    self.allReviewBtn.isHidden = true
                    self.reviewContentView.isHidden = true
                } else {
                    self.noReviewLabel.isHidden = true
                    self.allReviewBtn.isHidden = false
                    self.reviewContentView.isHidden = false
                    self.setReviewData(validResult.first)
                }
            }
        }
    }
    
    func didFailGetReview(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
    
    func didSuccess(_ model: ResponseMovieDetailModel?) {
        detailModel = model
        if let detailModel = detailModel {
            DispatchQueue.main.async {
                self.hideSkeloton()
                self.navigationItem.title = detailModel.title
                self.movieTitleLabel.text = detailModel.title
                self.movieOverviewLabel.text = "Overview:\n\(detailModel.overview ?? "")"
                if let poster = detailModel.posterPath {
                    self.moviePosterImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(poster)", placeholder: "img_no_image")
                }
                var genderNames = [String]()
                if let genres = detailModel.genres {
                    for genre in genres {
                        if let name = genre.name {
                            genderNames.append(name)
                        }
                    }
                }
                self.movieGenreLabel.text = genderNames.joined(separator: ", ")
            }
        }
    }
    
    func didFail(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
    
    func didSuccessGetCredit(_ model: ResponseCreditModel?) {
        creditModel = model
        DispatchQueue.main.async {
            self.castingCollectionView.reloadData()
        }
    }
    
    func didFailGetCredit(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
}

extension MovieDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FixedHeightLayout(height: UIScreen.main.bounds.height / 1.3)
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.isAttracting == false {
            let loc = fpc.surfaceLocation
            let minY = fpc.surfaceLocation(for: .full).y - 6.0
            let maxY = fpc.surfaceLocation(for: .tip).y + 6.0
            fpc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
}
