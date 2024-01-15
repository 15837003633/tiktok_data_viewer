import 'package:flutter/material.dart';
import 'core/models/member_model.dart';
import 'core/services/http_request.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class HomeContent extends StatefulWidget {
  String cate;
  int selectPageIndex;
  bool email_filte;

  HomeContent(this.cate, this.selectPageIndex, this.email_filte,{Key? key}):super(key:key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  final table_fields = ['ID','类目','昵称','账号','粉丝数','收入','观看量','社交账号','详情','国家',];

  late List<TKMemberModel>? member_models = null;

  int selectPageIndex = 1;
  late String cate;
  late bool email_filte;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectPageIndex = widget.selectPageIndex;
    cate = widget.cate;
    email_filte = widget.email_filte;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getMemebers(cate, selectPageIndex, email_filte), builder: (ctx, snap_short){

      if (!snap_short.hasData || snap_short.connectionState == ConnectionState.waiting) {
        return Text('暂无数据');
      }

      var tuple = snap_short.data!;

      this.member_models = tuple.$1;
      final display_pagenum = tuple.$2;
      final display_total_pagenum = tuple.$3;


      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DataTable(
                    dataRowMaxHeight:50,
                    border: TableBorder.all(
                        width: 0.5,color: Colors.grey),
                    columns: table_fields.map((e){
                      return DataColumn(label: Text(e));
                    }).toList(),
                    rows: this.member_models!
                        .map(
                          (item) => DataRow(
                        cells: [
                          DataCell(SelectableText (item.uid.toString())),
                          DataCell(SelectableText (item.cate.toString())),
                          DataCell(
                              GestureDetector(
                                onTap: (){
                                  gotoPersenalPage(item);
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      foregroundImage: NetworkImage("https://d3uucz7wx6jq40.cloudfront.net/tiktok.creator/${item.uid}/avatar_thumb.png"),
                                    ),
                                    SizedBox(width: 5,),
                                    Text (item.nickname.toString(),style: TextStyle(color: Colors.blue),),
                                  ],
                                ),
                              )
                          ),
                          DataCell(
                              SelectableText (item.handle.toString())),
                          DataCell(SelectableText (item.followers.toString())),
                          DataCell(SelectableText (item.revenue.toString())),
                          DataCell(SelectableText (item.views.toString())),
                          DataCell(buildSocialView('email:${item.email.toString()},${item.social.toString()}')),
                          DataCell(OutlinedButton(onPressed: (){
                            showDialog(context:ctx, builder: (ctx1){
                              Map map = jsonDecode(item.detail ?? '');
                              return Center(
                                child: Container(
                                  width: 800,
                                  padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: SelectableText('${map} \n\n${item.platform.toString()} \n\n${item.query_args.toString()}')),
                              );
                            });
                          },child: Text('查看'),)),
                          DataCell(SelectableText(item.country.toString())),
                        ],
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
          buildPageBarView(display_pagenum,display_total_pagenum),


        ],
      );
    });

  }


  Widget buildSocialView(String input){
    Map map = getSocial(input);
    return Row(
      children: map.keys.where((element) => map[element] != null).map((key){
        String platform = map[key];
        return GestureDetector(
            onTap: (){
          Clipboard.setData(ClipboardData(text: platform)).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("已复制到剪切板")));
          },
          );
        },
            child: buildSocialButton(key));
      }).toList()
    );
  }

  Widget buildSocialButton(String key){
    String file_name = '';
    if (key == "email"){
      file_name = "resource/images/gmail.png";
    }
    if (key == "ins"){
      file_name = "resource/images/instagram.png";
    }
    if (key == "ytb"){
      file_name =  "resource/images/youtube.png";
    }
    if (key == "twitter"){
      file_name = "resource/images/twitter.png";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(file_name,width: 35,fit: BoxFit.contain,),
    );
  }

  Widget buildPageBarView(int displayPageIndex,int displayPageIndex_total) {
    return Container(
      height: 40,
      child: ListView.builder(
          shrinkWrap:true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: displayPageIndex_total,
          itemBuilder: (ctx,index){
            Color display_color = (index+1) == displayPageIndex ? Colors.red: Colors.blue;
            return Container(
                padding:EdgeInsets.all(1.5),
                child: OutlinedButton(onPressed: (){
                  setState(() {
                    selectPageIndex = index+1;
                  });
                },style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(color: display_color))
                ) ,child: Text("${index + 1}",style: TextStyle(color: display_color),)));
          }),
    );
  }


  gotoPersenalPage(TKMemberModel item){
    final url = 'https://www.tiktok.com/@${item.handle.toString()}';
    html.window.open(url, 'new_tab');
  }

  Future<(List<TKMemberModel>, int, int)> getMemebers(String cate, int page_num, bool show_email) async{
    print('request $cate,$page_num,$show_email');
    var url_path = show_email ? '/get_members_by_cate_with_email':'/get_members_by_cate';
    dynamic resp = await HttpRequest.request(url_path,params: {'cate':cate,'page':page_num});

    List list = resp['data'];
    int page =resp['page'];
    int page_count = resp['totalPage'];
    final tuple = (list.map((e) => TKMemberModel.fromJson(e)).toList(),page,page_count);
    return tuple;
  }

  Map<String,String?> getSocial(String input){
    RegExp regExp = RegExp(r'(\w+):([^,]+)'); // 匹配字段名称和内容的正则表达式
    Iterable<Match> matches = regExp.allMatches(input);

    Map<String, String?> resultMap = {};

    for (Match match in matches) {
      String fieldName = match.group(1)!; // 提取字段名称
      String? content = match.group(2);   // 提取内容
      resultMap[fieldName] = content;  // 将字段名称和内容组装成 Map
    }

    return resultMap;
  }


}
