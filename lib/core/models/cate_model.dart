class TKCateModel{
  String cate;
  int count;

  TKCateModel(this.cate, this.count);

  factory TKCateModel.fromJson(Map<String,dynamic> json)=>TKCateModel(json['cate'],json['count']);
}