 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:provider/provider.dart';

import '../../config/theme/atoms/text.dart';
import '../../di_container.dart';
import 'network_service.dart';

class NetworkCheckerWidget extends StatelessWidget {
  final Widget child;

  const NetworkCheckerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // NetworkStatus? — null means "still checking"
    final networkStatus = Provider.of<NetworkStatus?>(context);

    // null = first check pending → show child to avoid flash
    if (networkStatus == null || networkStatus == NetworkStatus.online) {
      return child;
    }

    return const NoInternetWdget();
  }
}

class NoInternetWdget extends StatelessWidget {
  const NoInternetWdget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_sharp, size: 30.w),
              AppString.custom("No Internet").t16.build(fontSize: 14.t, color: context.colors.primary),
              AppString.custom("Check your Internet Connection..!").t16.build(fontSize: 15.t, color: context.colors.BLACK),
              SizedBox(height: 2.h),
              SizedBox(
                width: 55.w,
                // padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: ElevatedButton(
                    onPressed: () {
                      Di.sl<NetworkService>().checkConnection();
                    },
                    child: AppString.custom("Retry").t16.build(color: context.colors.WHITE, fontSize: 20.t, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
