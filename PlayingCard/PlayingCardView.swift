//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Tarasenco Jurik on 17.03.2018.
//  Copyright © 2018 Tarasenco Jurik. All rights reserved.
//----------------(Инкапсуляция)----------------
///internal - это значение по умолчанию, это означает «пригодный для использования любым объектом в моем приложении или инфраструктуре»
//private - это означает «только вызываемый изнутри этого объекта»,
///private (set) - это означает, что это свойство читается вне этого объекта, но не устанавливается
//«fileprivate», доступное по любому коду в этом исходном файле
///public - (только для фреймворков) это может использоваться объектами вне моей рамки
//open - (только для фреймворков) public и объекты вне моей структуры могут подклассифицировать это.
//--------------------------------
//"frame" and/or "center"(Не для Рисования) - для позиционирования UIView
//(VIEW's can be rotated (and scaled and translated))

///var center: CGPoint // центр UIView в своей системе координат супервизора
///var frame: CGRect // прямоугольник, содержащий UIView в своей системе координат супервизора

/* bounds - (Место Рисования!) Прямоугольник границ, который описывает местоположение и размер "view" в собственной системе координат.
 Порог границ по умолчанию - (0,0), а размер такой же, как размер прямоугольника в свойстве кадра. Изменение размера этого прямоугольника увеличивает или уменьшает "view" относительно его центральной точки. Изменение размера также изменяет размер прямоугольника в свойстве frame для соответствия. Координаты прямоугольника границ всегда указываются в точках(CGFloat).
 Изменение прямоугольника границ автоматически перерисовывает представление без вызова метода draw(). Если вы хотите, чтобы UIKit вызывал метод draw(), задайте свойство contentMode для перерисовки.
 Изменения этого свойства могут быть анимированы. */
///var layer: CALayer (Core Animation)
///var cornerRadius: CGFloat - сделаем фон закругленным прямоугольником
///var borderWidth: CGFloat  - нарисовать границу вокруг представления
///var borderColor: CGColor? - цвет границы (если есть)
//NSAttributedString для размещения текста draw(CGRect)
//let text = NSAttributedString(string: “hello”) // вероятно, некоторые атрибуты
//text.draw(at: aCGPoint)
///let image: UIImage? = UIImage(named: “foo”) //  Optional(Может не найти)
//You add foo.jpg to your project in the (Assets.xcassets)
//image.draw(in rect: CGRect)
import UIKit

 @IBDesignable // "Online" отображение на StoryBoard
class PlayingCardView: UIView {
    @IBInspectable //Менять в инспекторе
    var rank: Int = 3 { didSet  { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit: String = "♥️" { didSet  { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet  { setNeedsDisplay(); setNeedsLayout() } }
    //setNeedsLayout(),
    //setNeedsDisplay(_ rect: CGRect)- перерисовать.//"rect" - это область, которую нужно перерисовать.
    
    var faceCardScale: CGFloat = SizeRation.faceCardImageSizeToBoundsSize { didSet  { setNeedsDisplay() } }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0 // обновить стандартное значение
        default: break
        }
    }
    
    //----------------------- MARK: AttibutedString
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize) //MARK:font!
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) //MARK:АvtoResize Text!

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle : paragraphStyle, .font:font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
        //return NSAttributedString + Atribute func
    }
    //----------------------- MARK: LABEL
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLAbel = createCornerLabel()
    
    
    private func createCornerLabel() -> UILabel { // func Create Label
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label) // view - добавь на себя!
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        //.attributedText -  текущий стилизированний текст отображаеммий лейбой
        // cornerString - rankString + "/n" + suit
        
        label.frame.size = CGSize.zero // делаем розмер ноль
        label.sizeToFit() // Изменяет размер на столько на сколько нужно
        label.isHidden = !isFaceUp
        //.isHidden - Логическое значение, определяющее, скрыто ли "view".
    }
    //-----------------------end-----------------------
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay(); setNeedsLayout()
        //Вызывается при изменении среды интерфейса iOS.
        // обновляем "VEIW" eсли изменился шрифт
    }
    //-------------MARK: DRAW & LAYOUT
    override func layoutSubviews() { //MARK: layout - расположение
        //layoutSubviews()- Обновляет View каждий раз когда меняются граници
        // Вручную - setNeedsLayout()
        super.layoutSubviews()
        //напрямую задать прямоугольники фреймов ваших SubViews.
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, by: cornerOffset)
        //.origin - Точка, определяющая координаты начала прямоугольника!(левийВерхний)
        //cornerOffset - property in extansion(bounds.size.height)*(0.85)*(0.33) = 17.1(CGFloat)
        //.offsetBy смещение "x + CGFloat, y + CGFloat"

        configureCornerLabel(lowerRightCornerLAbel)
        lowerRightCornerLAbel.transform = CGAffineTransform.identity
            //CGAffineTransform - поворот,масштабированиe,искажениe
            .translatedBy(x: lowerRightCornerLAbel.frame.size.width,
                          y: lowerRightCornerLAbel.frame.size.height)
            .rotated(by: CGFloat.pi ) // π = 180°
        //.transform - преобразование, применяемое к "VIEW", относительно центра его границ.
        
        lowerRightCornerLAbel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, by: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLAbel.frame.size.width, by: -lowerRightCornerLAbel.frame.size.height)
        // .offsetBy - extension CGPoint!
    }
    //-
    private func drawPips() // image "♥️♠️♣️♦️"
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        // отристовка масти на карте
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.rightHalf)
                    pipString.draw(in: pipRect.leftHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        //(Only! системно) - отрисовивает!
        //Bручную - setNeedsDisplay()
        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0)
        roundRect.addClip()     // обрезает View по контуру.
        UIColor.white.setFill() // Цвет.Заливки
        roundRect.fill()        // Зделать Заливку
        
        if isFaceUp {
//UIImage(named: name ,in: Bundle(for: classForCoder) ,compatibleWith: traitCollection - отрисовка картінок на сториБорд.
            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale)) //0.75
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
                #colorLiteral(red: 1, green: 0.917081957, blue: 0.01379958831, alpha: 0.1).setFill()
                roundRect.fill()
            }
        }
    }
}
//--------------------- MARK: All PROPERTY
extension PlayingCardView {
    
    private struct SizeRation {
        
        static let cornerFontSizeBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.08
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRation.cornerFontSizeBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRation.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRation.cornerRadiusToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}
//-----------------------end-----------------------

extension CGRect { // CG (Core Graphics)
    /* CGRect - Структура, которая содержит расположение и размеры прямоугольника.
     В координатном пространстве Core Graphics по умолчанию начало координат расположено в нижнем левом углу прямоугольника, а прямоугольник - в верхнем правом углу. Если контекст имеет пространство с перевернутой координатой - часто случай в iOS - начало координат находится в верхнем левом углу, а прямоугольник продолжается в нижнем правом углу.*/
    
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint { //MARK:offsetBy
    func offsetBy(dx: CGFloat, by: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + by)
    }
}
