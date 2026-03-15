import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/mock_markets.dart';
import '../../models/market.dart';
import '../markets/market_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// 市集對應的座標
const _marketCoords = {
  '1': LatLng(25.0478, 121.5170),
  '2': LatLng(25.0173, 121.5397),
  '3': LatLng(25.0380, 121.5648),
};

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Market? _selectedMarket;
  bool _locating = false;
  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() => _locationGranted = true);
    }
  }

  static const _initialPosition = CameraPosition(
    target: LatLng(25.0330, 121.5654),
    zoom: 13,
  );

  Future<void> _goToMyLocation() async {
    setState(() => _locating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('請在設定中允許位置權限')),
          );
        }
        return;
      }
      setState(() => _locationGranted = true);
      final pos = await Geolocator.getCurrentPosition();
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  late final Set<Marker> _markers = {
    for (final market in mockMarkets)
      if (_marketCoords.containsKey(market.id))
        Marker(
          markerId: MarkerId(market.id),
          position: _marketCoords[market.id]!,
          infoWindow: InfoWindow.noText,
          onTap: () => setState(() => _selectedMarket = market),
        ),
  };

  Future<void> _zoomIn() async => _controller?.animateCamera(CameraUpdate.zoomIn());
  Future<void> _zoomOut() async => _controller?.animateCamera(CameraUpdate.zoomOut());

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('地圖功能請在手機上使用', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: _markers,
          myLocationEnabled: _locationGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _controller = controller,
          onTap: (_) => setState(() => _selectedMarket = null),
        ),
        // Zoom + 定位按鈕
        Positioned(
          right: 16,
          bottom: _selectedMarket != null ? 200 : 24,
          child: Column(
            children: [
              _ZoomButton(icon: Icons.add, onTap: _zoomIn),
              const SizedBox(height: 8),
              _ZoomButton(icon: Icons.remove, onTap: _zoomOut),
              const SizedBox(height: 16),
              _locating
                  ? Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _ZoomButton(icon: Icons.my_location, onTap: _goToMyLocation),
            ],
          ),
        ),
        // 市集資訊卡
        if (_selectedMarket != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _MarketInfoCard(
              market: _selectedMarket!,
              onClose: () => setState(() => _selectedMarket = null),
            ),
          ),
      ],
    );
  }
}

class _MarketInfoCard extends StatelessWidget {
  final Market market;
  final VoidCallback onClose;

  const _MarketInfoCard({required this.market, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: market.image,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(width: 72, height: 72, color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(width: 72, height: 72, color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(market.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.schedule_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(market.hours, style: const TextStyle(color: Colors.grey, fontSize: 13))),
                  ]),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MarketDetailScreen(market: market)),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('查看詳情'),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
      ),
    );
  }
}
