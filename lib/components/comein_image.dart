import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thecomein/models/hotel_profile.dart';

class HotelImage extends StatelessWidget {
  final HotelProfile? hotel;
  final double height;
  final double width;

  const HotelImage(
      {Key? key,
      required this.hotel,
      required this.height,
      required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (hotel == null) return noImage();
    return hotel!.assetImages == ''
        ? noImage()
        : Image.network(hotel!.assetImages,
            height: height, width: width, fit: BoxFit.cover);
  }

  noImage() {
    return Image.asset('assets/images/noimage.jpeg',
        height: height, width: width, fit: BoxFit.cover);
  }
}

class TourImage extends StatelessWidget {
  final TourProfile? tour;
  final double height;
  final double width;

  const TourImage(
      {Key? key, required this.tour, required this.height, required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (tour == null) return noImage();
    return tour!.assetImages.isEmpty
        ? noImage()
        : Image.network(tour!.assetImages[0],
            height: height, width: width, fit: BoxFit.cover);
  }

  noImage() {
    return Image.asset('assets/images/noimage.jpeg',
        height: height, width: width, fit: BoxFit.cover);
  }
}

class TourAssetImage extends StatelessWidget {
  final TourProfile? tour;
  final String assetImage;
  final double height;
  final double width;

  const TourAssetImage(
      {Key? key,
      required this.tour,
      required this.assetImage,
      required this.height,
      required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(assetImage,
        height: height, width: width, fit: BoxFit.cover);
  }

  noImage() {
    return Image.asset('assets/images/noimage.jpeg',
        height: height, width: width, fit: BoxFit.cover);
  }
}

class ComeInImage {
  static hotelImage(HotelProfile? hotel, double height, double width) {
    if (hotel == null || hotel.assetImages == '') return noImage(height, width);
    return Image.network(hotel.assetImages,
        height: height, width: width, fit: BoxFit.cover);
    // return Image(
    //     image: CachedNetworkImageProvider(hotel.assetImages),
    //     height: height,
    //     width: width,
    //     fit: BoxFit.cover);
  }

  static noImage(double height, double width) {
    return Image.asset('assets/images/noimage.jpeg',
        height: height, width: width, fit: BoxFit.cover);
  }
}
