import 'package:flutter/material.dart';
import 'package:medilink_client/models/radiographie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../api/user.dart';
import '../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.radioId});
  final String radioId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Radiographie?> labFuture;
  late String? provider = null;
  @override
  void initState() {
    super.initState();
    labFuture = getRadio();
    getProviderName();
  }

  Future<Radiographie?> getRadio() async {
    try {
      final response = await networkHandler.get("$radioPath/${widget.radioId}");
      if (response['status'] == true) {
        return Radiographie.fromJson(response['data']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> getProviderName() async {
    try {
      final response =
          await networkHandler.get("$radioPath/${widget.radioId}/provider");
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
    return FutureBuilder<Radiographie?>(
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
                  title: Text('Type'),
                  subtitle: Text('${lab.type}'),
                ),
                ListTile(
                  title: Text('Reason: '),
                  subtitle: Text('${lab.reason}'),
                ),
                ListTile(
                  title: Text('Descirption: '),
                  subtitle: Text('${lab.description}'),
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
                if (lab.results != null && lab.results!.isNotEmpty)
                  Column(
                    children: [
                      Text('Results:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lab.results!.length,
                        itemBuilder: (context, index) {
                          final file = lab.results![index];
                          return ListTile(
                            leading: Icon(_getFileTypeIcon(file.url!)),
                            title: Text(file.id!),
                            subtitle: Text(file.url!),
                            onTap: () {
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
