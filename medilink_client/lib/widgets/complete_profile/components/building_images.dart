

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../complete_profile_controller.dart';

class BuildingImages extends StatelessWidget {
  const BuildingImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteProfileController>(
      init: CompleteProfileController(),
      builder: (controller) {
        return SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildImage(
                context,
                controller,
                imageIndex: 1,
              ),
              SizedBox(width: 12),
              buildImage(
                context,
                controller,
                imageIndex: 2,
              ),
              SizedBox(width: 12),
              buildImage(
                context,
                controller,
                imageIndex: 3,
              ),
              SizedBox(width: 12),
              buildImage(
                context,
                controller,
                imageIndex: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildImage(BuildContext context, CompleteProfileController controller,
      {required int imageIndex}) {
    bool showAddIcon = controller.imageFiles[imageIndex - 1] == null;
    XFile? imageFile = controller.imageFiles[imageIndex - 1];

    return GestureDetector(
      onTap: () {
        if (showAddIcon) {
          controller.selectImage(imageIndex);
        } else {
          controller.deleteImage(imageIndex);
        }
      },
      child: Container(
        width: 200,
        height: 200,
        color: Colors.grey,
        child: Stack(
          children: [
            if (!showAddIcon && imageFile != null)
              Center(
                child: Image.file(File(imageFile.path), fit: BoxFit.fill,  width: double.infinity, height: double.infinity
                ),
              ),
            if (showAddIcon)
              Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (builder) => Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "kbuildingpic".tr,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton.icon(
                                  icon: const Icon(Icons.camera),
                                  onPressed: () {
                                    controller.takebuildingPhoto(
                                        ImageSource.camera, imageIndex);
                                    Navigator.pop(context);
                                  },
                                  label: Text("kcamera".tr),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.image),
                                  label: Text('kselectimage'.tr),
                                  onPressed: () {
                                    controller.takebuildingPhoto(
                                        ImageSource.gallery, imageIndex);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (!showAddIcon && imageFile != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteImage(imageIndex);
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
