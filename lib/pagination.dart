import 'package:flutter/material.dart';

class paginationDemo extends StatefulWidget {

  @override
  State<paginationDemo> createState() => _paginationDemoState();

}

class _paginationDemoState extends State<paginationDemo> {
  final ScrollController scrollController =ScrollController();

  List<String> items = [];
  bool loading = false;
  bool allLoading = false;

  mockFetch() async {
    if (allLoading) {
      return;
    }

    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(microseconds: 500));
    List<String> newData = items.length >= 50 ? [] : List.generate(
        10, (index) => "List Item${index + items.length}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoading = newData.isEmpty;
    });
  }
  @override
  void initState() {
super.initState();
mockFetch();
scrollController.addListener(() {
  if(scrollController.position.pixels >= scrollController.position.maxScrollExtent && !loading ){
    print("new Data");
    mockFetch();
  }
});

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Pagination"),
      ),
      body: LayoutBuilder(builder: ( context, constraints) {
        if(items.isNotEmpty){
          return Stack(
            children: [
              ListView.separated(
                controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      return
                        ListTile(
                          title: Text(items[index]),
                        );
                    }
                    else {
                      return Container(
                        width: constraints.maxWidth,
                        height: 30,
                        child: Center(child: Text("No More Data")),
                      );

                    }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 1,);
                  },
                  itemCount: items.length +(allLoading?1:0)),
              if(loading)...[
              Positioned(
                left: 0,
                  bottom: 0,
                  child: Container(
                    height: 80,
                    width: constraints.maxWidth ,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ))]
            ],
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },),
    );
  }
}
