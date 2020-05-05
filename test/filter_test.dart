import 'package:intl/intl.dart';
import 'package:test/test.dart';
import 'package:liquid_engine/src/context.dart';
import 'package:liquid_engine/src/builtins.dart';

void main() {
  group('liquid modules', () {
    Context extendedContext = Context.create();
    setUp(() {
      BuiltinsModule()..register(extendedContext);
    });
    group('builtins', () {
      test('size', () {
        expect(extendedContext.filters.containsKey('size'), true);
        expect(extendedContext.filters['size']([1, 2, 3, 4, 5], null), 5);
      });
      test('downcase', () {
        expect(extendedContext.filters.containsKey('downcase'), true);
        expect(extendedContext.filters.containsKey('lower'), true);
        expect(extendedContext.filters['downcase']('TEST TEST', null),
            'test Test');
      });
      test('upcase', () {
        expect(extendedContext.filters.containsKey('upcase'), true);
        expect(extendedContext.filters.containsKey('upper'), true);
        expect(
            extendedContext.filters['upcase']('test Test', null), 'TEST TEST');
      });
      test('capitalize', () {
        expect(extendedContext.filters.containsKey('capitalize'), true);
        expect(extendedContext.filters.containsKey('capfirst'), true);
        expect(extendedContext.filters['capitalize']('test', null), 'Test');
      });
      test('join', () {
        expect(extendedContext.filters.containsKey('join'), true);
        expect(extendedContext.filters['join']('test', null), 'Test');
      });
      test('abs', () {
        expect(extendedContext.filters.containsKey('abs'), true);
        expect(extendedContext.filters['abs'](-2, null), 2);
      });
      test('append', () {
        expect(extendedContext.filters.containsKey('append'), true);
        expect(extendedContext.filters['append']('Hello', [' World!']),
            'Hello World!');
      });
      test('at_least', () {
        expect(extendedContext.filters.containsKey('at_least'), true);
        expect(extendedContext.filters['at_least'](3, [5]), 5);
        expect(extendedContext.filters['at_least'](5, [3]), 5);
      });
      test('at_most', () {
        expect(extendedContext.filters.containsKey('at_most'), true);
        expect(extendedContext.filters['at_most'](3, [5]), 3);
        expect(extendedContext.filters['at_most'](5, [3]), 3);
      });
      test('ceil', () {
        expect(extendedContext.filters.containsKey('ceil'), true);
        expect(extendedContext.filters['ceil'](1.5, null), 2);
      });
      test('compact', () {
        expect(extendedContext.filters.containsKey('compact'), true);
        expect(extendedContext.filters['compact']([1, null], null).length, 1);
        expect(extendedContext.filters['compact'](1, null), 1);
      });
      test('concat', () {
        expect(extendedContext.filters.containsKey('concat'), true);
        expect(
            extendedContext
                .filters['concat']([
              1,
              '2'
            ], [
              3,
              [4, 5]
            ])
                .length,
            4);
      });
      /*test('date', () {
        expect(extendedContext.filters.containsKey('date'), true);
        var date = DateTime.now();
        expect(
          extendedContext.filters['date'](date, ['%x']),
          DateFormat.yMd().format(date),
        );
      });*/
      test('date_format', () {
        expect(extendedContext.filters.containsKey('date_format'), true);
        var date = DateTime.now();
        expect(extendedContext.filters['date_format'](date, null),
            DateFormat.yMMMMd().format(date));
      });
      test('divided_by', () {
        expect(extendedContext.filters.containsKey('divided_by'), true);
        expect(extendedContext.filters['divided_by'](16, [4]), 4);
      });
      test('escape', () {
        expect(extendedContext.filters.containsKey('escape'), true);
        // expect(extendedContext.filters['escape'](16, [4]), 4);
      });
      test('first', () {
        expect(extendedContext.filters.containsKey('first'), true);
        expect(extendedContext.filters['first']([1, 2], null), 1);
      });
      test('last', () {
        expect(extendedContext.filters.containsKey('last'), true);
        expect(extendedContext.filters['last']([1, 2], null), 2);
      });
      test('floor', () {
        expect(extendedContext.filters.containsKey('floor'), true);
        expect(extendedContext.filters['floor'](1.6, null), 1);
      });
      test('lstrip', () {
        expect(extendedContext.filters.containsKey('lstrip'), true);
        expect(extendedContext.filters['lstrip']('     \t   Hello', null),
            'Hello');
      });
      test('map', () {
        expect(extendedContext.filters.containsKey('map'), true);
        expect(
            extendedContext.filters['map']([
              {'label': 1},
              {'label': 2}
            ], [
              'label'
            ]),
            [1, 2]);
        expect(extendedContext.filters['map']({'label': 1}, ['label']), 1);
      });
      test('minus', () {
        expect(extendedContext.filters.containsKey('minus'), true);
        expect(extendedContext.filters['minus'](2, [1]), 1);
      });
      test('modulo', () {
        expect(extendedContext.filters.containsKey('minus'), true);
        expect(extendedContext.filters['minus'](2, [2]), 2 % 2);
      });
      test('newline_to_br', () {
        expect(extendedContext.filters.containsKey('newline_to_br'), true);
        expect(extendedContext.filters['newline_to_br']('\n', null), '<br />');
      });
      test('plus', () {
        expect(extendedContext.filters.containsKey('plus'), true);
        expect(extendedContext.filters['plus'](1, [1]), 2);
      });
      test('prepend', () {
        expect(extendedContext.filters.containsKey('prepend'), true);
        expect(extendedContext.filters['prepend'](' World', ['Hello']),
            'Hello World');
      });
      test('remove_first', () {
        expect(extendedContext.filters.containsKey('remove_first'), true);
        expect(extendedContext.filters['remove_first']('a a a', ['a']), ' a a');
      });
      test('replace', () {
        expect(extendedContext.filters.containsKey('replace'), true);
        expect(
            extendedContext.filters['replace']('a a a', ['a', 'b']), 'b b b');
      });
      test('remove', () {
        expect(extendedContext.filters.containsKey('remove'), true);
        expect(extendedContext.filters['remove']('a a a', ['a']), '  ');
      });
      test('replace_first', () {
        expect(extendedContext.filters.containsKey('replace_first'), true);
        expect(extendedContext.filters['replace_first']('a a a', ['a', 'b']),
            'b a a');
      });
      test('reverse', () {
        expect(extendedContext.filters.containsKey('reverse'), true);
        expect(extendedContext.filters['reverse']([1, 2, 3], null), [3, 2, 1]);
      });
      test('round', () {
        expect(extendedContext.filters.containsKey('round'), true);
        expect(extendedContext.filters['round'](1.4, null), 1);
        expect(extendedContext.filters['round'](1.5, null), 2);
      });
      test('rstrip', () {
        expect(extendedContext.filters.containsKey('rstrip'), true);
        expect(extendedContext.filters['rstrip']('Hello     \t   ', null),
            'Hello');
      });
      test('slice', () {
        expect(extendedContext.filters.containsKey('slice'), true);
        expect(extendedContext.filters['slice']('Hello', [0]), 'H');
        expect(extendedContext.filters['slice']('Hello', [0, 4]), 'Hell');
      });
      test('strip', () {
        expect(extendedContext.filters.containsKey('strip'), true);
        expect(
            extendedContext.filters['strip']('    \t   Hello       \t', null),
            'Hello');
        expect(extendedContext.filters.containsKey('trim'), true);
        expect(extendedContext.filters['trim']('    \t   Hello       \t', null),
            'Hello');
      });
      test('strip_html', () {
        expect(extendedContext.filters.containsKey('strip_html'), true);
        expect(extendedContext.filters['strip_html']('<p>Hello</p>', null),
            'Hello');
      });
      test('strip_newlines', () {
        expect(extendedContext.filters.containsKey('strip_newlines'), true);
        expect(extendedContext.filters['strip_newlines']('Hell\no', null),
            'Hello');
      });
      test('times', () {
        expect(extendedContext.filters.containsKey('times'), true);
        expect(extendedContext.filters['times'](2, [2]), 4);
      });
      test('truncate', () {
        expect(extendedContext.filters.containsKey('truncate'), true);
        expect(extendedContext.filters['truncate']('Hello', [10]).length, 5);
        expect(extendedContext.filters['truncate']('Hello', [4]).length, 4);
      });
      test('truncatewords', () {
        expect(extendedContext.filters.containsKey('truncatewords'), true);
        expect(extendedContext.filters['truncatewords']('Hello World', [1]),
            'Hello');
        expect(
            extendedContext.filters['truncatewords']('Hello World', [1, '--']),
            'Hello--');
      });
      test('uniq', () {
        expect(extendedContext.filters.containsKey('uniq'), true);
        expect(extendedContext.filters['uniq']([1, 1], null), [1]);
      });
      test('url encode/decode', () {
        expect(extendedContext.filters.containsKey('url_decode'), true);
        expect(extendedContext.filters.containsKey('url_encode'), true);
        var url = 'http://example.org/api?foo=some message';

        var encoded = extendedContext.filters['url_encode'](url, null);
        expect(encoded, 'http://example.org/api?foo=some%20message');
        var decoded = extendedContext.filters['url_decode'](encoded, null);
        expect(url, decoded);
      });
      test('sort', () {
        expect(extendedContext.filters.containsKey('sort'), true);

        expect(extendedContext.filters['sort'](['farm', 'Zoo'], null).first,
            'Zoo');
      });
      test('sort_natural', () {
        expect(extendedContext.filters.containsKey('sort_natural'), true);

        expect(
            extendedContext
                .filters['sort_natural'](['farm', 'Zoo'], null).first,
            'farm');
      });
    });
    group('jekyll', () {});
    group('amp', () {});
  });
}
