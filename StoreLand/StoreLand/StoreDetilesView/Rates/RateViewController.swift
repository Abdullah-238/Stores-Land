import UIKit

class RateViewController: UIViewController
{

    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var btnStar1: UIButton!
    @IBOutlet weak var btnStar2: UIButton!
    @IBOutlet weak var btnStar3: UIButton!
    @IBOutlet weak var btnStar4: UIButton!
    @IBOutlet weak var btnStar5: UIButton!
    
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var txtComment: UITextField!
    
    private var ratingValue: UInt8 = 0
    var storeId: Int!
    private var starButtons: [UIButton] = []
    private var isRated = false
    private var rate: RateDTO!
    private var oldRating: UInt8 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        starButtons = [btnStar1, btnStar2, btnStar3, btnStar4, btnStar5]
        
        setupStarButtons()
        updateStars(rating: 0)
        
        Task {
            await loadRating()
        }
    }

    private func setupStarButtons() {
        for (index, button) in starButtons.enumerated() {
            button.tag = index + 1
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
        }
    }

    @objc func starTapped(_ sender: UIButton) {
        updateStars(rating: sender.tag)
    }

    @IBAction func btnRateTapped(_ sender: UIButton) {
        Task {
            if isRated {
                await updateRate()
            } else {
                await addRate()
            }
        }
    }

    private func updateStars(rating: Int) {
        for (index, button) in starButtons.enumerated() {
            let isFilled = index < rating
            let imageName = isFilled ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.tintColor = isFilled ? .systemYellow : .lightGray
        }
        ratingValue = UInt8(rating)
    }

    private func loadRating() async {
        guard let personID = clsGlobal.person?.personID else { return }

        do {
            isRated = try await clsRate.IsRateExistsByStoreAndPerson(storeID: storeId, personID: personID)

            if isRated {
                rate = try await clsRate.GetRateByStoreAndPerson(storeID: storeId, personID: personID)

                DispatchQueue.main.async {
                    self.btnRate.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
                    self.oldRating = self.rate.rate ?? 0
                    self.txtComment.text = self.rate.comment
                    self.ratingValue = self.rate.rate ?? 0
                    self.updateStars(rating: Int(self.ratingValue))
                }
            }
        } catch {
            print("Failed to load rate: \(error)")
        }
    }

    private func updateRate() async {
        rate.comment = txtComment.text ?? ""
        rate.rate = ratingValue

        do {
            let updatedStoreRating = try await clsStore.updateStoreRatingWithOldRate(
                rate: ratingValue,
                oldRate: oldRating,
                storeID: storeId
            )

            if updatedStoreRating,
               try await clsRate.UpdateRate(rateID: rate.rateID!, rate: rate) {
                DispatchQueue.main.async {
                    self.btnRate.isEnabled = false
                    clsAlertHelper.showAlert(from: self, title: "Success", message: "Your rating has been updated successfully.")
                }
            }
        } catch {
            print("Failed to update rate: \(error)")
        }
    }

    private func addRate() async {
        guard let personID = clsGlobal.person?.personID else { return }

        let comment = txtComment.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let newRate = RateDTO(
            RateID: 0,
            StoreID: storeId,
            Comment: comment,
            Rate: ratingValue,
            PersonID: personID
        )

        do {
            if try await clsRate.AddRate(newRate) != nil,
               try await clsStore.updateStoreRating(rate: ratingValue, storeID: storeId) {
                DispatchQueue.main.async {
                    self.btnRate.isEnabled = false
                    clsAlertHelper.showAlert(from: self, title: "Success", message: "Your rating has been submitted successfully.")
                }
            }
        } catch {
            print("Failed to add rate: \(error)")
        }
    }
}
