import 'package:cake_it_app/src/data/cake_api_client.dart';
import 'package:cake_it_app/src/data/cake_repository.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

import 'cake_details_view.dart';

class CakeListView extends StatefulWidget {
  const CakeListView({
    super.key,
    required this.cakeRepository,
  });

  static const routeName = '/';

  final CakeRepository cakeRepository;

  @override
  State<CakeListView> createState() => _CakeListViewState();
}

class _CakeListViewState extends State<CakeListView> {
  List<Cake> _cakes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCakes();
  }

  Future<void> _fetchCakes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cakes = await widget.cakeRepository.fetchCakes();
      if (mounted) {
        setState(() {
          _cakes = cakes;
          _isLoading = false;
        });
      }
    } on CakeApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    try {
      final cakes = await widget.cakeRepository.fetchCakes();
      if (mounted) {
        setState(() {
          _cakes = cakes;
          _errorMessage = null;
        });
      }
    } on CakeApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂 CakeIt 🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_cakes.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        restorationId: 'cakeListView',
        itemCount: _cakes.length,
        itemBuilder: (BuildContext context, int index) {
          final cake = _cakes[index];
          return _CakeListTile(
            index: index,
            cake: cake,
            onTap: () => _navigateToDetail(index, cake),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _fetchCakes,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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

  void _navigateToDetail(int index, Cake cake) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: CakeDetailsView.routeName),
        builder: (_) => CakeDetailsView(index: index, cake: cake),
      ),
    );
  }
}

/// A single cake item in the list.
///
/// Extracted as a private widget to keep the build method clean
/// and to allow for efficient rebuilds.
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
