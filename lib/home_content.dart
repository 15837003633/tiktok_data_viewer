import 'package:flutter/material.dart';

import 'core/models/member_model.dart';
import 'core/services/http_request.dart';

class HomeContent extends StatefulWidget {
  String cate;
  int selectPageIndex;
  bool email_filte;

  HomeContent(this.cate, this.selectPageIndex, this.email_filte);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  final table_fields = ['ID','类目','昵称','账号','邮箱','粉丝数','收入','观看量','社交账号','数据来源','国家','详情','query'];

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

      print(snap_short);
      // /*
      if (!snap_short.hasData || snap_short.connectionState == ConnectionState.waiting) {
        return Text('暂无数据');
      }

      var tuple = snap_short.data!;
      print(tuple);

      this.member_models = tuple.$1;
      final display_pagenum = tuple.$2;
      final display_total_pagenum = tuple.$3;

      print(member_models);
      print(display_pagenum);
      print(display_total_pagenum);
      // */
      // final display_pagenum = selectPageIndex;
      // final display_total_pagenum = 5;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: DataTable(
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
                      DataCell(Text(item.uid.toString())),
                      DataCell(Text(item.cate.toString())),
                      DataCell(Text(item.nickname.toString())),
                      DataCell(Text(item.handle.toString())),
                      DataCell(Text(item.email.toString())),
                      DataCell(Text(item.followers.toString())),
                      DataCell(Text(item.revenue.toString())),
                      DataCell(Text(item.views.toString())),
                      DataCell(Text(item.social.toString())),
                      DataCell(Text(item.platform.toString())),
                      DataCell(Text(item.country.toString())),
                      DataCell(OutlinedButton(onPressed: (){
                        showDialog(context:ctx, builder: (ctx1){
                          return Container(
                              alignment: Alignment.center,
                              child: Container(
                                // width: 100,
                                // height: 30,
                                  constraints: BoxConstraints.loose(Size(800, 300)),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Text(item.detail ?? '没有数据')));
                        });
                      },child: Text('查看'),)),
                      DataCell(Text(item.query_args.toString())),
                    ],
                  ),
                ).toList(),
              ),
            ),
            buildPageBarView(display_pagenum,display_total_pagenum),


          ],
        ),
      );
    });

  }


  Widget buildPageBarView(int displayPageIndex,int displayPageIndex_total) {
    return Container(
      height: 40,
      child: ListView.builder(
          shrinkWrap:true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: displayPageIndex_total,
          itemBuilder: (ctx,index){
            Color display_color = (index+1) == displayPageIndex ? Colors.red: Colors.blue;
            return Container(
                padding:EdgeInsets.all(5),
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

}
