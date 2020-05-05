/* as defined here: https://ruby-doc.org/stdlib-2.7.1/libdoc/time/rdoc/Time.html#method-c-parse */
import 'package:intl/intl.dart';

Map conversions = {
  'a': (d) => 'E',
  'A': (d) => 'EEEE',
  'b': (d) => 'MMM',
  'B': (d) => 'MMMM',
  '+': (d) => _strptime(d, '%a %b %e %H:%M:%S %Z %Y'),
  '%': (d) => '%%',
  'Z': (d) => 'vvvv',
  'z': (d) {
    if (d.isUtc) {
      return 'GMT';
    } else {
      var offset = d.toLocal().timeZoneOffset.inHours * 100;
      return ' +${offset < 1000 ? '0' : ''}$offset';
    }
  },
  'Y': (d) => d.isLocal ? 'yyyy' : '',
  'y': (d) => 'yy',
  'X': (d) => 'h:mm a',
  'x': (d) => 'yMd',
  'W': (d) => '', // TODO implement
  'V': (d) => '', // TODO implement
  'U': (d) => '', // TODO implement
  'w': (d) => '${d.weekday == 7 ? 0 : d.weekday}',
  'w': (d) => '${d.weekday}',
  'v': (d) => _strptime(d, '%e-%b-%Y'),
  'T': (d) => _strptime(d, '%H:%M:%S'),
  't': (d) => '\t',
  'S': (d) => 'ss',
  's': (d) => '${d.millisecondsSinceEpoch / 1000}',
  'R': (d) => _strptime(d, '%H:%M'),
  'r': (d) => _strptime(d, '%I:%M:%S %p'),
  'P': (d) => 'a',
  'p': (d) => 'a',
  'N': (d) => 'S',
  'n': (d) => '\n',
  'M': (d) => 'm',
  'm': (d) => 'M',
  'L': (d) => 'S',
  'l': (d) => 'h',
  'k': (d) => 'H',
  'j': (d) => 'DDD',
  'I': (d) => 'hh',
  'H': (d) => 'HH',
  'h': (d) => _strptime(d, '%b'),
  'G': (d) => '', // TODO implement
  'g': (d) => 'yy',
  'F': (d) => _strptime(d, '%Y-%m-%d'),
  'e': (d) => 'd',
  'D': (d) => _strptime(d, '%m/%d/%y'),
  'd': (d) => 'dd',
  'C': (d) => '${d.year}'.substring(0, 2),
  'c': (d) => _strptime(d, '%x %X'),
};
String _strptime(DateTime dateTime, String format) {
  int i = 0;
  String output = '';
  print(i);

  while (i < format.length) {
    var c = format[i];
    if (c == '%' && (++i) < format.length) {
      c = format[i];
      if (conversions.containsKey(c)) {
        output += conversions[c](dateTime);
      } else {
        output += '%$c';
      }
    } else {
      output += c;
    }
    ++i;
  }
  return output;
}

String strptime(DateTime dateTime, String format) =>
    DateFormat(_strptime(dateTime, format)).format(dateTime);

String formatRfc822(DateTime d) {
  var template = 'EEE, dd MMM yyyy HH:mm:ss';
  var out = DateFormat(template).format(d);
  if (d.isUtc) {
    out += ' GMT';
  } else {
    var offset = d.toLocal().timeZoneOffset.inHours * 100;
    out += ' +${offset < 1000 ? '0' : ''}$offset';
  }

  return out;
}
