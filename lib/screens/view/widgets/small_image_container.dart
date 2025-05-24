import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionary_walls/models/info_model.dart';

class SmallImageContainer extends StatelessWidget {
  const SmallImageContainer({
    super.key,
    required this.infos,
    required this.index,
  });
  final List<Info> infos;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(right: 12),
      clipBehavior: Clip.antiAlias,

      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: colorScheme.onSurface.withAlpha(24),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://picsum.photos/id/${infos[index].id}/400',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    padding: EdgeInsets.only(left: 12, top: 8, bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black45, Colors.transparent],
                      ),
                    ),
                    child: Text(
                      infos[index].name.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        color: Colors.grey[100],
                      ),
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
