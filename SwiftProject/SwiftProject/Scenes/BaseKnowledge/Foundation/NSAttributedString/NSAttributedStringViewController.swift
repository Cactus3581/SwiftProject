//
//  NSAttributedStringViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/30.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//
//  NSAttributedStringViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/30.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*
 1. sizeThatFits 和 boundingRect的共同点：都需要提供文本和宽度，都是用来计算size的。
 boundingRect：适用场景范围广，不局限于计算整体高度；局限性是label的属性必须与富文本的属性一致才可以，否则计算会有偏差；计算普通文本/富文本计算方法的本质都是走的富文本的配置属性
 sizeThatFit：需要引入view，决定了只能在view内部使用；只能计算整体高度；返回的size是最准确的；不需要关心值是普通文本还是富文本

2. 给一段宽度，能占几个字符：用于部门路径的折叠展开功能

 */

class NSAttributedStringViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func test1(text: String) {

        var tagList = [UserProfileTagModel]()
        for index in 0..<4 {
            let model =  UserProfileTagModel()
            if index == 0 {
                model.type = 2
                model.imageName = "profilegender"
            } else if index == 1 {
                  model.type = 2
                  model.imageName = "profilegender"
            } else if index == 2 {
                  model.type = 1
                  model.text = "on leeave"
            } else if index == 3 {
                  model.type = 1
                  model.text = "已停用"
            }
            tagList.append(model)
        }

        let tagView = UserProfileTagsView()
        self.view.addSubview(tagView)
        tagView.tags = tagList

        let attributeText = NSMutableAttributedString.init(string: text)
        attributeText.addAttributes(getAttributes(), range: NSMakeRange(0, text.count))
        label.attributedText = attributeText

