import 'package:airview_tech/Home/AdHelper.dart';
import 'package:airview_tech/Home/offer_view.dart';
import 'package:airview_tech/Home/profile/profile.dart';
import 'package:airview_tech/Home/publish_offer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  int _currentIndex = 0;
  BannerAd? _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  _createBannerAd() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad?.load();
  }

  final List<Widget> _children = const [
    OfferView(),
    PublishOffer(),
    Profile(),
  ];

  Widget showAdd() {
    if (_isAdLoaded) {
      return Container(
        width: _ad?.size.width.toDouble(),
        height: _ad?.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _ad!),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _children[_currentIndex]),
          showAdd(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: "Offers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Tickets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}
