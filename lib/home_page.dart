import 'package:flutter/material.dart';
import 'package:tiktok_data_viewer/home_content.dart';
import 'core/models/member_model.dart';
import 'core/services/http_request.dart';
import 'core/models/cate_model.dart';
class TKHomePage extends StatefulWidget {
  const TKHomePage({Key? key}) : super(key: key);

  @override
  State<TKHomePage> createState() => _TKHomePageState();
}

class _TKHomePageState extends State<TKHomePage> {


  late List<TKCateModel> cate_models = [];


  int selectTapIndex = 0;

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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTabBarView(),
            buildToolBarView(),
            Divider(),
            buildBodyView(),
            SizedBox(height: 40,)
          ],
        ),
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
      padding:EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                  child: Text("${e.cate}(${e.count})",style: TextStyle(color: display_color),),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("筛选："),
          Row(
            children: [
              Checkbox(value: email_filte, onChanged: (new_value){
                setState(() {
                  email_filte = new_value!;
                });
              }),
              Text('邮箱'),
            ],
          )
        ],
      ),
    );
  }


  Widget buildBodyView(){
    if (selectTapIndex >= this.cate_models.length){
      return Text("暂无数据");
    }
    TKCateModel currentCate = this.cate_models[selectTapIndex];
    return HomeContent(key:ValueKey('${currentCate.cate}+${email_filte}'),currentCate.cate,1,email_filte);
  }


   Future<List<TKCateModel>> getCateConfit() async{
    dynamic resp = await HttpRequest.request('/get_members_cates');
    List list = resp['data'];
    return list.map((e) => TKCateModel.fromJson(e)).toList();
  }


}
