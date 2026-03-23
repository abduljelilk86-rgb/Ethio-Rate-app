import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const EthioRateApp());
}

class EthioRateApp extends StatelessWidget {
  const EthioRateApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ethio Rate',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  double usdToEtb = 115.60;
  double result = 0;

  final String bannerUnitId = 'ca-app-pub-2189629238123101~2629894385';
  final String interstitialUnitId = 'ca-app-pub-2189629238123101/4537872425';

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    _bannerAd = BannerAd(
      adUnitId: bannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (_) => setState(() {})),
    )..load();

    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _loadAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ethio Rate"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.green),
                title: const Text("የባንክ ምንዛሬ"),
                trailing: Text("$usdToEtb ETB", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: "የዶላር መጠን ($)", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  double amount = double.tryParse(value) ?? 0;
                  result = amount * usdToEtb;
                });
              },
            ),
            const SizedBox(height: 20),
            Text("ውጤት: ${result.toStringAsFixed(2)} ብር", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showInterstitial,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("አስላ"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bannerAd != null
          ? SizedBox(width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!))
          : null,
    );
  }
}
