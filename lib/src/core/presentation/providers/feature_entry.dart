import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeatureEntry<TService, TRepository, TViewModel extends ChangeNotifier>
    extends StatelessWidget {
  const FeatureEntry({
    super.key,
    required this.createService,
    required this.createRepository,
    required this.createViewModel,
    required this.child,
    this.initialize,
  });

  final TService Function(BuildContext context) createService;
  final TRepository Function(BuildContext context) createRepository;
  final TViewModel Function(BuildContext context) createViewModel;
  final Widget child;
  final FutureOr<void> Function(TViewModel viewModel)? initialize;

  @override
  Widget build(BuildContext context) {
    final scopedChild = initialize == null
        ? child
        : _FeatureInitializer<TViewModel>(
            initialize: initialize!,
            child: child,
          );

    return MultiProvider(
      providers: [
        Provider<TService>(create: createService),
        Provider<TRepository>(create: createRepository),
        ChangeNotifierProvider<TViewModel>(create: createViewModel),
      ],
      child: scopedChild,
    );
  }
}

class _FeatureInitializer<TViewModel extends ChangeNotifier>
    extends StatefulWidget {
  const _FeatureInitializer({
    required this.initialize,
    required this.child,
  });

  final FutureOr<void> Function(TViewModel viewModel) initialize;
  final Widget child;

  @override
  State<_FeatureInitializer<TViewModel>> createState() =>
      _FeatureInitializerState<TViewModel>();
}

class _FeatureInitializerState<TViewModel extends ChangeNotifier>
    extends State<_FeatureInitializer<TViewModel>> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await widget.initialize(context.read<TViewModel>());
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
