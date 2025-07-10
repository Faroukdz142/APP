import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String image;
  final String id;
  const ProductImage({super.key, required this.image, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4, vertical: 10),
      child: Hero(
        tag: id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            cacheKey: id,
            imageUrl: image,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 3,
          ),
        ),
      ),
    );
  }
}
