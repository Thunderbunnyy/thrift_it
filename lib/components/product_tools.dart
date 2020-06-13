import 'dart:io';
import 'package:flutter/material.dart';


Widget productTextField(
    {String textTitle,
      String textHint,
      double height,
      TextEditingController controller,
      TextInputType textType}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle;
  textHint == null ? textHint = "Enter Hint" : textHint;
  height == null ? height = 50.0 : height;
  //height !=null

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style:
          new TextStyle(fontWeight: FontWeight.w700, color: Colors.red[300]),
        ),
      ),
      new Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: new Container(
          height: height,
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(color: Colors.white),
              borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new TextField(
              controller: controller,
              keyboardType: textType == null ? TextInputType.text : textType,
              decoration: new InputDecoration(
                  border: InputBorder.none, hintText: textHint),
            ),
          ),
        ),
      ),
    ],
  );
}


List<DropdownMenuItem<String>> buildAndGetDropDownItems(List size) {
  List<DropdownMenuItem<String>> items = new List();
  for (String size in size) {
    items.add(new DropdownMenuItem(value: size, child: new Text(size)));
  }
  return items;
}

Widget productDropDown(
    {String textTitle,
      String selectedItem,
      List<DropdownMenuItem<String>> dropDownItems,
      ValueChanged<String> changedDropDownItems}) {
  textTitle == null ? textTitle = "Enter Title" : textTitle;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          textTitle,
          style:
          new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(color: Colors.white),
              borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  value: selectedItem,
                  items: dropDownItems,
                  onChanged: changedDropDownItems,
                )),
          ),
        ),
      ),
    ],
  );
}

Widget MultiImagePickerList(
    {List<File> imageList, removeNewImage(int position)}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0 ? Container() :SizedBox(
      height: 150.0,
      child: ListView.builder(
          itemCount: imageList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 3.0, right: 3.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(100),
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(15.0)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(imageList[index]))
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new CircleAvatar(
                      backgroundColor: Colors.red[600],
                      child: new IconButton(
                          icon: new Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            removeNewImage(index);
                          }),
                    ),
                  )
                ],
              ),
            );
          }),
    ),
  );
}

showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(
      SnackBar(
    backgroundColor: Colors.red[600],
    content: new Text(
      message,
      style: new TextStyle(color: Colors.white),
    ),
  ));
}

Widget appButton(
    {String btnTxt,
      double btnPadding,
      Color btnColor,
      VoidCallback onBtnclicked}) {
  btnTxt == null ? btnTxt == "App Button" : btnTxt;
  btnPadding == null ? btnPadding = 0.0 : btnPadding;
  btnColor == null ? btnColor = Colors.white : btnColor;

  return Padding(
    padding: new EdgeInsets.all(btnPadding),
    child: new RaisedButton(
      color: Colors.red[300],
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
      onPressed: onBtnclicked,
      child: Container(
        height: 50.0,
        child: new Center(
          child: new Text(
            btnTxt,
            style: new TextStyle(color: btnColor, fontSize: 18.0),
          ),
        ),
      ),
    ),
  );
}