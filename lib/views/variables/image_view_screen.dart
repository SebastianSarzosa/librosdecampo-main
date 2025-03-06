import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:libroscampo/repositories/variables_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:libroscampo/models/variables.dart'; // Add this import

class ImageViewScreen extends StatefulWidget {
  final int controlId;
  final XFile? imageFile;
  final Function(XFile) onImageTaken;
  final String userRole;

  const ImageViewScreen({Key? key, required this.controlId, required this.imageFile, required this.onImageTaken, required this.userRole}) : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile;
    _loadImage();
  }

  Future<void> _loadImage() async {
    final existingVariable = await VariablesRepository().getVariableByControlAndName(widget.controlId, 'Foto');
    if (existingVariable != null && existingVariable.imagePath != null) {
      setState(() {
        _imageFile = XFile(existingVariable.imagePath!);
      });
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    if (widget.userRole == 'admin' || widget.userRole == 'editor') {
      final status = await [
        Permission.camera,
      ].request();

      if (status[Permission.camera]!.isGranted) {
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() {
            _imageFile = image;
          });
          await _saveImagePath(image.path);
          widget.onImageTaken(image);
        }
      } else if (status[Permission.camera]!.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permiso para acceder a la cámara denegado'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (status[Permission.camera]!.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permiso para acceder a la cámara denegado permanentemente. Por favor, habilítelo en la configuración.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No tienes permiso para tomar fotos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveImagePath(String path) async {
    final existingVariable = await VariablesRepository().getVariableByControlAndName(widget.controlId, 'Foto');
    if (existingVariable != null) {
      existingVariable.imagePath = path;
      await VariablesRepository().update(existingVariable.idVariable!, existingVariable);
    } else {
      final nuevaVariable = Variable(
        nombreVariable: 'Foto',
        valorTexto: null,
        valorNumerico: null,
        valorFecha: null,
        fkidControl: widget.controlId,
        imagePath: path,
      );
      await VariablesRepository().create(nuevaVariable);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver Foto", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true); // Indicar que se debe refrescar el dashboard
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('No existe ninguna foto.')
                : Image.file(File(_imageFile!.path)),
            const SizedBox(height: 10),
            if (widget.userRole == 'admin' || widget.userRole == 'editor')
              ElevatedButton(
                onPressed: () => _takePhoto(context),
                child: const Text('Tomar Foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