        let totalWidth = self.view.bounds.size.width - 16*2
        let list = sw_getPerlineContent(attributedString: attributeText, width: totalWidth)
        let lastLine = list.last
        if let lastLine = lastLine {
            let lastLineWidth = sizeOfAttributedString(text: lastLine, size: CGSize(width: totalWidth, height: CGFloat(MAXFLOAT))).width
            let tagViewWidth = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            let tagViewHeight = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let font = UIFont.systemFont(ofSize: 32)
            let lineHeight = font.lineHeight
            if totalWidth < lastLineWidth + tagViewWidth {
                // tagsView 换行
                tagView.snp.makeConstraints { (make) in
                    make.leading.equalTo(label)
                    make.top.equalTo(label.snp.bottom)
                }
            } else {
                tagView.snp.makeConstraints { (make) in
                    make.leading.equalTo(label).offset(lastLineWidth)
                    make.bottom.equalTo(label).offset(-(lineHeight - tagViewHeight)/2)
                }
            }
        }
    }

    func getAttributes() -> [NSAttributedString.Key: Any] {
        //设置文本段落排版格式
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.lineSpacing = 45     //设置行间距
          paragraphStyle.alignment = .left      //文本对齐方向
          paragraphStyle.lineBreakMode = .byWordWrapping
        let dic = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32),
            NSAttributedString.Key.kern: 0,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.backgroundColor: UIColor.lightGray
            ] as [NSAttributedString.Key : Any]
        return dic
    }

    //MARK:使用boundingRectWithSize:options:attributes:context计算

    //计算富文本整体高度
    func sizeOfAttributedString(text: NSAttributedString, size: CGSize) -> CGSize {
        /*
         options:表示计算的类型
         NSStringDrawingUsesLineFragmentOrigin:绘制文本时使用 line fragement origin 而不是 baseline origin。一般使用这项。
         NSStringDrawingUsesFontLeading:根据字体计算高度
         NSStringDrawingUsesDeviceMetrics:使用象形文字计算高度
         NSStringDrawingTruncatesLastVisibleLine:如果NSStringDrawingUsesLineFragmentOrigin设置，这个选项没有用
         */
        // 富文本里的字间距，行间距，字体会影响大小
        let size = text.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    //计算普通文本整体高度
    func sizeOfString(text: NSAttributedString, size: CGSize, attributes: [NSAttributedString.Key : Any]) -> CGSize {
        let size = text.string.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    //MARK:使用sizeThats计算（控件角度）
    func sizeThatFits(text: String) {
        let attributeText = NSMutableAttributedString.init(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        let lineSpace = 45 as CGFloat
        paragraphStyle.lineSpacing = lineSpace     //设置行间距
        paragraphStyle.alignment = .left      //文本对齐方向
        paragraphStyle.lineBreakMode = .byWordWrapping
        let font = UIFont.systemFont(ofSize: 32)
        let dic = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.kern: 0
            ] as [NSAttributedString.Key : Any]
        attributeText.addAttributes(dic, range: NSMakeRange(0, attributeText.length))
        label.attributedText = attributeText

        // size1
        var size = label.sizeThatFits(CGSize(width: self.view.bounds.size.width-32, height: CGFloat(MAXFLOAT)))
        print(size)
        // size2
        size = sizeOfAttributedString(text: attributeText, size: CGSize(width: self.view.bounds.size.width-32, height: CGFloat(MAXFLOAT)))
        print(size)
    }


    //MARK:使用CTFramesetter（计算整体高度）
    func height2(text: NSAttributedString, size: CGSize, attributes: [NSAttributedString.Key : Any]) -> CGSize {
        /*
        CTFramesetterCreateWithAttributedString(CFAttributedString)
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
        CFRelease(framesetter);
        return fitSize;
         */
        return CGSize(width: 0, height: 0)
    }

    //MARK:获取行数
    func getLineNumber(totalHeight: CGFloat, font: UIFont, lineSpace: CGFloat) -> Int{
        //  行数 = 文本总高度 / （单行高度+行间距）
         let lineHeight = font.lineHeight //单行整体高度
         let wordHeight = font.pointSize //单行字体高度
         return Int((totalHeight + lineSpace) / (lineHeight + lineSpace))
    }

    //MARK:获取每一行的内容
    func sw_getPerlineContent(attributedString: NSAttributedString, width: CGFloat) -> [NSAttributedString] {

        // 1.初始化路径
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)), transform: nil)
        // 2.初始化framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)

        // 3.绘制frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path, nil)
        let frame1 = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        // 获得CTLine数组
        let lines = CTFrameGetLines(frame)

        // 获得行数
        let numberOfLines = CFArrayGetCount(lines)

        // 获得每一行的origin, CoreText的origin是在字形的baseLine处的
        var lineOrigins = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: numberOfLines)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)

        var linesArray = [NSAttributedString]()
        // 遍历每一行
        for index in 0..<numberOfLines {
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, index), to: CTLine.self)
            let lineRef: CTLine = line
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range: NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = (attributedString.attributedSubstring(from: range))
            linesArray.append(lineString)
        }
        return linesArray
    }

    //MARK:富文本基础属性
    func test() -> NSAttributedString {

        let text = """
        君不见黄河之水天上来，奔流到海不复回。\n
        君不见高堂明镜悲白发，朝如青丝暮成雪。\n
        人生得意须尽欢，莫使金樽空对月。\n
        天生我材必有用，千金散尽还复来。\n
        烹羊宰牛且为乐，会须一饮三百杯。\n
        岑夫子，丹丘生，将进酒，杯莫停。\n
        与君歌一曲，请君为我倾耳听。\n
        钟鼓馔玉不足贵，但愿长醉不愿醒。\n
        古来圣贤皆寂寞，惟有饮者留其名。\n
        陈王昔时宴平乐，斗酒十千恣欢谑。\n
        主人何为言少钱，径须沽取对君酌。\n
        五花马、千金裘，呼儿将出换美酒，与尔同销万古愁。\n
        😄！
        """

        let attributeText = NSMutableAttributedString.init(string: text)

        let count = text.utf16.count
        //设置文本段落排版格式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1     //设置行间距
        paragraphStyle.paragraphSpacing = 10//段落间距
//        paragraphStyle.firstLineHeadIndent = 0     //段落首行缩进距离
//        paragraphStyle.headIndent = 0     //文本每一行的缩进距离，(不包含首行)
//        paragraphStyle.tailIndent = 0  //文本行末缩进距离
        paragraphStyle.alignment = .justified      //文本对齐方向
        //paragraphStyle.baseWritingDirection = .rightToLeft  //文本排序方向
        paragraphStyle.lineBreakMode = .byWordWrapping
        attributeText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, count))

        //设置粗体
        attributeText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSMakeRange(0, count))
        //设置文本背景颜色
        attributeText.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.lightGray], range: NSMakeRange(0, count))
        //设置字体颜色
        attributeText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], range: NSMakeRange(0, count))
        //设置字间距
        attributeText.addAttributes([NSAttributedString.Key.kern: 3], range: NSMakeRange(0, count))
        //设置下划线样式
        attributeText.addAttributes([NSAttributedString.Key.underlineStyle: 1], range: NSMakeRange(0, count))
        //设置下划线颜色
        attributeText.addAttributes([NSAttributedString.Key.underlineColor: UIColor.red], range: NSMakeRange(0, count))
        //设置基线偏移值，正值上偏，负值下偏
        attributeText.addAttributes([NSAttributedString.Key.baselineOffset: 5], range: NSMakeRange(0, count))

        //设置阴影
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 2, height: 2)   //阴影偏移量
        shadow.shadowColor = UIColor.blue  //阴影颜色
        attributeText.addAttributes([NSAttributedString.Key.shadow: shadow], range: NSMakeRange(0, count))

        //设置文字特殊效果，目前只有图版印刷效果可用
        //attributeText.addAttributes([NSTextEffectAttributeName: NSTextEffectLetterpressStyle], range: NSMakeRange(0, count))
        //设置字体倾斜，正值右倾，负值左倾
        attributeText.addAttributes([NSAttributedString.Key.obliqueness: 0.7], range: NSMakeRange(0, count))
        //设置字体扁平化/文本横向拉伸，正值横向拉伸文本，负值横向压缩文本
        //attributeText.addAttributes([NSExpansionAttributeName: 0.5], range: NSMakeRange(0, count))
        //设置文字书写方向，从左向右书写或者从右向左书写
        //attributeText.addAttributes([NSWritingDirectionAttributeName: NSWritingDirection.rightToLeft], range: NSMakeRange(0, 10))
        //设置删除线
        attributeText.addAttributes([NSAttributedString.Key.strikethroughStyle: 1], range: NSMakeRange(0, count))
        //设置删除线颜色
        attributeText.addAttributes([NSAttributedString.Key.strikethroughColor: UIColor.yellow], range: NSMakeRange(0, count))
        //添加链接，只能用在 UITextView 中。，不支持UILabel/UITextField
        attributeText.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "http://www.baidu.com")!, range: NSMakeRange(0, count))
        //设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
        attributeText.addAttributes([NSAttributedString.Key.ligature: 1], range: NSMakeRange(0, count))
        //设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
        attributeText.addAttributes([NSAttributedString.Key.strokeWidth: 0], range: NSMakeRange(0, count))
        //填充部分颜色，不是字体颜色，取值为 UIColor 对象
        attributeText.addAttributes([NSAttributedString.Key.strokeColor: UIColor.yellow], range: NSMakeRange(0, count))
        //设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
        attributeText.addAttributes([NSAttributedString.Key.verticalGlyphForm: 0], range: NSMakeRange(0, count))

        //设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = UIImage.init(named: "profilegender")
        //计算文字高度
        let lineHeight = label.font.lineHeight
        //设置图片的显示大小
        textAttachment.bounds = CGRect(x: 0, y: 0, width: lineHeight, height: lineHeight)
        //图片转成富文本
        let imageAttributedString = NSAttributedString(attachment: textAttachment)
        attributeText.append(imageAttributedString)

        /*
        let attributes = [
            NSAttributedString.Key.strokeColor: UIColor.yellow,
            NSAttributedString.Key.verticalGlyphForm: 0
            ] as [NSAttributedString.Key : Any]

        //设置多个属性
        attributeText.setAttributes(attributes, range: NSMakeRange(0, count))
        //添加单个属性
        attributeText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, count))
        //添加多个属性
        attributeText.addAttributes(attributes, range: NSMakeRange(0, count))
        //移除某个属性
        attributeText.removeAttribute(NSAttributedString.Key.font, range: NSMakeRange(0, count))

        //字符串处理
        let str = ""
        let attString = NSAttributedString.init(string: str)
        attributeText.append(attString)//拼接字符串
        attributeText.insert(attString, at: 0)//插入字符串
        attributeText.replaceCharacters(in: NSMakeRange(0, count), with: attString)//替换
        attributeText.replaceCharacters(in: NSMakeRange(0, count), with: "")
         */

        var range = NSRange.init(location: 0, length: attributeText.length)
        //获取指定位置上的属性信息，并返回与指定位置属性相同并且连续的字符串的范围信息
        let key = attributeText.attributes(at: 0, effectiveRange: &range)
        print(key)

        return attributeText
    }

    // 链接
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
      return true
    }
}
