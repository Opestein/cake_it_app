import 'dart:convert';

import 'package:cake_it_app/src/features/cake.dart';
import 'package:cake_it_app/src/features/cake_details_view.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Displays a list of cakes.
/// Hmmm Stateful Widget is used here, but it could be a StatelessWidget?
class CakeListView extends StatefulWidget {
  const CakeListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<CakeListView> createState() => _CakeListViewState();
}

class _CakeListViewState extends State<CakeListView> {
  final _refreshController = RefreshController(initialRefresh: false);
  List<Cake> cakes = [];

  @override
  void initState() {
    super.initState();
    fetchCakes();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Future<void> fetchCakes(
      {Function()? onSuccess, Function(String errorMessage)? onFailed}) async {
    final url = Uri.parse(
        "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = json.decode(response.body);
      setState(() {
        cakes = decodedResponse.map((cake) => Cake.fromJson(cake)).toList();
      });
      if (onSuccess != null) {
        onSuccess();
      }
    } else {
      String errorMessage = "";
      try {
        errorMessage = json.decode(response.body)["message"];
      } catch (err) {
        errorMessage = err.toString();
      }
      if (onFailed != null) {
        onFailed(errorMessage);
      }
    }
  }

  _onRefresh() {
    _refreshController.requestRefresh();
    fetchCakes(onSuccess: () {
      _refreshController.refreshToIdle();
    }, onFailed: (errorMessage) {
      _refreshController.refreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(label: "OK", onPressed: () {}),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂CakeItApp🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: Theme.of(context).primaryColor,
        ),
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        child: ListView.builder(
          restorationId: 'cakeListView',
          itemCount: cakes.length,
          itemBuilder: (BuildContext context, int index) {
            final cake = cakes[index];

            return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  cake.title ?? '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(cake.description ?? ''),
                leading: Hero(
                  tag: index,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                      cakes.elementAt(index).image!,
                    ),
                  ),
                ),
                onTap: () {
                  Cake cake = cakes.elementAt(index);
                  Navigator.restorablePushNamed(
                    context,
                    CakeDetailsView.routeName,
                    arguments: Cake(
                      uui: index.toString(),
                      title: cake.title ?? '',
                      description: cake.description ?? '',
                      image: cake.image ?? '',
                    ).toJson(),
                  );
                });
          },
        ),
      ),
    );
  }
}
