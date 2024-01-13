import 'package:flutter/material.dart';
import 'core/services/http_request.dart';
import 'core/models/cate_model.dart';
class TKHomePage extends StatefulWidget {
  const TKHomePage({Key? key}) : super(key: key);

  @override
  State<TKHomePage> createState() => _TKHomePageState();
}

class _TKHomePageState extends State<TKHomePage> {

  late List<TKCateModel> cate_models = [];

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      padding:EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Wrap(
                children: cate_models.map((e) => TextButton(onPressed:(){
                  int index =  cate_models.indexOf(e);
                  cate_click(index);
                },child: Text(e.cate)),
                ).toList()
      ),
    );
  }
  @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: this.cate_models.length,
  //     child: Scaffold(
  //       appBar: TabBar(
  //         isScrollable: true,
  //         tabs: cate_models.map((e) => Container(
  //             child: Text(e.cate,style: TextStyle(color: Colors.black),)),
  //         ).toList(),
  //       ),
  //       body: TabBarView(
  //         children: cate_models.map((e) => TextButton(onPressed:(){
  //           int index =  cate_models.indexOf(e);
  //           cate_click(index);
  //         },child: Text(e.cate)),
  //         ).toList()
  //       ),
  //       ),
  //   );
  // }



  cate_click(int index){
    print('click ${cate_models[index].cate}');
  }

   Future<List<TKCateModel>> getCateConfit() async{
    dynamic resp = await HttpRequest.request('/get_members_cates');
    List list = resp['data'];
    return list.map((e) => TKCateModel.fromJson(e)).toList();
  }

}
