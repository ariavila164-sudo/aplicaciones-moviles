import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/lugar_turistico.dart';
import '../viewmodels/detalle_view_model.dart';

class DetalleLugarScreen extends StatefulWidget {
  final LugarTuristico lugar;
  const DetalleLugarScreen({super.key, required this.lugar});

  @override
  State<DetalleLugarScreen> createState() => _DetalleLugarScreenState();
}

class _DetalleLugarScreenState extends State<DetalleLugarScreen> {
  late final DetalleViewModel _viewModel;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _viewModel = DetalleViewModel(widget.lugar);
    final video = widget.lugar.videoAsset;
    if (video != null) {
      _videoController = VideoPlayerController.asset(video)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lugar.nombre)),
      body: ListView(
        children: [
          Image.asset(widget.lugar.imagenAsset, height: 220, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.lugar.descripcion, style: const TextStyle(fontSize: 16)),
          ),
          AnimatedBuilder(
            animation: _viewModel,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _viewModel.alternarAudio,
                icon: Icon(_viewModel.reproduciendo ? Icons.pause : Icons.headphones),
                label: Text(_viewModel.reproduciendo ? 'Pausar audioguia' : 'Escuchar audioguia'),
              ),
            ),
          ),
          if (_videoController != null && _videoController!.value.isInitialized)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  IconButton(
                    icon: Icon(_videoController!.value.isPlaying ? Icons.pause_circle : Icons.play_circle),
                    iconSize: 48,
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
