import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as path;

// class PdfPreviewProject extends StatefulWidget {
//   @override
//   _PdfPreviewProjectState createState() => _PdfPreviewProjectState();
// }
//
// class _PdfPreviewProjectState extends State<PdfPreviewProject> {
//   String pathPDF = "";
//   String landscapePathPdf = "";
//   String remotePDFpath = "";
//   String corruptedPathPDF = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fromAsset('assets/corrupted.pdf', 'corrupted.pdf').then((f) {
//       setState(() {
//         corruptedPathPDF = f.path;
//       });
//     });
//     fromAsset('assets/demo-link.pdf', 'demo.pdf').then((f) {
//       setState(() {
//         pathPDF = f.path;
//       });
//     });
//     fromAsset('assets/demo-landscape.pdf', 'landscape.pdf').then((f) {
//       setState(() {
//         landscapePathPdf = f.path;
//       });
//     });
//
//     createFileOfPdfUrl().then((f) {
//       setState(() {
//         remotePDFpath = f.path;
//       });
//     });
//   }
//
//   Future<File> createFileOfPdfUrl() async {
//     Completer<File> completer = Completer();
//     print("Start download file from internet!");
//     try {
//       // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
//       // final url = "https://pdfkit.org/docs/guide.pdf";
//       final url = "http://www.pdf995.com/samples/pdf.pdf";
//       final filename = url.substring(url.lastIndexOf("/") + 1);
//       var request = await HttpClient().getUrl(Uri.parse(url));
//       var response = await request.close();
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       var dir = await getApplicationDocumentsDirectory();
//       print("Download files");
//       print("${dir.path}/$filename");
//       File file = File("${dir.path}/$filename");
//
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file!');
//     }
//
//     return completer.future;
//   }
//
//   Future<File> fromAsset(String asset, String filename) async {
//     // To open from assets, you can copy them to the app storage folder, and the access them "locally"
//     Completer<File> completer = Completer();
//
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/$filename");
//       var data = await rootBundle.load(asset);
//       var bytes = data.buffer.asUint8List();
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file!');
//     }
//
//     return completer.future;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PDF View',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Plugin example app')),
//         body: Center(child: Builder(
//           builder: (BuildContext context) {
//             return Column(
//               children: <Widget>[
//                 TextButton(
//                   child: Text("Open PDF"),
//                   onPressed: () {
//                     if (pathPDF.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFScreen(path: pathPDF),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Open Landscape PDF"),
//                   onPressed: () {
//                     if (landscapePathPdf.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               PDFScreen(path: landscapePathPdf),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Remote PDF"),
//                   onPressed: () {
//                     if (remotePDFpath.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFScreen(path: remotePDFpath),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Open Corrupted PDF"),
//                   onPressed: () {
//                     if (pathPDF.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               PDFScreen(path: corruptedPathPDF),
//                         ),
//                       );
//                     }
//                   },
//                 )
//               ],
//             );
//           },
//         )),
//       ),
//     );
//   }
// }

class PDFScreen extends StatefulWidget {
  final List<FileDetailModel>? filePaths;
  final String? path;

