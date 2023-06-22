import 'package:flutter/material.dart';
import 'package:medilink_client/api/user.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../models/labresult.dart';
import '../../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.labid}) : super(key: key);
  final String labid;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Labresult?> labFuture;
  late String? provider;
  @override
  void initState() {
    super.initState();
    labFuture = getLab();
    getProviderName();
  }

  Future<Labresult?> getLab() async {
    try {
      final response =
          await networkHandler.get("$labresultPath/${widget.labid}");
      if (response['status'] == true) {
        return Labresult.fromJson(response['data']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> getProviderName() async {
    try {
      final response =
          await networkHandler.get("$labresultPath/${widget.labid}/provider");
      if (response['status'] == true) {
        print("${response['data']['provider']}");
        setState(() {
          provider = response['data']['provider'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Labresult?>(
      future: labFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching lab data'));
        } else if (snapshot.hasData) {
          final lab = snapshot.data!;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Test'),
                  subtitle: Text('${lab.test}'),
                ),
                ListTile(
                  title: Text('Reason: '),
                  subtitle: Text('${lab.reason}'),
                ),
                ListTile(
                  title: Text('Result: '),
                  subtitle: Text('${lab.result}'),
                ),
                if (provider != null) ...[
                  ListTile(
                    title: Text('Provider: '),
                    subtitle: Text(provider!),
                  ),
                ],
                ListTile(
                  title: Text('Date: '),
                  subtitle: Text('${lab.date}'),
                ),
                SizedBox(height: 10),
                if (lab.files != null && lab.files!.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Files:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lab.files!.length,
                        itemBuilder: (context, index) {
                          final file = lab.files![index];
                          return ListTile(
                            leading: Icon(_getFileTypeIcon(file.url!)),
                            title: Center(child: Text(file.id!)),
                            onTap: () {
                              print("file . url : ${file.url}");
                              _openFile(file.url!);
                            },
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No lab data available'));
        }
      },
    );
  }

  IconData _getFileTypeIcon(String fileUrl) {
    if (fileUrl.contains(RegExp(r'\.(jpe?g|png)'))) {
      return Icons.image;
    } else if (fileUrl.contains(RegExp(r'\.(pdf)'))) {
      return Icons.picture_as_pdf;
    } else if (fileUrl.contains(RegExp(r'\.(docx?|xls(x|)))'))) {
      return Icons.insert_drive_file;
    } else {
      return Icons.insert_drive_file;
    }
  }

  void _openFile(String fileUrl) {
    if (fileUrl.contains(RegExp(r'\.(jpe?g|png)'))) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return _buildImageGallery(fileUrl);
      }));
    } else if (fileUrl.contains(RegExp(r'\.(pdf)'))) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return _buildPdfViewer(fileUrl);
      }));
    }
  }

  Widget _buildImageGallery(String imageUrl) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(imageUrl),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
    );
  }

  Widget _buildPdfViewer(String pdfUrl) {
    return SfPdfViewer.network(pdfUrl, enableDocumentLinkAnnotation: false);
  }
}
