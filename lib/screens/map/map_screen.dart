import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  static const _initialPosition = CameraPosition(
    target: LatLng(25.0330, 121.5654), // 台北市中心
    zoom: 13,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('market_1'),
      position: const LatLng(25.0478, 121.5170),
      infoWindow: const InfoWindow(title: '建國花市', snippet: '週六、日 09:00-18:00'),
    ),
    Marker(
      markerId: const MarkerId('market_2'),
      position: const LatLng(25.0569, 121.5294),
      infoWindow: const InfoWindow(title: '士林夜市農產區', snippet: '每日 16:00-24:00'),
    ),
    Marker(
      markerId: const MarkerId('market_3'),
      position: const LatLng(25.0173, 121.5397),
      infoWindow: const InfoWindow(title: '永康街農夫市集', snippet: '週日 10:00-17:00'),
    ),
  };

  Future<void> _zoomIn() async {
    await _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    await _controller?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    // Web 不支援 google_maps_flutter，顯示提示
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
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _controller = controller,
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: Column(
            children: [
              _ZoomButton(icon: Icons.add, onTap: _zoomIn),
              const SizedBox(height: 8),
              _ZoomButton(icon: Icons.remove, onTap: _zoomOut),
            ],
          ),
        ),
      ],
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
      ),
    );
  }
}
