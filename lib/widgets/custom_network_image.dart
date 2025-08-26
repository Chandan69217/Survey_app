import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? selectedFile;
  final String? placeHolder;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomNetworkImage({
    Key? key,
    this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.selectedFile,
    this.placeHolder,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        child: selectedFile != null ?
        Image.file(
          selectedFile!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        )
            : imageUrl==null || imageUrl!.isEmpty ?  Image.asset(
          placeHolder??'assets/images/dummy_profile.webp',
          width: width,
          height: height,
          fit: fit,
        ): CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          width: width,
          height: height,
          fit: fit,
          imageBuilder: (context, imageProvider) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(placeHolder??'assets/images/dummy_profile.webp',),
                fit: fit,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
            ),
          ),
          errorWidget: (context, url, error) => placeHolder != null
              ? Image.asset(placeHolder!, width: width, height: height, fit: fit)
              : const Icon(Icons.broken_image, size: 40),
        )

      // FadeInImage.assetNetwork(
      //   width: width,
      //   height: height,
      //   placeholder: placeHolder??'assets/logo/Placeholder_image.webp',
      //   image: imageUrl!,
      //   fit: fit,
      //   imageErrorBuilder: (context, error, stackTrace) {
      //     return Image.asset(
      //       placeHolder??'assets/logo/Placeholder_image.webp',
      //       width: width,
      //       height: height,
      //       fit: fit,
      //     );
      //   },
      // ),
    );
  }
}