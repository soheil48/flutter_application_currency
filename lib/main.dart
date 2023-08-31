import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'Model/Currency.dart';

void main(List<String> args) => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Currency> currency = [];

  Future getResponse(BuildContext context) async {
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    var value = await http.get(Uri.parse(url));

    print(value.statusCode);
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'بروزرسانی اطلاعات با موفقیت انجام شد');

        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(
              () {
                currency.add(
                  Currency(
                    id: jsonList[i]['id'],
                    title: jsonList[i]['title'],
                    price: jsonList[i]['price'],
                    changes: jsonList[i]['changes'],
                    status: jsonList[i]['status'],
                  ),
                );
              },
            );
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // farsi
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lalezar',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Lalezar',
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lalezar',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Lalezar',
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Color.fromARGB(243, 243, 243, 243),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  'assets/picture/wallet.png',
                  cacheHeight: 40,
                  width: 40,
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 10),
                    child: Text(
                      'قیمت بروز',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontFamily: 'Lalezar',
                          fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Image.asset(
                      'assets/picture/ham.png',
                      alignment: Alignment.centerLeft,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.quiz_rounded,
                            size: 30, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          'نرخ ارز آزاد چیست؟',
                          style: TextStyle(fontSize: 14.5),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(19.0),
                    child: Text(
                      'نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را باهم تبادل می نمایید.',
                      // textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 13,
                          // fontFamily: 'Lalezar',
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 104, 104, 104),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          // SizedBox(height: 20),
                          Text(
                            'نام آزاد ارز',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'قیمت',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'تغییر',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          // SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.1,
                    width: 345,
                    child: listFutureBuilder(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 220, 220, 220),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 202, 193, 255),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                currency.clear();
                                listFutureBuilder(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh,
                                color: Color.fromARGB(255, 42, 42, 42),
                              ),
                              label: const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(
                                  'بروزرسانی',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w100,
                                      color: Color.fromARGB(255, 44, 44, 44)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(38, 0, 0, 0),
                            child: Text('آخرین بروزرسانی ${_gettime()}'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int postion) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Myitem(postion, currency),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }
}

String _gettime() {
  DateTime now = DateTime.now();
  return DateFormat('kk:mm').format(now);
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style:
            const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Lalezar'),
      ),
      backgroundColor: Colors.green,
    ),
  );
}

// ignore: must_be_immutable
class Myitem extends StatelessWidget {
  int postion;
  List<Currency> currency;
  Myitem(this.postion, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 2, color: Colors.grey)],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[postion].title!,
            style: const TextStyle(
                color: Color.fromARGB(255, 54, 54, 54), fontSize: 13),
          ),
          Text(
            getFarsinumber(currency[postion].price.toString()),
            style: const TextStyle(color: Colors.blueAccent, fontSize: 13),
          ),
          // Text(
          //   currency[postion].status!,
          //   style: const TextStyle(color: Colors.green, fontSize: 13),
          // ),
          Text(
            getFarsinumber(currency[postion].changes.toString()),
            style: currency[postion].status == 'n'
                ? const TextStyle(color: Colors.red, fontSize: 13)
                : const TextStyle(color: Colors.green, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

String getFarsinumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });

  return number;
}
