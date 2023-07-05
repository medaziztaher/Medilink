import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/radiographie.dart';
import 'package:medilink_client/settings/path.dart';
import 'package:medilink_client/widgets/radiographie/edit_radio/edit_radio_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../api/user.dart';

class Body extends StatelessWidget {
  const Body(
      {Key? key,
      required this.radiographie,
      required this.userId,
      this.provider})
      : super(key: key);

  final Radiographie radiographie;
  final String userId;
  final String? provider;

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

  void _openFile(BuildContext context, String fileUrl) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (userId == radiographie.patient ||
              userId == radiographie.provider) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Get.off(() => EditRadioScreen(
                        radiographie: radiographie,
                        userId: userId,
                      )),
                  icon: Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      final response = await networkHandler
                          .delete("$radioPath/${radiographie.id}");
                      final responseData = json.decode(response.body);
                      print(responseData);
                      if (response.statusCode == 200) {
                        final message = responseData['message'];
                        Get.back();
                        Get.snackbar("Radiographie Deleted", message);
                      } else if (response.statusCode == 500) {
                        final message = responseData['error'];
                        Get.snackbar("Error Deleting Radiographie", message);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Type: '),
                  subtitle: Text('${radiographie.type}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Description: '),
                  subtitle: Text('${radiographie.description}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Reason: '),
                  subtitle: Text('${radiographie.reason}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Date: '),
                  subtitle: Text('${radiographie.date}'),
                ),
                SizedBox(height: 10),
                if (radiographie.provider != null) ...[
                  ListTile(
                    title: Text('Provider: '),
                    subtitle: Text('$provider'),
                  ),
                ],
                if (radiographie.files != null &&
                    radiographie.files!.isNotEmpty) ...[
                  Column(
                    children: [
                      Text('Files:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: radiographie.files!.length,
                        itemBuilder: (context, index) {
                          final file = radiographie.files![index];
                          return ListTile(
                            leading: Icon(_getFileTypeIcon(file)),
                            title: Text(file.split('/').last),
                            onTap: () {
                              _openFile(context, file);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
