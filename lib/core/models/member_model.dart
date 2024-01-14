class TKMemberModel{
  String? uid;
  String? cate;
  String? nickname;
  String? handle;
  String? email;
  String? followers;
  String? revenue;
  String? views;
  String? social;
  String? detail;
  String? platform;
  String? country;
  String? query_args;


  TKMemberModel({
    this.uid,
    this.cate,
    this.nickname,
    this.handle,
    this.email,
    this.followers,
    this.revenue,
    this.views,
    this.social,
    this.detail,
    this.platform,
    this.country,
    this.query_args
}
);

  factory TKMemberModel.fromJson(Map<String,dynamic> json)=>TKMemberModel(uid:json['uid'],cate:json['cate'],nickname:json['nickname'],handle:json['handle'],email:json['email'],followers:json['followers'],revenue:json['revenue'],views:json['views'],social:json['social'],detail:json['detail'],platform:json['platform'],country:json['country'],query_args:json['query_args']);
}