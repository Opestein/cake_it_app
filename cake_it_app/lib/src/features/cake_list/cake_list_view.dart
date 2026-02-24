import 'package:cake_it_app/src/features/cake_list/bloc/cake_list_bloc.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:cake_it_app/src/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CakeListView extends StatelessWidget {
  const CakeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂 CakeIt 🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed(RouteNames.settings),
          ),
        ],
      ),
      body: BlocBuilder<CakeListBloc, CakeListState>(
        builder: (context, state) {
          return switch (state.status) {
            CakeListStatus.initial ||
            CakeListStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            CakeListStatus.failure => _ErrorView(
                errorMessage:
                    state.errorMessage ?? 'An unexpected error occurred.',
                onRetry: () =>
                    context.read<CakeListBloc>().add(const CakeListFetched()),
              ),
            CakeListStatus.success when state.cakes.isEmpty =>
              const _EmptyView(),
            CakeListStatus.success => _CakeList(cakes: state.cakes),
          };
        },
      ),
    );
  }
}

class _CakeList extends StatelessWidget {
  const _CakeList({required this.cakes});

  final List<Cake> cakes;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CakeListBloc>().add(const CakeListRefreshed());
        // Wait for the bloc to emit a non-loading state after refresh.
        await context.read<CakeListBloc>().stream.firstWhere(
              (s) => s.status != CakeListStatus.loading,
            );
      },
      child: ListView.builder(
        restorationId: 'cakeListView',
        itemCount: cakes.length,
        itemBuilder: (context, index) {
          final cake = cakes[index];
          return _CakeListTile(
            index: index,
            cake: cake,
            onTap: () => context.pushNamed(
              RouteNames.cakeDetail,
              pathParameters: {'index': '$index'},
              extra: cake,
            ),
          );
        },
      ),
    );
  }
}

class _CakeListTile extends StatelessWidget {
  const _CakeListTile({
    required this.index,
    required this.cake,
    required this.onTap,
  });

  final int index;
  final Cake cake;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        cake.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        cake.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Hero(
        tag: 'cake_image_$index',
        child: CircleAvatar(
          foregroundImage:
              cake.image.isNotEmpty ? NetworkImage(cake.image) : null,
          child: cake.image.isEmpty ? const Icon(Icons.cake) : null,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cake_outlined, size: 48),
          const SizedBox(height: 16),
          Text(
            'No cakes found',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
