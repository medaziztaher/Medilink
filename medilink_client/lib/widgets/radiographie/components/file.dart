import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/radiographie/radiographie_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../components/default_button.dart';
import '../../../utils/size_config.dart';

class RadioUpload extends StatelessWidget {
  const RadioUpload({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RadiographieController>(
      init: RadiographieController(userId: userId),
      builder: (controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultButton(
                press: controller.openFilePicker,
                text: 'Open File Picker',
              ),
              SizedBox(height: 16.0),
              Text('Selected Files:'),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.filePaths.length,
                itemBuilder: (context, index) {
                  final filePath = controller.filePaths[index];
                  final fileName = path.basename(filePath);
                  return ListTile(
                    title: filePath.toLowerCase().endsWith('.pdf')
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFView(
                                  filePath: filePath,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(fileName),
                                SizedBox(
                                  width: getProportionateScreenWidth(5),
                                ),
                                Icon(Icons.document_scanner)
                              ],
                            ),
                          )
                        : filePath.toLowerCase().endsWith('.txt')
                            ? GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFView(
                                      filePath: filePath,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(fileName),
                                    SizedBox(
                                      width: getProportionateScreenWidth(5),
                                    ),
                                    Icon(Icons.document_scanner)
                                  ],
                                ),
                              )
                            : filePath.toLowerCase().endsWith('.doc')
                                ? GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFView(
                                          filePath: filePath,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(fileName),
                                        SizedBox(
                                          width: getProportionateScreenWidth(5),
                                        ),
                                        Icon(Icons.document_scanner)
                                      ],
                                    ),
                                  )
                                : filePath.toLowerCase().endsWith('.docx')
                                    ? GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFView(
                                              filePath: filePath,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(fileName),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      5),
                                            ),
                                            Icon(Icons.document_scanner)
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        child: Image.file(
                                          File(filePath),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                appBar: AppBar(),
                                                body: Container(
                                                  child:
                                                      PhotoViewGallery.builder(
                                                    itemCount: 1,
                                                    builder: (context, index) {
                                                      return PhotoViewGalleryPageOptions(
                                                        imageProvider:
                                                            FileImage(
                                                                File(filePath)),
                                                        initialScale:
                                                            PhotoViewComputedScale
                                                                .contained,
                                                        minScale:
                                                            PhotoViewComputedScale
                                                                    .contained *
                                                                0.8,
                                                        maxScale:
                                                            PhotoViewComputedScale
                                                                    .covered *
                                                                2,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteFile(filePath),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
