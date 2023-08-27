import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart' as gdpr;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

String _url = 'https://wa.me/';
String _whatsapp = 'https://wa.me/';
String _country = '+1';
const String historyPageBannerID = "ca-app-pub-1062782143322117/7804938480";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  _sendURL() async {
    if (await canLaunchUrl(Uri.parse(_url))) {
      await launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_url';
    }
  }

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: const AdRequest(),
      adUnitId: historyPageBannerID,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  void gdprConsent() async {
    final consent = await gdpr.GdprDialog.instance.getConsentStatus();
    if (consent == gdpr.ConsentStatus.required ||
        consent == gdpr.ConsentStatus.unknown) {
      // await gdpr.GdprDialog.instance.resetDecision();
      await gdpr.GdprDialog.instance.showDialog(
          isForTest: false, testDeviceId: 'B292DCBE404628828AFB70BBBBB6B248');
    }
  }

  @override
  void initState() {
    gdprConsent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Chat Easy!",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Image.asset(
                            'asset/whatsappimg.png',
                            height: 110,
                          )),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Send WhatsApp message\nwithout saving number!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.yellow),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      CountryCodePicker(
                        onChanged: urlChange,
                        initialSelection: 'US',
                        showDropDownButton: true,
                        dialogBackgroundColor: Colors.grey[900],
                        barrierColor: Colors.grey[900],
                        backgroundColor: Colors.grey[900],
                        textStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 15),
                        dialogTextStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 15),
                        searchStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 15),
                        searchDecoration: InputDecoration(
                          hintText: "Search",
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              )),
                        ),
                      ),
                      TextField(
                        controller: _mobileController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color(0xFFE0E0E0), fontSize: 16),
                        cursorColor: Colors.grey[400],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Mobile",
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: _textController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color(0xFFE0E0E0), fontSize: 16),
                        cursorColor: Colors.grey[400],
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: ElevatedButton(
                          onPressed: () {
                            _url = _whatsapp +
                                _country +
                                _mobileController.text +
                                '?text=' +
                                _textController.text;
                            _sendURL();
                          },
                          child: const Text('Send'),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(190, 45),
                              primary: const Color(0xFF2FCE5D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (_anchoredBanner != null)
              Container(
                color: Colors.blue,
                width: _anchoredBanner!.size.width.toDouble(),
                height: _anchoredBanner!.size.height.toDouble(),
                child: AdWidget(ad: _anchoredBanner!),
              ),
          ]),
    );
  }
}

void urlChange(Object? object) {
  String line = object.toString();
  _country = line;
}
