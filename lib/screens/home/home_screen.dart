import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionary_walls/models/info_model.dart';
import 'package:visionary_walls/screens/home/widgets/image_container.dart';
import 'package:visionary_walls/screens/home/widgets/my_vision_container.dart';
import 'package:visionary_walls/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  final List<Info> _infos = [];
  int _page = 1;
  final int _limit = 5;
  bool _isLoading = false;
  bool _isFirstLoading = true;
  bool _hasMore = true;
  @override
  void initState() {
    _fetchItems();
    super.initState();
  }

  Future<void> _fetchItems() async {
    setState(() => _isLoading = true);

    try {
      final newInfos = await _apiService.fetchItems(_page, _limit);
      setState(() {
        _infos.addAll(newInfos);
        _isLoading = false;
        _hasMore = newInfos.length == _limit;
        _page++;
        _isFirstLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      setState(() => _isFirstLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        'Explore Vision',
        style: GoogleFonts.openSans(
          color: colorScheme.onSurface,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
    );
    final Text middle = Text(
      'Explore Vision',
      style: GoogleFonts.openSans(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
              !_isFirstLoading
                  ? _infos.isNotEmpty
                      ? NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.pixels >=
                                  scrollNotification.metrics.maxScrollExtent -
                                      300 &&
                              !_isLoading &&
                              _hasMore) {
                            _fetchItems();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 20.0),
                          itemBuilder:
                              (context, index) =>
                                  index == 0
                                      ? GestureDetector(
                                        onTap: ()=>Navigator.pushNamed(context, '/download'),
                                        child: MyVisionContainer())
                                      : index - 1 < _infos.length
                                      ? GestureDetector(
                                        onTap:
                                            () => Navigator.pushNamed(
                                              context,
                                              '/view',
                                              arguments: {
                                                'info': _infos[index - 1],
                                                'infos': _infos,
                                                'index': index - 1,
                                               
                                              },
                                            ),
                                        child: ImageContainer(
                                          info: _infos[index - 1],
                                        ),
                                      )
                                      : Center(
                                        child: CircularProgressIndicator(
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                          separatorBuilder:
                              (contex, index) => SizedBox(height: 16),
                          itemCount: _infos.length + 1 + (_isLoading ? 1 : 0),
                        ),
                      )
                      : Center(child: Text('No data'))
                  : Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.onSurface,
                    ),
                  ),
        ),
      ),
    );
  }
}
