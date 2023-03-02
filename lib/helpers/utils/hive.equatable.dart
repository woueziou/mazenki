import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

abstract class EquatableHiveObject extends HiveObject with EquatableMixin {}
