import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/recipe.dart';
import 'package:mobile/services/recipe_service.dart';

class RegisterRecipe extends StatefulWidget {
  late Recipe? recipe;
  RegisterRecipe({super.key, this.recipe});

  @override
  State<RegisterRecipe> createState() => _RegisterRecipeState();
}

class _RegisterRecipeState extends State<RegisterRecipe> {
  RecipeService recipeService = RecipeService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _prepTimeController = TextEditingController();
  TextEditingController _servingsController = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _register() async {
    var base64Image = "";
    print(_nameController.text);
    print(_prepTimeController.text);
    print(_servingsController.text);

    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      base64Image = base64Encode(bytes);
      print('Base64 image: $base64Image');
    }

    if (_nameController.text.isEmpty ||
        _prepTimeController.text.isEmpty ||
        _servingsController.text.isEmpty) {
      return;
    }

    try {
      await recipeService.registerRecipe(
        _nameController.text,
        _prepTimeController.text,
        int.parse(_servingsController.text),
        base64Image,
      );
      Navigator.pop(context);
      return;
    } catch (e) {
      print(e);
    }
  }

  void _update() async {
    var base64Image = "";
    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      base64Image = base64Encode(bytes);
      print('Base64 image: $base64Image');
    }

    if (_nameController.text.isEmpty ||
        _prepTimeController.text.isEmpty ||
        _servingsController.text.isEmpty) {
      return;
    }

    try {
      await recipeService.updateRecipe(
        widget.recipe!.id,
        _nameController.text,
        _prepTimeController.text,
        int.parse(_servingsController.text),
        base64Image,
      );
      Navigator.pop(context);
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _prepTimeController.text = widget.recipe!.prepTime.toString();
      _servingsController.text = widget.recipe!.servings.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(color: Colors.black54),
        Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Register Recipe",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _prepTimeController,
                      decoration:
                          const InputDecoration(labelText: 'Preparation Time'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _servingsController,
                      decoration: const InputDecoration(labelText: 'Servings'),
                    ),
                    SizedBox(height: 8),
                    _image == null
                        ? Text('Nenhuma imagem selecionada.')
                        : Image.file(_image!),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => getImage(ImageSource.gallery),
                      child: Text('Selecionar da Galeria'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(
                        widget.recipe == null
                            ? "Register Recipe"
                            : "Edit Recipe",
                        style: TextStyle(color: Colors.deepPurple[100]),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.deepPurple[400])),
                      onPressed: widget.recipe == null ? _register : _update,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