  const PDFScreen({super.key, this.filePaths, this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Utility Bill "),

        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("Submit")),
              ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[

            PDFView(
              //filePath: "https://docs.google.com/viewerng/viewer?url=https://www.learningcontainer.com/download/sample-pdf-file-for-testing/?ind%3D0%26filename%3Dsample-pdf-file.pdf%26wpdmdl%3D1566%26refresh%3D663cc84a4b8fd1715259466%26open%3D1",
              filePath: "http://www.pdf995.com/samples/pdf.pdf",
              enableSwipe: false,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),

           /* ListView.builder(
              itemCount: widget.filePaths!.length,
              itemBuilder: (BuildContext context, int index) {
                var filePath = widget.filePaths?[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(2))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // Text("${filePath?.name}  ${filePath?.size}")
                  child: PDFView(
                    filePath: filePath?.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage!,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: false,
                    // if set to true the link is handled in flutter

                    onRender: (pages) {
                      setState(() {
                        pages = pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      //_controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String? uri) {
                      print('goto uri: $uri');
                    },
                    onPageChanged: (int? page, int? total) {
                      print('page change: $page/$total');
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),
                );
              },
            ),*/

            /* widget.filePaths!.length > 1
                  ? GridView.builder(
                      itemCount: widget.filePaths?.length,
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: (orientation == Orientation.portrait) ? 1 : 2),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // crossAxisCount: widget.filePaths!.length>1 ?2:1,
                        crossAxisCount: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var filePath = widget.filePaths?[index];
                        return PDFView(
                          filePath: filePath,
                          enableSwipe: false,
                          swipeHorizontal: false,
                          autoSpacing: false,
                          pageFling: false,
                          pageSnap: true,
                          defaultPage: currentPage!,
                          fitPolicy: FitPolicy.BOTH,
                          preventLinkNavigation: false,
                          // if set to true the link is handled in flutter
                          onRender: (pages) {
                            setState(() {
                              pages = pages;
                              isReady = true;
                            });
                          },
                          onError: (error) {
                            setState(() {
                              errorMessage = error.toString();
                            });
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            setState(() {
                              errorMessage = '$page: ${error.toString()}';
                            });
                            print('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            //_controller.complete(pdfViewController);
                          },
                          onLinkHandler: (String? uri) {
                            print('goto uri: $uri');
                          },
                          onPageChanged: (int? page, int? total) {
                            print('page change: $page/$total');
                            setState(() {
                              currentPage = page;
                            });
                          },
                        );
                      },
                    )
                  : PDFView(
                      filePath: "https://docs.google.com/viewerng/viewer?url=https://www.learningcontainer.com/download/sample-pdf-file-for-testing/?ind%3D0%26filename%3Dsample-pdf-file.pdf%26wpdmdl%3D1566%26refresh%3D663cc84a4b8fd1715259466%26open%3D1",
                      enableSwipe: false,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: false,
                      pageSnap: true,
                      defaultPage: currentPage!,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation: false,
                      // if set to true the link is handled in flutter
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        print('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),*/
            errorMessage.isEmpty
                ? !isReady
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container()
                : Center(
              child: Text(errorMessage),
            )
          ],
        ),
        // floatingActionButton: FutureBuilder<PDFViewController>(
        //   future: _controller.future,
        //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
        //     if (snapshot.hasData) {
        //       return FloatingActionButton.extended(
        //         label: Text("Go to ${pages! ~/ 2}"),
        //         onPressed: () async {
        //           await snapshot.data!.setPage(pages! ~/ 2);
        //         },
        //       );
        //     }
        //
        //     return Container();
        //   },
        // ),
        );
  }
}

///file picker
class FilePickerScreen extends StatefulWidget {
  const FilePickerScreen({super.key});

  @override
  State<FilePickerScreen> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              pickMultipleFiles();
            },
            child: const Text("Single File Picker")),
        ElevatedButton(
            onPressed: () {
              pickMultipleFiles();
            },
            child: const Text("Multiple File Picker")),
      ],
    ));
  }

  void pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.path.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: file.path),
          ),
        );
      }
    } else {
      // User canceled the picker
    }
  }

  void pickMultipleFiles() async {
    // FilePickerResult? result =
    //     await FilePicker.platform.pickFiles(allowMultiple: true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ 'pdf'],
        allowMultiple: true
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      List<FileDetailModel> filePaths = [];
      for (var element in files) {
        // print("file : ${element.}");

        String size=await getFileSize(element.path, 1);
        String name=fileName(element);
        // print("file size : ${await getFileSize(element.path, 1)}");
        // print("file name : ${fileName(element)}");
        filePaths.add(FileDetailModel(element.path,name,size));
      }

      if (filePaths.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(filePaths: filePaths),
          ),
        );
      }
    } else {
      // User canceled the picker
    }
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  String fileName(File file) {
    String basename = path.basename(file.path);
    return basename;
  }
}

class FileDetailModel{
  String path;
  String name;
  String size;

  FileDetailModel(this.path,this.name,this.size);
}
