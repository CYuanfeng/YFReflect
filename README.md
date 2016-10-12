# YFReflect
一键字典和模型互换(Swift版的Reflect)

模型只需要继承NSObject

详细地用法在Demo里


需要重写的类方法：
  1.GetSpecailProperty()  属性名称与字典名称不对应的,用字典来返回。
  例：
  
  // market : 属性的名称
  // Market : 字典里对应模型里属性的名称
  override class func GetSpecailProperty() -> NSDictionary {
        return ["market":"Market","points":"Points","reference":"Reference","type":"Type","typeName":"TypeName"]
    }
