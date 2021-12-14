import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:random_color/random_color.dart';
import 'package:text_editor/text_editor.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhotoEdit extends StatefulWidget {
  const PhotoEdit({Key key}) : super(key: key);

  @override
  _PhotoEditState createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  var useruid;
  final TextEditingController caption = new TextEditingController();
  bool loading = false;
  File croppedFile;
  CachedVideoPlayerController _controller;
  //change this to true to check video or false to see video VIEW
  bool checkvideo = false;
  //change this to true to check video or false to see video VIEW

  @override
  void initState() {
    _controller = CachedVideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/laid-69.appspot.com/o/240181750_1720759198108061_4154513460926878529_n.mp4?alt=media&token=b249e3eb-1322-48bb-ac1c-46625b3833f2')
      ..initialize().then((_) {});

    super.initState();
  }

  double process = 0;
  final fonts = [
    'roboto',
    'acme',
    'anton',
    'bebas',
    'caveat',
    'dance',
    'FjallaOne',
    'IndieFlower',
    'Lobster',
    'MonteCarlo',
    'NotoSansJP',
    'OpenSans',
    'Oswald',
    'Pacifico',
    'PaletteMosaic',
    'Raleway',
    'Robotomedium',
    'Robotoregular',
    'Staatliches',
    'Teko',
  ];
  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'roboto',
  );
  String _text = '';
  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  paletteColors: [
                    Colors.black,
                    Colors.white,
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.pink,
                    Colors.cyanAccent,
                  ],
                  decoration: EditorDecoration(
                    doneButton: Icon(Icons.close, color: Colors.white),
                    fontFamily: Icon(Icons.title, color: Colors.white),
                    colorPalette: Icon(Icons.palette, color: Colors.white),
                    alignment: AlignmentDecoration(
                      left: Text(
                        'left',
                        style: TextStyle(color: Colors.white),
                      ),
                      center: Text(
                        'center',
                        style: TextStyle(color: Colors.white),
                      ),
                      right: Text(
                        'right',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Offset offset = Offset.zero;
  Offset offset1 = Offset.zero;

  var yOffset = 0.0;
  var xOffset = 0.0;
  double _scale = 1.0;
  double _previousScale = 1.0;
  String gifs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              left: offset1.dx,
              top: offset1.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  print(offset1);
                  setState(() {
                    offset1 = Offset(offset1.dx + details.delta.dx,
                        offset1.dy + details.delta.dy);
                  });
                },
                child: checkvideo == false
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.network(
                          croppedFile != null
                              ? croppedFile
                              : 'https://firebasestorage.googleapis.com/v0/b/laid-69.appspot.com/o/boy.jpg?alt=media&token=491d0f8a-09ca-48f7-b95b-11d400a015f3',
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 150,
                        child: _controller.value.initialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: CachedVideoPlayer(_controller),
                              )
                            : Container(),
                      ),
              ),
            ),
            gifs != null
                ? Container(
                    child: Positioned.fromRect(
                      rect: Rect.fromPoints(
                          Offset(xOffset - 125.0, yOffset - 100.0),
                          Offset(xOffset + 250.0, yOffset + 100.0)),
                      child: Container(
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              gifs = null;
                            });
                          },
                          onScaleStart: (ScaleStartDetails details) {
                            print(details);

                            setState(() {
                              _previousScale = _scale;
                            });
                          },
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            print(details);
                            setState(() {
                              var offset = details.focalPoint;
                              xOffset = offset.dx;
                              yOffset = offset.dy;
                            });
                            setState(() {
                              _scale = _previousScale * details.scale;
                            });
                          },
                          onScaleEnd: (ScaleEndDetails details) {
                            print(details);

                            _previousScale = 1.0;
                            setState(() {});
                          },
                          child: RotatedBox(
                            quarterTurns: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.diagonal3(
                                    Vector3(_scale, _scale, _scale)),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://media.giphy.com/media/$gifs/giphy.gif',
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              child: Positioned(
                left: offset.dx,
                top: offset.dy,
                child: GestureDetector(
                    onPanUpdate: (details) {
                      print(offset);
                      setState(() {
                        offset = Offset(offset.dx + details.delta.dx,
                            offset.dy + details.delta.dy);
                      });
                    },
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () =>
                                _tapHandler(_text, _textStyle, _textAlign),
                            child: Text(
                              _text,
                              style: _textStyle,
                              textAlign: _textAlign,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
            checkvideo == false
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: Colors.black38,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    icon: Icon(
                      Icons.crop_rotate,
                      size: 27,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      croppedFile = await ImageCropper.cropImage(
                          sourcePath:
                              'https://firebasestorage.googleapis.com/v0/b/laid-69.appspot.com/o/boy.jpg?alt=media&token=491d0f8a-09ca-48f7-b95b-11d400a015f3',
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          androidUiSettings: AndroidUiSettings(
                              toolbarTitle: 'Resize',
                              toolbarColor: Color(0XFF252331),
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              backgroundColor: Colors.black,
                              cropFrameColor: Colors.blue,
                              activeControlsWidgetColor: Colors.blue,
                              lockAspectRatio: false),
                          iosUiSettings: IOSUiSettings(
                            minimumAspectRatio: 1.0,
                          ));
                      setState(() {});
                    }),
                IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 27,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      GiphyGif gif = await GiphyGet.getGif(
                          context: context, //Required
                          apiKey:
                              "ZD1hA474mv3VLV0VPoY7IudkwvdDHPmC", //Required.
                          lang: GiphyLanguage
                              .english, //Optional - Language for query.
                          searchText:
                              "Search GIF", //Optional - AppBar search hint text.
                          tabColor:
                              Colors.red, // Optional- default accent color.
                          modal: false);
                      if (gif != null) {
                        setState(() {
                          gifs = gif.id;
                        });
                      }
                    }),
                IconButton(
                  icon: Icon(
                    Icons.title,
                    size: 27,
                    color: Colors.white,
                  ),
                  onPressed: () => _tapHandler(_text, _textStyle, _textAlign),
                ),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 27,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
