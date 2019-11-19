import 'package:liquid/src/buildin_tags/named_block.dart';
import 'package:liquid/src/builtins.dart';

import 'tag.dart';
import 'block.dart';

typedef dynamic Filter(dynamic input, List<dynamic> args);

abstract class RenderContext {
  RenderContext get parent;

  RenderContext get root;

  Map<String, Iterable<String>> blocks;

  Map<String, dynamic> get variables;

  Map<String, Filter> get filters;

  Map<String, dynamic> getTagState(Tag tag);

  RenderContext push(Map<String, dynamic> variables);

  bool get useMirrorsLibrary;

  RenderContext clone();

  RenderContext cloneAsRoot();
}

abstract class ParseContext {
  Map<String, BlockParserFactory> get tags;
}

abstract class Module {
  void register(Context context);
}

class Context implements RenderContext, ParseContext {

  Map<String, Iterable<String>> blocks = {};

  @override
  Map<String, BlockParserFactory> tags = {};

  @override
  Map<String, dynamic> variables = {};

  @override
  Map<String, Filter> filters = {};

  Map<String, Module> modules = {
    'builtins': BuiltinsModule()
  };

  Map<Tag, Map<String, dynamic>> _tagStates = {};

  Map<String, dynamic> getTagState(Tag tag) => parent == null
      ? _tagStates.putIfAbsent(tag, () => {})
      : root.getTagState(tag);

  Context parent;

  RenderContext get root => parent == null ? this : parent.root;

  bool useMirrorsLibrary = true;

  Context._();

  factory Context.create() {
    final context = Context._();

    context.modules['builtins'].register(context);

    return context;
  }

  Context push(Map<String, dynamic> variables) {
    final context = Context._();
    context.blocks = Map.from(blocks);
    context.tags = Map.from(tags);
    context.filters = Map.from(filters);
    context.variables = Map.from(this.variables);
    context.variables.addAll(variables);
    context.parent = this;
    return context;
  }

  Context clone() => push({});

  Context cloneAsRoot() {
    final context = clone();
    context.parent = null;
    return context;
  }
}