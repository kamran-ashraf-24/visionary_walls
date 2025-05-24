import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:visionary_walls/models/info_model.dart';
import 'package:visionary_walls/screens/view/widgets/small_image_container.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({
    super.key,
    required this.info,
    required this.infos,
    required this.index,
  });
  final int index;
  final Info info;
  final List<Info> infos;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool _isLoading = false;
  bool _isLoaded = false;
  Future<void> _downloadImageToGallery(String imageUrl) async {
    // Request permissions
    // final status = await Permission.photos.request(); // iOS
    // final storage = await Permission.storage.request(); // Android

    // if (!status.isGranted && !storage.isGranted) {
    //   throw Exception("Permission denied");
    // }

    try {
      // Download image data
      setState(() => _isLoading = true);
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;

        // Save to gallery
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
        );
        setState(() => _isLoading = false);
        setState(() => _isLoaded = true);

        print('Saved to gallery: $result');
      } else {
        throw Exception("Image download failed");
      }
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 40),
            Container(
              clipBehavior: Clip.antiAlias,
              height: height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.info.url,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 280),
                    fadeOutDuration: Duration(milliseconds: 280),
                    placeholder:
                        (context, url) => CachedNetworkImage(
                          imageUrl:
                              'https://picsum.photos/id/${widget.info.id}/800',
                          fit: BoxFit.cover,
                        ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black45, Colors.transparent],
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.info.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.josefinSans(
                                  fontSize: 30,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[100],
                                ),
                              ),

                              Text(
                                'Resolution • ${widget.info.width} × ${widget.info.height} pixels',
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withAlpha(120),
                                ),
                              ),
                              SizedBox(height: 4),
                              FilledButton.icon(
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.grey[100],
                                  ),
                                ),
                                onPressed:
                                    () => _downloadImageToGallery(
                                      widget.info.url,
                                    ),
                                label: Text(
                                  _isLoading
                                      ? 'Added to Device'
                                      : 'Add to Device',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                icon:
                                    !_isLoading
                                        ? Icon(
                                          _isLoaded ? Icons.done : Icons.add,
                                          color: Colors.grey[800],
                                        )
                                        : SizedBox(
                                          height: 12,
                                          width: 12,
                                          child: CircularProgressIndicator(
                                            color: Colors.grey[800],
                                            strokeWidth: 1,
                                          ),
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: IconButton.filled(
                        padding: EdgeInsets.zero,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.black.withAlpha(120),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[100],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 10, bottom: 8),
                child: Text(
                  'Related',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              height: 160,

              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap:
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/view',
                          arguments: {
                            'info':
                                widget.infos[(widget.index + index + 1) %
                                    widget.infos.length],
                            'infos': widget.infos,
                            'index': widget.index + 1,
                          },
                        ),
                    child: SmallImageContainer(
                      infos: widget.infos,
                      index: (widget.index + index + 1) % widget.infos.length,
                    ),
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
