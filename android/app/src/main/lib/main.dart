import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EthioSuperApp(),
  ));
}

class EthioSuperApp extends StatefulWidget {
  const EthioSuperApp({super.key});
  @override
  State<EthioSuperApp> createState() => _EthioSuperAppState();
}

class _EthioSuperAppState extends State<EthioSuperApp> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  
  // Data values
  double usdToEtb = 115.60;
  String fuelPrice = "110.00 ETB";
  String goldPrice = "6,500 ETB/Gram";
  String cementPrice = "2,000 ETB/Bag";
  bool isLoading = true;

  // Ad Unit IDs (Replace XXXXX with your real IDs)
  final String bannerId = 'ca-app-pub-2189629238123101/2629894385';
  final String interId = 'ca-app-pub-2189629238123101/4537872425';

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
    _loadAds();
  }

  Future<void> _fetchExchangeRate() async {
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          usdToEtb = data['rates']['ETB'].toDouble();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _loadAds() {
    // Load Banner
    _bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (_) => setState(() {})),
    )..load();

    // Load Interstitial
    InterstitialAd.load(
      adUnitId: interId,
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
      _loadAds(); // Reload for next time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text("Ethio Daily Info", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {
              _fetchExchangeRate();
              _showInterstitial(); // Show ad on refresh
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoTile("USD to ETB", "1 USD = $usdToEtb ETB", Icons.monetization_on, Colors.green),
                  _infoTile("Fuel Price", fuelPrice, Icons.local_gas_station, Colors.orange),
                  _infoTile("Gold (21K)", goldPrice, Icons.settings_input_component, Colors.amber),
                  _infoTile("Cement (PPC)", cementPrice, Icons.build, Colors.brown),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showInterstitial,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("SEE MORE DETAILS", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }

  Widget _infoTile(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
