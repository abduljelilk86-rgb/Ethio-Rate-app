import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: EthioRate()));
}

class EthioRate extends StatefulWidget {
  const EthioRate({super.key});
  @override
  State<EthioRate> createState() => _EthioRateState();
}

class _EthioRateState extends State<EthioRate> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  double usd = 115.60;
  double result = 0;

  final String bannerId = 'ca-app-pub-2189629238123101~2629894385';
  final String interstitialId = 'ca-app-pub-2189629238123101/4537872425;

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    _bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (_) => setState(() {})),
    )..load();

    InterstitialAd.load(
      adUnitId: interstitialId,
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
      appBar: AppBar(title: const Text("Ethio Rate"), centerTitle: true, backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.green),
                title: const Text("Bank Rate"),
                trailing: Text("$usd ETB", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: "USD ($)", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => result = (double.tryParse(v) ?? 0) * usd),
            ),
            const SizedBox(height: 20),
            Text("Result: ${result.toStringAsFixed(2)} ETB", style: const TextStyle(fontSize: 25, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _showInterstitial,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Calculate"),
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
የመጨረሻ እርምጃዎች
ይህንን ኮድ main.dart ላይ ለጥፈህ Commit changes በለው።

ስልክህ ላይ ያለው የድሮው አፕ (Flutter Demo) መኖሩን አረጋግጥና አጥፋው (Uninstall)።

Actions ገጽ ላይ ሂደቱ አረንጓዴ (✅) ሲሆን አዲሱን APK አውርደህ ጫነው።

አሁን ሁለቱም ማስታወቂያዎች ገብተዋል። ኮዱን ለጥፈህ ጨረስክ? Actions ላይ ቢጫው ምልክት መሽከርከር ጀመረ?
