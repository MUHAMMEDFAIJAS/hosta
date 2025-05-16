// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdBannerWidget extends StatefulWidget {
//   const AdBannerWidget({super.key});

//   @override
//   State<AdBannerWidget> createState() => _AdBannerWidgetState();
// }

// class _AdBannerWidgetState extends State<AdBannerWidget> {
//   late BannerAd _bannerAd;
//   bool _isAdLoaded = false;

//   @override
//   void initState() {
//     super.initState();

//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-9727415183002174/2749824360', // ✅ your ad unit
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//           print('Ad failed to load: $error');
//         },
//       ),
//     )..load();
//   }

//   @override
//   void dispose() {
//     _bannerAd.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isAdLoaded
//         ? SizedBox(
//             height: _bannerAd.size.height.toDouble(),
//             width: _bannerAd.size.width.toDouble(),
//             child: AdWidget(ad: _bannerAd),
//           )
//         : const SizedBox(); 
//   }
// }
