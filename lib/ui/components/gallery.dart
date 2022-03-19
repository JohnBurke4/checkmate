import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final urlImages = [
    'https://imageio.forbes.com/specials-images/imageserve/61499e784c9631d3af55ed22/Magnus-Carlsen-Mastercard-promotional-headshot/960x0.jpg?fit=bounds&format=jpg&width=960',
    'https://upload.wikimedia.org/wikipedia/commons/e/ec/FIDE_World_FR_Chess_Championship_2019_-_Magnus_Carlsen_%28cropped%29.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/a/aa/Carlsen_Magnus_%2830238051906%29.jpg',
    'https://images.chesscomfiles.com/uploads/v1/news/895104.ba7ca489.668x375o.37bd1f5b4a08.jpeg',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: InkWell(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(urlImages.first),
            ),
            onTap: openGallery,
          ),
        ),
      );

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          urlImages: urlImages,
        ),
      ));
}

//class PickFromCameraRoll extends StatefulWidget{

//}

class GalleryWidget extends StatefulWidget {
  final PageController pageController;
  final List<String> urlImages;
  final index;

  GalleryWidget({
    Key? key,
    required this.urlImages,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: PhotoViewGallery.builder(
          pageController: widget.pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.urlImages.length,
          builder: (context, index) {
            final urlImage = widget.urlImages[index];

            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(urlImage),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2,
            );
          },
        ),
      );
}
