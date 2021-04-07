import 'package:flutter/material.dart';
import 'package:qr_code_app/constants/size_config.dart';

const testKeys = [Key("fancyButtons"), Key("flatButtons")];

class DialogQr extends StatefulWidget {
  DialogQr(
      {Key key,
      this.title,
      this.descreption,
      this.okFun,
      this.cancelFun,
      this.okColor,
      this.cancelColor,
      this.ok,
      this.cancel,
      this.theme})
      : super(key: key);

  final String title;
  final String descreption;
  final Function okFun;
  final Function cancelFun;
  final Color okColor;
  final Color cancelColor;
  final String ok;
  final String cancel;
  final int theme;
  @override
  _DialogQrState createState() => _DialogQrState();
}

class _DialogQrState extends State<DialogQr> {
  String title;
  String descreption;
  Function okFun;
  Function cancelFun;
  Color cancelColor;
  Color okColor;
  String ok;
  String cancel;
  int theme;
  double width;
  double height;

  @override
  void initState() {
    title = widget.title;
    descreption = widget.descreption;
    okFun = widget.okFun;
    okColor = widget.okColor;
    cancelFun = widget.cancelFun;
    cancelColor = widget.cancelColor;
    ok = widget.ok;
    cancel = widget.cancel;
    theme = widget.theme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    //var dialogWidth = 0.36 * height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme == 0 ? 15 : 0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme == 0 ? 15 : 0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //image,
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Container(
                    child: Text(
                      descreption,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              UIHelper.verticalSpace(15),
              Container(
                child: Row(
                  mainAxisAlignment: theme == 1
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    theme == 0
                        ? customButton(cancel, cancelColor, cancelFun)
                        : flatButton(cancel, cancelColor, cancelFun),
                    SizedBox(
                      width: 50,
                    ),
                    theme == 0
                        ? customButton(ok, okColor, okFun)
                        : flatButton(ok, okColor, okFun)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(String t, Color c, Function f) {
    return TextButton(
      key: testKeys[0],
      style: TextButton.styleFrom(
        primary: c,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        f != null ? f() : print("function is null");
        Navigator.of(context).pop();
      },
      child: Text(
        t,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );

    // Container(
    //   child: RaisedButton(
    //     key: testKeys[0],
    //     shape: RoundedRectangleBorder(
    //         borderRadius: new BorderRadius.circular(30.0)),
    //     color: c,
    //     child: Text(
    //       t,
    //       style: TextStyle(color: Colors.white, fontSize: 16,),
    //     ),
    //     onPressed: () {
    //       f != null ? f() : print("function is null");
    //       Navigator.of(context).pop();
    //     },
    //   ),
    // );
  }

  Widget flatButton(String t, Color c, Function f) {
    return Container(
        child: TextButton(
      key: testKeys[1],
      
      style: TextButton.styleFrom(
      
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        f != null ? f() : print("function is null");
        Navigator.of(context).pop();
      },
      child: Text(
        t,
        style: TextStyle(color: c, fontSize: 18),
      ),
    )
        // FlatButton(
        //   key: testKeys[1],
        //   child: Text(
        //     t,
        //     style: TextStyle(color: c, fontSize: 15),
        //   ),
        //   onPressed: () {
        //     f != null ? f() : print("function is null");
        //     Navigator.of(context).pop();
        //   },
        // ),
        );
  }
}
