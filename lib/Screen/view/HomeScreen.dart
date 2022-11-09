import 'package:database/Screen/dbHelper.dart';
import 'package:database/Screen/homeController/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtStd = TextEditingController();
  TextEditingController txtMobile = TextEditingController();

  TextEditingController utxtName = TextEditingController();
  TextEditingController utxtStd = TextEditingController();
  TextEditingController utxtMobile = TextEditingController();

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    DbHelper db = DbHelper();
    homeController.stdList.value = await db.readData();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Student data"),
      ),
      body: Obx(
        () => ListView.builder(
            itemCount: homeController.stdList.value.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Text("${homeController.stdList.value[index]['id']}"),
                  title: Text("${homeController.stdList.value[index]['name']}"),
                  subtitle:
                      Text("${homeController.stdList.value[index]['mobile']}"),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            DbHelper db = DbHelper();
                            db.deleteData('${homeController.stdList.value[index]['id']}');
                            getdata();
                          },
                          icon: Icon(Icons.delete),
                        ),
                        IconButton(onPressed: (){
                          utxtName=TextEditingController(
                            text: "${homeController.stdList.value[index]['name']}"
                          );
                          utxtStd=TextEditingController(
                              text: "${homeController.stdList.value[index]['std']}"
                          );
                          utxtMobile=TextEditingController(
                              text: "${homeController.stdList.value[index]['mobile']}"
                          );
                          Get.defaultDialog(
                              content: Column(
                                children: [
                                  TextField(
                                    controller: utxtName,
                                    decoration: InputDecoration(hintText: "Name"),
                                  ),
                                  TextField(
                                    controller: utxtStd,
                                    decoration: InputDecoration(hintText: "Std"),
                                  ),
                                  TextField(
                                    controller: utxtMobile,
                                    decoration: InputDecoration(hintText: "Mobile"),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        DbHelper db = DbHelper();
                                        db.updateData('${homeController.stdList.value[index]['id']}', utxtName.text, utxtStd.text, utxtMobile.text);
                                        getdata();
                                      },
                                      child: Text("Submit"))
                                ],
                              ));



                        }, icon: Icon(Icons.edit))
                      ],
                    ),
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
              content: Column(
            children: [
              TextField(
                controller: txtName,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: txtStd,
                decoration: InputDecoration(hintText: "Std"),
              ),
              TextField(
                controller: txtMobile,
                decoration: InputDecoration(hintText: "Mobile"),
              ),
              ElevatedButton(
                  onPressed: () {
                    DbHelper db = DbHelper();
                    db.datainsert(txtName.text, txtStd.text, txtMobile.text);
                    getdata();
                  },
                  child: Text("Submit"))
            ],
          ));
        },
        child: Icon(Icons.add),
      ),
    ));
  }
}
