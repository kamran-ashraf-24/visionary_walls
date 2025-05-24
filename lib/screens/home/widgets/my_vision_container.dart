import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyVisionContainer extends StatelessWidget {
  const MyVisionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withAlpha(16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                'My favorites',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
            ],
          ),
          SizedBox(
            width: 60,
            child: Image.asset('assets/favorite.png', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
