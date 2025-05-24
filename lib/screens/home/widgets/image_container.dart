import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionary_walls/models/info_model.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.info});
  final Info info;
  final radius = 14.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.46,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.onSurface.withAlpha(24),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://picsum.photos/id/${info.id}/800',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(radius),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black45, Colors.transparent],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.name.toUpperCase(),
                          style: GoogleFonts.josefinSans(
                            fontSize: 24,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[100],
                          ),
                        ),
                        Text(
                          'Resolution • ${info.width} × ${info.height} pixels',
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(120),
                          ),
                        ),
                      ],
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
