import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:liquid_engine/src/ruby_helper.dart';

import 'block.dart';
import 'buildin_tags/assign.dart';
import 'buildin_tags/capture.dart';
import 'buildin_tags/comment.dart';
import 'buildin_tags/cycle.dart';
import 'buildin_tags/extends.dart';
import 'buildin_tags/filter.dart';
import 'buildin_tags/for.dart';
import 'buildin_tags/if.dart';
import 'buildin_tags/ifchanged.dart';
import 'buildin_tags/include.dart';
import 'buildin_tags/load.dart';
import 'buildin_tags/named_block.dart';
import 'context.dart';

class BuiltinsModule implements Module {
  @override
  void register(Context context) {
    context.tags['assign'] = BlockParser.simple(Assign.factory);
    context.tags['cache'] = BlockParser.simple(Cache.factory);
    context.tags['capture'] = BlockParser.simple(Capture.factory);
    context.tags['comment'] = BlockParser.simple(Comment.factory);
    context.tags['for'] = For.factory;
    context.tags['cycle'] = BlockParser.simple(Cycle.factory, hasEndTag: false);
    context.tags['ifchanged'] = BlockParser.simple(IfChanged.factory);
    context.tags['if'] = If.factory;
    context.tags['unless'] = If.unlessFactory;
    context.tags['include'] = Include.factory;
    context.tags['filter'] = BlockParser.simple(FilterBlock.factory);
    context.tags['load'] = BlockParser.simple(Load.factory, hasEndTag: false);
    context.tags['block'] = BlockParser.simple(NamedBlock.factory);
    context.tags['extends'] = Extends.factory;
// TODO context.tags['raw']
// TODO context.tags['increment']
// TODO context.tags['decrement']
// TODO context.tags['case']
// TODO context.tags['when']

    context.filters['default'] = (input, args) {
      var output = input != null ? input.toString() : '';
      if (output.isNotEmpty) {
        return output;
      }

      for (final arg in args) {
        output = arg != null ? arg.toString() : '';
        if (output.isNotEmpty) {
          return output;
        }
      }

      return '';
    };

    context.filters['default_if_none'] = (input, args) {
      if (input != null) {
        return input;
      }

      for (final arg in args) {
        if (arg != null) {
          return arg;
        }
      }

      return '';
    };

    context.filters['size'] =
        (input, args) => input is Iterable ? input.length : 0;

    context.filters['downcase'] = context.filters['lower'] =
        (input, args) => input?.toString()?.toLowerCase();

    context.filters['upcase'] = context.filters['upper'] =
        (input, args) => input?.toString()?.toUpperCase();

    context.filters['capitalize'] = context.filters['capfirst'] =
        (input, args) => input?.toString()?.replaceFirstMapped(
              RegExp(r'^\w'),
              (m) => m.group(0).toUpperCase(),
            );

    context.filters['join'] = (input, args) => (input as Iterable)
        .join(args != null && args.isNotEmpty ? args[0] : ' ');
 context.filters['abs'] =
        (input, args) => input is num ? input.abs() : num.tryParse(input).abs();
    context.filters['append'] = (input, args) =>
        args != null && args.isNotEmpty && input is String
            ? input + args[0]
            : input;
    context.filters['at_least'] = (input, args) =>
        args != null && args.isNotEmpty && input < args[0] ? args[0] : input;
    context.filters['at_most'] = (input, args) =>
        args != null && args.isNotEmpty && input > args[0] ? args[0] : input;
    context.filters['ceil'] = (input, args) =>
        input is num ? input.ceil() : num.tryParse(input).ceil();
    context.filters['compact'] = (input, args) {
      var out = input;
      if (out is List) {
        out.removeWhere((v) => v == null);
      }
      return out;
    };
    context.filters['concat'] = (input, args) {
      var out = input;
      if (out is List && args != null && args.isNotEmpty) {
        for (var arg in args) {
          out.add(arg);
        }
      }
      return out;
    };

// (ruby-style)
    context.filters['date'] = (input, args) => args != null && args.length == 1
        ? strptime(input as DateTime, args[0])
        : strptime(input as DateTime, '%c');

// (dart-style)
    context.filters['date_format'] = (input, args) =>
        DateFormat(args != null && args.isNotEmpty ? args[0] : 'yMMMMd')
            .format(input as DateTime);
    context.filters['divided_by'] = (input, args) =>
        args != null && args.isNotEmpty
            ? (input as num) / (args[0] as num)
            : input;
    context.filters['first'] = (input, args) => (input as List).first;
    context.filters['last'] = (input, args) => (input as List).last;
    context.filters['floor'] = (input, args) =>
        input is num ? input.floor() : num.tryParse(input).floor();
    context.filters['lstrip'] = context.filters['trim_left'] =
        (input, args) => input.toString().trimLeft();
    context.filters['map'] = (input, args) {
      if (args != null && args.length == 1) {
        var key = args[0];
        if (input is List) {
          return input.map((m) => (m as Map)[key]);
        } else if (input is Map) {
          return input[key];
        }
      }
      return input;
    };
    context.filters['minus'] = (input, args) => args != null && args.isNotEmpty
        ? (input as num) - (args[0] as num)
        : input;
    context.filters['modulo'] = (input, args) => args != null && args.isNotEmpty
        ? (input as num) % (args[0] as num)
        : input;
    context.filters['newline_to_br'] =
        (input, args) => input.toString().replaceAll('\n', '<br />');
    context.filters['plus'] = (input, args) => args != null && args.isNotEmpty
        ? (input as num) + (args[0] as num)
        : input;
    context.filters['prepend'] = (input, args) =>
        args != null && args.isNotEmpty ? args[0] + input : input;
    context.filters['remove'] = (input, args) => args != null && args.isNotEmpty
        ? input.toString().replaceAll(args[0], '')
        : input;
    context.filters['remove_first'] = (input, args) =>
        args != null && args.isNotEmpty
            ? input.toString().replaceFirst(args[0], '')
            : input;
    context.filters['replace'] = (input, args) =>
        args != null && args.length == 2
            ? input.toString().replaceAll(args[0], args[1])
            : input;

    context.filters['replace_first'] = (input, args) =>
        args != null && args.length > 1
            ? input
                .toString()
                .replaceFirst(args[0], args[1], args.length == 3 ? args[2] : 0)
            : input;
    context.filters['reverse'] = (input, args) => (input as List).reversed;
    context.filters['round'] = (input, args) =>
        input is num ? input.round() : num.tryParse(input).round();
    context.filters['rstrip'] = context.filters['trim_right'] =
        (input, args) => input.toString().trimRight();
    context.filters['slice'] = (input, args) {
      if (args != null) {
        switch (args.length) {
          case 1:
            return input.toString()[args[0]];
          case 2:
            return input.toString().substring(args[0], args[1]);
        }
      } else {
        return input;
      }
    };
    context.filters['sort'] = (input, args) {
      var out = input;
      if (input is List && args != null && args.length == 1) {
        var key = args[0];
        out.sort((a, b) => a[key].toString().compareTo(b[key].toString()));
      } else if (input is List) {
        out.sort((a, b) => a.toString().compareTo(b.toString()));
      }
      return out;
    };
    context.filters['sort_natural'] = (input, args) {
      var out = input;
      if (input is List && args != null && args.length == 1) {
        var key = args[0];
        out.sort((a, b) => a[key]
            .toString()
            .toLowerCase()
            .compareTo(b[key].toString().toLowerCase()));
      } else if (input is List) {
        out.sort((a, b) =>
            a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
      }
      return out;
    };
    context.filters['split'] = (input, args) => args != null && args.isNotEmpty
        ? input.toString().split(args[0])
        : input;
    context.filters['strip'] =
        context.filters['trim'] = (input, args) => input.toString().trim();
    context.filters['strip_html'] = (input, args) => input
        .toString()
        .replaceAll(
            RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true), '');
    context.filters['strip_newlines'] =
        (input, args) => input.toString().replaceAll('\n', '');
    context.filters['times'] = (input, args) => args != null && args.isNotEmpty
        ? (input as num) * (args[0] as num)
        : input;
    context.filters['truncate'] = (input, args) =>
        args != null && args.isNotEmpty && input.length > args[0]
            ? input.substring(0, args[0] - 3) + '...'
            : input;
    context.filters['truncatewords'] = (input, args) {
      if (args != null && args.isNotEmpty) {
        switch (args.length) {
          case 1:
            return input.toString().split(' ').sublist(0, args[0]).join(' ');
          case 2:
            return input.toString().split(' ').sublist(0, args[0]).join(' ') +
                args[1];
        }
      } else {
        return input;
      }
    };
    context.filters['uniq'] =
        (input, args) => input is List ? input.toSet() : input;
    context.filters['url_decode'] = (input, args) => Uri.decodeFull(input);
    context.filters['url_encode'] = (input, args) => Uri.encodeFull(input);
    context.filters['escape'] = (input, args) => Uri.encodeComponent(
          input.toString(),
        );
// TODO context.filters['escape_once']
    context.filters['to_base64'] = context.filters['image_to_base64'] =
        (input, args) => base64Encode(input as List<int>);
  }
}
