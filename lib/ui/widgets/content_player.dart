import 'package:chewie/chewie.dart';
import 'package:filmfolio/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentPlayer extends StatefulWidget {
  final Movie movie;

  const ContentPlayer({Key? key, required this.movie}) : super(key: key);

  @override
  _ContentPlayerState createState() => _ContentPlayerState();
}

class _ContentPlayerState extends State<ContentPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.network(widget.movie.trailer);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      placeholder: const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() {
      _isPlayerReady = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Trailer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _isPlayerReady
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                )
              : const Center(child: CircularProgressIndicator()),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Scenes from ${widget.movie.name}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          _buildPhotoGallery(),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return widget.movie.photos.isEmpty
        ? Center(
            child: Text("No photos available",
                style: TextStyle(color: Colors.white)))
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: widget.movie.photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    _showFullScreenImage(context, widget.movie.photos[index]),
                child: Image.network(
                  widget.movie.photos[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    ));
  }
}
