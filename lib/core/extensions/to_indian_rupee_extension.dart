 

import 'package:intl/intl.dart';

var _format = NumberFormat.currency(
  name: "",
  locale: 'HI',
  decimalDigits: 2,
  // change it to get decimal places
  symbol: '₹',
);

NumberFormat _formatWith({bool showSymbol = true, int decimalPoint = 2}) =>
    NumberFormat.currency(
      name: "",
      locale: 'HI',
      decimalDigits: decimalPoint,
      symbol: showSymbol ? '₹' : "",
    );

extension IndianCurrencyFormatt on num {
  String get toIndianRupee {
    return _format.format(this);
  }

  String toIndianRupeeWith({bool showSymbol = true, int decimalPoint = 2}) {
    return _formatWith(showSymbol: showSymbol, decimalPoint: decimalPoint)
        .format(this);
  }
}

extension IndianCurrencyFormattForInt on int {
  String get toIndianRupee {
    return _format.format(this);
  }

  String toIndianRupeeWith({bool showSymbol = true, int decimalPoint = 2}) {
    return _formatWith(showSymbol: showSymbol, decimalPoint: decimalPoint)
        .format(this);
  }
}

extension IndianCurrencyFormattForString on String {
  String get toIndianRupee {
    return _format.format(num.tryParse(this) ?? 0);
  }

  String toIndianRupeeWith({bool showSymbol = true, int decimalPoint = 2}) {
    return _formatWith(showSymbol: showSymbol, decimalPoint: decimalPoint)
        .format(num.tryParse(this) ?? 0);
  }
}
