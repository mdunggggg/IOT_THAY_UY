import 'package:intl/intl.dart';

extension extDateTime on DateTime? {
  String get formatDefault =>
      this == null ? '' : DateFormat('dd/MM/yyyy').format(this!);

  String formatCustom({String format = 'dd/MM/yyyy'}) {
    if (this != null) {
      return DateFormat(format).format(this!);
    }
    return '';
  }

  String formatHHmm() {
    if (this != null) {
      return DateFormat('HH:mm').format(this!);
    }
    return '';
  }
}
