

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/constants/app_strings.dart';

import '../../config/theme/atoms/text.dart';
import "common_toast.dart";
import 'devlog.dart';

enum UploadType {
  cameraImage("Upload Image from Camera", Icons.camera_alt),
  cameraVideo("Upload Video from Camera", Icons.camera),
  galleryImage("Upload Image from Gallery", Icons.image_outlined),
  galleryVideo("Upload Video from Gallery", Icons.video_call),
  galleryMultipleImages("Upload Images from Gallery", Icons.image_outlined),
  pdf("Upload PDF", Icons.picture_as_pdf_outlined),
  ;

  final String title;
  final IconData icon;

  const UploadType(this.title, this.icon);
}

class PickedImage {
  final List<String?> paths;
  final UploadType type;

  PickedImage({required this.paths, required this.type});
}

class ImageUtils {
  ImageUtils._();

  static Future<Uint8List> getImageData(String url) async {
    Uri uri = Uri.parse(url);

    final response = await http.get(uri);

    devlog("IMAGE_DATA_DOWNLOADED_FOR : $url");
    return response.bodyBytes;
  }

  static Future<String?> pickImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source, imageQuality: 80, maxWidth: 800, maxHeight: 800);

      // If the user cancels or presses back, `image` will be null
      if (image == null) {
        debugPrint("No image selected.");
        return null;
      }
      final imagePath = image.path;
      return imagePath;
    } catch (e) {
      devlogError("error in category image upload  $e");
      showSnackbar("Trouble to pick image..try again later.!");
      return null;
    }
  }

  static Future<List<String?>> pickMultipleImages({int? limit}) async {
    try {
      devlog("LIMIT : $limit");
      final images = await ImagePicker().pickMultiImage(
          imageQuality: 80, maxWidth: 800, maxHeight: 800, limit: limit);
      if (images.isEmpty) return [];
      final imagesPath = images.map((e) => e.path).toList();
      return imagesPath;
    } catch (e) {
      devlogError("error in pickMultipleImages image upload $e");
      showSnackbar("Trouble to pick image..try again later.!");
      return [];
    }
  }

  static Future<String?> pickVideo({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickVideo(source: source);
      if (image == null) return null;
      final imagePath = image.path;
      return imagePath;
    } catch (e) {
      devlogError("error in pickVideo image upload $e");
      showSnackbar("Trouble to pick image..try again later.!");
      return null;
    }
  }

  static Future<String> cropImage(BuildContext context,
      {String? title, required String imagePath, required Size ratio}) async {
    return imagePath;
    // CroppedFile? croppedFile = await ImageCropper().cropImage(
    //   sourcePath: imagePath,
    //   aspectRatio: CropAspectRatio(ratioX: ratio.width, ratioY: ratio.height),
    //   uiSettings: [
    //     AndroidUiSettings(
    //         toolbarTitle: title ?? 'Edit Image',
    //         toolbarColor: AppColors.primary(context),
    //         toolbarWidgetColor: Colors.white,
    //         initAspectRatio: CropAspectRatioPreset.original,
    //         lockAspectRatio: true,
    //         hideBottomControls: true,
    //         activeControlsWidgetColor: AppColors.primary(context)),
    //     IOSUiSettings(title: title ?? 'Edit Image'),
    //     WebUiSettings(context: context),
    //   ],
    // );
    // return croppedFile?.path ?? '';
  }

  static Future<PickedImage?> showPickImageBottomSheet<T>(
    BuildContext context, {
    String title = "Upload Images",
    List<UploadType> fileTypes = const [
      UploadType.cameraImage,
      UploadType.galleryMultipleImages,
      UploadType.galleryVideo,
    ],
    int? limit,
  }) {
    return showModalBottomSheet<PickedImage>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (ctx) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: AppString.custom(title).title18.build(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                tileColor: ctx.colors.primary,
                onTap: () {},
              ),
              ...List.generate(
                fileTypes.length,
                (index) {
                  final fileType = fileTypes[index];
                  return _MediaTile(
                      title: fileType.title,
                      icon: fileType.icon,
                      onTap: () async {
                        final List<String?> imagePaths = switch (fileType) {
                          UploadType.cameraImage => [
                              await pickImage(source: ImageSource.camera)
                            ],
                          UploadType.cameraVideo => [
                              await pickVideo(source: ImageSource.camera)
                            ],
                          UploadType.galleryImage => [
                              await pickImage(source: ImageSource.gallery)
                            ],
                          UploadType.galleryVideo => [
                              await pickVideo(source: ImageSource.gallery)
                            ],
                          UploadType.galleryMultipleImages =>
                            await pickMultipleImages(limit: limit),
                          // UploadType.pdf => (await FilePicker.platform.pickFiles(allowMultiple: false, dialogTitle: "Pick PDF file", type: FileType.custom, allowedExtensions: ['pdf']))?.paths ?? []
                          _ => [],
                        };
                        Navigator.pop(ctx,
                            PickedImage(paths: imagePaths, type: fileType));
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MediaTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MediaTile(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AppString.custom(title).regular16.build(),
      leading: Icon(icon, color: context.colors.primary),
      onTap: onTap,
    );
  }
}
