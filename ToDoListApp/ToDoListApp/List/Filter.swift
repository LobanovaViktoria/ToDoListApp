enum Filter: Int {
    case all
    case open
    case closed
    
    var title: String {
        switch self {
       
        case .all:
            "all".localized
        case .open:
            "open".localized
        case .closed:
            "closed".localized
        }
    }
}
