import 'package:flutter/material.dart';
import 'core/models/member_model.dart';
import 'core/services/http_request.dart';
import 'core/models/cate_model.dart';
class TKHomePage extends StatefulWidget {
  const TKHomePage({Key? key}) : super(key: key);

  @override
  State<TKHomePage> createState() => _TKHomePageState();
}

class _TKHomePageState extends State<TKHomePage> {


  final table_fields = ['ID','类目','昵称','账号','邮箱','粉丝数','收入','观看量','社交账号','数据来源','国家','详情','query'];
  late List<TKCateModel> cate_models = [TKCateModel('家具',300),TKCateModel('宠物用品',200)];
  late List<TKMemberModel>? member_models = [
    TKMemberModel(uid: '12312312',cate: '家具',nickname: 'scott'),
    TKMemberModel(uid: '12312312',cate: '家具1',nickname: 'scott1'),
    TKMemberModel(uid: '12312312',cate: '家具2',nickname: 'scott2'),
    TKMemberModel(uid: '12312312',cate: '家具3',nickname: 'scott3',detail: "啊啊啊自行车自行车自行车自行车自行车自行车自行车自行车在线查自习正擦仔细"),
    TKMemberModel(uid: '12312312',cate: '家具4',nickname: 'scott4',query_args: '啊撒大声地啊实打实大师大大啊实打实大撒大声地阿萨德'),
    TKMemberModel(uid: '12312312',cate: '家具5',nickname: 'scott5'),
  ];

  int selectTapIndex = 0;
  int selectPageIndex = 1;

  bool email_filte = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCateConfit().then((value){
      setState(() {
        this.cate_models = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTabBarView(),
          buildToolBarView(),
          Divider(),
          buildBodyView(),
        ],
      ),
    );
  }
  @override



  cate_click(int index){
    setState(() {
      selectTapIndex = index;
      print('click ${cate_models[index].cate}');
    });
  }


  Widget buildTabBarView(){
    return Container(
      padding:EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Wrap(
          children: cate_models.map((e){
            int btn_index = cate_models.indexOf(e);
            Color display_color = btn_index == selectTapIndex ? Colors.red: Colors.blue;
            return Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                  onPressed:(){
                    int index =  cate_models.indexOf(e);
                    cate_click(index);
                  },
                  child: Text(e.cate,style: TextStyle(color: display_color),),
                  style:ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color:display_color))
                  )
              ),
            );
          }).toList()
      ),
    );
  }

  Widget buildToolBarView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("筛选："),
          Row(
            children: [
              Checkbox(value: email_filte, onChanged: (new_value){
                setState(() {
                  selectPageIndex = 1;
                  email_filte = new_value!;
                });
              }),
              Text('邮箱')
            ],
          )
        ],
      ),
    );
  }


    Widget buildBodyView(){
    TKCateModel currentCate = this.cate_models[selectTapIndex];
    return FutureBuilder(future: getMemebers(currentCate.cate, selectPageIndex, email_filte), builder: (ctx, snap_short){

      // /*
      if (!snap_short.hasData) return Text('暂无数据');

      var tuple = snap_short.data!;

      this.member_models = tuple.$1;
      final display_pagenum = tuple.$2;
      final display_total_pagenum = tuple.$3;
       // */
      // final display_pagenum = selectPageIndex;
      // final display_total_pagenum = 5;

      return SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
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


   Future<List<TKCateModel>> getCateConfit() async{
    dynamic resp = await HttpRequest.request('/get_members_cates');
    List list = resp['data'];
    return list.map((e) => TKCateModel.fromJson(e)).toList();
  }

  Future<(List<TKMemberModel>, int, int)> getMemebers(String cate, int page_num, bool show_email) async{
    var url_path = show_email ? '/get_members_by_cate_with_email':'/get_members_by_cate';
    dynamic resp = await HttpRequest.request(url_path,params: {'page':page_num,'page':page_num});
    List list = resp['data'];
    return (list.map((e) => TKMemberModel.fromJson(e)).toList(),int.parse(resp['page']),int.parse(resp['totalPage']));
  }
}
