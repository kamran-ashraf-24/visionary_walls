import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionary_walls/models/info_model.dart';
import 'package:visionary_walls/screens/home/widgets/image_container.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final List<Info> _infos = [];
  Future<List<Info>> fetchDownloaded() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        'My Favorites',
        style: GoogleFonts.openSans(
          color: colorScheme.onSurface,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
    );
    final Text middle = Text(
      'My Favorites',
      style: GoogleFonts.openSans(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              CupertinoSliverNavigationBar(
                largeTitle: title,
                middle: middle,
                alwaysShowMiddle: false,
                stretch: true,
                border: Border(),
                backgroundColor: Theme.of(
                  context,
                ).scaffoldBackgroundColor.withAlpha(180),

                bottom: PreferredSize(
                  preferredSize: Size(16, 16),
                  child: SizedBox(),
                ),
                bottomMode: NavigationBarBottomMode.always,
              ),
            ],
        body: FutureBuilder<List<Info>>(
          future: fetchDownloaded(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    _infos.isNotEmpty
                        ? NotificationListener<ScrollNotification>(
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 20.0),
                            itemBuilder:
                                (context, index) => GestureDetector(
                                  // onTap:
                                  //     () => Navigator.pushNamed(
                                  //       context,
                                  //       '/view',
                                  //       arguments: {
                                  //         'info': _infos[index],
                                  //         'infos': _infos,
                                  //         'index': index,

                                  //       },
                                  //     ),
                                  child: ImageContainer(info: _infos[index]),
                                ),
                            separatorBuilder:
                                (contex, index) => SizedBox(height: 16),
                            itemCount: _infos.length,
                          ),
                        )
                        : Center(child: Text('No data')),
              );
            }
            return Center(
              child: CircularProgressIndicator(color: colorScheme.onSurface),
            );
          },
        ),
      ),
    );
  }
}
