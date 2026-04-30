 

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/config/theme/app_theme.dart';
import 'package:myapp/src/home/datasource/model/repo/home_repo.dart';
import 'package:myapp/src/home/datasource/model/repo/home_repo_impl.dart';
import 'package:myapp/src/home/home_bloc/home_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/src/home/home_bloc/home_event.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/data/dio/dio_client.dart';
import 'config/data/dio/logging_intercepter.dart';
import 'core/constants/api_constants.dart';
import 'core/local_data/home_local_datasource.dart';
import 'core/local_data/local_storage_service.dart';
import 'core/network/network_service.dart';

part 'di_container.main.dart';
